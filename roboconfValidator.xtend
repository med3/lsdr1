/*
 * generated by Xtext
 */
package org.xtext.validation

import java.util.ConcurrentModificationException
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.BasicEMap
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.EMap
import org.eclipse.xtext.validation.Check
import org.xtext.rdsl.Children
import org.xtext.rdsl.Component
import org.xtext.rdsl.Export
import org.xtext.rdsl.Graph
import org.xtext.rdsl.Imports
import org.xtext.rdsl.RdslPackage
import org.xtext.rdsl.exportVariable
import org.xtext.rdsl.importVariable

//import org.eclipse.xtext.validation.Check
/**
 * This class contains custom validation rules. 
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class RdslValidator extends AbstractRdslValidator {

	public static val INVALID_CARD = 'INVALID CARD'

//children : 0..1, extends 0..1, exports: *, imports: *
	@Check(FAST)
	def checkCardinalityOfProperties(Component c) {

		if (c.childrens.size > 1) {
			error(
				'At max we can have one children',
				RdslPackage.Literals.COMPONENT__CHILDRENS,
				INVALID_CARD
			)
		}
		if (c.extends.size > 1) {
			error(
				'At max we can have one extends',
				RdslPackage.Literals.COMPONENT__EXTENDS,
				INVALID_CARD
			)
		}
	}

// Instance's IP adresses should respect the syntax
	@Check(FAST)
	def checkSyntaxIPAdress(Instance i){

	if(i.ipAdress == NULL) return

	if(i.ipAdress.equals('IPv4')){
		if(i.ip4.size != 3)
			error(
				'Syntax of IPv4 Adress not respected',
				RdslPackage.Literals.INSTANCE_ADRESS,
				INVALID_CARD
			)
		else{
			for(INT part: i.ip4){
				if(part > 255 || part < 0)
					error(
						'Syntax of IPv4 Adress not respected',
						RdslPackage.Literals.INSTANCE_ADRESS_INTERVALS,
						INVALID_CARD
					)
			}
		}
	}

	if(i.ipAdress.equals('IPv6')){
		if(i.ip6.size != 7)
			error(
				'Syntax of IPv6 Adress not respected',
				RdslPackage.Literals.INSTANCE_ADRESS,
				INVALID_CARD
			)
		else{
			for(INT part: i.ip6){
				if(part > 255 || part < 0)
					error(
						'Syntax of IPv6 Adress not respected',
						RdslPackage.Literals.INSTANCE_ADRESS_INTERVALS,
						INVALID_CARD
					)
			}
		}
	}


}

// A component's name should start with an upper case

	@Check(FAST)
	def checkComponentStartWithUpperCase(Component c){
		if (c.name.charAt(0).lowerCase){
 			warning("Entity name should start with a capital letter",
 			RdslPackage.Literals.COMPONENT_NAME,
 			INVALID_COMPONENT_NAME,
 			)
 		}
}

// The load of an Instance indicates the need of extra nodes
	@Check(FAST)
	def checkInstanceLoad(Instance i){
		if(i.theLoad > 100 || i.theLoad < 0){
			error(
				'Load of an Instance should be comprised between 0 and 100',
				RdslPackage.Literals.INSTANCE_LOAD,
				INVALID_CARD
			)
		}

		if(i.theLoad > 80){
			warning('A new Instance is needed',
				RdslPackage::Literals.INSTANCE_REQUIRED))
		}
		if(i.theLoad < 20){
			warning('More Instances than needed',
				RdslPackage::Literals.ADDITIONAL_INSTANCE))
		}				

}


	/* Error : Child name already declared : Duplicate child name forbidden */
	@Check(FAST)
	def checkDuplicateChildreen(Children c) {
		var EList<Component> childreenList = new BasicEList<Component>
		childreenList = c.children
		childreenList.add(c.child)
		for (Component comp : childreenList) {
			childreenList.remove(comp);
			for (Component compo : childreenList) {
				if (comp.name.equals(compo.name)) {
					error(
						'Child already declared',
						RdslPackage.Literals.CHILDREN__CHILDREN,
						INVALID_CARD
					)
				}
			}
		}
	}

	/* Variable exported already declared : Duplicate variable forbidden */
	@Check(FAST)
	def checkExportsDeclareInComponent(exportVariable ex) {
		var Component eCompo = ex.eContainer().eContainer() as Component;
		var EList<Export> exports = new BasicEList<Export>;
		exports = eCompo.exports;
		var int count = 0;
		try {
			for (Export e : exports) {
				for (exportVariable exv : e.exports) {
					if (exv.name.equals(ex.name)) {
						count++;
					}
				}
				if (e.export.name.equals(ex.name)) {
					count++;
				}

			}

			if (count > 1) {
				error(
					'Variable exported already declared',
					RdslPackage.Literals.EXPORT_VARIABLE__INITIAL,
					INVALID_CARD
				)
			}
		} catch (ConcurrentModificationException e) {
		}
	}

	/* Variable Import already declared : Duplicate variable forbidden */
	@Check(FAST)
	def checkDuplicateImport(importVariable imp) {
		var Component eCompo = imp.eContainer().eContainer() as Component;
		var EList<Imports> imports = new BasicEList<Imports>;
		imports = eCompo.imports;
		var int count = 0;
		try {
			/*  Case 1 : importname is star ( Example : eimports : lamb.*) => name is null*/
			if (imp.name == null) {
				for (Imports impo : imports) {
					for (importVariable impv : impo.imports) {
						if (impv.importvariable.name.equals(imp.importvariable.name)) {
							count++;
						}
					}
					if (impo.imported.importvariable.name.equals(imp.importvariable.name)) {
						count++;
					}
				}
			} /*  Case 2 : importVariable is null ( Example : imports : ip) */
			else if (imp.importvariable == null) {
				for (Imports impo : imports) {
					for (importVariable impv : impo.imports) {
						if (impv.importvariable == null && impv.name.equals(imp.name)) {
							count++;
						}
					}
					if (impo.imported.importvariable == null && impo.imported.name.equals(imp.name)) {
						count++;
					}
				}

			} /*  Case 3 :  ( Example : imports : LB.ip) */
			else {
				for (Imports impo : imports) {
					for (importVariable impv : impo.imports) {
						if (impv.importvariable != null && impv.importvariable.name.equals(imp.importvariable.name) &&
							impv.name.equals(imp.name)) {
							count++;
						}
					}
					if (impo.imported.importvariable != null &&
						impo.imported.importvariable.name.equals(imp.importvariable.name) &&
						impo.imported.name.equals(imp.name)) {
						count++;
					}
				}
			}

			if (count > 1) {
				error(
					'Variable import already declared',
					RdslPackage.Literals.IMPORT_VARIABLE__IMPORTVARIABLE,
					INVALID_CARD
				)
			}
		} catch (ConcurrentModificationException e) {
		}
	}

	/* Variable imported must be declare as Export in its component */
	@Check(FAST)
	def checkImportsDeclareInComponent(importVariable imp) {
		var Graph eGraph = imp.eContainer().eContainer().eContainer() as Graph;
		var EMap<String, EList<String>> emap = new BasicEMap();
		var EList<String> elist;
		try {

			for (Component c : eGraph.components) {
				elist = new BasicEList<String>;
				for (Export export : c.exports) {
					for (exportVariable exVar : export.exports) {
						elist.add(exVar.name);
					}
					elist.add(export.export.name);
				}
				emap.put(c.name, elist);
			}

			var String CompFacet = imp.importvariable.name;
			var String importVal = imp.name;
			var Component compo = imp.eContainer().eContainer() as Component;
			if (CompFacet == null) {
				if (! emap.get(compo.name).contains(importVal)) {
					error(
						'Variable imported must be declare as Export in the component',
						RdslPackage.Literals.IMPORT_VARIABLE__IMPORTVARIABLE,
						INVALID_CARD
					)
				}
			} else {
				if (! emap.get(CompFacet).contains(importVal)) {
					error(
						'Variable imported must be declare as Export in the component',
						RdslPackage.Literals.IMPORT_VARIABLE__IMPORTVARIABLE,
						INVALID_CARD
					)
				}
			}
		} catch (ConcurrentModificationException e) {
		}
	}
}
