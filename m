Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A3535AE42
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhDJOZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:25:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54023 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234875AbhDJOZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:25:10 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id A45FB5C0100;
        Sat, 10 Apr 2021 10:24:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 10 Apr 2021 10:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talbothome.com;
         h=message-id:subject:from:to:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        G9j/FnOXAA37+V9jS2qxl7MzC0F/J3BlJxUTeGpU+NI=; b=UrNsk/i/MjIZukwt
        QeE20CIReCRkNh0BdFrmvv09aE2gMGfv/cKF6JZVU4h01ngzgrS328OcLv13aFXv
        kIbBHEQnBY9xrOoVMjSAlx81Zl5+cbPK1yrk+wtg4O1ne/l1BAqxDmo52miUgXCS
        RFEQJ8hLW9BhG/OlLDufYmBMH4mUaoIshW5Xfnq/PqbbVIbT36tdXva0FjBOrDPO
        MLuIz1a+isVbbTSS/fOoYWRPFsgw0fEvOip2jPwQF5l3vcuf/aUWgrJ9XSK3EQVb
        pU0kLi4kY+Qy8cWmPJcoo7NrO78Rg9xD+3dChFnJeOBAL5OYlF2Fb51B/2HaO5I5
        s5pj5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=G9j/FnOXAA37+V9jS2qxl7MzC0F/J3BlJxUTeGpU+
        NI=; b=iN5BEzwnCL1XUcozQrkhSItecj9kDk49hvwQSWkHAdcj6IyyWDM+NrNFd
        idoC284Y8nNr/zNg3E3O6+lWrBkIKvF+dhhZKdSQOiB0IKZQ/4vkYa85/dWJ/85O
        QzvbgYZ2AJCWlk8TuV9CHWLNrKXzl2AojbNEBt0naMlGUfTEHrO3XGleAEmEgm2+
        8B5YhcUjmVnuEj/zS5bWUtw52HJdUyCuJKe34ygVeU1KX4wTji9lC6lRwwGnk23P
        KVZW1+KYGO4YLyLEeJ72rwG9t/hsEqT7bHEZ7U5OYysWbZ/Ct7ittHXwzFtgixzL
        whaYEDBM4rzFVQrjxijPYWtdIfE/A==
X-ME-Sender: <xms:NrVxYEvaAzuosnaMXJI1wzbBOjrwfWuVKZBaBQhbv-34yZYvdjgaug>
    <xme:NrVxYDe_CVq4CmyQEFiYKkHByTgWITFxq6jrQc99MQC216vCiY9Jrckr7MfmAv5Kk
    vhjgVEjVoWAYciRiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkuffhvfffjghftggfggfgsehtje
    ertddtreejnecuhfhrohhmpeevhhhrihhsucfvrghlsghothcuoegthhhrihhssehtrghl
    sghothhhohhmvgdrtghomheqnecuggftrfgrthhtvghrnhepudetvddvheetffeivefhfe
    eugefftdfhleegveegkeehuedujefgiefffeffffffnecuffhomhgrihhnpehkvghrnhgv
    lhdrohhrghdpshhrrdhhthdpvgigrghmphhlvgdrtghomhdpthdqmhhosghilhgvrdgtoh
    hmpdhpuhhrihdrshhmnecukfhppeejvddrleehrddvgeefrdduheeinecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheptghhrhhishesthgrlhgsoh
    hthhhomhgvrdgtohhm
X-ME-Proxy: <xmx:NrVxYJJVG3lQ8MZzmC05jTNdEQOXAd4mPSulx7fdJdbOM0e6i42kIw>
    <xmx:NrVxYJaQQT_weccA3qsMhs_5S4S2Zp2W8HVBkypnxO3tDejJ1wtghw>
    <xmx:NrVxYMtAxPa1e16QZP2D9WM3EI5rdESF43kQFLFJuX1uTjx6ViBzKQ>
    <xmx:N7VxYAMOU2kxwDeiz-A7bQGI-GMZFf4oByPlaHLe9T0YF8Mib1FGFg>
Received: from SpaceballstheLaptop.talbothome.com (unknown [72.95.243.156])
        by mail.messagingengine.com (Postfix) with ESMTPA id A89CD24005B;
        Sat, 10 Apr 2021 10:24:54 -0400 (EDT)
Message-ID: <78c963a43f01464afb489e974f444a39e2c4cbfd.camel@talbothome.com>
Subject: [PATCH 9/9] Enable support for Modem Manager
From:   Chris Talbot <chris@talbothome.com>
To:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm
Date:   Sat, 10 Apr 2021 10:24:54 -0400
In-Reply-To: <c239428496e79e503d51c77346ef648f86c32eb0.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
         <b23ba0656ea0d58fdbd8c83072e017f63629f934.camel@talbothome.com>
         <df512b811ee2df6b8f55dd2a9fb0178e6e5c490f.camel@talbothome.com>
         <178dd29027e6abb4a205e25c02f06769848cbb76.camel@talbothome.com>
         <eee886683aa0cbf57ec3f0c8637ba02bc01600d6.camel@talbothome.com>
         <9c67f5690bd4d5625b799f40e68fa54373617341.camel@talbothome.com>
         <85928d2def5893cd90f823b563369e313e993084.camel@talbothome.com>
         <9f9d0f40db75ff82a306af14e7879e567dce9821.camel@talbothome.com>
         <c239428496e79e503d51c77346ef648f86c32eb0.camel@talbothome.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables mmsd support for Modem Manager. The support has
been well tested across at all major US carriers, as well as Canadia,
Sweden, and French carriers (more have likely beentested, but these
have been confirmed).

The commit automatically searches for SMS WAPs on Modem Manager, and
monitors the modem manager connectivity, giving a full transparent
abtraction for MMS sending and recieving.
---
 Makefile.am               |    8 +-
 README                    |  107 +++-
 configure.ac              |    5 +
 doc/modem-manager-api.txt |  102 ++++
 plugins/modemmanager.c    | 1179 +++++++++++++++++++++++++++++++++++++
 src/service.c             |    3 +-
 src/service.h             |    2 +
 7 files changed, 1400 insertions(+), 6 deletions(-)
 create mode 100644 doc/modem-manager-api.txt
 create mode 100644 plugins/modemmanager.c

diff --git a/Makefile.am b/Makefile.am
index 99fdb76..ecca9d8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -12,8 +12,8 @@ builtin_sources =
 builtin_cflags =
 builtin_libadd =
 
-builtin_modules += ofono
-builtin_sources += plugins/ofono.c
+builtin_modules += ofono modemmanager
+builtin_sources += plugins/ofono.c plugins/modemmanager.c
 
 libexec_PROGRAMS = src/mmsd
 
@@ -24,7 +24,7 @@ src_mmsd_SOURCES = $(gdbus_sources) $(gweb_sources)
$(builtin_sources) \
 			src/push.h src/push.c src/store.h src/store.c
\
 			src/wsputil.h src/wsputil.c src/mmsutil.h
src/mmsutil.c
 
-src_mmsd_LDADD = $(builtin_libadd) @GLIB_LIBS@ @DBUS_LIBS@ -lresolv -
ldl
+src_mmsd_LDADD = $(builtin_libadd) @GLIB_LIBS@ @DBUS_LIBS@
@MMGLIB_LIBS@ -lresolv -ldl
 
 src_mmsd_LDFLAGS = -Wl,--export-dynamic
 
@@ -41,7 +41,7 @@ src/plugin.$(OBJEXT): src/builtin.h
 src/builtin.h: src/genbuiltin $(builtin_sources)
 	$(AM_V_GEN)$(srcdir)/src/genbuiltin $(builtin_modules) > $@
 
-AM_CFLAGS = @GLIB_CFLAGS@ @DBUS_CFLAGS@ $(builtin_cflags) \
+AM_CFLAGS = @GLIB_CFLAGS@ @DBUS_CFLAGS@ @MMGLIB_CFLAGS@
$(builtin_cflags) \
 					-DMMS_PLUGIN_BUILTIN \
 					-DPLUGINDIR=\""$(plugindir)"\"
\
 					-
DPUSHCONFDIR=\""$(pushconfdir)"\"
diff --git a/README b/README
index cecc99f..ff02121 100644
--- a/README
+++ b/README
@@ -16,12 +16,51 @@ Please note that mmsd alone will not get MMS
working! It is designed to work
 with a higher level chat application to facilitate fetching and 
 sending MMS. It interfaces with other applications via the dbus.
 
+A note about this repository
+===========================
+This repository is a fork of 
+https://git.kernel.org/pub/scm/network/ofono/mmsd.git
+
+and includes updates found here:
+https://git.sr.ht/~anteater/mmsd
+
+Commit f4b8b32477a411180be1823fdc460b4f7e1e3c9c from the master branch
+is synced with the latest updates from upstream.
+
+This fork includes a plugin to support Modem Manager in addition to
ofono, 
+patches to improve the core of mmsd, and packaging for Debian. This
author 
+has only tested this fork with Modem Manager, and primarily maintains 
+the Modem Manager plugin. However, the ofono plugin should work as 
+expected, and the author is happy to work with others to keep the 
+ofono plugin maintained and/or improve the ofono plugin.
+
+Based on a conversation held in Nov/Dec 2019 in the ofono IRC,
upstream 
+mmsd has effectively not been maintained for around 8 years. This
author has 
+attempted to contact the ofono maintainers both through the ofono
mailing 
+list and the ofono IRC to upstream changes found here, but did not get
a 
+response. This author is happy to work with the ofono maintainers to
upstream 
+the changes found in this repository, should they so desire.
+
+Modem Manager specific notes
+===========================
+Upon start up, mmsd looks for and tracks the state of the modem
+that has Modem Messaging (i.e. SMS) capabilities. Since mmsd is a
lower 
+level program, mmsd assumes that other parts of the OS stack manage
mobile 
+connectivity. 
+
+Please note that due to limitations of Modem Manager, mmsd does not
support
+having multiple APNs at the same time (for carriers that seperate MMS
APN 
+from Mobile Data APNs).
+    
+Please read "Configuring the Modem Manager Plugin" for configuration.
+
 Compiling mmsd
 ============================
 In order to compile proxy daemon you need following software packages:
 	- GCC compiler
 	- D-Bus library
 	- GLib library
+	- Modem Manager Library
 
 Installing mmsd
 ============================
@@ -74,4 +113,70 @@ TotalMaxAttachmentSize
         The maximum size all of your attachments can be before mmsd
rejects it.
         NOTE: This value is carrier specific! Changing this value to a
higher
               number may cause your carrier to silently reject MMSes
you send.
-              CHANGE AT YOUR OWN RISK!
\ No newline at end of file
+              CHANGE AT YOUR OWN RISK!
+
+Configuring the Modem Manager Plugin
+===========================
+On first run, mmsd will write a settings file at
+"$HOME/.mms/modemmanager/ModemManagerSettings"
+
+IMPORTANT NOTE: If you change any settings through the file,
+                mmsd MUST BE RESTARTED for the changes to take effect!
+                
+                You can change CarrierMMSC, CarrierMMSProxy, or
MMS_APN via 
+                dbus and they will take effect right away, but any
+	            messages sent to the mmsd queue need to be
processed 
+	            again. The easiest way to do this is to reset
mmsd.
+	            But it can be done with the dbus proxy call
ProcessMessageQueue().
+
+This settings file needs to be changed before mmsd will connect! The
settings
+are as follows:
+
+CarrierMMSC
+        Get this from your carrier.
+	        
+        Carrier MMSC Format: "http://mms.example.com"
+        
+CarrierMMSProxy 
+        Get this from your carrier.
+     	        
+        MMS Proxy Format: "proxy.example.com:80" or "NULL"
+            Both the proxy address AND port are required, or else mmsd
will not work!
+            The proxy is "proxy.example.com" 
+            The proxy port is "80"
+            If you do NOT have a proxy, set this to "NULL"
+            
+MMS_APN
+        Note that at this point, this plugin can only support one
bearer at 
+        a time (this works fine for carriers with a combined
Internet/MMS APN
+        but will not function with carriers that have two APNS
seperating 
+        the two)
+        
+        MMS APN Format: "apn.example.com"
+
+AutoProcessOnConnection
+        Tell mmsd to automatically send and recieve messages when the
modem
+        is connected. This will also allow mmsd to auto send/recieve
if the
+        modem is disconnected and reconnects, suspends and unsuspends,
etc.
+        
+        AutoProcessOnConnection Options: "true" or "false"
+
+AutoProcessSMSWAP
+        Tell mmsd to automatically check and process SMS WAPs. This
can be
+        useful if you do not have a chat application that manages MMS
or if
+        a higher level chat application does not process SMS WAPs to
send to
+        mmsd.
+        
+        AutoProcessSMSWAP Options: "true" or "false"
+        
+        
+An example of what you are looking for is here:
+https://www.t-mobile.com/support/devices/not-sold-by-t-mobile/byod-t-mobile-data-and-apn-settings
+
+From this:
+
+CarrierMMSC=http://mms.msg.eng.t-mobile.com/mms/wapenc
+MMS_APN=fast.t-mobile.com
+CarrierMMSProxy=NULL
+
+
diff --git a/configure.ac b/configure.ac
index 6b5e1b1..721eb19 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,4 +78,9 @@ PKG_CHECK_MODULES(DBUS, dbus-1 >= 1.2, dummy=yes,
 AC_SUBST(DBUS_CFLAGS)
 AC_SUBST(DBUS_LIBS)
 
+PKG_CHECK_MODULES(MMGLIB, mm-glib >= 1.10, dummy=yes,
+				AC_MSG_ERROR(mm-glib >= 1.10 is
required))
+AC_SUBST(MMGLIB_CFLAGS)
+AC_SUBST(MMGLIB_LIBS)
+
 AC_OUTPUT(Makefile)
diff --git a/doc/modem-manager-api.txt b/doc/modem-manager-api.txt
new file mode 100644
index 0000000..4a7f67f
--- /dev/null
+++ b/doc/modem-manager-api.txt
@@ -0,0 +1,102 @@
+Message hierarchy
+=================
+
+Service		org.ofono.mms
+Interface	org.ofono.mms.ModemManager
+Object path	/org/ofono/mms
+
+NOTE: This is an independent bus from the rest of mmsd. In order to
talk to 
+      Modem Manager, this plugin must work with dbus 2.0. The rest of
mmsd
+      operates on dbus 1.0. Be sure to connect independently to this
bus!
+
+Methods		                    
+
+    PushNotify()
+    
+		Send mmsd the contents of an SMS WAP for it to process
+		See purple-mm-sms for how this is used
+        
+        Gvariant input Format String    (ay)
+            This is the data contents of the SMS WAP
+
+	ChangeSettings()
+	    IMPORTANT NOTE: Settings changed here will work right
away, but any
+	                    messages sent to the mmsd queue need to be
processed 
+	                    again. The easiest way to do this is to
reset mmsd.
+	                    But it can be done with the dbus proxy
call 
+	                    ProcessMessageQueue()
+	    
+	    This sets and saves the Carrier MMSC, MMS Proxy, and MMS
APN
+	    
+	    Gvariant Input Format String    ((sss))
+	        Argument 1: Carrier MMSC
+	        Argument 2: MMS Proxy
+	        Argument 3: MMS APN
+	        
+	        Carrier MMSC
+	            Get this from your carrier.
+	        
+	            Carrier MMSC Format: "http://mms.example.com"
+	        
+            MMS Proxy 
+                Get this from your carrier.
+         	        
+	            MMS Proxy Format: "proxy.example.com:80" or "NULL"
+	                The proxy is "proxy.example.com" 
+	                The Proxy port is "80"
+                    Both the proxy address AND port is required, or
else mmsd will not work!
+	                If you do NOT have a proxy, set this to "NULL"
+	            
+	        MMS APN
+	            Note that at this point, this plugin can only
support one bearer at 
+	            a time (this works fine for carriers with a
combined Internet/MMS APN
+	            but will not function with carriers that have two
APNS seperating 
+	            the two)
+	        
+	            MMS APN Format: "apn.example.com"
+	        
+	    Example Python Program to call "ChangeSettings":
+	
+            #!/usr/bin/python
+
+            import pydbus
+            from pydbus import SessionBus
+            bus = SessionBus()
+            TestServer = bus.get("org.ofono.mms.ModemManager",
"/org/ofono/mms")
+            TestServer.ChangeSettings(("http://mms.invalid", "NULL",
"apn.invalid"))
+            #TestServer.ChangeSettings(("http://mms.invalid",
"proxy.invalid:80", "apn.invalid"))
+
+    ProcessMessageQueue()
+        This manually activates the Modem Manager Bearer to process
any messages
+        not sent or recieved yet. The primary idea behind is two fold:
+        
+        a) If the Bearer Handler is misconfigured, the OS/higher level
program
+           can change the settings via the dbus and test the bearer
handler 
+           to confirm it works.
+           
+        b) If modem data is disconnected (manually or due to modem
suspend), 
+           the OS/higher level program can also track this and can
command 
+           mmsd to now process any messages it needs to send/recieve
once
+           modem data is active.
+           
+        Since BearerHandlerError() emits a signal for any errors
activating the
+        modem contect, ProcessMessageQueue() does not return any
value.        
+
+Signals		
+    BearerHandlerError()
+        If the bearer handler has an issue activating the context, it
will emit
+        a signal of the error. The errors are shown above. 
+        
+        NOTE: MMSD_MM_MODEM_CONTEXT_ACTIVE will never be emitted as a
signal.
+        
+        Gvariant Output Format String    (h)
+            enum {
+                  MMSD_MM_MODEM_MMSC_MISCONFIGURED, //the MMSC is the
default value
+                  MMSD_MM_MODEM_NO_BEARERS_ACTIVE, //The Modem has no
bearers
+                  MMSD_MM_MODEM_INTERFACE_DISCONNECTED, //mmsd found
the right bearer, but it is disconnected
+                  MMSD_MM_MODEM_INCORRECT_APN_CONNECTED, //no APN is
connected that matches the settings
+                  MMSD_MM_MODEM_FUTURE_CASE_DISCONNECTED, //Reserved
for future case
+                  MMSD_MM_MODEM_CONTEXT_ACTIVE //No error, context
activated properly
+            } mm_context_connection;
+
+Properties	None
diff --git a/plugins/modemmanager.c b/plugins/modemmanager.c
new file mode 100644
index 0000000..383c0f5
--- /dev/null
+++ b/plugins/modemmanager.c
@@ -0,0 +1,1179 @@
+/*
+ *
+ *  Multimedia Messaging Service
+ *
+ *  Copyright (C) 2010-2011  Intel Corporation. All rights reserved.
+ *  Updated 2021: kop316, fuzzy7k, craftyguy, Mohammad Sadiq
+ *
+ *  Adapted from: https://source.puri.sm/Librem5/purple-mm-sms
+ *                Copyright (C) 2018 Purism SPC
+ *
+ *  This program is free software; you can redistribute it and/or
modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-
1301  USA
+ *
+ */
+
+
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
+#include <errno.h>
+#include <gio/gio.h>
+#include <stdlib.h>
+#include <libmm-glib.h>
+#include "mms.h"
+
+// SETTINGS_STORE is synced with services.c
+#define SETTINGS_STORE "ModemManagerSettings"
+// SETTINGS_GROUP is where we store our settings for this plugin
+#define SETTINGS_GROUP "Modem Manager"
+//Identifier of the plugin
+#define IDENTIFIER     "modemmanager"
+//dbus default timeout for Modem
+#define MMSD_MM_MODEM_TIMEOUT       20000
+
+enum {
+	MMSD_MM_STATE_NO_MANAGER,
+	MMSD_MM_STATE_MANAGER_FOUND,
+	MMSD_MM_STATE_NO_MODEM,
+	MMSD_MM_STATE_MODEM_FOUND,
+	MMSD_MM_STATE_NO_MESSAGING_MODEM,
+	MMSD_MM_STATE_MODEM_DISABLED,
+	MMSD_MM_STATE_MODEM_UNLOCK_ERROR,
+	MMSD_MM_STATE_READY
+} e_mmsd_connection;
+
+enum {
+	MMSD_MM_MODEM_MMSC_MISCONFIGURED,	 //the MMSC is the
default value
+	MMSD_MM_MODEM_NO_BEARERS_ACTIVE,	//The Modem has no
bearers
+	MMSD_MM_MODEM_INTERFACE_DISCONNECTED,	//mmsd found the right
bearer, but it is disconnected
+	MMSD_MM_MODEM_INCORRECT_APN_CONNECTED,	//no APN is connected
that matches the settings
+	MMSD_MM_MODEM_FUTURE_CASE_DISCONNECTED, //Reserved for future
case
+	MMSD_MM_MODEM_CONTEXT_ACTIVE		//No error, context
activated properly
+} mm_context_connection;
+
+struct modem_data {
+	struct mms_service *service; //Do not mess with the guts of
this in plugin.c!
+	GKeyFile *modemsettings;
+	//These are pulled from the settings file, and can be set via
the Dbus
+	char			*message_center;		// The
mmsc
+	char			*mms_apn;			// The
MMS APN
+	char			*MMS_proxy;			// I
*think* this is where mms proxy goes?
+	// These are for settings the context (i.e. APN settings and
if the bearer is active)
+	char			*context_interface;		//
Bearer interface here (e.g. "wwan0")
+	char			*context_path;			//
Dbus path of the bearer
+	dbus_bool_t		 context_active;		//
Whether the context is active
+	//The Bus org.ofono.mms.ModemManager
+	GDBusConnection		*master_connection;
+	guint			 owner_id;		 
+	guint			 registration_id; 
+	// This is a way to track the state of the modem if it is
disabled
+	MmGdbusModem		*gdbus_modem;
+	gulong			 modem_state_watch_id;
+	//These are modem manager related settings
+	MMManager		*mm;
+	guint			 mm_watch_id;
+	MMObject		*object; 
+	MMModem			*modem;
+	char			*path;
+	MMSim			*sim;
+	gchar			*imsi;
+	MMModemMessaging	*modem_messaging;
+	MMModemState		 state;
+	GPtrArray	 	*device_arr;
+	gboolean		 modem_available;
+	gboolean		 manager_available;
+	gboolean		 plugin_registered;
+	gboolean		 auto_process_on_connection;
+	gboolean		 autoprocess_sms_wap;
+};
+
+typedef struct {
+	MMObject	*object;
+	MMModem		*modem;
+	MMSim		*sim;
+} MmsdDevice;
+
+/* Introspection data for the service we are exporting */
+static const gchar introspection_xml[] =
+  "<node>"
+  "  <interface name='org.ofono.mms.ModemManager'>"
+  "    <annotation name='org.ofono.mms.ModemManager'
value='OnInterface'/>"
+  "    <annotation name='org.ofono.mms.ModemManager'
value='AlsoOnInterface'/>"
+  "    <method name='PushNotify'>"
+  "      <annotation name='org.ofono.mms.ModemManager'
value='OnMethod'/>"
+  "      <arg type='ay' name='smswap' direction='in'/>"
+  "    </method>"
+  "    <method name='ChangeSettings'>"
+  "      <annotation name='org.ofono.mms.ModemManager'
value='OnMethod'/>"
+  "      <arg type='(sss)' name='greeting' direction='in'/>"
+  "    </method>"
+  "    <method name='ProcessMessageQueue'>"
+  "      <annotation name='org.ofono.mms.ModemManager'
value='OnMethod'/>"
+  "    </method>"
+  "    <signal name='BearerHandlerError'>"
+  "      <annotation name='org.ofono.mms.ModemManager'
value='Onsignal'/>"
+  "      <arg type='h' name='ContextError'/>"
+  "    </signal>"
+  "  </interface>"
+  "</node>";
+
+
+static GDBusNodeInfo *introspection_data = NULL;
+struct modem_data *modem;
+
+static void mmsd_mm_state(int state);
+static void mmsd_plugin_connect(void);
+static void mmsd_plugin_disconnect(void);
+static void free_device(MmsdDevice *device);
+static void bearer_handler(mms_bool_t active, void *user_data);
+static int set_context(void);
+static void cb_mm_manager_new(GDBusConnection *connection,
GAsyncResult *res, gpointer user_data);
+static void mm_appeared_cb(GDBusConnection *connection, const gchar
*name, const gchar *name_owner, gpointer user_data);
+static void mm_vanished_cb(GDBusConnection *connection, const gchar
*name, gpointer user_data);
+static void mm_get_modem_manager(void);
+static int modemmanager_init(void);
+static void modemmanager_exit(void);
+
+static void
+handle_method_call(GDBusConnection		*connection,
+		   const gchar			*sender,
+		   const gchar			*object_path,
+		   const gchar			*interface_name,
+		   const gchar			*method_name,
+		   GVariant			*parameters,
+		   GDBusMethodInvocation	*invocation,
+		   gpointer			 user_data)
+{
+	if(g_strcmp0(method_name, "PushNotify") == 0)
+	{
+		GVariant *smswap;
+		const unsigned char *data;
+		gsize data_len;
+		if(modem->modem_available == TRUE) {
+
+			g_variant_get(parameters, "(@ay)", &smswap);
+			data_len = g_variant_get_size(smswap);
+			data = g_variant_get_fixed_array(smswap,
&data_len, 1);
+			mms_error("ModemManagerPlugin():
%s",__func__);
+
+			mms_service_push_notify(modem->service, data,
data_len);
+			g_dbus_method_invocation_return_value(invocati
on, NULL);
+
+		 } else {
+			g_dbus_method_invocation_return_dbus_error(inv
ocation,
+								  
"org.ofono.mms.ModemManager",
+								  
"Modem is not active!");
+		}
+	} 
+	else if(g_strcmp0(method_name, "ChangeSettings") == 0) {
+
+		const gchar *mmsc, *mmsproxy, *mmsapn;
+		g_variant_get(parameters, "((sss))", &mmsc,
+						     &mmsproxy,
+						     &mmsapn);
+		mms_error("ModemManagerPlugin(): args MMSC:%s MMS
Proxy:%s MMS APN:%s", mmsc, mmsproxy, mmsapn);
+		modem->modemsettings = mms_settings_open(IDENTIFIER,
SETTINGS_STORE);
+
+		if(g_strcmp0(mmsc, "") != 0) {
+			g_free(modem->message_center);
+			modem->message_center = g_strdup(mmsc);
+			g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+					      "CarrierMMSC", modem-
>message_center);
+		}
+
+		if(g_strcmp0(mmsproxy, "") != 0) {
+			g_free(modem->MMS_proxy);
+			modem->MMS_proxy = g_strdup(mmsproxy);
+			g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+					      "CarrierMMSProxy",
modem->MMS_proxy);
+			if(g_strcmp0(modem->MMS_proxy, "NULL") == 0) {
+				g_free(modem->MMS_proxy);
+				modem->MMS_proxy = NULL;
+			}
+		}
+		
+		if(g_strcmp0(mmsapn, "") != 0) {
+			g_free(modem->mms_apn);
+			modem->mms_apn = g_strdup(mmsapn);
+			g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+					      "MMS_APN", modem-
>mms_apn);
+		}
+		mms_settings_close(IDENTIFIER, SETTINGS_STORE,
+				   modem->modemsettings, TRUE); 
+
+		g_dbus_method_invocation_return_value(invocation,
NULL);
+	}
+	else if(g_strcmp0(method_name, "ProcessMessageQueue") == 0) {
+		if(modem->modem_available == TRUE) {
+			/*
+			 * Prevent a race condition from the
connection turning active to usable
+			 * for mmsd
+			 */
+			sleep(1);
+
+			activate_bearer(modem->service);
+			g_dbus_method_invocation_return_value(invocati
on, NULL);
+		} else {
+			g_dbus_method_invocation_return_dbus_error(inv
ocation,
+								  
"org.ofono.mms.ModemManager",
+								  
"Modem is not active!");
+		}
+	}
+} 
+
+static const GDBusInterfaceVTable interface_vtable =
+{
+	handle_method_call
+};
+
+static void
+on_bus_acquired(GDBusConnection *connection,
+		const gchar	*name,
+		gpointer	 user_data)
+{
+
+	modem->master_connection = connection;
+
+	modem->registration_id =
g_dbus_connection_register_object(connection,
+								  
"/org/ofono/mms",
+								  
introspection_data->interfaces[0],
+								  
&interface_vtable,
+								  
NULL,	/* user_data */
+								  
NULL,	/* user_data_free_func */
+								  
NULL);	/* GError** */
+
+	g_assert(modem->registration_id > 0);
+}
+
+static void
+on_name_acquired(GDBusConnection	*connection,
+		 const gchar		*name,
+		 gpointer		 user_data)
+{
+}
+
+static void
+on_name_lost(GDBusConnection	*connection,
+	     const gchar	*name,
+	     gpointer		 user_data)
+{
+}
+
+static void
+cb_sms_delete_finish(MMModemMessaging	*modemmessaging,
+		     GAsyncResult	*result,
+		     MMSms		*sms)
+{
+	g_autoptr(GError) error = NULL;
+
+	if(mm_modem_messaging_delete_finish(modemmessaging, result,
&error)) {
+		g_debug("Message delete finish");
+	} else {
+		g_debug("Couldn't delete SMS - error: %s", error ?
error->message : "unknown");
+	}
+}
+
+static void
+mmsd_process_sms(MMSms	*sms)
+{
+	const gchar	*message;
+	const guint8	*data;
+	const char	*path;
+	gsize		 data_len;
+
+	data_len = 0;
+	message = mm_sms_get_text(sms);
+	data = mm_sms_get_data(sms, &data_len);
+
+	if(message) {
+		mms_error("ModemManagerPlugin(): This is a regular
SMS.");
+		mms_error("ModemManagerPlugin(): Message: %s",
message);
+	} else if(data) {
+		mms_error("ModemManagerPlugin(): Received SMS WAP!");
+		if(modem->modem_available == TRUE) {
+			mms_service_push_notify(modem->service, data,
data_len);
+			path = mm_sms_get_path(sms);
+			if(path) {
+				mm_modem_messaging_delete(modem-
>modem_messaging,
+							  path,
+							  NULL,
+							 
(GAsyncReadyCallback)cb_sms_delete_finish,
+							  sms);
+			} else {
+				mms_error("ModemManagerPlugin(): mmsd
cannot process MMS at this time!");
+			}
+		}
+	} else {
+		mms_error("ModemManagerPlugin(): Not sure what kind of
SMS this is!");
+	}
+}
+
+static void
+cb_sms_state_change(MMSms	*sms,
+		    GParamSpec	*pspec,
+		    gpointer 	*user_data)
+{
+	MMSmsState state;
+
+	state = mm_sms_get_state(sms);
+	mms_error("ModemManagerPlugin(): %s: state %s", __func__,
+		  mm_sms_state_get_string(mm_sms_get_state(sms)));
+
+	if(state == MM_SMS_STATE_RECEIVED) {
+		mmsd_process_sms(sms);
+	}
+}
+
+static void
+mmsd_check_pdu_type(MMSms	*sms)
+{
+	MMSmsState	state;
+	MMSmsPduType	pdu_type;
+
+	pdu_type = mm_sms_get_pdu_type(sms);
+	state = mm_sms_get_state(sms);
+	switch(pdu_type) {
+		case MM_SMS_PDU_TYPE_CDMA_DELIVER:
+		case MM_SMS_PDU_TYPE_DELIVER:
+
+			if(state == MM_SMS_STATE_RECEIVED) {
+				mmsd_process_sms(sms);
+			}
+
+			if(state == MM_SMS_STATE_RECEIVING) {
+				// The first chunk of a multipart SMS
has been
+				// received -> wait for
MM_SMS_STATE_RECEIVED
+				g_signal_connect(sms,
+						 "notify::state",
+						
G_CALLBACK(cb_sms_state_change),
+						 NULL);
+			}
+		break;
+
+		case MM_SMS_PDU_TYPE_STATUS_REPORT:
+		case MM_SMS_PDU_TYPE_SUBMIT:
+			mms_error("ModemManagerPlugin(): This is not
an SMS being recieved, do not care");
+			break;
+
+		case MM_SMS_PDU_TYPE_UNKNOWN:
+			mms_error("ModemManagerPlugin(): Unknown PDU
type");
+			break;
+
+		default:
+			mms_error("ModemManagerPlugin(): PDU type not
handled");
+	}
+}
+
+
+static void
+cb_sms_list_new_ready(MMModemMessaging	*modemmessaging,
+		      GAsyncResult	*result,
+		      gchar		*path)
+{
+	GList			*l, *list;
+	g_autoptr(GError)	 error = NULL;
+	MMSms			*sms;
+
+	list = mm_modem_messaging_list_finish(modemmessaging, result,
&error);
+
+	if(!list) {
+		mms_error("ModemManagerPlugin(): Couldn't get SMS list
- error: %s", 
+			  error ? error->message : "unknown");
+	} else {
+	for(l = list; l; l = g_list_next(l)) {
+		//We are searching for the SMS from the list that is
new
+		if(!g_strcmp0(mm_sms_get_path(MM_SMS(l->data)), path))
{
+			sms = g_object_ref(MM_SMS(l->data));
+			mmsd_check_pdu_type(sms);
+			break;
+		}
+	}
+	g_list_free_full(list, g_object_unref);
+	g_free(path);
+	}
+}
+
+static gboolean
+cb_dbus_signal_sms_added(MMModemMessaging	*device,
+			 gchar			*const_path,
+			 gpointer		 user_data)
+{
+	gchar *path;
+	path = g_strdup(const_path);
+	mm_modem_messaging_list(modem->modem_messaging,
+				NULL,
+				(GAsyncReadyCallback)cb_sms_list_new_r
eady,
+				path);
+	return TRUE;
+}
+
+static void
+cb_sms_list_all_ready(MMModemMessaging	*modemmessaging,
+		      GAsyncResult	*result,
+		      gpointer		 user_data)
+{
+	GList			*l, *list;
+	g_autoptr(GError)	error = NULL;
+	MMSms			*sms;
+
+	list = mm_modem_messaging_list_finish(modemmessaging, result,
&error);
+
+	if(!list) {
+		g_debug("Couldn't get SMS list - error: %s", error ?
error->message : "unknown");
+	} else {
+		for(l = list; l; l = g_list_next(l)) {
+			sms = g_object_ref(MM_SMS(l->data));
+			mmsd_check_pdu_type(sms);
+		}
+	}
+}
+
+
+static void
+mmsd_get_all_sms(void)
+{
+	g_return_if_fail(MM_IS_MODEM_MESSAGING(modem-
>modem_messaging));
+	mm_modem_messaging_list(modem->modem_messaging,
+				NULL,
+				(GAsyncReadyCallback)cb_sms_list_all_r
eady,
+				NULL);
+}
+
+static void
+mmsd_mm_init_modem(MMObject *obj)
+{
+	MmGdbusModemMessaging *gdbus_sms;
+	modem->object = obj;
+	modem->modem = mm_object_get_modem(MM_OBJECT(obj));
+	modem->path = mm_modem_dup_path(modem->modem);
+
+	g_dbus_proxy_set_default_timeout(G_DBUS_PROXY(modem->modem),
+					 MMSD_MM_MODEM_TIMEOUT);
+
+	modem->modem_messaging =
mm_object_get_modem_messaging(MM_OBJECT(obj)); 
+	g_return_if_fail(MM_IS_MODEM_MESSAGING(modem-
>modem_messaging));
+
+
+	gdbus_sms = MM_GDBUS_MODEM_MESSAGING(modem->modem_messaging);
+	if(modem->autoprocess_sms_wap) {
+		mms_error("ModemManagerPlugin(): Autoprocessing SMS
WAPs");
+		g_signal_connect(gdbus_sms,
+				 "added",
+				 
G_CALLBACK(cb_dbus_signal_sms_added),
+				  NULL);
+	} else {
+		mms_error("ModemManagerPlugin(): Not autoprocessing
SMS WAPs");
+	}
+
+	mms_error("ModemManagerPlugin(): %s", __func__);
+}
+
+static void
+free_device(MmsdDevice *device)
+{
+	if(!device)
+		return;
+
+	g_clear_object(&device->sim);
+	g_clear_object(&device->modem);
+	g_clear_object(&device->object);
+	g_free(device);
+}
+
+static gboolean
+device_match_by_object(MmsdDevice	*device,
+		       GDBusObject	*object)
+
+{
+	g_return_val_if_fail(G_IS_DBUS_OBJECT(object), FALSE);
+	g_return_val_if_fail(MM_OBJECT(device->object), FALSE);
+
+	return object == G_DBUS_OBJECT(device->object);
+}
+
+static void
+mmsd_mm_add_object(MMObject *obj)
+{
+	MmsdDevice *device;
+	const gchar *object_path;
+
+	object_path =
g_dbus_object_get_object_path(G_DBUS_OBJECT(obj));
+
+	g_return_if_fail(object_path);
+	//Begin if statement
+	if(g_ptr_array_find_with_equal_func(modem->device_arr,
+					    obj,
+					   
(GEqualFunc)device_match_by_object,
+					    NULL)) {
+	//End if statement
+	mms_error("ModemManagerPlugin(): Device %s already added",
object_path);
+	return;
+	}
+
+	mms_error("ModemManagerPlugin(): Added device at: %s",
object_path);
+
+	// TODO choose default modem if devices->len > 1
+	device = g_new0(MmsdDevice, 1);
+	device->object = g_object_ref(MM_OBJECT(obj));
+	device->modem = mm_object_get_modem(MM_OBJECT(obj));
+	g_ptr_array_add(modem->device_arr, device);
+
+	mmsd_mm_init_modem(obj);
+
+	mmsd_mm_state(MMSD_MM_STATE_MODEM_FOUND);
+}
+
+static void
+mmsd_mm_get_modems(void)
+{
+	GList *list, *l;
+	gboolean has_modem = FALSE;
+
+	g_return_if_fail(MM_IS_MANAGER(modem->mm));
+
+	list =
g_dbus_object_manager_get_objects(G_DBUS_OBJECT_MANAGER(modem->mm));
+
+	for(l = list; l != NULL; l = l->next) {
+		if(!mm_object_peek_modem_messaging(l->data))
+			continue;
+
+		has_modem = TRUE;
+		mmsd_mm_add_object(MM_OBJECT(l->data));
+	}
+
+	if(!has_modem) {
+		mmsd_mm_state(MMSD_MM_STATE_NO_MODEM);
+	} else if(list) {
+		g_list_free_full(list, g_object_unref);
+	}
+}
+
+
+static void
+cb_object_added(GDBusObjectManager 	*manager,
+		GDBusObject		*object,
+		gpointer		 user_data)
+{
+	mms_error("ModemManagerPlugin(): %s", __func__);
+	if(mm_object_peek_modem_messaging(MM_OBJECT(object))) {
+		mms_error("ModemManagerPlugin(): New Object does not
have Messaging feature, ignoring....");
+		mmsd_mm_add_object(MM_OBJECT(object));
+	}
+
+
+}
+
+
+
+static void
+cb_object_removed(GDBusObjectManager	*manager,
+		  GDBusObject		*object,
+		  gpointer		 user_data)
+{
+	guint index;
+
+
+	g_return_if_fail(G_IS_DBUS_OBJECT(object));
+	g_return_if_fail(G_IS_DBUS_OBJECT_MANAGER(manager));
+	//Begin if statement
+	if(g_ptr_array_find_with_equal_func(modem->device_arr,
+					    object,
+					   
(GEqualFunc)device_match_by_object,
+					    &index)) {
+	//End if Statement
+		g_ptr_array_remove_index_fast(modem->device_arr,
index);
+	}
+
+	if(MM_OBJECT(object) == modem->object) {
+		mmsd_mm_state(MMSD_MM_STATE_NO_MODEM);
+	}
+
+	mms_error("ModemManagerPlugin(): Modem removed: %s",
g_dbus_object_get_object_path(object));
+}
+
+
+static void
+cb_name_owner_changed(GDBusObjectManager	*manager,
+		      GDBusObject		*object,
+		      gpointer			 user_data)
+{
+	gchar *name_owner;
+
+	name_owner =
g_dbus_object_manager_client_get_name_owner(G_DBUS_OBJECT_MANAGER_CLIEN
T(manager));
+
+	if(!name_owner) {
+		mmsd_mm_state(MMSD_MM_STATE_NO_MANAGER);
+	}
+
+	mms_error("ModemManagerPlugin(): Name owner changed");
+
+	g_free(name_owner);
+}
+
+static void
+cb_mm_manager_new(GDBusConnection 	*connection,
+		  GAsyncResult		*res,
+		  gpointer		 user_data)
+{
+	gchar		 	*name_owner;
+	g_autoptr(GError)	 error = NULL;
+
+
+	modem->mm = mm_manager_new_finish(res, &error);
+	modem->device_arr =
g_ptr_array_new_with_free_func((GDestroyNotify) free_device);
+
+	if(modem->mm) {
+
+		mmsd_mm_state(MMSD_MM_STATE_MANAGER_FOUND);
+
+		g_signal_connect(modem->mm,
+				 "interface-added",
+				 G_CALLBACK(cb_object_added),
+				 NULL);
+
+		g_signal_connect(modem->mm,
+				 "object-added",
+				 G_CALLBACK(cb_object_added),
+				 NULL);
+
+		g_signal_connect(modem->mm,
+				 "object-removed",
+				 G_CALLBACK(cb_object_removed),
+				 NULL);
+
+		g_signal_connect(modem->mm,
+				 "notify::name-owner",
+				 G_CALLBACK(cb_name_owner_changed),
+				 NULL);
+
+		name_owner =
g_dbus_object_manager_client_get_name_owner(G_DBUS_OBJECT_MANAGER_CLIEN
T(modem->mm));
+		mms_error("ModemManagerPlugin(): ModemManager found:
%s\n", name_owner);
+		g_free(name_owner);
+
+		mmsd_mm_get_modems();
+
+	} else {
+		mms_error("ModemManagerPlugin(): Error connecting to
ModemManager: %s\n", error->message);
+
+		mmsd_mm_state(MMSD_MM_STATE_NO_MANAGER);
+	}
+}
+
+static void
+cb_get_sim_ready(MMModem	*MMmodem,
+		 GAsyncResult	*res,
+		 gpointer	 user_data)
+{
+	modem->sim = mm_modem_get_sim_finish(MMmodem, res, NULL);
+
+	modem->imsi = mm_sim_dup_imsi(modem->sim);
+
+	mms_error("ModemManagerPlugin(): Got SIM Path: %s Identifier:
%s, imsi: %s", mm_sim_get_path(modem->sim),
+			   mm_sim_get_identifier(modem->sim), modem-
>imsi);
+}
+
+static void
+mmsd_mm_get_modem_state(void)
+{
+	g_autoptr(GError) error = NULL;
+
+	if(!modem->modem) {
+		mmsd_mm_state(MMSD_MM_STATE_NO_MODEM);
+		return;
+	}
+
+	if(!modem->modem_messaging) {
+		mmsd_mm_state(MMSD_MM_STATE_NO_MESSAGING_MODEM);
+		return;
+	}
+
+	if(modem->state < MM_MODEM_STATE_ENABLED) {
+			mms_error("ModemManagerPlugin(): Something May
be wrong with the modem, checking....");
+			switch(modem->state) {
+			case MM_MODEM_STATE_FAILED:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_FAILED");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_UNKNOWN:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_UNKNOWN");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_LOCKED:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_FAILED");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_INITIALIZING:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_INITIALIZING");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_DISABLED:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_DISABLED");
+				mms_error("ModemManagerPlugin():
Turning on Modem....");
+				mm_modem_set_power_state_sync(modem-
>modem, MM_MODEM_POWER_STATE_ON, NULL, &error);
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_DISABLING:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_DISABLING");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			case MM_MODEM_STATE_ENABLING:
+				mms_error("ModemManagerPlugin():
MM_MODEM_STATE_ENABLING");
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+			default:
+				mms_error("ModemManagerPlugin():
MM_MODEM_OTHER_BAD_STATE: %d", modem->state);
+				mmsd_mm_state(MMSD_MM_STATE_MODEM_DISA
BLED);
+				return;
+		}
+	}
+	mms_error("ModemManagerPlugin(): MM_MODEM_GOOD_STATE: %d",
modem->state);
+	mmsd_mm_state(MMSD_MM_STATE_READY);
+
+	/* Automatically process unsent/unrecieved messages when the
modem is connected */
+	if(modem->state == MM_MODEM_STATE_CONNECTED) {
+		if(modem->auto_process_on_connection == TRUE) {
+			mms_error("Auto processing unsent/unrecieved
messages per settings.");
+			/*
+			 * Prevent a race condition from the
connection 
+			 * turning active to usable for mmsd
+			 */
+			sleep(1);
+
+			activate_bearer(modem->service);
+		} else {
+			mms_error("Not auto processing
unsent/unrecieved messages per settings.");
+		}
+	}
+	return;
+}
+
+static void 
+modem_state_changed_cb(MMModem			*cb_modem,
+		       MMModemState		 old,
+		       MMModemState	 	 new,
+		       MMModemStateChangeReason	 reason)
+{
+	mms_error("ModemManagerPlugin(): State Change: Old State: %d
New State: %d, Reason: %d", old, new, reason);
+	modem->state = new;
+	mmsd_mm_get_modem_state();
+}
+
+static void
+mmsd_mm_state(int state)
+{
+	switch(state) {
+		case MMSD_MM_STATE_MODEM_FOUND:
+			if(!modem->modem_available) {
+				if(modem->modem) {
+					mm_modem_get_sim(modem->modem,
+							 NULL,
+							
(GAsyncReadyCallback)cb_get_sim_ready,
+							 NULL);
+								
						
+					modem->gdbus_modem =
MM_GDBUS_MODEM(modem->modem);
+
+					modem->modem_state_watch_id =
g_signal_connect(modem->gdbus_modem, 
+								
		       "state-changed", 
+								
		       G_CALLBACK(modem_state_changed_cb), 
+								
		       NULL);
+				}
+				modem->state =
mm_modem_get_state(modem->modem);
+				mmsd_mm_get_modem_state();
+			}
+			break;
+		case MMSD_MM_STATE_NO_MODEM:
+			if(modem->modem_available) {
+				g_signal_handler_disconnect(modem-
>gdbus_modem,
+							    modem-
>modem_state_watch_id);
+				mmsd_plugin_disconnect();
+				mms_error("ModemManagerPlugin(): Modem
vanished, Disabling plugin");
+			} else {
+				mms_error("ModemManagerPlugin(): Could
not connect to modem");
+			}
+			modem->modem_available = FALSE;
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_NO_MODEM");
+			break;
+
+		case MMSD_MM_STATE_NO_MESSAGING_MODEM:
+			g_signal_handler_disconnect(modem-
>gdbus_modem,
+						    modem-
>modem_state_watch_id);
+			mmsd_plugin_disconnect();
+			mms_error("ModemManagerPlugin(): Modem has no
messaging capabilities");
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_NO_MESSAGING_MODEM");
+			modem->modem_available = FALSE;
+			break;
+
+		case MMSD_MM_STATE_MODEM_DISABLED:
+			mms_error("ModemManagerPlugin(): Modem
disabled");
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_MODEM_DISABLED");
+
+			mms_service_set_bearer_handler(modem->service,
NULL, NULL);
+			modem->modem_available = FALSE;
+			break;
+
+		case MMSD_MM_STATE_MANAGER_FOUND:
+			if(!modem->manager_available) {
+				modem->manager_available = TRUE;
+				modem->owner_id =
g_bus_own_name(G_BUS_TYPE_SESSION,
+								
"org.ofono.mms.ModemManager",
+								
G_BUS_NAME_OWNER_FLAGS_NONE,
+								
on_bus_acquired,
+								
on_name_acquired,
+								
on_name_lost,
+								 NULL,
+								
NULL);
+			}
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_MANAGER_FOUND");
+			break;
+
+		case MMSD_MM_STATE_NO_MANAGER:
+			if(modem->manager_available) {
+				mmsd_plugin_disconnect();
+				g_clear_object(&modem->mm);
+				g_dbus_connection_unregister_object(mo
dem->master_connection,
+								   
modem->registration_id);
+				g_bus_unown_name(modem->owner_id);
+				mms_error("ModemManagerPlugin():
ModemManager vanished");
+				modem->modem_available = FALSE;
+			} else {
+				mms_error("ModemManagerPlugin(): Could
not connect to ModemManager");
+			}
+			modem->manager_available = FALSE;
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_NO_MANAGER");
+			break;
+
+		case MMSD_MM_STATE_MODEM_UNLOCK_ERROR:
+			mms_error("ModemManagerPlugin(): SIM card
unlock failed");
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_MODEM_UNLOCK_ERROR");
+			break;
+
+		case MMSD_MM_STATE_READY:
+			mms_error("ModemManagerPlugin():
MMSD_MM_STATE_READY");
+			modem->modem_available = TRUE;
+			mmsd_plugin_connect();
+			if(modem->autoprocess_sms_wap) {
+				mms_error("ModemManagerPlugin():
Checking for new SMS WAPs");
+			mmsd_get_all_sms();
+			} else {
+				mms_error("ModemManagerPlugin(): Not
checking SMS WAPs");
+			}
+			break;
+
+		default:
+			g_return_if_reached();
+	}
+}
+
+static void
+mm_appeared_cb(GDBusConnection	*connection,
+	       const gchar 	*name,
+	       const gchar 	*name_owner,
+	       gpointer		 user_data)
+{
+	g_assert(G_IS_DBUS_CONNECTION(connection));
+
+	mm_manager_new(connection,
+		       G_DBUS_OBJECT_MANAGER_CLIENT_FLAGS_NONE,
+		       NULL,
+		       (GAsyncReadyCallback) cb_mm_manager_new,
+		       NULL);
+}
+
+static void
+mm_vanished_cb(GDBusConnection	*connection,
+	       const gchar	*name,
+	       gpointer		 user_data)
+{
+	g_assert(G_IS_DBUS_CONNECTION(connection));
+
+	mms_error("ModemManagerPlugin(): Modem Manager vanished");
+	mmsd_mm_state(MMSD_MM_STATE_NO_MANAGER);
+}
+
+static void
+mm_get_modem_manager(void)
+{
+	modem->mm_watch_id = g_bus_watch_name(G_BUS_TYPE_SYSTEM,
+					      MM_DBUS_SERVICE,
+					     
G_BUS_NAME_WATCHER_FLAGS_AUTO_START,
+					     
(GBusNameAppearedCallback) mm_appeared_cb,
+					     
(GBusNameVanishedCallback) mm_vanished_cb,
+					      NULL, 
+					      NULL);
+}
+
+static void bearer_handler(mms_bool_t    active, 
+			   void 	*user_data)
+{
+	struct modem_data *modem = user_data;
+	gint32 response;
+
+	/* Check for any errors within the context */
+	response = set_context();
+	if(response != MMSD_MM_MODEM_CONTEXT_ACTIVE) {
+		mms_error("ModemManagerPlugin(): Set MMSC: %s, Set
Proxy: %s, Set MMS APN: %s", modem->message_center, modem->MMS_proxy,
modem->mms_apn);
+		g_dbus_connection_emit_signal(modem-
>master_connection,
+					      NULL,
+					      "/org/ofono/mms",
+					     
"org.ofono.mms.ModemManager",
+					      "BearerHandlerError",
+					      g_variant_new("(h)",
response),
+					      NULL);
+	}
+	mms_error("ModemManagerPlugin(): At Bearer Handler: path %s
active %d context_active %d", modem->path, active, modem-
>context_active);
+	if(active == TRUE && modem->context_active == TRUE) {
+		mms_error("ModemManagerPlugin(): active and
context_active, bearer_notify");
+		mms_service_bearer_notify(modem->service, TRUE, modem-
>context_interface, modem->MMS_proxy);
+		return;
+	} else if(active == TRUE && modem->context_active == FALSE) {
+		mms_error("ModemManagerPlugin(): Error activating
context!");
+		mms_service_bearer_notify(modem->service, FALSE, NULL,
NULL);
+		return;
+	}
+
+	mms_error("ModemManagerPlugin(): checking for failure");
+	if(active == FALSE && modem->context_active == FALSE) {
+		mms_error("ModemManagerPlugin(): Context not
active!");
+		mms_service_bearer_notify(modem->service, FALSE, NULL,
NULL);
+		return;
+	} else {
+		mms_error("ModemManagerPlugin(): No failures");
+		mms_service_bearer_notify(modem->service, FALSE,
modem->context_interface, modem->MMS_proxy);
+		return;
+	}
+
+}
+ 
+static int set_context(void)
+{
+	guint 			 max_bearers, active_bearers;
+	GList 			*bearer_list, *l;
+	MMBearer 		*modem_bearer;
+	MMBearerProperties 	*modem_bearer_properties;
+	const gchar 		*apn;
+	gboolean 		 interface_disconnected;
+	gboolean 		 bearer_connected;
+
+	mms_error("ModemManagerPlugin(): Setting Context...");
+	if(modem->context_active) {
+		g_free(modem->context_interface);
+		g_free(modem->context_path);
+	}
+	modem->context_active = FALSE;
+	interface_disconnected = FALSE;
+	mms_service_set_mmsc(modem->service, modem->message_center);
+	max_bearers = mm_modem_get_max_active_bearers(modem->modem);
+	mms_error("ModemManagerPlugin(): Max number of bearers: %d",
max_bearers);
+	bearer_list = mm_modem_list_bearers_sync(modem->modem, NULL,
NULL);
+	active_bearers = 0;
+	if(bearer_list != NULL) {
+		for(l = bearer_list; l != NULL; l = l->next) {
+			active_bearers = active_bearers + 1;
+			modem_bearer =(MMBearer *) l->data;
+			modem_bearer_properties =
mm_bearer_get_properties(modem_bearer);
+			apn =
mm_bearer_properties_get_apn(modem_bearer_properties);
+			mms_error("ModemManagerPlugin(): Current
Context APN: %s, mmsd settings MMS APN: %s", apn, modem->mms_apn);
+			bearer_connected =
mm_bearer_get_connected(modem_bearer);
+			if(g_strcmp0(apn, modem->mms_apn) == 0 ) {
+				if(modem->state !=
MM_MODEM_STATE_CONNECTED) {
+					mms_error("ModemManagerPlugin(
): The modem interface is reporting it is disconnected!");
+					mms_error("ModemManagerPlugin(
): Reported State: %d", modem->state);
+					interface_disconnected = TRUE;
+				} else if(!bearer_connected) {
+					mms_error("ModemManagerPlugin(
): The proper context is not connected!");
+					interface_disconnected = TRUE;
+				} else {
+					mms_error("ModemManagerPlugin(
): You are connected to the correct APN! Enabling context...");
+					modem->context_interface =
mm_bearer_dup_interface(modem_bearer);
+					modem->context_path =
mm_bearer_dup_path(modem_bearer);
+					modem->context_active = TRUE;
+				}
+			}
+		}
+		g_list_free(bearer_list);
+		g_list_free(l);
+		if(!modem->context_active) { // I did not find the
right context I wanted.
+			if(active_bearers == max_bearers) {
+				if(interface_disconnected) {
+					return
MMSD_MM_MODEM_INTERFACE_DISCONNECTED;
+				} else {
+					mms_error("ModemManagerPlugin(
): The modem is not connected to the correct APN!");
+					return
MMSD_MM_MODEM_INCORRECT_APN_CONNECTED;
+				}
+			} else if(active_bearers == 0) {
+				mms_error("ModemManagerPlugin(): The
modem bearer is disconnected! Please enable modem data");
+				return
MMSD_MM_MODEM_NO_BEARERS_ACTIVE;
+			} 
+			 else if(active_bearers < max_bearers) {
+				/*
+				 * TODO: Modem manager does not
support this yet, but this is
+				 *	 where to add code when Modem
manager supports multiple
+				 *	 contexts and/or a seperate
MMS context.
+				 *	 The Pinephone and Librem 5
only support 
+				 *	 one active bearer as well
+				 */ 
+				mms_error("ModemManagerPlugin(): This
is a stub for adding a new context/bearer, but Modem Manager does not
support this yet."); 
+				return
MMSD_MM_MODEM_FUTURE_CASE_DISCONNECTED;
+			}
+		}
+	} else {
+		mms_error("ModemManagerPlugin(): There are no modem
bearers! Please enable modem data");
+		return MMSD_MM_MODEM_NO_BEARERS_ACTIVE;
+	}
+	
+	if(g_strcmp0(modem->message_center, "http://mmsc.invalid") ==
0) {
+		mms_error("ModemManagerPlugin(): The MMSC is not
configured! Please configure the MMSC and restart mmsd.");
+		return MMSD_MM_MODEM_MMSC_MISCONFIGURED;
+	} 
+	return MMSD_MM_MODEM_CONTEXT_ACTIVE;
+}
+
+static void mmsd_plugin_connect(void) {
+	if(modem->plugin_registered == FALSE) {
+		mms_error("ModemManagerPlugin(): Registering Modem
Manager MMS Service");
+		mms_service_register(modem->service);
+		modem-> plugin_registered = TRUE;
+	}
+	mms_error("ModemManagerPlugin(): Setting Bearer Handler");
+	mms_service_set_bearer_handler(modem->service, bearer_handler,
modem);
+} 
+
+
+static void mmsd_plugin_disconnect(void)
+{
+	mms_error("ModemManagerPlugin(): Disabling Bearer Handler");
+	mms_service_set_bearer_handler(modem->service, NULL, NULL);
+	g_object_unref(modem->sim);
+	g_free(modem->imsi);
+	g_free(modem->path);
+	g_clear_object(&modem->modem);
+	g_clear_object(&modem->modem_messaging);
+	modem->object = NULL;
+	if(modem->device_arr && modem->device_arr->len) {
+		g_ptr_array_set_size(modem->device_arr, 0);
+		g_ptr_array_unref(modem->device_arr);
+	}
+	modem->modem_available = FALSE;
+}
+ 
+static int modemmanager_init(void)
+{
+	g_autoptr(GError) error = NULL;
+	/* Set up modem Structure to be used here */
+	modem = g_try_new0(struct modem_data, 1);
+
+	if(modem == NULL) {
+		mms_error("ModemManagerPlugin(): Could not allocate
space for modem data!");
+		return -ENOMEM;
+	}
+	modem->service = mms_service_create();
+	mms_service_set_identity(modem->service, IDENTIFIER);
+	
+	// Opening/making config file at
$HOME/.mms/modemmanager/ModemManagerSettings
+	modem->modemsettings = mms_settings_open(IDENTIFIER,
SETTINGS_STORE);
+
+	modem->message_center = g_key_file_get_string(modem-
>modemsettings, 
+						      SETTINGS_GROUP,
+						      "CarrierMMSC",
&error);
+	if(error) {
+		mms_error("ModemManagerPlugin(): No MMSC was
configured!");
+		modem->message_center =
g_strdup("http://mms.invalid");
+		g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+				      "CarrierMMSC", modem-
>message_center);
+		error = NULL;
+	}
+
+	modem->mms_apn = g_key_file_get_string(modem->modemsettings, 
+					       SETTINGS_GROUP,
+					       "MMS_APN", &error);
+	if(error) {
+		mms_error("ModemManagerPlugin(): No MMS APN was
configured!");
+		modem->mms_apn = g_strdup("apn.invalid");
+		g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+							  "MMS_APN",
modem->mms_apn);
+		error = NULL;
+	}
+
+	modem->MMS_proxy = g_key_file_get_string(modem->modemsettings,
+						 SETTINGS_GROUP,
+						 "CarrierMMSProxy",
&error);
+	if(error) {
+		mms_error("ModemManagerPlugin(): No Context Proxy was
configured! Setting to NULL.");
+		modem->MMS_proxy = g_strdup("NULL");
+		g_key_file_set_string(modem->modemsettings,
SETTINGS_GROUP,
+				      "CarrierMMSProxy", modem-
>MMS_proxy);
+		error = NULL;
+	}
+	if(g_strcmp0(modem->MMS_proxy, "NULL") == 0) {
+		g_free(modem->MMS_proxy);
+		modem->MMS_proxy = NULL;
+	}
+
+	modem->auto_process_on_connection =
g_key_file_get_boolean(modem->modemsettings, 
+								  
SETTINGS_GROUP,
+								  
"AutoProcessOnConnection", 
+								  
&error);
+	if(error) {
+		mms_error("ModemManagerPlugin(): Auto Process On
Connection was not configured! Setting to TRUE.");
+		modem->auto_process_on_connection = TRUE;
+		g_key_file_set_boolean(modem->modemsettings,
SETTINGS_GROUP,
+				       "AutoProcessOnConnection",
modem->auto_process_on_connection);
+		error = NULL;
+	}
+
+	modem->autoprocess_sms_wap = g_key_file_get_boolean(modem-
>modemsettings, 
+							   
SETTINGS_GROUP,
+							  
"AutoProcessSMSWAP", 
+							   &error);
+	if(error) {
+		mms_error("ModemManagerPlugin(): Auto Process SMS WAP
was not configured! Setting to FALSE.");
+		modem->autoprocess_sms_wap = FALSE;
+		g_key_file_set_boolean(modem->modemsettings,
SETTINGS_GROUP,
+				       "AutoProcessSMSWAP", modem-
>autoprocess_sms_wap);
+		error = NULL;
+	}
+
+	mms_settings_close(IDENTIFIER, SETTINGS_STORE, modem-
>modemsettings, TRUE);
+	introspection_data =
g_dbus_node_info_new_for_xml(introspection_xml, NULL);
+	g_assert(introspection_data != NULL);
+
+	modem->modem_available = FALSE;
+	modem->manager_available = FALSE;
+	modem->context_active = FALSE;
+	modem->plugin_registered = FALSE;
+	mm_get_modem_manager();
+
+	return 0;
+}
+
+static void modemmanager_exit(void)
+{
+	if(modem->plugin_registered == TRUE) {
+		mms_service_unregister(modem->service);
+	}
+	if(modem->manager_available) {
+		mmsd_plugin_disconnect();
+		g_clear_object(&modem->mm);
+		g_dbus_connection_unregister_object(modem-
>master_connection,
+						    modem-
>registration_id);
+		g_bus_unown_name(modem->owner_id);
+	}
+	g_free(modem->message_center);
+	g_free(modem->MMS_proxy);
+	g_free(modem->mms_apn);
+	g_free(modem);
+	g_dbus_node_info_unref(introspection_data);
+}
+
+MMS_PLUGIN_DEFINE(modemmanager, modemmanager_init, modemmanager_exit)
diff --git a/src/service.c b/src/service.c
index b0c2428..0f5c13c 100644
--- a/src/service.c
+++ b/src/service.c
@@ -647,7 +647,7 @@ static void process_request_queue(struct
mms_service *service);
 static void emit_message_added(const struct mms_service *service,
 						struct mms_message
*msg);
 
-static void activate_bearer(struct mms_service *service)
+void activate_bearer(struct mms_service *service)
 {
 	DBG("service %p setup %d active %d", service, service-
>bearer_setup, service->bearer_active);
 
@@ -782,6 +782,7 @@ static DBusMessage *get_messages(DBusConnection
*conn,
 	reply = dbus_message_new_method_return(dbus_msg);
 	if (reply == NULL)
 		return NULL;
+	//return reply;
 
 	dbus_message_iter_init_append(reply, &iter);
 
diff --git a/src/service.h b/src/service.h
index 56c0585..586ceca 100644
--- a/src/service.h
+++ b/src/service.h
@@ -52,3 +52,5 @@ int mms_message_register(struct mms_service *service,
 						struct mms_message
*msg);
 int mms_message_unregister(const struct mms_service *service,
 						const char *msg_path);
+
+void activate_bearer(struct mms_service *service);
-- 
2.30.2


