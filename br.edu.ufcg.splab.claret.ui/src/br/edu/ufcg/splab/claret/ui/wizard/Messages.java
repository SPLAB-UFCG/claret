package br.edu.ufcg.splab.claret.ui.wizard;

import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {
	private static final String BUNDLE_NAME = "br.edu.ufcg.splab.claret.ui.wizard.messages"; //$NON-NLS-1$
	
	public static String HelloWorldFile_Label;
	public static String HelloWorldFile_Description;
	public static String HelloWorldProject_Label;
	public static String HelloWorldProject_Description;
	public static String ClaretProject_Label;
	public static String ClaretProject_Description;
	
	static {
	// initialize resource bundle
	NLS.initializeMessages(BUNDLE_NAME, Messages.class);
	}

	private Messages() {
	}
}
