Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5190B1BB0E0
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgD0WCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgD0WCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:05 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6F52087E;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=wzhGn++bfspWVoHEy2uWMKHT37k3Fc2hIQ7yHubHNZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAzNKe/24V3ksltezVXw5DsRZTNQIdwgMiIFQU/hal5FcBX17ob8i86095nAaAoGJ
         yVuJhwxkuMRs7HSwz9hTyi6PbVvRP2GLkc9q+EKN5Jvggcuywp3rayGwdrSpZT6rk2
         awfShFN6nmfVd42Zdl4k8kOUrKZkXvEdzuOenO2U=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Inv-J0; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 04/38] docs: networking: convert arcnet-hardware.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:19 +0200
Message-Id: <182967a0f02bc0365ce1612df83ece8623566ff5.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add document title markup;
- add notes markups;
- mark tables as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 ...rcnet-hardware.txt => arcnet-hardware.rst} | 2169 +++++++++--------
 Documentation/networking/index.rst            |    1 +
 2 files changed, 1136 insertions(+), 1034 deletions(-)
 rename Documentation/networking/{arcnet-hardware.txt => arcnet-hardware.rst} (66%)

diff --git a/Documentation/networking/arcnet-hardware.txt b/Documentation/networking/arcnet-hardware.rst
similarity index 66%
rename from Documentation/networking/arcnet-hardware.txt
rename to Documentation/networking/arcnet-hardware.rst
index 731de411513c..b5a1a020c824 100644
--- a/Documentation/networking/arcnet-hardware.txt
+++ b/Documentation/networking/arcnet-hardware.rst
@@ -1,11 +1,15 @@
- 
------------------------------------------------------------------------------
-1) This file is a supplement to arcnet.txt.  Please read that for general
-   driver configuration help.
------------------------------------------------------------------------------
-2) This file is no longer Linux-specific.  It should probably be moved out of
-   the kernel sources.  Ideas?
------------------------------------------------------------------------------
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+ARCnet Hardware
+===============
+
+.. note::
+
+   1) This file is a supplement to arcnet.txt.  Please read that for general
+      driver configuration help.
+   2) This file is no longer Linux-specific.  It should probably be moved out
+      of the kernel sources.  Ideas?
 
 Because so many people (myself included) seem to have obtained ARCnet cards
 without manuals, this file contains a quick introduction to ARCnet hardware,
@@ -14,8 +18,8 @@ e-mail apenwarr@worldvisions.ca with any settings for your particular card,
 or any other information you have!
 
 
-INTRODUCTION TO ARCNET
-----------------------
+Introduction to ARCnet
+======================
 
 ARCnet is a network type which works in a way similar to popular Ethernet
 networks but which is also different in some very important ways.
@@ -30,7 +34,7 @@ since I only have the 2.5 Mbps variety.  It is probably not going to saturate
 your 100 Mbps card.  Stop complaining. :)
 
 You also cannot connect an ARCnet card to any kind of Ethernet card and
-expect it to work.  
+expect it to work.
 
 There are two "types" of ARCnet - STAR topology and BUS topology.  This
 refers to how the cards are meant to be wired together.  According to most
@@ -71,19 +75,24 @@ although they are generally kept down to the Ethernet-style 1500 bytes.
 For more information on the advantages and disadvantages (mostly the
 advantages) of ARCnet networks, you might try the "ARCnet Trade Association"
 WWW page:
+
 	http://www.arcnet.com
 
 
-CABLING ARCNET NETWORKS
------------------------
+Cabling ARCnet Networks
+=======================
+
+This section was rewritten by
+
+	Vojtech Pavlik     <vojtech@suse.cz>
 
-This section was rewritten by 
-        Vojtech Pavlik     <vojtech@suse.cz>
 using information from several people, including:
-        Avery Pennraun     <apenwarr@worldvisions.ca>
- 	Stephen A. Wood    <saw@hallc1.cebaf.gov>
- 	John Paul Morrison <jmorriso@bogomips.ee.ubc.ca>
- 	Joachim Koenig     <jojo@repas.de>
+
+	- Avery Pennraun     <apenwarr@worldvisions.ca>
+	- Stephen A. Wood    <saw@hallc1.cebaf.gov>
+	- John Paul Morrison <jmorriso@bogomips.ee.ubc.ca>
+	- Joachim Koenig     <jojo@repas.de>
+
 and Avery touched it up a bit, at Vojtech's request.
 
 ARCnet (the classic 2.5 Mbps version) can be connected by two different
@@ -103,13 +112,13 @@ equal to a high impedance one with a terminator installed.
 
 Usually, the ARCnet networks are built up from STAR cards and hubs.  There
 are two types of hubs - active and passive.  Passive hubs are small boxes
-with four BNC connectors containing four 47 Ohm resistors:
+with four BNC connectors containing four 47 Ohm resistors::
 
-   |         | wires
-   R         + junction
--R-+-R-      R 47 Ohm resistors
-   R
-   |
+	   |         | wires
+	   R         + junction
+	-R-+-R-      R 47 Ohm resistors
+	   R
+	   |
 
 The shielding is connected together.  Active hubs are much more complicated;
 they are powered and contain electronics to amplify the signal and send it
@@ -127,14 +136,15 @@ And now to the cabling.  What you can connect together:
 2. A card to a passive hub.  Remember that all unused connectors on the hub
    must be properly terminated with 93 Ohm (or something else if you don't
    have the right ones) terminators.
-   	(Avery's note: oops, I didn't know that.  Mine (TV cable) works
+
+	(Avery's note: oops, I didn't know that.  Mine (TV cable) works
 	anyway, though.)
 
 3. A card to an active hub.  Here is no need to terminate the unused
    connectors except some kind of aesthetic feeling.  But, there may not be
    more than eleven active hubs between any two computers.  That of course
    doesn't limit the number of active hubs on the network.
-   
+
 4. An active hub to another.
 
 5. An active hub to passive hub.
@@ -142,22 +152,22 @@ And now to the cabling.  What you can connect together:
 Remember that you cannot connect two passive hubs together.  The power loss
 implied by such a connection is too high for the net to operate reliably.
 
-An example of a typical ARCnet network:
+An example of a typical ARCnet network::
 
-           R                     S - STAR type card              
+	   R                     S - STAR type card
     S------H--------A-------S    R - Terminator
-           |        |            H - Hub                         
-           |        |            A - Active hub                  
-           |   S----H----S                                       
-           S        |                                            
-                    |                                            
-                    S                                            
-                                                                          
+	   |        |            H - Hub
+	   |        |            A - Active hub
+	   |   S----H----S
+	   S        |
+		    |
+		    S
+
 The BUS topology is very similar to the one used by Ethernet.  The only
 difference is in cable and terminators: they should be 93 Ohm.  Ethernet
 uses 50 Ohm impedance. You use T connectors to put the computers on a single
 line of cable, the bus. You have to put terminators at both ends of the
-cable. A typical BUS ARCnet network looks like:
+cable. A typical BUS ARCnet network looks like::
 
     RT----T------T------T------T------TR
      B    B      B      B      B      B
@@ -168,63 +178,63 @@ cable. A typical BUS ARCnet network looks like:
 
 But that is not all! The two types can be connected together.  According to
 the official documentation the only way of connecting them is using an active
-hub:
+hub::
 
-         A------T------T------TR
-         |      B      B      B
+	 A------T------T------TR
+	 |      B      B      B
      S---H---S
-         |
-         S
+	 |
+	 S
 
 The official docs also state that you can use STAR cards at the ends of
-BUS network in place of a BUS card and a terminator:
+BUS network in place of a BUS card and a terminator::
 
      S------T------T------S
-            B      B
+	    B      B
 
 But, according to my own experiments, you can simply hang a BUS type card
 anywhere in middle of a cable in a STAR topology network.  And more - you
 can use the bus card in place of any star card if you use a terminator. Then
 you can build very complicated networks fulfilling all your needs!  An
-example:
+example::
+
+				  S
+				  |
+	   RT------T-------T------H------S
+	    B      B       B      |
+				  |       R
+    S------A------T-------T-------A-------H------TR
+	   |      B       B       |       |      B
+	   |   S                 BT       |
+	   |   |                  |  S----A-----S
+    S------H---A----S             |       |
+	   |   |      S------T----H---S   |
+	   S   S             B    R       S
 
-                                  S
-                                  |
-           RT------T-------T------H------S
-            B      B       B      |
-                                  |       R
-    S------A------T-------T-------A-------H------TR                    
-           |      B       B       |       |      B                         
-           |   S                 BT       |                                 
-           |   |                  |  S----A-----S
-    S------H---A----S             |       | 
-           |   |      S------T----H---S   |
-           S   S             B    R       S  
-                                                               
 A basically different cabling scheme is used with Twisted Pair cabling. Each
 of the TP cards has two RJ (phone-cord style) connectors.  The cards are
 then daisy-chained together using a cable connecting every two neighboring
 cards.  The ends are terminated with RJ 93 Ohm terminators which plug into
-the empty connectors of cards on the ends of the chain.  An example:
+the empty connectors of cards on the ends of the chain.  An example::
 
-          ___________   ___________
-      _R_|_         _|_|_         _|_R_  
-     |     |       |     |       |     |      
-     |Card |       |Card |       |Card |     
-     |_____|       |_____|       |_____|          
+	  ___________   ___________
+      _R_|_         _|_|_         _|_R_
+     |     |       |     |       |     |
+     |Card |       |Card |       |Card |
+     |_____|       |_____|       |_____|
 
 
 There are also hubs for the TP topology.  There is nothing difficult
 involved in using them; you just connect a TP chain to a hub on any end or
-even at both.  This way you can create almost any network configuration. 
+even at both.  This way you can create almost any network configuration.
 The maximum of 11 hubs between any two computers on the net applies here as
-well.  An example:
+well.  An example::
 
     RP-------P--------P--------H-----P------P-----PR
-                               |
+			       |
       RP-----H--------P--------H-----P------PR
-             |                 |
-             PR                PR
+	     |                 |
+	     PR                PR
 
     R - RJ Terminator
     P - TP Card
@@ -234,11 +244,13 @@ Like any network, ARCnet has a limited cable length.  These are the maximum
 cable lengths between two active ends (an active end being an active hub or
 a STAR card).
 
+		========== ======= ===========
 		RG-62       93 Ohm up to 650 m
 		RG-59/U     75 Ohm up to 457 m
 		RG-11/U     75 Ohm up to 533 m
 		IBM Type 1 150 Ohm up to 200 m
 		IBM Type 3 100 Ohm up to 100 m
+		========== ======= ===========
 
 The maximum length of all cables connected to a passive hub is limited to 65
 meters for RG-62 cabling; less for others.  You can see that using passive
@@ -248,8 +260,8 @@ most distant points of the net is limited to 3000 meters. The maximum length
 of a TP cable between two cards/hubs is 650 meters.
 
 
-SETTING THE JUMPERS
--------------------
+Setting the Jumpers
+===================
 
 All ARCnet cards should have a total of four or five different settings:
 
@@ -261,43 +273,51 @@ All ARCnet cards should have a total of four or five different settings:
     eating net connections on my system (at least) otherwise.  My guess is
     this may be because, if your card is at 0x2E0, probing for a serial port
     at 0x2E8 will reset the card and probably mess things up royally.
+
 	- Avery's favourite: 0x300.
 
   - the IRQ: on  8-bit cards, it might be 2 (9), 3, 4, 5, or 7.
-             on 16-bit cards, it might be 2 (9), 3, 4, 5, 7, or 10-15.
-             
+	     on 16-bit cards, it might be 2 (9), 3, 4, 5, 7, or 10-15.
+
     Make sure this is different from any other card on your system.  Note
     that IRQ2 is the same as IRQ9, as far as Linux is concerned.  You can
     "cat /proc/interrupts" for a somewhat complete list of which ones are in
     use at any given time.  Here is a list of common usages from Vojtech
     Pavlik <vojtech@suse.cz>:
-    	("Not on bus" means there is no way for a card to generate this
+
+	("Not on bus" means there is no way for a card to generate this
 	interrupt)
-	IRQ  0 - Timer 0 (Not on bus)
-	IRQ  1 - Keyboard (Not on bus)
-	IRQ  2 - IRQ Controller 2 (Not on bus, nor does interrupt the CPU)
-	IRQ  3 - COM2
-	IRQ  4 - COM1
-	IRQ  5 - FREE (LPT2 if you have it; sometimes COM3; maybe PLIP)
-	IRQ  6 - Floppy disk controller
-	IRQ  7 - FREE (LPT1 if you don't use the polling driver; PLIP) 
-	IRQ  8 - Realtime Clock Interrupt (Not on bus)
-	IRQ  9 - FREE (VGA vertical sync interrupt if enabled)
-	IRQ 10 - FREE
-	IRQ 11 - FREE
-	IRQ 12 - FREE
-	IRQ 13 - Numeric Coprocessor (Not on bus)
-	IRQ 14 - Fixed Disk Controller
-	IRQ 15 - FREE (Fixed Disk Controller 2 if you have it) 
-	
-	Note: IRQ 9 is used on some video cards for the "vertical retrace"
-	interrupt.  This interrupt would have been handy for things like
-	video games, as it occurs exactly once per screen refresh, but
-	unfortunately IBM cancelled this feature starting with the original
-	VGA and thus many VGA/SVGA cards do not support it.  For this
-	reason, no modern software uses this interrupt and it can almost
-	always be safely disabled, if your video card supports it at all.
-	
+
+	======   =========================================================
+	IRQ  0   Timer 0 (Not on bus)
+	IRQ  1   Keyboard (Not on bus)
+	IRQ  2   IRQ Controller 2 (Not on bus, nor does interrupt the CPU)
+	IRQ  3   COM2
+	IRQ  4   COM1
+	IRQ  5   FREE (LPT2 if you have it; sometimes COM3; maybe PLIP)
+	IRQ  6   Floppy disk controller
+	IRQ  7   FREE (LPT1 if you don't use the polling driver; PLIP)
+	IRQ  8   Realtime Clock Interrupt (Not on bus)
+	IRQ  9   FREE (VGA vertical sync interrupt if enabled)
+	IRQ 10   FREE
+	IRQ 11   FREE
+	IRQ 12   FREE
+	IRQ 13   Numeric Coprocessor (Not on bus)
+	IRQ 14   Fixed Disk Controller
+	IRQ 15   FREE (Fixed Disk Controller 2 if you have it)
+	======   =========================================================
+
+
+	.. note::
+
+	   IRQ 9 is used on some video cards for the "vertical retrace"
+	   interrupt.  This interrupt would have been handy for things like
+	   video games, as it occurs exactly once per screen refresh, but
+	   unfortunately IBM cancelled this feature starting with the original
+	   VGA and thus many VGA/SVGA cards do not support it.  For this
+	   reason, no modern software uses this interrupt and it can almost
+	   always be safely disabled, if your video card supports it at all.
+
 	If your card for some reason CANNOT disable this IRQ (usually there
 	is a jumper), one solution would be to clip the printed circuit
 	contact on the board: it's the fourth contact from the left on the
@@ -308,14 +328,18 @@ All ARCnet cards should have a total of four or five different settings:
   - the memory address:  Unlike most cards, ARCnets use "shared memory" for
     copying buffers around.  Make SURE it doesn't conflict with any other
     used memory in your system!
+
+    ::
+
 	A0000		- VGA graphics memory (ok if you don't have VGA)
-        B0000		- Monochrome text mode
-        C0000		\  One of these is your VGA BIOS - usually C0000.
-        E0000		/
-        F0000		- System BIOS
+	B0000		- Monochrome text mode
+	C0000		\  One of these is your VGA BIOS - usually C0000.
+	E0000		/
+	F0000		- System BIOS
 
     Anything less than 0xA0000 is, well, a BAD idea since it isn't above
     640k.
+
 	- Avery's favourite: 0xD0000
 
   - the station address:  Every ARCnet card has its own "unique" network
@@ -326,6 +350,7 @@ All ARCnet cards should have a total of four or five different settings:
     neat stuff will probably happen if you DO use them).  By the way, if you
     haven't already guessed, don't set this the same as any other ARCnet on
     your network!
+
 	- Avery's favourite:  3 and 4.  Not that it matters.
 
   - There may be ETS1 and ETS2 settings.  These may or may not make a
@@ -336,28 +361,34 @@ All ARCnet cards should have a total of four or five different settings:
     requirement here is that all cards on the network with ETS1 and ETS2
     jumpers have them in the same position.  Chris Hindy <chrish@io.org>
     sent in a chart with actual values for this:
+
+	======= ======= =============== ====================
 	ET1	ET2	Response Time	Reconfiguration Time
-	---	---	-------------	--------------------
+	======= ======= =============== ====================
 	open	open	74.7us		840us
 	open	closed	283.4us		1680us
 	closed	open	561.8us		1680us
 	closed	closed	1118.6us	1680us
-    
+	======= ======= =============== ====================
+
     Make sure you set ETS1 and ETS2 to the SAME VALUE for all cards on your
     network.
-    
-Also, on many cards (not mine, though) there are red and green LED's. 
+
+Also, on many cards (not mine, though) there are red and green LED's.
 Vojtech Pavlik <vojtech@suse.cz> tells me this is what they mean:
+
+	=============== =============== =====================================
 	GREEN           RED             Status
-	-----		---		------
+	=============== =============== =====================================
 	OFF             OFF             Power off
 	OFF             Short flashes   Cabling problems (broken cable or not
-					  terminated)
+					terminated)
 	OFF (short)     ON              Card init
 	ON              ON              Normal state - everything OK, nothing
-					  happens
+					happens
 	ON              Long flashes    Data transfer
 	ON              OFF             Never happens (maybe when wrong ID)
+	=============== =============== =====================================
 
 
 The following is all the specific information people have sent me about
@@ -366,7 +397,7 @@ huge amounts of duplicated information.  I have no time to fix it.  If you
 want to, PLEASE DO!  Just send me a 'diff -u' of all your changes.
 
 The model # is listed right above specifics for that card, so you should be
-able to use your text viewer's "search" function to find the entry you want. 
+able to use your text viewer's "search" function to find the entry you want.
 If you don't KNOW what kind of card you have, try looking through the
 various diagrams to see if you can tell.
 
@@ -378,8 +409,9 @@ model that is, please e-mail me to say so.
 
 Cards Listed in this file (in this order, mostly):
 
+	=============== ======================= ====
 	Manufacturer	Model #			Bits
-	------------	-------			----
+	=============== ======================= ====
 	SMC		PC100			8
 	SMC		PC110			8
 	SMC		PC120			8
@@ -404,17 +436,19 @@ Cards Listed in this file (in this order, mostly):
 	No Name		Taiwan R.O.C?		8
 	No Name		Model 9058		8
 	Tiara		Tiara Lancard?		8
-	
+	=============== ======================= ====
 
-** SMC = Standard Microsystems Corp.
-** CNet Tech = CNet Technology, Inc.
 
+* SMC = Standard Microsystems Corp.
+* CNet Tech = CNet Technology, Inc.
 
 Unclassified Stuff
-------------------
+==================
+
   - Please send any other information you can find.
-  
-  - And some other stuff (more info is welcome!):
+
+  - And some other stuff (more info is welcome!)::
+
      From: root@ultraworld.xs4all.nl (Timo Hilbrink)
      To: apenwarr@foxnet.net (Avery Pennarun)
      Date: Wed, 26 Oct 1994 02:10:32 +0000 (GMT)
@@ -423,7 +457,7 @@ Unclassified Stuff
      [...parts deleted...]
 
      About the jumpers: On my PC130 there is one more jumper, located near the
-     cable-connector and it's for changing to star or bus topology; 
+     cable-connector and it's for changing to star or bus topology;
      closed: star - open: bus
      On the PC500 are some more jumper-pins, one block labeled with RX,PDN,TXI
      and another with ALE,LA17,LA18,LA19 these are undocumented..
@@ -432,136 +466,130 @@ Unclassified Stuff
 
      --- CUT ---
 
+Standard Microsystems Corp (SMC)
+================================
+
+PC100, PC110, PC120, PC130 (8-bit cards) and PC500, PC600 (16-bit cards)
+------------------------------------------------------------------------
 
-** Standard Microsystems Corp (SMC) **
-PC100, PC110, PC120, PC130 (8-bit cards)
-PC500, PC600 (16-bit cards)
----------------------------------
   - mainly from Avery Pennarun <apenwarr@worldvisions.ca>.  Values depicted
     are from Avery's setup.
   - special thanks to Timo Hilbrink <timoh@xs4all.nl> for noting that PC120,
-    130, 500, and 600 all have the same switches as Avery's PC100. 
+    130, 500, and 600 all have the same switches as Avery's PC100.
     PC500/600 have several extra, undocumented pins though. (?)
   - PC110 settings were verified by Stephen A. Wood <saw@cebaf.gov>
   - Also, the JP- and S-numbers probably don't match your card exactly.  Try
     to find jumpers/switches with the same number of settings - it's
     probably more reliable.
-  
-
-     JP5		       [|]    :    :    :    :
-(IRQ Setting)		      IRQ2  IRQ3 IRQ4 IRQ5 IRQ7
-		Put exactly one jumper on exactly one set of pins.
-
-
-                          1  2   3  4  5  6   7  8  9 10
-     S1                /----------------------------------\
-(I/O and Memory        |  1  1 * 0  0  0  0 * 1  1  0  1  |
- addresses)            \----------------------------------/
-                          |--|   |--------|   |--------|
-                          (a)       (b)           (m)
-                          
-                WARNING.  It's very important when setting these which way
-                you're holding the card, and which way you think is '1'!
-                
-                If you suspect that your settings are not being made
-		correctly, try reversing the direction or inverting the
-		switch positions.
-
-		a: The first digit of the I/O address.
-			Setting		Value
-			-------		-----
-			00		0
-			01		1
-			10		2
-			11		3
-
-		b: The second digit of the I/O address.
-			Setting		Value
-			-------		-----
-			0000		0
-			0001		1
-			0010		2
-			...		...
-			1110		E
-			1111		F
-
-		The I/O address is in the form ab0.  For example, if
-		a is 0x2 and b is 0xE, the address will be 0x2E0.
-
-		DO NOT SET THIS LESS THAN 0x200!!!!!
-
-
-		m: The first digit of the memory address.
-			Setting		Value
-			-------		-----
-			0000		0
-			0001		1
-			0010		2
-			...		...
-			1110		E
-			1111		F
-
-		The memory address is in the form m0000.  For example, if
-		m is D, the address will be 0xD0000.
-
-		DO NOT SET THIS TO C0000, F0000, OR LESS THAN A0000!
-
-                          1  2  3  4  5  6  7  8
-     S2                /--------------------------\
-(Station Address)      |  1  1  0  0  0  0  0  0  |
-                       \--------------------------/
-
-			Setting		Value
-			-------		-----
-			00000000	00
-			10000000	01
-			01000000	02
-			...
-			01111111	FE
-			11111111	FF
-
-		Note that this is binary with the digits reversed!
-
-		DO NOT SET THIS TO 0 OR 255 (0xFF)!
-
-
-*****************************************************************************
-
-** Standard Microsystems Corp (SMC) **
+
+::
+
+	     JP5		       [|]    :    :    :    :
+	(IRQ Setting)		      IRQ2  IRQ3 IRQ4 IRQ5 IRQ7
+			Put exactly one jumper on exactly one set of pins.
+
+
+				  1  2   3  4  5  6   7  8  9 10
+	     S1                /----------------------------------\
+	(I/O and Memory        |  1  1 * 0  0  0  0 * 1  1  0  1  |
+	 addresses)            \----------------------------------/
+				  |--|   |--------|   |--------|
+				  (a)       (b)           (m)
+
+			WARNING.  It's very important when setting these which way
+			you're holding the card, and which way you think is '1'!
+
+			If you suspect that your settings are not being made
+			correctly, try reversing the direction or inverting the
+			switch positions.
+
+			a: The first digit of the I/O address.
+				Setting		Value
+				-------		-----
+				00		0
+				01		1
+				10		2
+				11		3
+
+			b: The second digit of the I/O address.
+				Setting		Value
+				-------		-----
+				0000		0
+				0001		1
+				0010		2
+				...		...
+				1110		E
+				1111		F
+
+			The I/O address is in the form ab0.  For example, if
+			a is 0x2 and b is 0xE, the address will be 0x2E0.
+
+			DO NOT SET THIS LESS THAN 0x200!!!!!
+
+
+			m: The first digit of the memory address.
+				Setting		Value
+				-------		-----
+				0000		0
+				0001		1
+				0010		2
+				...		...
+				1110		E
+				1111		F
+
+			The memory address is in the form m0000.  For example, if
+			m is D, the address will be 0xD0000.
+
+			DO NOT SET THIS TO C0000, F0000, OR LESS THAN A0000!
+
+				  1  2  3  4  5  6  7  8
+	     S2                /--------------------------\
+	(Station Address)      |  1  1  0  0  0  0  0  0  |
+			       \--------------------------/
+
+				Setting		Value
+				-------		-----
+				00000000	00
+				10000000	01
+				01000000	02
+				...
+				01111111	FE
+				11111111	FF
+
+			Note that this is binary with the digits reversed!
+
+			DO NOT SET THIS TO 0 OR 255 (0xFF)!
+
+
 PC130E/PC270E (8-bit cards)
 ---------------------------
+
   - from Juergen Seifert <seifert@htwm.de>
 
-
-STANDARD MICROSYSTEMS CORPORATION (SMC) ARCNET(R)-PC130E/PC270E
-===============================================================
-
 This description has been written by Juergen Seifert <seifert@htwm.de>
-using information from the following Original SMC Manual 
+using information from the following Original SMC Manual
 
-             "Configuration Guide for
-             ARCNET(R)-PC130E/PC270
-            Network Controller Boards
-                Pub. # 900.044A
-                   June, 1989"
+	     "Configuration Guide for ARCNET(R)-PC130E/PC270 Network
+	     Controller Boards Pub. # 900.044A June, 1989"
 
 ARCNET is a registered trademark of the Datapoint Corporation
-SMC is a registered trademark of the Standard Microsystems Corporation  
+SMC is a registered trademark of the Standard Microsystems Corporation
 
-The PC130E is an enhanced version of the PC130 board, is equipped with a 
+The PC130E is an enhanced version of the PC130 board, is equipped with a
 standard BNC female connector for connection to RG-62/U coax cable.
 Since this board is designed both for point-to-point connection in star
-networks and for connection to bus networks, it is downwardly compatible 
+networks and for connection to bus networks, it is downwardly compatible
 with all the other standard boards designed for coax networks (that is,
-the PC120, PC110 and PC100 star topology boards and the PC220, PC210 and 
+the PC120, PC110 and PC100 star topology boards and the PC220, PC210 and
 PC200 bus topology boards).
 
-The PC270E is an enhanced version of the PC260 board, is equipped with two 
+The PC270E is an enhanced version of the PC260 board, is equipped with two
 modular RJ11-type jacks for connection to twisted pair wiring.
 It can be used in a star or a daisy-chained network.
 
+::
 
-         8 7 6 5 4 3 2 1
+	 8 7 6 5 4 3 2 1
     ________________________________________________________________
    |   |       S1        |                                          |
    |   |_________________|                                          |
@@ -587,27 +615,27 @@ It can be used in a star or a daisy-chained network.
        |                                             |
        |_____________________________________________|
 
-Legend:
+Legend::
 
-SMC 90C63	ARCNET Controller / Transceiver /Logic
-S1	1-3:	I/O Base Address Select
+  SMC 90C63	ARCNET Controller / Transceiver /Logic
+  S1	1-3:	I/O Base Address Select
 	4-6:	Memory Base Address Select
 	7-8:	RAM Offset Select
-S2	1-8:	Node ID Select
-EXT		Extended Timeout Select
-ROM		ROM Enable Select
-STAR		Selected - Star Topology	(PC130E only)
+  S2	1-8:	Node ID Select
+  EXT		Extended Timeout Select
+  ROM		ROM Enable Select
+  STAR		Selected - Star Topology	(PC130E only)
 		Deselected - Bus Topology	(PC130E only)
-CR3/CR4		Diagnostic LEDs
-J1		BNC RG62/U Connector		(PC130E only)
-J1		6-position Telephone Jack	(PC270E only)
-J2		6-position Telephone Jack	(PC270E only)
+  CR3/CR4	Diagnostic LEDs
+  J1		BNC RG62/U Connector		(PC130E only)
+  J1		6-position Telephone Jack	(PC270E only)
+  J2		6-position Telephone Jack	(PC270E only)
 
 Setting one of the switches to Off/Open means "1", On/Closed means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in group S2 are used to set the node ID.
 These switches work in a way similar to the PC100-series cards; see that
@@ -615,10 +643,10 @@ entry for more information.
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The first three switches in switch group S1 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
 
    Switch | Hex I/O
@@ -635,14 +663,16 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer requires 2K of a 16K block of RAM. The base of this
 16K block can be located in any of eight positions.
 Switches 4-6 of switch group S1 select the Base of the 16K block.
-Within that 16K address space, the buffer may be assigned any one of four 
+Within that 16K address space, the buffer may be assigned any one of four
 positions, determined by the offset, switches 7 and 8 of group S1.
 
+::
+
    Switch     | Hex RAM | Hex ROM
    4 5 6  7 8 | Address | Address *)
    -----------|---------|-----------
@@ -650,115 +680,111 @@ positions, determined by the offset, switches 7 and 8 of group S1.
    0 0 0  0 1 |  C0800  |  C2000
    0 0 0  1 0 |  C1000  |  C2000
    0 0 0  1 1 |  C1800  |  C2000
-              |         |
+	      |         |
    0 0 1  0 0 |  C4000  |  C6000
    0 0 1  0 1 |  C4800  |  C6000
    0 0 1  1 0 |  C5000  |  C6000
    0 0 1  1 1 |  C5800  |  C6000
-              |         |
+	      |         |
    0 1 0  0 0 |  CC000  |  CE000
    0 1 0  0 1 |  CC800  |  CE000
    0 1 0  1 0 |  CD000  |  CE000
    0 1 0  1 1 |  CD800  |  CE000
-              |         |
+	      |         |
    0 1 1  0 0 |  D0000  |  D2000  (Manufacturer's default)
    0 1 1  0 1 |  D0800  |  D2000
    0 1 1  1 0 |  D1000  |  D2000
    0 1 1  1 1 |  D1800  |  D2000
-              |         |
+	      |         |
    1 0 0  0 0 |  D4000  |  D6000
    1 0 0  0 1 |  D4800  |  D6000
    1 0 0  1 0 |  D5000  |  D6000
    1 0 0  1 1 |  D5800  |  D6000
-              |         |
+	      |         |
    1 0 1  0 0 |  D8000  |  DA000
    1 0 1  0 1 |  D8800  |  DA000
    1 0 1  1 0 |  D9000  |  DA000
    1 0 1  1 1 |  D9800  |  DA000
-              |         |
+	      |         |
    1 1 0  0 0 |  DC000  |  DE000
    1 1 0  0 1 |  DC800  |  DE000
    1 1 0  1 0 |  DD000  |  DE000
    1 1 0  1 1 |  DD800  |  DE000
-              |         |
+	      |         |
    1 1 1  0 0 |  E0000  |  E2000
    1 1 1  0 1 |  E0800  |  E2000
    1 1 1  1 0 |  E1000  |  E2000
    1 1 1  1 1 |  E1800  |  E2000
-  
-*) To enable the 8K Boot PROM install the jumper ROM.
-   The default is jumper ROM not installed.
+
+  *) To enable the 8K Boot PROM install the jumper ROM.
+     The default is jumper ROM not installed.
 
 
 Setting the Timeouts and Interrupt
-----------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The jumpers labeled EXT1 and EXT2 are used to determine the timeout 
+The jumpers labeled EXT1 and EXT2 are used to determine the timeout
 parameters. These two jumpers are normally left open.
 
 To select a hardware interrupt level set one (only one!) of the jumpers
 IRQ2, IRQ3, IRQ4, IRQ5, IRQ7. The Manufacturer's default is IRQ2.
- 
+
 
 Configuring the PC130E for Star or Bus Topology
------------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The single jumper labeled STAR is used to configure the PC130E board for 
+The single jumper labeled STAR is used to configure the PC130E board for
 star or bus topology.
-When the jumper is installed, the board may be used in a star network, when 
+When the jumper is installed, the board may be used in a star network, when
 it is removed, the board can be used in a bus topology.
 
 
 Diagnostic LEDs
----------------
+^^^^^^^^^^^^^^^
 
 Two diagnostic LEDs are visible on the rear bracket of the board.
 The green LED monitors the network activity: the red one shows the
-board activity:
+board activity::
 
  Green  | Status               Red      | Status
  -------|-------------------   ---------|-------------------
   on    | normal activity      flash/on | data transfer
   blink | reconfiguration      off      | no data transfer;
   off   | defective board or            | incorrect memory or
-        | node ID is zero               | I/O address
+	| node ID is zero               | I/O address
 
 
-*****************************************************************************
-
-** Standard Microsystems Corp (SMC) **
 PC500/PC550 Longboard (16-bit cards)
--------------------------------------
+------------------------------------
+
   - from Juergen Seifert <seifert@htwm.de>
 
 
-STANDARD MICROSYSTEMS CORPORATION (SMC) ARCNET-PC500/PC550 Long Board
-=====================================================================
+  .. note::
 
-Note: There is another Version of the PC500 called Short Version, which 
+      There is another Version of the PC500 called Short Version, which
       is different in hard- and software! The most important differences
       are:
+
       - The long board has no Shared memory.
       - On the long board the selection of the interrupt is done by binary
-        coded switch, on the short board directly by jumper.
-        
+	coded switch, on the short board directly by jumper.
+
 [Avery's note: pay special attention to that: the long board HAS NO SHARED
-MEMORY.  This means the current Linux-ARCnet driver can't use these cards. 
+MEMORY.  This means the current Linux-ARCnet driver can't use these cards.
 I have obtained a PC500Longboard and will be doing some experiments on it in
 the future, but don't hold your breath.  Thanks again to Juergen Seifert for
 his advice about this!]
 
 This description has been written by Juergen Seifert <seifert@htwm.de>
-using information from the following Original SMC Manual 
+using information from the following Original SMC Manual
 
-             "Configuration Guide for
-             SMC ARCNET-PC500/PC550
-         Series Network Controller Boards
-             Pub. # 900.033 Rev. A
-                November, 1989"
+	 "Configuration Guide for SMC ARCNET-PC500/PC550
+	 Series Network Controller Boards Pub. # 900.033 Rev. A
+	 November, 1989"
 
 ARCNET is a registered trademark of the Datapoint Corporation
-SMC is a registered trademark of the Standard Microsystems Corporation  
+SMC is a registered trademark of the Standard Microsystems Corporation
 
 The PC500 is equipped with a standard BNC female connector for connection
 to RG-62/U coax cable.
@@ -769,7 +795,9 @@ The PC550 is equipped with two modular RJ11-type jacks for connection
 to twisted pair wiring.
 It can be used in a star or a daisy-chained (BUS) network.
 
-       1 
+::
+
+       1
        0 9 8 7 6 5 4 3 2 1     6 5 4 3 2 1
     ____________________________________________________________________
    < |         SW1         | |     SW2     |                            |
@@ -796,34 +824,34 @@ It can be used in a star or a daisy-chained (BUS) network.
    >    |  |                                             |
    <____|  |_____________________________________________|
 
-Legend:
+Legend::
 
-SW1	1-6:	I/O Base Address Select
+  SW1	1-6:	I/O Base Address Select
 	7-10:	Interrupt Select
-SW2	1-6:	Reserved for Future Use
-SW3	1-8:	Node ID Select
-JP2	1-4:	Extended Timeout Select
-JP6		Selected - Star Topology	(PC500 only)
+  SW2	1-6:	Reserved for Future Use
+  SW3	1-8:	Node ID Select
+  JP2	1-4:	Extended Timeout Select
+  JP6		Selected - Star Topology	(PC500 only)
 		Deselected - Bus Topology	(PC500 only)
-CR3	Green	Monitors Network Activity
-CR4	Red	Monitors Board Activity
-J1		BNC RG62/U Connector		(PC500 only)
-J1		6-position Telephone Jack	(PC550 only)
-J2		6-position Telephone Jack	(PC550 only)
+  CR3	Green	Monitors Network Activity
+  CR4	Red	Monitors Board Activity
+  J1		BNC RG62/U Connector		(PC500 only)
+  J1		6-position Telephone Jack	(PC550 only)
+  J2		6-position Telephone Jack	(PC550 only)
 
 Setting one of the switches to Off/Open means "1", On/Closed means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in group SW3 are used to set the node ID. Each node
-attached to the network must have an unique node ID which must be 
+attached to the network must have an unique node ID which must be
 different from 0.
 Switch 1 serves as the least significant bit (LSB).
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
     Switch | Value
     -------|-------
@@ -836,30 +864,30 @@ These values are:
       7    |  64
       8    | 128
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    8 7 6 5 4 3 2 1 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
-   1 1 1 1 1 1 1 1 |   FF    |  255 
+   1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The first six switches in switch group SW1 are used to select one
-of 32 possible I/O Base addresses using the following table
+of 32 possible I/O Base addresses using the following table::
 
    Switch       | Hex I/O
    6 5  4 3 2 1 | Address
@@ -899,16 +927,18 @@ of 32 possible I/O Base addresses using the following table
 
 
 Setting the Interrupt
----------------------
+^^^^^^^^^^^^^^^^^^^^^
 
-Switches seven through ten of switch group SW1 are used to select the 
-interrupt level. The interrupt level is binary coded, so selections 
+Switches seven through ten of switch group SW1 are used to select the
+interrupt level. The interrupt level is binary coded, so selections
 from 0 to 15 would be possible, but only the following eight values will
 be supported: 3, 4, 5, 7, 9, 10, 11, 12.
 
+::
+
    Switch   | IRQ
-   10 9 8 7 | 
-   ---------|-------- 
+   10 9 8 7 |
+   ---------|--------
     0 0 1 1 |  3
     0 1 0 0 |  4
     0 1 0 1 |  5
@@ -919,52 +949,50 @@ be supported: 3, 4, 5, 7, 9, 10, 11, 12.
     1 1 0 0 | 12
 
 
-Setting the Timeouts 
---------------------
+Setting the Timeouts
+^^^^^^^^^^^^^^^^^^^^
 
-The two jumpers JP2 (1-4) are used to determine the timeout parameters. 
+The two jumpers JP2 (1-4) are used to determine the timeout parameters.
 These two jumpers are normally left open.
 Refer to the COM9026 Data Sheet for alternate configurations.
 
 
 Configuring the PC500 for Star or Bus Topology
-----------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The single jumper labeled JP6 is used to configure the PC500 board for 
+The single jumper labeled JP6 is used to configure the PC500 board for
 star or bus topology.
-When the jumper is installed, the board may be used in a star network, when 
+When the jumper is installed, the board may be used in a star network, when
 it is removed, the board can be used in a bus topology.
 
 
 Diagnostic LEDs
----------------
+^^^^^^^^^^^^^^^
 
 Two diagnostic LEDs are visible on the rear bracket of the board.
 The green LED monitors the network activity: the red one shows the
-board activity:
+board activity::
 
  Green  | Status               Red      | Status
  -------|-------------------   ---------|-------------------
   on    | normal activity      flash/on | data transfer
   blink | reconfiguration      off      | no data transfer;
   off   | defective board or            | incorrect memory or
-        | node ID is zero               | I/O address
+	| node ID is zero               | I/O address
 
 
-*****************************************************************************
-
-** SMC **
 PC710 (8-bit card)
 ------------------
+
   - from J.S. van Oosten <jvoosten@compiler.tdcnet.nl>
-  
+
 Note: this data is gathered by experimenting and looking at info of other
 cards. However, I'm sure I got 99% of the settings right.
 
 The SMC710 card resembles the PC270 card, but is much more basic (i.e. no
-LEDs, RJ11 jacks, etc.) and 8 bit. Here's a little drawing:
+LEDs, RJ11 jacks, etc.) and 8 bit. Here's a little drawing::
 
-    _______________________________________   
+    _______________________________________
    | +---------+  +---------+              |____
    | |   S2    |  |   S1    |              |
    | +---------+  +---------+              |
@@ -976,12 +1004,12 @@ LEDs, RJ11 jacks, etc.) and 8 bit. Here's a little drawing:
    |  +===+                                |
    |                                       |
    |   .. JP1   +----------+               |
-   |   ..       | big chip |               |   
+   |   ..       | big chip |               |
    |   ..       |  90C63   |               |
    |   ..       |          |               |
    |   ..       +----------+               |
     -------                     -----------
-           |||||||||||||||||||||
+	   |||||||||||||||||||||
 
 The row of jumpers at JP1 actually consists of 8 jumpers, (sometimes
 labelled) the same as on the PC270, from top to bottom: EXT2, EXT1, ROM,
@@ -992,71 +1020,76 @@ are swapped (S1 is the nodeaddress, S2 sets IO- and RAM-address).
 
 I know it works when connected to a PC110 type ARCnet board.
 
-	
+
 *****************************************************************************
 
-** Possibly SMC **
+Possibly SMC
+============
+
 LCS-8830(-T) (8 and 16-bit cards)
 ---------------------------------
+
   - from Mathias Katzer <mkatzer@HRZ.Uni-Bielefeld.DE>
   - Marek Michalkiewicz <marekm@i17linuxb.ists.pwr.wroc.pl> says the
     LCS-8830 is slightly different from LCS-8830-T.  These are 8 bit, BUS
     only (the JP0 jumper is hardwired), and BNC only.
-	
+
 This is a LCS-8830-T made by SMC, I think ('SMC' only appears on one PLCC,
 nowhere else, not even on the few Xeroxed sheets from the manual).
 
-SMC ARCnet Board Type LCS-8830-T
-
-   ------------------------------------
-  |                                    |
-  |              JP3 88  8 JP2         |
-  |       #####      | \               |
-  |       #####    ET1 ET2          ###|
-  |                              8  ###|
-  |  U3   SW 1                  JP0 ###|  Phone Jacks
-  |  --                             ###|
-  | |  |                               |
-  | |  |   SW2                         |
-  | |  |                               |
-  | |  |  #####                        |
-  |  --   #####                       ####  BNC Connector 
-  |                                   ####
-  |   888888 JP1                       |
-  |   234567                           |
-   --                           -------
-     |||||||||||||||||||||||||||
-      --------------------------
-
-
-SW1: DIP-Switches for Station Address
-SW2: DIP-Switches for Memory Base and I/O Base addresses
-
-JP0: If closed, internal termination on (default open)
-JP1: IRQ Jumpers
-JP2: Boot-ROM enabled if closed
-JP3: Jumpers for response timeout
- 
-U3: Boot-ROM Socket          
-
-
-ET1 ET2     Response Time     Idle Time    Reconfiguration Time
-
-               78                86               840
- X            285               316              1680
-     X        563               624              1680
- X   X       1130              1237              1680
-
-(X means closed jumper)
-
-(DIP-Switch downwards means "0")
+SMC ARCnet Board Type LCS-8830-T::
+
+     ------------------------------------
+    |                                    |
+    |              JP3 88  8 JP2         |
+    |       #####      | \               |
+    |       #####    ET1 ET2          ###|
+    |                              8  ###|
+    |  U3   SW 1                  JP0 ###|  Phone Jacks
+    |  --                             ###|
+    | |  |                               |
+    | |  |   SW2                         |
+    | |  |                               |
+    | |  |  #####                        |
+    |  --   #####                       ####  BNC Connector
+    |                                   ####
+    |   888888 JP1                       |
+    |   234567                           |
+     --                           -------
+       |||||||||||||||||||||||||||
+	--------------------------
+
+
+  SW1: DIP-Switches for Station Address
+  SW2: DIP-Switches for Memory Base and I/O Base addresses
+
+  JP0: If closed, internal termination on (default open)
+  JP1: IRQ Jumpers
+  JP2: Boot-ROM enabled if closed
+  JP3: Jumpers for response timeout
+
+  U3: Boot-ROM Socket
+
+
+  ET1 ET2     Response Time     Idle Time    Reconfiguration Time
+
+		 78                86               840
+   X            285               316              1680
+       X        563               624              1680
+   X   X       1130              1237              1680
+
+  (X means closed jumper)
+
+  (DIP-Switch downwards means "0")
 
 The station address is binary-coded with SW1.
 
 The I/O base address is coded with DIP-Switches 6,7 and 8 of SW2:
 
+========	========
 Switches        Base
 678             Address
+========	========
 000		260-26f
 100		290-29f
 010		2e0-2ef
@@ -1065,19 +1098,22 @@ Switches        Base
 101		350-35f
 011		380-38f
 111 		3e0-3ef
+========	========
 
 
 DIP Switches 1-5 of SW2 encode the RAM and ROM Address Range:
 
+========        ============= ================
 Switches        RAM           ROM
 12345           Address Range  Address Range
+========        ============= ================
 00000		C:0000-C:07ff	C:2000-C:3fff
 10000		C:0800-C:0fff
 01000		C:1000-C:17ff
 11000		C:1800-C:1fff
 00100		C:4000-C:47ff	C:6000-C:7fff
 10100		C:4800-C:4fff
-01100		C:5000-C:57ff 
+01100		C:5000-C:57ff
 11100		C:5800-C:5fff
 00010		C:C000-C:C7ff	C:E000-C:ffff
 10010		C:C800-C:Cfff
@@ -1094,7 +1130,7 @@ Switches        RAM           ROM
 00101		D:8000-D:87ff	D:A000-D:bfff
 10101		D:8800-D:8fff
 01101		D:9000-D:97ff
-11101		D:9800-D:9fff 
+11101		D:9800-D:9fff
 00011		D:C000-D:c7ff	D:E000-D:ffff
 10011		D:C800-D:cfff
 01011		D:D000-D:d7ff
@@ -1103,34 +1139,37 @@ Switches        RAM           ROM
 10111		E:0800-E:0fff
 01111		E:1000-E:17ff
 11111		E:1800-E:1fff
+========        ============= ================
 
 
-*****************************************************************************
+PureData Corp
+=============
 
-** PureData Corp **
 PDI507 (8-bit card)
 --------------------
+
   - from Mark Rejhon <mdrejhon@magi.com> (slight modifications by Avery)
   - Avery's note: I think PDI508 cards (but definitely NOT PDI508Plus cards)
     are mostly the same as this.  PDI508Plus cards appear to be mainly
     software-configured.
 
 Jumpers:
+
 	There is a jumper array at the bottom of the card, near the edge
-        connector.  This array is labelled J1.  They control the IRQs and
-        something else.  Put only one jumper on the IRQ pins.
+	connector.  This array is labelled J1.  They control the IRQs and
+	something else.  Put only one jumper on the IRQ pins.
 
 	ETS1, ETS2 are for timing on very long distance networks.  See the
 	more general information near the top of this file.
 
 	There is a J2 jumper on two pins.  A jumper should be put on them,
-        since it was already there when I got the card.  I don't know what
-        this jumper is for though.
+	since it was already there when I got the card.  I don't know what
+	this jumper is for though.
 
 	There is a two-jumper array for J3.  I don't know what it is for,
-        but there were already two jumpers on it when I got the card.  It's
-        a six pin grid in a two-by-three fashion.  The jumpers were
-        configured as follows:
+	but there were already two jumpers on it when I got the card.  It's
+	a six pin grid in a two-by-three fashion.  The jumpers were
+	configured as follows::
 
 	   .-------.
 	 o | o   o |
@@ -1140,28 +1179,28 @@ Jumpers:
 
 Carl de Billy <CARL@carainfo.com> explains J3 and J4:
 
-	J3 Diagram:
+   J3 Diagram::
 
-           .-------.
-         o | o   o |
-           :-------:    TWIST Technology
-         o | o   o |
-           `-------'
-           .-------.
-           | o   o | o
-           :-------:    COAX Technology
-           | o   o | o
-           `-------'
+	   .-------.
+	 o | o   o |
+	   :-------:    TWIST Technology
+	 o | o   o |
+	   `-------'
+	   .-------.
+	   | o   o | o
+	   :-------:    COAX Technology
+	   | o   o | o
+	   `-------'
 
   - If using coax cable in a bus topology the J4 jumper must be removed;
     place it on one pin.
 
-  - If using bus topology with twisted pair wiring move the J3 
+  - If using bus topology with twisted pair wiring move the J3
     jumpers so they connect the middle pin and the pins closest to the RJ11
     Connectors.  Also the J4 jumper must be removed; place it on one pin of
     J4 jumper for storage.
 
-  - If using  star topology with twisted pair wiring move the J3 
+  - If using  star topology with twisted pair wiring move the J3
     jumpers so they connect the middle pin and the pins closest to the RJ11
     connectors.
 
@@ -1169,40 +1208,43 @@ Carl de Billy <CARL@carainfo.com> explains J3 and J4:
 DIP Switches:
 
 	The DIP switches accessible on the accessible end of the card while
-        it is installed, is used to set the ARCnet address.  There are 8
-        switches.  Use an address from 1 to 254.
+	it is installed, is used to set the ARCnet address.  There are 8
+	switches.  Use an address from 1 to 254
 
-	Switch No.
-	12345678	ARCnet address
-	-----------------------------------------
+	==========      =========================
+	Switch No.	ARCnet address
+	12345678
+	==========      =========================
 	00000000	FF  	(Don't use this!)
 	00000001	FE
 	00000010	FD
-	....
-	11111101	2	
+	...
+	11111101	2
 	11111110	1
 	11111111	0	(Don't use this!)
+	==========      =========================
 
 	There is another array of eight DIP switches at the top of the
-        card.  There are five labelled MS0-MS4 which seem to control the
-        memory address, and another three labelled IO0-IO2 which seem to
-        control the base I/O address of the card.
+	card.  There are five labelled MS0-MS4 which seem to control the
+	memory address, and another three labelled IO0-IO2 which seem to
+	control the base I/O address of the card.
 
 	This was difficult to test by trial and error, and the I/O addresses
-        are in a weird order.  This was tested by setting the DIP switches,
-        rebooting the computer, and attempting to load ARCETHER at various
-        addresses (mostly between 0x200 and 0x400).  The address that caused
-        the red transmit LED to blink, is the one that I thought works.
+	are in a weird order.  This was tested by setting the DIP switches,
+	rebooting the computer, and attempting to load ARCETHER at various
+	addresses (mostly between 0x200 and 0x400).  The address that caused
+	the red transmit LED to blink, is the one that I thought works.
 
 	Also, the address 0x3D0 seem to have a special meaning, since the
-        ARCETHER packet driver loaded fine, but without the red LED
-        blinking.  I don't know what 0x3D0 is for though.  I recommend using
-        an address of 0x300 since Windows may not like addresses below
-        0x300.
+	ARCETHER packet driver loaded fine, but without the red LED
+	blinking.  I don't know what 0x3D0 is for though.  I recommend using
+	an address of 0x300 since Windows may not like addresses below
+	0x300.
 
-	IO Switch No.
-	210             I/O address
-	-------------------------------
+	=============   ===========
+	IO Switch No.   I/O address
+	210
+	=============   ===========
 	111             0x260
 	110             0x290
 	101             0x2E0
@@ -1211,29 +1253,31 @@ DIP Switches:
 	010             0x350
 	001             0x380
 	000             0x3E0
+	=============   ===========
 
 	The memory switches set a reserved address space of 0x1000 bytes
-        (0x100 segment units, or 4k).  For example if I set an address of
-        0xD000, it will use up addresses 0xD000 to 0xD100.
+	(0x100 segment units, or 4k).  For example if I set an address of
+	0xD000, it will use up addresses 0xD000 to 0xD100.
 
 	The memory switches were tested by booting using QEMM386 stealth,
-        and using LOADHI to see what address automatically became excluded
-        from the upper memory regions, and then attempting to load ARCETHER
-        using these addresses.
+	and using LOADHI to see what address automatically became excluded
+	from the upper memory regions, and then attempting to load ARCETHER
+	using these addresses.
 
 	I recommend using an ARCnet memory address of 0xD000, and putting
-        the EMS page frame at 0xC000 while using QEMM stealth mode.  That
-        way, you get contiguous high memory from 0xD100 almost all the way
-        the end of the megabyte.
+	the EMS page frame at 0xC000 while using QEMM stealth mode.  That
+	way, you get contiguous high memory from 0xD100 almost all the way
+	the end of the megabyte.
 
 	Memory Switch 0 (MS0) didn't seem to work properly when set to OFF
-        on my card.  It could be malfunctioning on my card.  Experiment with
-        it ON first, and if it doesn't work, set it to OFF.  (It may be a
-        modifier for the 0x200 bit?)
+	on my card.  It could be malfunctioning on my card.  Experiment with
+	it ON first, and if it doesn't work, set it to OFF.  (It may be a
+	modifier for the 0x200 bit?)
 
+	=============   ============================================
 	MS Switch No.
 	43210           Memory address
-	--------------------------------
+	=============   ============================================
 	00001           0xE100  (guessed - was not detected by QEMM)
 	00011           0xE000  (guessed - was not detected by QEMM)
 	00101           0xDD00
@@ -1250,40 +1294,36 @@ DIP Switches:
 	11011           0xC800 (guessed - crashes tested system)
 	11101           0xC500 (guessed - crashes tested system)
 	11111           0xC400 (guessed - crashes tested system)
-	
-	
-*****************************************************************************
+	=============   ============================================
+
+CNet Technology Inc.
+====================
 
-** CNet Technology Inc. **
 120 Series (8-bit cards)
 ------------------------
   - from Juergen Seifert <seifert@htwm.de>
 
-
-CNET TECHNOLOGY INC. (CNet) ARCNET 120A SERIES
-==============================================
-
 This description has been written by Juergen Seifert <seifert@htwm.de>
-using information from the following Original CNet Manual 
+using information from the following Original CNet Manual
 
-              "ARCNET
-            USER'S MANUAL 
-                for
-               CN120A
-               CN120AB
-               CN120TP
-               CN120ST
-               CN120SBT
-             P/N:12-01-0007
-             Revision 3.00"
+	      "ARCNET USER'S MANUAL for
+	      CN120A
+	      CN120AB
+	      CN120TP
+	      CN120ST
+	      CN120SBT
+	      P/N:12-01-0007
+	      Revision 3.00"
 
 ARCNET is a registered trademark of the Datapoint Corporation
 
-P/N 120A   ARCNET 8 bit XT/AT Star
-P/N 120AB  ARCNET 8 bit XT/AT Bus
-P/N 120TP  ARCNET 8 bit XT/AT Twisted Pair
-P/N 120ST  ARCNET 8 bit XT/AT Star, Twisted Pair
-P/N 120SBT ARCNET 8 bit XT/AT Star, Bus, Twisted Pair
+- P/N 120A   ARCNET 8 bit XT/AT Star
+- P/N 120AB  ARCNET 8 bit XT/AT Bus
+- P/N 120TP  ARCNET 8 bit XT/AT Twisted Pair
+- P/N 120ST  ARCNET 8 bit XT/AT Star, Twisted Pair
+- P/N 120SBT ARCNET 8 bit XT/AT Star, Bus, Twisted Pair
+
+::
 
     __________________________________________________________________
    |                                                                  |
@@ -1307,75 +1347,77 @@ P/N 120SBT ARCNET 8 bit XT/AT Star, Bus, Twisted Pair
    |  >  SOCKET      |  JP 6 5 4 3 2                    |o|o|o| | J1  |
    |  |______________|    |o|o|o|o|o|                   |o|o|o| |_____|
    |_____                 |o|o|o|o|o|                   ______________|
-         |                                             |
-         |_____________________________________________|
+	 |                                             |
+	 |_____________________________________________|
 
-Legend:
+Legend::
 
-90C65       ARCNET Probe
-S1  1-5:    Base Memory Address Select
-    6-8:    Base I/O Address Select
-S2  1-8:    Node ID Select (ID0-ID7)
-JP1     ROM Enable Select
-JP2     IRQ2
-JP3     IRQ3
-JP4     IRQ4
-JP5     IRQ5
-JP6     IRQ7
-JP7/JP8     ET1, ET2 Timeout Parameters
-JP10/JP11   Coax / Twisted Pair Select  (CN120ST/SBT only)
-JP12        Terminator Select       (CN120AB/ST/SBT only)
-J1      BNC RG62/U Connector        (all except CN120TP)
-J2      Two 6-position Telephone Jack   (CN120TP/ST/SBT only)
+  90C65       ARCNET Probe
+  S1  1-5:    Base Memory Address Select
+      6-8:    Base I/O Address Select
+  S2  1-8:    Node ID Select (ID0-ID7)
+  JP1     ROM Enable Select
+  JP2     IRQ2
+  JP3     IRQ3
+  JP4     IRQ4
+  JP5     IRQ5
+  JP6     IRQ7
+  JP7/JP8     ET1, ET2 Timeout Parameters
+  JP10/JP11   Coax / Twisted Pair Select  (CN120ST/SBT only)
+  JP12        Terminator Select       (CN120AB/ST/SBT only)
+  J1      BNC RG62/U Connector        (all except CN120TP)
+  J2      Two 6-position Telephone Jack   (CN120TP/ST/SBT only)
 
 Setting one of the switches to Off means "1", On means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW2 are used to set the node ID. Each node attached
 to the network must have an unique node ID which must be different from 0.
 Switch 1 (ID0) serves as the least significant bit (LSB).
 
-The node ID is the sum of the values of all switches set to "1"  
+The node ID is the sum of the values of all switches set to "1"
 These values are:
 
-   Switch | Label | Value
-   -------|-------|-------
-     1    | ID0   |   1
-     2    | ID1   |   2
-     3    | ID2   |   4
-     4    | ID3   |   8
-     5    | ID4   |  16
-     6    | ID5   |  32
-     7    | ID6   |  64
-     8    | ID7   | 128
+   =======  ======  =====
+   Switch   Label   Value
+   =======  ======  =====
+     1      ID0       1
+     2      ID1       2
+     3      ID2       4
+     4      ID3       8
+     5      ID4      16
+     6      ID5      32
+     7      ID6      64
+     8      ID7     128
+   =======  ======  =====
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    8 7 6 5 4 3 2 1 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
    1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The last three switches in switch block SW1 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
 
    Switch      | Hex I/O
@@ -1392,13 +1434,15 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The memory buffer (RAM) requires 2K. The base of this buffer can be 
+The memory buffer (RAM) requires 2K. The base of this buffer can be
 located in any of eight positions. The address of the Boot Prom is
 memory base + 8K or memory base + 0x2000.
 Switches 1-5 of switch block SW1 select the Memory Base address.
 
+::
+
    Switch              | Hex RAM | Hex ROM
     1   2   3   4   5  | Address | Address *)
    --------------------|---------|-----------
@@ -1410,22 +1454,24 @@ Switches 1-5 of switch block SW1 select the Memory Base address.
    ON  ON  OFF ON  OFF |  D8000  |  DA000
    ON  ON  ON  OFF OFF |  DC000  |  DE000
    ON  ON  OFF OFF OFF |  E0000  |  E2000
-  
-*) To enable the Boot ROM install the jumper JP1
 
-Note: Since the switches 1 and 2 are always set to ON it may be possible
+  *) To enable the Boot ROM install the jumper JP1
+
+.. note::
+
+      Since the switches 1 and 2 are always set to ON it may be possible
       that they can be used to add an offset of 2K, 4K or 6K to the base
       address, but this feature is not documented in the manual and I
       haven't tested it yet.
 
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 To select a hardware interrupt level install one (only one!) of the jumpers
-JP2, JP3, JP4, JP5, JP6. JP2 is the default.
+JP2, JP3, JP4, JP5, JP6. JP2 is the default::
 
-   Jumper | IRQ     
+   Jumper | IRQ
    -------|-----
      2    |  2
      3    |  3
@@ -1435,71 +1481,66 @@ JP2, JP3, JP4, JP5, JP6. JP2 is the default.
 
 
 Setting the Internal Terminator on CN120AB/TP/SBT
---------------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The jumper JP12 is used to enable the internal terminator. 
+The jumper JP12 is used to enable the internal terminator::
 
-                         -----
-       0                |  0  |     
+			 -----
+       0                |  0  |
      -----   ON         |     |  ON
     |  0  |             |  0  |
     |     |  OFF         -----   OFF
     |  0  |                0
      -----
-   Terminator          Terminator 
+   Terminator          Terminator
     disabled            enabled
-  
+
 
 Selecting the Connector Type on CN120ST/SBT
--------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+::
 
      JP10    JP11        JP10    JP11
-                         -----   -----
-       0       0        |  0  | |  0  |       
+			 -----   -----
+       0       0        |  0  | |  0  |
      -----   -----      |     | |     |
     |  0  | |  0  |     |  0  | |  0  |
     |     | |     |      -----   -----
-    |  0  | |  0  |        0       0 
+    |  0  | |  0  |        0       0
      -----   -----
-     Coaxial Cable       Twisted Pair Cable 
+     Coaxial Cable       Twisted Pair Cable
        (Default)
 
 
 Setting the Timeout Parameters
-------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The jumpers labeled EXT1 and EXT2 are used to determine the timeout 
+The jumpers labeled EXT1 and EXT2 are used to determine the timeout
 parameters. These two jumpers are normally left open.
 
 
+CNet Technology Inc.
+====================
 
-*****************************************************************************
-
-** CNet Technology Inc. **
 160 Series (16-bit cards)
 -------------------------
   - from Juergen Seifert <seifert@htwm.de>
 
-CNET TECHNOLOGY INC. (CNet) ARCNET 160A SERIES
-==============================================
-
 This description has been written by Juergen Seifert <seifert@htwm.de>
-using information from the following Original CNet Manual 
+using information from the following Original CNet Manual
 
-              "ARCNET
-            USER'S MANUAL 
-                for
-               CN160A
-               CN160AB
-               CN160TP
-             P/N:12-01-0006
-             Revision 3.00"
+	      "ARCNET USER'S MANUAL for
+	      CN160A CN160AB CN160TP
+	      P/N:12-01-0006 Revision 3.00"
 
 ARCNET is a registered trademark of the Datapoint Corporation
 
-P/N 160A   ARCNET 16 bit XT/AT Star
-P/N 160AB  ARCNET 16 bit XT/AT Bus
-P/N 160TP  ARCNET 16 bit XT/AT Twisted Pair
+- P/N 160A   ARCNET 16 bit XT/AT Star
+- P/N 160AB  ARCNET 16 bit XT/AT Bus
+- P/N 160TP  ARCNET 16 bit XT/AT Twisted Pair
+
+::
 
    ___________________________________________________________________
   <                             _________________________          ___|
@@ -1526,30 +1567,30 @@ P/N 160TP  ARCNET 16 bit XT/AT Twisted Pair
   >            |  |                                       |
   <____________|  |_______________________________________|
 
-Legend:
+Legend::
 
-9026            ARCNET Probe
-SW1 1-6:    Base I/O Address Select
-    7-10:   Base Memory Address Select
-SW2 1-8:    Node ID Select (ID0-ID7)
-JP1/JP2     ET1, ET2 Timeout Parameters
-JP3-JP13    Interrupt Select
-J1      BNC RG62/U Connector        (CN160A/AB only)
-J1      Two 6-position Telephone Jack   (CN160TP only)
-LED
+  9026            ARCNET Probe
+  SW1 1-6:    Base I/O Address Select
+      7-10:   Base Memory Address Select
+  SW2 1-8:    Node ID Select (ID0-ID7)
+  JP1/JP2     ET1, ET2 Timeout Parameters
+  JP3-JP13    Interrupt Select
+  J1      BNC RG62/U Connector        (CN160A/AB only)
+  J1      Two 6-position Telephone Jack   (CN160TP only)
+  LED
 
 Setting one of the switches to Off means "1", On means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW2 are used to set the node ID. Each node attached
 to the network must have an unique node ID which must be different from 0.
 Switch 1 (ID0) serves as the least significant bit (LSB).
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
    Switch | Label | Value
    -------|-------|-------
@@ -1562,32 +1603,32 @@ These values are:
      7    | ID6   |  64
      8    | ID7   | 128
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    8 7 6 5 4 3 2 1 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
    1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The first six switches in switch block SW1 are used to select the I/O Base
-address using the following table:
+address using the following table::
 
-             Switch        | Hex I/O
+	     Switch        | Hex I/O
     1   2   3   4   5   6  | Address
    ------------------------|--------
    OFF ON  ON  OFF OFF ON  |  260
@@ -1604,10 +1645,10 @@ Note: Other IO-Base addresses seem to be selectable, but only the above
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The switches 7-10 of switch block SW1 are used to select the Memory
-Base address of the RAM (2K) and the PROM.
+Base address of the RAM (2K) and the PROM::
 
    Switch          | Hex RAM | Hex ROM
     7   8   9  10  | Address | Address
@@ -1616,17 +1657,19 @@ Base address of the RAM (2K) and the PROM.
    OFF OFF ON  OFF |  D0000  |  D8000 (Default)
    OFF OFF OFF ON  |  E0000  |  E8000
 
-Note: Other MEM-Base addresses seem to be selectable, but only the above
+.. note::
+
+      Other MEM-Base addresses seem to be selectable, but only the above
       combinations are documented.
 
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 To select a hardware interrupt level install one (only one!) of the jumpers
-JP3 through JP13 using the following table:
+JP3 through JP13 using the following table::
 
-   Jumper | IRQ     
+   Jumper | IRQ
    -------|-----------------
      3    |  14
      4    |  15
@@ -1640,10 +1683,12 @@ JP3 through JP13 using the following table:
     12    |   7
     13    |   2 (=9) Default!
 
-Note:  - Do not use JP11=IRQ6, it may conflict with your Floppy Disk
-         Controller
+.. note::
+
+       - Do not use JP11=IRQ6, it may conflict with your Floppy Disk
+	 Controller
        - Use JP3=IRQ14 only, if you don't have an IDE-, MFM-, or RLL-
-         Hard Disk, it may conflict with their controllers
+	 Hard Disk, it may conflict with their controllers
 
 
 Setting the Timeout Parameters
@@ -1653,14 +1698,16 @@ The jumpers labeled JP1 and JP2 are used to determine the timeout
 parameters. These two jumpers are normally left open.
 
 
-*****************************************************************************
+Lantech
+=======
 
-** Lantech **
 8-bit card, unknown model
 -------------------------
   - from Vlad Lungu <vlungu@ugal.ro> - his e-mail address seemed broken at
     the time I tried to reach him.  Sorry Vlad, if you didn't get my reply.
 
+::
+
    ________________________________________________________________
    |   1         8                                                 |
    |   ___________                                               __|
@@ -1683,25 +1730,27 @@ parameters. These two jumpers are normally left open.
    |      |    PROM    |        |ooooo|  JP6                       |
    |      |____________|        |ooooo|                            |
    |_____________                                             _   _|
-                |____________________________________________| |__|
+		|____________________________________________| |__|
 
 
 UM9065L : ARCnet Controller
 
 SW 1    : Shared Memory Address and I/O Base
 
-        ON=0
+::
 
-        12345|Memory Address
-        -----|--------------
-        00001|  D4000
-        00010|  CC000
-        00110|  D0000
-        01110|  D1000
-        01101|  D9000
-        10010|  CC800
-        10011|  DC800
-        11110|  D1800
+	ON=0
+
+	12345|Memory Address
+	-----|--------------
+	00001|  D4000
+	00010|  CC000
+	00110|  D0000
+	01110|  D1000
+	01101|  D9000
+	10010|  CC800
+	10011|  DC800
+	11110|  D1800
 
 It seems that the bits are considered in reverse order.  Also, you must
 observe that some of those addresses are unusual and I didn't probe them; I
@@ -1710,43 +1759,48 @@ some others that I didn't write here the card seems to conflict with the
 video card (an S3 GENDAC). I leave the full decoding of those addresses to
 you.
 
-        678| I/O Address
-        ---|------------
-        000|    260
-        001|    failed probe
-        010|    2E0
-        011|    380
-        100|    290
-        101|    350
-        110|    failed probe
-        111|    3E0
+::
 
-SW 2  : Node ID (binary coded)
+	678| I/O Address
+	---|------------
+	000|    260
+	001|    failed probe
+	010|    2E0
+	011|    380
+	100|    290
+	101|    350
+	110|    failed probe
+	111|    3E0
 
-JP 4  : Boot PROM enable   CLOSE - enabled
-                           OPEN  - disabled
+  SW 2  : Node ID (binary coded)
 
-JP 6  : IRQ set (ONLY ONE jumper on 1-5 for IRQ 2-6)
+  JP 4  : Boot PROM enable   CLOSE - enabled
+			     OPEN  - disabled
 
+  JP 6  : IRQ set (ONLY ONE jumper on 1-5 for IRQ 2-6)
 
-*****************************************************************************
 
-** Acer **
+Acer
+====
+
 8-bit card, Model 5210-003
 --------------------------
+
   - from Vojtech Pavlik <vojtech@suse.cz> using portions of the existing
     arcnet-hardware file.
 
 This is a 90C26 based card.  Its configuration seems similar to the SMC
 PC100, but has some additional jumpers I don't know the meaning of.
 
-               __
-              |  |
+::
+
+	       __
+	      |  |
    ___________|__|_________________________
   |         |      |                       |
   |         | BNC  |                       |
   |         |______|                    ___|
-  |  _____________________             |___  
+  |  _____________________             |___
   | |                     |                |
   | | Hybrid IC           |                |
   | |                     |       o|o J1   |
@@ -1762,51 +1816,51 @@ PC100, but has some additional jumpers I don't know the meaning of.
   |                    _____               |
   |                   |     |   _____      |
   |                   |     |  |     |  ___|
-  |                   |     |  |     | |    
-  |  _____            | ROM |  | UFS | |    
-  | |     |           |     |  |     | |   
-  | |     |     ___   |     |  |     | |   
-  | |     |    |   |  |__.__|  |__.__| |   
-  | | NCR |    |XTL|   _____    _____  |   
-  | |     |    |___|  |     |  |     | |   
-  | |90C26|           |     |  |     | |   
-  | |     |           | RAM |  | UFS | |   
-  | |     | J17 o|o   |     |  |     | |   
-  | |     | J16 o|o   |     |  |     | |   
-  | |__.__|           |__.__|  |__.__| |   
-  |  ___                               |   
-  | |   |8                             |   
-  | |SW2|                              |   
-  | |   |                              |   
-  | |___|1                             |   
-  |  ___                               |   
-  | |   |10           J18 o|o          |   
-  | |   |                 o|o          |   
-  | |SW1|                 o|o          |   
-  | |   |             J21 o|o          |   
-  | |___|1                             |   
-  |                                    |   
-  |____________________________________|   
+  |                   |     |  |     | |
+  |  _____            | ROM |  | UFS | |
+  | |     |           |     |  |     | |
+  | |     |     ___   |     |  |     | |
+  | |     |    |   |  |__.__|  |__.__| |
+  | | NCR |    |XTL|   _____    _____  |
+  | |     |    |___|  |     |  |     | |
+  | |90C26|           |     |  |     | |
+  | |     |           | RAM |  | UFS | |
+  | |     | J17 o|o   |     |  |     | |
+  | |     | J16 o|o   |     |  |     | |
+  | |__.__|           |__.__|  |__.__| |
+  |  ___                               |
+  | |   |8                             |
+  | |SW2|                              |
+  | |   |                              |
+  | |___|1                             |
+  |  ___                               |
+  | |   |10           J18 o|o          |
+  | |   |                 o|o          |
+  | |SW1|                 o|o          |
+  | |   |             J21 o|o          |
+  | |___|1                             |
+  |                                    |
+  |____________________________________|
 
 
-Legend:
+Legend::
 
-90C26       ARCNET Chip
-XTL         20 MHz Crystal
-SW1 1-6     Base I/O Address Select
-    7-10    Memory Address Select
-SW2 1-8     Node ID Select (ID0-ID7)
-J1-J5       IRQ Select
-J6-J21      Unknown (Probably extra timeouts & ROM enable ...)
-LED1        Activity LED 
-BNC         Coax connector (STAR ARCnet)
-RAM         2k of SRAM
-ROM         Boot ROM socket
-UFS         Unidentified Flying Sockets
+  90C26       ARCNET Chip
+  XTL         20 MHz Crystal
+  SW1 1-6     Base I/O Address Select
+      7-10    Memory Address Select
+  SW2 1-8     Node ID Select (ID0-ID7)
+  J1-J5       IRQ Select
+  J6-J21      Unknown (Probably extra timeouts & ROM enable ...)
+  LED1        Activity LED
+  BNC         Coax connector (STAR ARCnet)
+  RAM         2k of SRAM
+  ROM         Boot ROM socket
+  UFS         Unidentified Flying Sockets
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW2 are used to set the node ID. Each node attached
 to the network must have an unique node ID which must not be 0.
@@ -1815,7 +1869,7 @@ Switch 1 (ID0) serves as the least significant bit (LSB).
 Setting one of the switches to OFF means "1", ON means "0".
 
 The node ID is the sum of the values of all switches set to "1"
-These values are:
+These values are::
 
    Switch | Value
    -------|-------
@@ -1832,40 +1886,40 @@ Don't set this to 0 or 255; these values are reserved.
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The switches 1 to 6 of switch block SW1 are used to select one
-of 32 possible I/O Base addresses using the following tables
-   
-          | Hex
+of 32 possible I/O Base addresses using the following tables::
+
+	  | Hex
    Switch | Value
    -------|-------
-     1    | 200  
-     2    | 100  
-     3    |  80  
-     4    |  40  
-     5    |  20  
-     6    |  10 
+     1    | 200
+     2    | 100
+     3    |  80
+     4    |  40
+     5    |  20
+     6    |  10
 
 The I/O address is sum of all switches set to "1". Remember that
 the I/O address space bellow 0x200 is RESERVED for mainboard, so
-switch 1 should be ALWAYS SET TO OFF. 
+switch 1 should be ALWAYS SET TO OFF.
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer (RAM) requires 2K. The base of this buffer can be
 located in any of sixteen positions. However, the addresses below
 A0000 are likely to cause system hang because there's main RAM.
 
-Jumpers 7-10 of switch block SW1 select the Memory Base address.
+Jumpers 7-10 of switch block SW1 select the Memory Base address::
 
    Switch          | Hex RAM
     7   8   9  10  | Address
    ----------------|---------
    OFF OFF OFF OFF |  F0000 (conflicts with main BIOS)
-   OFF OFF OFF ON  |  E0000 
+   OFF OFF OFF ON  |  E0000
    OFF OFF ON  OFF |  D0000
    OFF OFF ON  ON  |  C0000 (conflicts with video BIOS)
    OFF ON  OFF OFF |  B0000 (conflicts with mono video)
@@ -1873,10 +1927,10 @@ Jumpers 7-10 of switch block SW1 select the Memory Base address.
 
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-Jumpers 1-5 of the jumper block J1 control the IRQ level. ON means 
-shorted, OFF means open.
+Jumpers 1-5 of the jumper block J1 control the IRQ level. ON means
+shorted, OFF means open::
 
     Jumper              |  IRQ
     1   2   3   4   5   |
@@ -1889,65 +1943,67 @@ shorted, OFF means open.
 
 
 Unknown jumpers & sockets
--------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^
 
 I know nothing about these. I just guess that J16&J17 are timeout
 jumpers and maybe one of J18-J21 selects ROM. Also J6-J10 and
 J11-J15 are connecting IRQ2-7 to some pins on the UFSs. I can't
 guess the purpose.
 
+Datapoint?
+==========
 
-*****************************************************************************
-
-** Datapoint? **
 LAN-ARC-8, an 8-bit card
 ------------------------
+
   - from Vojtech Pavlik <vojtech@suse.cz>
 
 This is another SMC 90C65-based ARCnet card. I couldn't identify the
 manufacturer, but it might be DataPoint, because the card has the
 original arcNet logo in its upper right corner.
 
-          _______________________________________________________
-         |                         _________                     |
-         |                        |   SW2   | ON      arcNet     |
-         |                        |_________| OFF             ___|
-         |  _____________         1 ______  8                |   | 8  
-         | |             | SW1     | XTAL | ____________     | S |    
-         | > RAM (2k)    |         |______||            |    | W |    
-         | |_____________|                 |      H     |    | 3 |    
-         |                        _________|_____ y     |    |___| 1  
-         |  _________            |         |     |b     |        |    
-         | |_________|           |         |     |r     |        |    
-         |                       |     SMC |     |i     |        |    
-         |                       |    90C65|     |d     |        |      
-         |  _________            |         |     |      |        |
-         | |   SW1   | ON        |         |     |I     |        |
-         | |_________| OFF       |_________|_____/C     |   _____|
-         |  1       8                      |            |  |     |___
-         |  ______________                 |            |  | BNC |___|
-         | |              |                |____________|  |_____|
-         | > EPROM SOCKET |              _____________           |
-         | |______________|             |_____________|          |
-         |                                         ______________|
-         |                                        | 
-         |________________________________________|
+::
 
-Legend:
+	  _______________________________________________________
+	 |                         _________                     |
+	 |                        |   SW2   | ON      arcNet     |
+	 |                        |_________| OFF             ___|
+	 |  _____________         1 ______  8                |   | 8
+	 | |             | SW1     | XTAL | ____________     | S |
+	 | > RAM (2k)    |         |______||            |    | W |
+	 | |_____________|                 |      H     |    | 3 |
+	 |                        _________|_____ y     |    |___| 1
+	 |  _________            |         |     |b     |        |
+	 | |_________|           |         |     |r     |        |
+	 |                       |     SMC |     |i     |        |
+	 |                       |    90C65|     |d     |        |
+	 |  _________            |         |     |      |        |
+	 | |   SW1   | ON        |         |     |I     |        |
+	 | |_________| OFF       |_________|_____/C     |   _____|
+	 |  1       8                      |            |  |     |___
+	 |  ______________                 |            |  | BNC |___|
+	 | |              |                |____________|  |_____|
+	 | > EPROM SOCKET |              _____________           |
+	 | |______________|             |_____________|          |
+	 |                                         ______________|
+	 |                                        |
+	 |________________________________________|
 
-90C65       ARCNET Chip 
-SW1 1-5:    Base Memory Address Select
-    6-8:    Base I/O Address Select
-SW2 1-8:    Node ID Select
-SW3 1-5:    IRQ Select   
-    6-7:    Extra Timeout
-    8  :    ROM Enable   
-BNC         Coax connector
-XTAL        20 MHz Crystal
+Legend::
+
+  90C65       ARCNET Chip
+  SW1 1-5:    Base Memory Address Select
+      6-8:    Base I/O Address Select
+  SW2 1-8:    Node ID Select
+  SW3 1-5:    IRQ Select
+      6-7:    Extra Timeout
+      8  :    ROM Enable
+  BNC         Coax connector
+  XTAL        20 MHz Crystal
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW3 are used to set the node ID. Each node attached
 to the network must have an unique node ID which must not be 0.
@@ -1955,8 +2011,8 @@ Switch 1 serves as the least significant bit (LSB).
 
 Setting one of the switches to Off means "1", On means "0".
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
    Switch | Value
    -------|-------
@@ -1971,10 +2027,10 @@ These values are:
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The last three switches in switch block SW1 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
 
    Switch      | Hex I/O
@@ -1991,13 +2047,16 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The memory buffer (RAM) requires 2K. The base of this buffer can be 
+The memory buffer (RAM) requires 2K. The base of this buffer can be
 located in any of eight positions. The address of the Boot Prom is
 memory base + 0x2000.
+
 Jumpers 3-5 of switch block SW1 select the Memory Base address.
 
+::
+
    Switch              | Hex RAM | Hex ROM
     1   2   3   4   5  | Address | Address *)
    --------------------|---------|-----------
@@ -2009,16 +2068,16 @@ Jumpers 3-5 of switch block SW1 select the Memory Base address.
    ON  ON  OFF ON  OFF |  D8000  |  DA000
    ON  ON  ON  OFF OFF |  DC000  |  DE000
    ON  ON  OFF OFF OFF |  E0000  |  E2000
-  
-*) To enable the Boot ROM set the switch 8 of switch block SW3 to position ON.
+
+  *) To enable the Boot ROM set the switch 8 of switch block SW3 to position ON.
 
 The switches 1 and 2 probably add 0x0800 and 0x1000 to RAM base address.
 
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-Switches 1-5 of the switch block SW3 control the IRQ level.
+Switches 1-5 of the switch block SW3 control the IRQ level::
 
     Jumper              |  IRQ
     1   2   3   4   5   |
@@ -2031,64 +2090,67 @@ Switches 1-5 of the switch block SW3 control the IRQ level.
 
 
 Setting the Timeout Parameters
-------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The switches 6-7 of the switch block SW3 are used to determine the timeout
 parameters.  These two switches are normally left in the OFF position.
 
 
-*****************************************************************************
+Topware
+=======
 
-** Topware **
 8-bit card, TA-ARC/10
--------------------------
+---------------------
+
   - from Vojtech Pavlik <vojtech@suse.cz>
 
 This is another very similar 90C65 card. Most of the switches and jumpers
 are the same as on other clones.
 
- _____________________________________________________________________
-|  ___________   |                         |            ______        |
-| |SW2 NODE ID|  |                         |           | XTAL |       |
-| |___________|  |  Hybrid IC              |           |______|       |
-|  ___________   |                         |                        __|    
-| |SW1 MEM+I/O|  |_________________________|                   LED1|__|)   
-| |___________|           1 2                                         |     
-|                     J3 |o|o| TIMEOUT                          ______|    
-|     ______________     |o|o|                                 |      |    
-|    |              |  ___________________                     | RJ   |    
-|    > EPROM SOCKET | |                   \                    |------|     
-|J2  |______________| |                    |                   |      |    
-||o|                  |                    |                   |______|
-||o| ROM ENABLE       |        SMC         |    _________             |
-|     _____________   |       90C65        |   |_________|       _____|    
-|    |             |  |                    |                    |     |___ 
-|    > RAM (2k)    |  |                    |                    | BNC |___|
-|    |_____________|  |                    |                    |_____|    
-|                     |____________________|                          |    
-| ________ IRQ 2 3 4 5 7                  ___________                 |
-||________|   |o|o|o|o|o|                |___________|                |
-|________   J1|o|o|o|o|o|                               ______________|
-         |                                             |
-         |_____________________________________________|
+::
 
-Legend:
+   _____________________________________________________________________
+  |  ___________   |                         |            ______        |
+  | |SW2 NODE ID|  |                         |           | XTAL |       |
+  | |___________|  |  Hybrid IC              |           |______|       |
+  |  ___________   |                         |                        __|
+  | |SW1 MEM+I/O|  |_________________________|                   LED1|__|)
+  | |___________|           1 2                                         |
+  |                     J3 |o|o| TIMEOUT                          ______|
+  |     ______________     |o|o|                                 |      |
+  |    |              |  ___________________                     | RJ   |
+  |    > EPROM SOCKET | |                   \                    |------|
+  |J2  |______________| |                    |                   |      |
+  ||o|                  |                    |                   |______|
+  ||o| ROM ENABLE       |        SMC         |    _________             |
+  |     _____________   |       90C65        |   |_________|       _____|
+  |    |             |  |                    |                    |     |___
+  |    > RAM (2k)    |  |                    |                    | BNC |___|
+  |    |_____________|  |                    |                    |_____|
+  |                     |____________________|                          |
+  | ________ IRQ 2 3 4 5 7                  ___________                 |
+  ||________|   |o|o|o|o|o|                |___________|                |
+  |________   J1|o|o|o|o|o|                               ______________|
+	   |                                             |
+	   |_____________________________________________|
 
-90C65       ARCNET Chip
-XTAL        20 MHz Crystal
-SW1 1-5     Base Memory Address Select
-    6-8     Base I/O Address Select
-SW2 1-8     Node ID Select (ID0-ID7)
-J1          IRQ Select
-J2          ROM Enable
-J3          Extra Timeout
-LED1        Activity LED 
-BNC         Coax connector (BUS ARCnet)
-RJ          Twisted Pair Connector (daisy chain)
+Legend::
+
+  90C65       ARCNET Chip
+  XTAL        20 MHz Crystal
+  SW1 1-5     Base Memory Address Select
+      6-8     Base I/O Address Select
+  SW2 1-8     Node ID Select (ID0-ID7)
+  J1          IRQ Select
+  J2          ROM Enable
+  J3          Extra Timeout
+  LED1        Activity LED
+  BNC         Coax connector (BUS ARCnet)
+  RJ          Twisted Pair Connector (daisy chain)
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW2 are used to set the node ID. Each node attached to
 the network must have an unique node ID which must not be 0.  Switch 1 (ID0)
@@ -2097,7 +2159,7 @@ serves as the least significant bit (LSB).
 Setting one of the switches to Off means "1", On means "0".
 
 The node ID is the sum of the values of all switches set to "1"
-These values are:
+These values are::
 
    Switch | Label | Value
    -------|-------|-------
@@ -2111,10 +2173,10 @@ These values are:
      8    | ID7   | 128
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The last three switches in switch block SW1 are used to select one
-of eight possible I/O Base addresses using the following table:
+of eight possible I/O Base addresses using the following table::
 
 
    Switch      | Hex I/O
@@ -2122,7 +2184,7 @@ of eight possible I/O Base addresses using the following table:
    ------------|--------
    ON  ON  ON  |  260  (Manufacturer's default)
    OFF ON  ON  |  290
-   ON  OFF ON  |  2E0                         
+   ON  OFF ON  |  2E0
    OFF OFF ON  |  2F0
    ON  ON  OFF |  300
    OFF ON  OFF |  350
@@ -2131,35 +2193,38 @@ of eight possible I/O Base addresses using the following table:
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer (RAM) requires 2K. The base of this buffer can be
 located in any of eight positions. The address of the Boot Prom is
 memory base + 0x2000.
+
 Jumpers 3-5 of switch block SW1 select the Memory Base address.
 
+::
+
    Switch              | Hex RAM | Hex ROM
     1   2   3   4   5  | Address | Address *)
    --------------------|---------|-----------
    ON  ON  ON  ON  ON  |  C0000  |  C2000
-   ON  ON  OFF ON  ON  |  C4000  |  C6000  (Manufacturer's default) 
+   ON  ON  OFF ON  ON  |  C4000  |  C6000  (Manufacturer's default)
    ON  ON  ON  OFF ON  |  CC000  |  CE000
-   ON  ON  OFF OFF ON  |  D0000  |  D2000  
+   ON  ON  OFF OFF ON  |  D0000  |  D2000
    ON  ON  ON  ON  OFF |  D4000  |  D6000
    ON  ON  OFF ON  OFF |  D8000  |  DA000
    ON  ON  ON  OFF OFF |  DC000  |  DE000
    ON  ON  OFF OFF OFF |  E0000  |  E2000
 
-*) To enable the Boot ROM short the jumper J2.
+   *) To enable the Boot ROM short the jumper J2.
 
 The jumpers 1 and 2 probably add 0x0800 and 0x1000 to RAM address.
 
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Jumpers 1-5 of the jumper block J1 control the IRQ level.  ON means
-shorted, OFF means open.
+shorted, OFF means open::
 
     Jumper              |  IRQ
     1   2   3   4   5   |
@@ -2172,19 +2237,21 @@ shorted, OFF means open.
 
 
 Setting the Timeout Parameters
-------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The jumpers J3 are used to set the timeout parameters. These two 
+The jumpers J3 are used to set the timeout parameters. These two
 jumpers are normally left open.
 
-  
-*****************************************************************************
+Thomas-Conrad
+=============
 
-** Thomas-Conrad **
 Model #500-6242-0097 REV A (8-bit card)
 ---------------------------------------
+
   - from Lars Karlsson <100617.3473@compuserve.com>
 
+::
+
      ________________________________________________________
    |          ________   ________                           |_____
    |         |........| |........|                            |
@@ -2194,11 +2261,11 @@ Model #500-6242-0097 REV A (8-bit card)
    |                                              address |   |
    |    ______                                    switch  |   |
    |   |      |                                           |   |
-   |   |      |                                           |___|    
+   |   |      |                                           |___|
    |   |      |                                 ______        |___._
    |   |______|                                |______|         ____| BNC
    |                                            Jumper-        _____| Connector
-   |   Main chip                                block  _    __|   '  
+   |   Main chip                                block  _    __|   '
    |                                                  | |  |    RJ Connector
    |                                                  |_|  |    with 110 Ohm
    |                                                       |__  Terminator
@@ -2208,46 +2275,49 @@ Model #500-6242-0097 REV A (8-bit card)
    |   |___________|   |_____|                             |__
    |  Boot PROM socket IRQ-jumpers                            |_  Diagnostic
    |________                                       __          _| LED (red)
-            | | | | | | | | | | | | | | | | | | | |  |        |
-            | | | | | | | | | | | | | | | | | | | |  |________|
-                                                              |
-                                                              |
+	    | | | | | | | | | | | | | | | | | | | |  |        |
+	    | | | | | | | | | | | | | | | | | | | |  |________|
+							      |
+							      |
 
 And here are the settings for some of the switches and jumpers on the cards.
 
+::
 
-          I/O
+	    I/O
 
-         1 2 3 4 5 6 7 8
+	   1 2 3 4 5 6 7 8
 
-2E0----- 0 0 0 1 0 0 0 1
-2F0----- 0 0 0 1 0 0 0 0
-300----- 0 0 0 0 1 1 1 1
-350----- 0 0 0 0 1 1 1 0
+  2E0----- 0 0 0 1 0 0 0 1
+  2F0----- 0 0 0 1 0 0 0 0
+  300----- 0 0 0 0 1 1 1 1
+  350----- 0 0 0 0 1 1 1 0
 
 "0" in the above example means switch is off "1" means that it is on.
 
+::
 
-    ShMem address.
+      ShMem address.
 
-      1 2 3 4 5 6 7 8
+	1 2 3 4 5 6 7 8
 
-CX00--0 0 1 1 | |   |
-DX00--0 0 1 0       |
-X000--------- 1 1   |
-X400--------- 1 0   |
-X800--------- 0 1   |
-XC00--------- 0 0   
-ENHANCED----------- 1
-COMPATIBLE--------- 0
+  CX00--0 0 1 1 | |   |
+  DX00--0 0 1 0       |
+  X000--------- 1 1   |
+  X400--------- 1 0   |
+  X800--------- 0 1   |
+  XC00--------- 0 0
+  ENHANCED----------- 1
+  COMPATIBLE--------- 0
 
+::
 
-       IRQ
+	 IRQ
 
 
-   3 4 5 7 2
-   . . . . .
-   . . . . .
+     3 4 5 7 2
+     . . . . .
+     . . . . .
 
 
 There is a DIP-switch with 8 switches, used to set the shared memory address
@@ -2266,10 +2336,9 @@ varies by the type of card involved.  I fail to see how either of these
 enhance anything.  Send me more detailed information about this mode, or
 just use "compatible" mode instead.]
 
+Waterloo Microsystems Inc. ??
+=============================
 
-*****************************************************************************
-
-** Waterloo Microsystems Inc. ?? **
 8-bit card (C) 1985
 -------------------
   - from Robert Michael Best <rmb117@cs.usask.ca>
@@ -2283,103 +2352,104 @@ e-mail me.]
 
 The probe has not been able to detect the card on any of the J2 settings,
 and I tried them again with the "Waterloo" chip removed.
- 
- _____________________________________________________________________
-| \/  \/              ___  __ __                                      |
-| C4  C4     |^|     | M ||  ^  ||^|                                  |
-| --  --     |_|     | 5 ||     || | C3                               |
-| \/  \/      C10    |___||     ||_|                                  | 
-| C4  C4             _  _ |     |                 ??                  | 
-| --  --            | \/ ||     |                                     | 
-|                   |    ||     |                                     | 
-|                   |    ||  C1 |                                     | 
-|                   |    ||     |  \/                            _____|    
-|                   | C6 ||     |  C9                           |     |___ 
-|                   |    ||     |  --                           | BNC |___| 
-|                   |    ||     |          >C7|                 |_____|
-|                   |    ||     |                                     |
-| __ __             |____||_____|       1 2 3     6                   |
-||  ^  |     >C4|                      |o|o|o|o|o|o| J2    >C4|       |
-||     |                               |o|o|o|o|o|o|                  |
-|| C2  |     >C4|                                          >C4|       |
-||     |                                   >C8|                       |
-||     |       2 3 4 5 6 7  IRQ                            >C4|       |
-||_____|      |o|o|o|o|o|o| J3                                        |
-|_______      |o|o|o|o|o|o|                            _______________|
-        |                                             |
-        |_____________________________________________|
 
-C1 -- "COM9026
-       SMC 8638"
-      In a chip socket.
+::
 
-C2 -- "@Copyright
-       Waterloo Microsystems Inc.
-       1985"
-      In a chip Socket with info printed on a label covering a round window
-      showing the circuit inside. (The window indicates it is an EPROM chip.)
+   _____________________________________________________________________
+  | \/  \/              ___  __ __                                      |
+  | C4  C4     |^|     | M ||  ^  ||^|                                  |
+  | --  --     |_|     | 5 ||     || | C3                               |
+  | \/  \/      C10    |___||     ||_|                                  |
+  | C4  C4             _  _ |     |                 ??                  |
+  | --  --            | \/ ||     |                                     |
+  |                   |    ||     |                                     |
+  |                   |    ||  C1 |                                     |
+  |                   |    ||     |  \/                            _____|
+  |                   | C6 ||     |  C9                           |     |___
+  |                   |    ||     |  --                           | BNC |___|
+  |                   |    ||     |          >C7|                 |_____|
+  |                   |    ||     |                                     |
+  | __ __             |____||_____|       1 2 3     6                   |
+  ||  ^  |     >C4|                      |o|o|o|o|o|o| J2    >C4|       |
+  ||     |                               |o|o|o|o|o|o|                  |
+  || C2  |     >C4|                                          >C4|       |
+  ||     |                                   >C8|                       |
+  ||     |       2 3 4 5 6 7  IRQ                            >C4|       |
+  ||_____|      |o|o|o|o|o|o| J3                                        |
+  |_______      |o|o|o|o|o|o|                            _______________|
+	  |                                             |
+	  |_____________________________________________|
 
-C3 -- "COM9032
-       SMC 8643"
-      In a chip socket.
+  C1 -- "COM9026
+	 SMC 8638"
+	In a chip socket.
 
-C4 -- "74LS"
-      9 total no sockets.
+  C2 -- "@Copyright
+	 Waterloo Microsystems Inc.
+	 1985"
+	In a chip Socket with info printed on a label covering a round window
+	showing the circuit inside. (The window indicates it is an EPROM chip.)
 
-M5 -- "50006-136
-       20.000000 MHZ
-       MTQ-T1-S3
-       0 M-TRON 86-40"
-      Metallic case with 4 pins, no socket.
+  C3 -- "COM9032
+	 SMC 8643"
+	In a chip socket.
 
-C6 -- "MOSTEK@TC8643
-       MK6116N-20
-       MALAYSIA"
-      No socket.
+  C4 -- "74LS"
+	9 total no sockets.
 
-C7 -- No stamp or label but in a 20 pin chip socket.
+  M5 -- "50006-136
+	 20.000000 MHZ
+	 MTQ-T1-S3
+	 0 M-TRON 86-40"
+	Metallic case with 4 pins, no socket.
 
-C8 -- "PAL10L8CN
-       8623"
-      In a 20 pin socket.
+  C6 -- "MOSTEK@TC8643
+	 MK6116N-20
+	 MALAYSIA"
+	No socket.
 
-C9 -- "PAl16R4A-2CN
-       8641"
-      In a 20 pin socket.
+  C7 -- No stamp or label but in a 20 pin chip socket.
 
-C10 -- "M8640
-          NMC
-        9306N"
-       In an 8 pin socket.
+  C8 -- "PAL10L8CN
+	 8623"
+	In a 20 pin socket.
 
-?? -- Some components on a smaller board and attached with 20 pins all 
-      along the side closest to the BNC connector.  The are coated in a dark 
-      resin.
+  C9 -- "PAl16R4A-2CN
+	 8641"
+	In a 20 pin socket.
 
-On the board there are two jumper banks labeled J2 and J3. The 
-manufacturer didn't put a J1 on the board. The two boards I have both 
+  C10 -- "M8640
+	    NMC
+	  9306N"
+	 In an 8 pin socket.
+
+  ?? -- Some components on a smaller board and attached with 20 pins all
+	along the side closest to the BNC connector.  The are coated in a dark
+	resin.
+
+On the board there are two jumper banks labeled J2 and J3. The
+manufacturer didn't put a J1 on the board. The two boards I have both
 came with a jumper box for each bank.
 
-J2 -- Numbered 1 2 3 4 5 6. 
-      4 and 5 are not stamped due to solder points.
-       
-J3 -- IRQ 2 3 4 5 6 7
+::
 
-The board itself has a maple leaf stamped just above the irq jumpers 
-and "-2 46-86" beside C2. Between C1 and C6 "ASS 'Y 300163" and "@1986 
+  J2 -- Numbered 1 2 3 4 5 6.
+	4 and 5 are not stamped due to solder points.
+
+  J3 -- IRQ 2 3 4 5 6 7
+
+The board itself has a maple leaf stamped just above the irq jumpers
+and "-2 46-86" beside C2. Between C1 and C6 "ASS 'Y 300163" and "@1986
 CORMAN CUSTOM ELECTRONICS CORP." stamped just below the BNC connector.
 Below that "MADE IN CANADA"
 
-  
-*****************************************************************************
+No Name
+=======
 
-** No Name **
 8-bit cards, 16-bit cards
 -------------------------
+
   - from Juergen Seifert <seifert@htwm.de>
-  
-NONAME 8-BIT ARCNET
-===================
 
 I have named this ARCnet card "NONAME", since there is no name of any
 manufacturer on the Installation manual nor on the shipping box. The only
@@ -2388,8 +2458,10 @@ it is "Made in Taiwan"
 
 This description has been written by Juergen Seifert <seifert@htwm.de>
 using information from the Original
-                    "ARCnet Installation Manual"
 
+		    "ARCnet Installation Manual"
+
+::
 
     ________________________________________________________________
    | |STAR| BUS| T/P|                                               |
@@ -2416,32 +2488,32 @@ using information from the Original
        |        \ IRQ   / T T O                      |
        |__________________1_2_M______________________|
 
-Legend:
+Legend::
 
-COM90C65:       ARCnet Probe
-S1  1-8:    Node ID Select
-S2  1-3:    I/O Base Address Select
-    4-6:    Memory Base Address Select
-    7-8:    RAM Offset Select
-ET1, ET2    Extended Timeout Select
-ROM     ROM Enable Select
-CN              RG62 Coax Connector
-STAR| BUS | T/P Three fields for placing a sign (colored circle)
-                indicating the topology of the card
+  COM90C65:       ARCnet Probe
+  S1  1-8:    Node ID Select
+  S2  1-3:    I/O Base Address Select
+      4-6:    Memory Base Address Select
+      7-8:    RAM Offset Select
+  ET1, ET2    Extended Timeout Select
+  ROM     ROM Enable Select
+  CN              RG62 Coax Connector
+  STAR| BUS | T/P Three fields for placing a sign (colored circle)
+		  indicating the topology of the card
 
 Setting one of the switches to Off means "1", On means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in group SW1 are used to set the node ID.
 Each node attached to the network must have an unique node ID which
 must be different from 0.
 Switch 8 serves as the least significant bit (LSB).
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
     Switch | Value
     -------|-------
@@ -2454,30 +2526,30 @@ These values are:
       2    |  64
       1    | 128
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    1 2 3 4 5 6 7 8 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
    1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The first three switches in switch group SW2 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
    Switch      | Hex I/O
     1   2   3  | Address
@@ -2493,7 +2565,7 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer requires 2K of a 16K block of RAM. The base of this
 16K block can be located in any of eight positions.
@@ -2501,6 +2573,8 @@ Switches 4-6 of switch group SW2 select the Base of the 16K block.
 Within that 16K address space, the buffer may be assigned any one of four
 positions, determined by the offset, switches 7 and 8 of group SW2.
 
+::
+
    Switch     | Hex RAM | Hex ROM
    4 5 6  7 8 | Address | Address *)
    -----------|---------|-----------
@@ -2508,60 +2582,62 @@ positions, determined by the offset, switches 7 and 8 of group SW2.
    0 0 0  0 1 |  C0800  |  C2000
    0 0 0  1 0 |  C1000  |  C2000
    0 0 0  1 1 |  C1800  |  C2000
-              |         |
+	      |         |
    0 0 1  0 0 |  C4000  |  C6000
    0 0 1  0 1 |  C4800  |  C6000
    0 0 1  1 0 |  C5000  |  C6000
    0 0 1  1 1 |  C5800  |  C6000
-              |         |
+	      |         |
    0 1 0  0 0 |  CC000  |  CE000
    0 1 0  0 1 |  CC800  |  CE000
    0 1 0  1 0 |  CD000  |  CE000
    0 1 0  1 1 |  CD800  |  CE000
-              |         |
+	      |         |
    0 1 1  0 0 |  D0000  |  D2000  (Manufacturer's default)
    0 1 1  0 1 |  D0800  |  D2000
    0 1 1  1 0 |  D1000  |  D2000
    0 1 1  1 1 |  D1800  |  D2000
-              |         |
+	      |         |
    1 0 0  0 0 |  D4000  |  D6000
    1 0 0  0 1 |  D4800  |  D6000
    1 0 0  1 0 |  D5000  |  D6000
    1 0 0  1 1 |  D5800  |  D6000
-              |         |
+	      |         |
    1 0 1  0 0 |  D8000  |  DA000
    1 0 1  0 1 |  D8800  |  DA000
    1 0 1  1 0 |  D9000  |  DA000
    1 0 1  1 1 |  D9800  |  DA000
-              |         |
+	      |         |
    1 1 0  0 0 |  DC000  |  DE000
    1 1 0  0 1 |  DC800  |  DE000
    1 1 0  1 0 |  DD000  |  DE000
    1 1 0  1 1 |  DD800  |  DE000
-              |         |
+	      |         |
    1 1 1  0 0 |  E0000  |  E2000
    1 1 1  0 1 |  E0800  |  E2000
    1 1 1  1 0 |  E1000  |  E2000
    1 1 1  1 1 |  E1800  |  E2000
-  
-*) To enable the 8K Boot PROM install the jumper ROM.
-   The default is jumper ROM not installed.
+
+   *) To enable the 8K Boot PROM install the jumper ROM.
+      The default is jumper ROM not installed.
 
 
 Setting Interrupt Request Lines (IRQ)
--------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 To select a hardware interrupt level set one (only one!) of the jumpers
 IRQ2, IRQ3, IRQ4, IRQ5 or IRQ7. The manufacturer's default is IRQ2.
- 
+
 
 Setting the Timeouts
---------------------
+^^^^^^^^^^^^^^^^^^^^
 
 The two jumpers labeled ET1 and ET2 are used to determine the timeout
 parameters (response and reconfiguration time). Every node in a network
 must be set to the same timeout values.
 
+::
+
    ET1 ET2 | Response Time (us) | Reconfiguration Time (ms)
    --------|--------------------|--------------------------
    Off Off |        78          |          840   (Default)
@@ -2572,8 +2648,8 @@ must be set to the same timeout values.
 On means jumper installed, Off means jumper not installed
 
 
-NONAME 16-BIT ARCNET
-====================
+16-BIT ARCNET
+-------------
 
 The manual of my 8-Bit NONAME ARCnet Card contains another description
 of a 16-Bit Coax / Twisted Pair Card. This description is incomplete,
@@ -2584,13 +2660,16 @@ the booklet there is a different way of counting ... 2-9, 2-10, A-1,
 Also the picture of the board layout is not as good as the picture of
 8-Bit card, because there isn't any letter like "SW1" written to the
 picture.
+
 Should somebody have such a board, please feel free to complete this
 description or to send a mail to me!
 
 This description has been written by Juergen Seifert <seifert@htwm.de>
 using information from the Original
-                    "ARCnet Installation Manual"
 
+		    "ARCnet Installation Manual"
+
+::
 
    ___________________________________________________________________
   <                    _________________  _________________           |
@@ -2622,15 +2701,15 @@ Setting one of the switches to Off means "1", On means "0".
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in group SW2 are used to set the node ID.
 Each node attached to the network must have an unique node ID which
 must be different from 0.
 Switch 8 serves as the least significant bit (LSB).
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
     Switch | Value
     -------|-------
@@ -2643,30 +2722,30 @@ These values are:
       2    |  64
       1    | 128
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    1 2 3 4 5 6 7 8 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
    1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The first three switches in switch group SW1 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
    Switch      | Hex I/O
     3   2   1  | Address
@@ -2682,13 +2761,13 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer requires 2K of a 16K block of RAM. The base of this
 16K block can be located in any of eight positions.
 Switches 6-8 of switch group SW1 select the Base of the 16K block.
 Within that 16K address space, the buffer may be assigned any one of four
-positions, determined by the offset, switches 4 and 5 of group SW1.
+positions, determined by the offset, switches 4 and 5 of group SW1::
 
    Switch     | Hex RAM | Hex ROM
    8 7 6  5 4 | Address | Address
@@ -2697,111 +2776,111 @@ positions, determined by the offset, switches 4 and 5 of group SW1.
    0 0 0  0 1 |  C0800  |  C2000
    0 0 0  1 0 |  C1000  |  C2000
    0 0 0  1 1 |  C1800  |  C2000
-              |         |
+	      |         |
    0 0 1  0 0 |  C4000  |  C6000
    0 0 1  0 1 |  C4800  |  C6000
    0 0 1  1 0 |  C5000  |  C6000
    0 0 1  1 1 |  C5800  |  C6000
-              |         |
+	      |         |
    0 1 0  0 0 |  CC000  |  CE000
    0 1 0  0 1 |  CC800  |  CE000
    0 1 0  1 0 |  CD000  |  CE000
    0 1 0  1 1 |  CD800  |  CE000
-              |         |
+	      |         |
    0 1 1  0 0 |  D0000  |  D2000  (Manufacturer's default)
    0 1 1  0 1 |  D0800  |  D2000
    0 1 1  1 0 |  D1000  |  D2000
    0 1 1  1 1 |  D1800  |  D2000
-              |         |
+	      |         |
    1 0 0  0 0 |  D4000  |  D6000
    1 0 0  0 1 |  D4800  |  D6000
    1 0 0  1 0 |  D5000  |  D6000
    1 0 0  1 1 |  D5800  |  D6000
-              |         |
+	      |         |
    1 0 1  0 0 |  D8000  |  DA000
    1 0 1  0 1 |  D8800  |  DA000
    1 0 1  1 0 |  D9000  |  DA000
    1 0 1  1 1 |  D9800  |  DA000
-              |         |
+	      |         |
    1 1 0  0 0 |  DC000  |  DE000
    1 1 0  0 1 |  DC800  |  DE000
    1 1 0  1 0 |  DD000  |  DE000
    1 1 0  1 1 |  DD800  |  DE000
-              |         |
+	      |         |
    1 1 1  0 0 |  E0000  |  E2000
    1 1 1  0 1 |  E0800  |  E2000
    1 1 1  1 0 |  E1000  |  E2000
    1 1 1  1 1 |  E1800  |  E2000
-  
+
 
 Setting Interrupt Request Lines (IRQ)
--------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 ??????????????????????????????????????
 
 
 Setting the Timeouts
---------------------
+^^^^^^^^^^^^^^^^^^^^
 
 ??????????????????????????????????????
 
 
-*****************************************************************************
-
-** No Name **
 8-bit cards ("Made in Taiwan R.O.C.")
------------
+-------------------------------------
+
   - from Vojtech Pavlik <vojtech@suse.cz>
 
 I have named this ARCnet card "NONAME", since I got only the card with
-no manual at all and the only text identifying the manufacturer is 
+no manual at all and the only text identifying the manufacturer is
 "MADE IN TAIWAN R.O.C" printed on the card.
 
-          ____________________________________________________________
-         |                 1 2 3 4 5 6 7 8                            |
-         | |o|o| JP1       o|o|o|o|o|o|o|o| ON                        |
-         |  +              o|o|o|o|o|o|o|o|                        ___|
-         |  _____________  o|o|o|o|o|o|o|o| OFF         _____     |   | ID7
-         | |             | SW1                         |     |    |   | ID6
-         | > RAM (2k)    |        ____________________ |  H  |    | S | ID5
-         | |_____________|       |                    ||  y  |    | W | ID4
-         |                       |                    ||  b  |    | 2 | ID3
-         |                       |                    ||  r  |    |   | ID2
-         |                       |                    ||  i  |    |   | ID1
-         |                       |       90C65        ||  d  |    |___| ID0
-         |      SW3              |                    ||     |        |      
-         | |o|o|o|o|o|o|o|o| ON  |                    ||  I  |        |
-         | |o|o|o|o|o|o|o|o|     |                    ||  C  |        |
-         | |o|o|o|o|o|o|o|o| OFF |____________________||     |   _____|
-         |  1 2 3 4 5 6 7 8                            |     |  |     |___
-         |  ______________                             |     |  | BNC |___|
-         | |              |                            |_____|  |_____|
-         | > EPROM SOCKET |                                           |
-         | |______________|                                           |
-         |                                              ______________|
-         |                                             |
-         |_____________________________________________|
+::
 
-Legend:
+	  ____________________________________________________________
+	 |                 1 2 3 4 5 6 7 8                            |
+	 | |o|o| JP1       o|o|o|o|o|o|o|o| ON                        |
+	 |  +              o|o|o|o|o|o|o|o|                        ___|
+	 |  _____________  o|o|o|o|o|o|o|o| OFF         _____     |   | ID7
+	 | |             | SW1                         |     |    |   | ID6
+	 | > RAM (2k)    |        ____________________ |  H  |    | S | ID5
+	 | |_____________|       |                    ||  y  |    | W | ID4
+	 |                       |                    ||  b  |    | 2 | ID3
+	 |                       |                    ||  r  |    |   | ID2
+	 |                       |                    ||  i  |    |   | ID1
+	 |                       |       90C65        ||  d  |    |___| ID0
+	 |      SW3              |                    ||     |        |
+	 | |o|o|o|o|o|o|o|o| ON  |                    ||  I  |        |
+	 | |o|o|o|o|o|o|o|o|     |                    ||  C  |        |
+	 | |o|o|o|o|o|o|o|o| OFF |____________________||     |   _____|
+	 |  1 2 3 4 5 6 7 8                            |     |  |     |___
+	 |  ______________                             |     |  | BNC |___|
+	 | |              |                            |_____|  |_____|
+	 | > EPROM SOCKET |                                           |
+	 | |______________|                                           |
+	 |                                              ______________|
+	 |                                             |
+	 |_____________________________________________|
 
-90C65       ARCNET Chip 
-SW1 1-5:    Base Memory Address Select
-    6-8:    Base I/O Address Select
-SW2 1-8:    Node ID Select (ID0-ID7)
-SW3 1-5:    IRQ Select   
-    6-7:    Extra Timeout
-    8  :    ROM Enable   
-JP1         Led connector
-BNC         Coax connector
+Legend::
 
-Although the jumpers SW1 and SW3 are marked SW, not JP, they are jumpers, not 
+  90C65       ARCNET Chip
+  SW1 1-5:    Base Memory Address Select
+      6-8:    Base I/O Address Select
+  SW2 1-8:    Node ID Select (ID0-ID7)
+  SW3 1-5:    IRQ Select
+      6-7:    Extra Timeout
+      8  :    ROM Enable
+  JP1         Led connector
+  BNC         Coax connector
+
+Although the jumpers SW1 and SW3 are marked SW, not JP, they are jumpers, not
 switches.
 
-Setting the jumpers to ON means connecting the upper two pins, off the bottom 
+Setting the jumpers to ON means connecting the upper two pins, off the bottom
 two - or - in case of IRQ setting, connecting none of them at all.
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in SW2 are used to set the node ID. Each node attached
 to the network must have an unique node ID which must not be 0.
@@ -2809,8 +2888,8 @@ Switch 1 (ID0) serves as the least significant bit (LSB).
 
 Setting one of the switches to Off means "1", On means "0".
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
 
    Switch | Label | Value
    -------|-------|-------
@@ -2823,30 +2902,30 @@ These values are:
      7    | ID6   |  64
      8    | ID7   | 128
 
-Some Examples:
+Some Examples::
 
-    Switch         | Hex     | Decimal 
+    Switch         | Hex     | Decimal
    8 7 6 5 4 3 2 1 | Node ID | Node ID
    ----------------|---------|---------
    0 0 0 0 0 0 0 0 |    not allowed
-   0 0 0 0 0 0 0 1 |    1    |    1 
+   0 0 0 0 0 0 0 1 |    1    |    1
    0 0 0 0 0 0 1 0 |    2    |    2
    0 0 0 0 0 0 1 1 |    3    |    3
        . . .       |         |
    0 1 0 1 0 1 0 1 |   55    |   85
        . . .       |         |
    1 0 1 0 1 0 1 0 |   AA    |  170
-       . . .       |         |  
+       . . .       |         |
    1 1 1 1 1 1 0 1 |   FD    |  253
    1 1 1 1 1 1 1 0 |   FE    |  254
    1 1 1 1 1 1 1 1 |   FF    |  255
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The last three switches in switch block SW1 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
 
    Switch      | Hex I/O
@@ -2863,13 +2942,16 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory (RAM) buffer Address
---------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The memory buffer (RAM) requires 2K. The base of this buffer can be 
+The memory buffer (RAM) requires 2K. The base of this buffer can be
 located in any of eight positions. The address of the Boot Prom is
 memory base + 0x2000.
+
 Jumpers 3-5 of jumper block SW1 select the Memory Base address.
 
+::
+
    Switch              | Hex RAM | Hex ROM
     1   2   3   4   5  | Address | Address *)
    --------------------|---------|-----------
@@ -2881,15 +2963,15 @@ Jumpers 3-5 of jumper block SW1 select the Memory Base address.
    ON  ON  OFF ON  OFF |  D8000  |  DA000
    ON  ON  ON  OFF OFF |  DC000  |  DE000
    ON  ON  OFF OFF OFF |  E0000  |  E2000
-  
-*) To enable the Boot ROM set the jumper 8 of jumper block SW3 to position ON.
+
+  *) To enable the Boot ROM set the jumper 8 of jumper block SW3 to position ON.
 
 The jumpers 1 and 2 probably add 0x0800, 0x1000 and 0x1800 to RAM adders.
 
 Setting the Interrupt Line
---------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-Jumpers 1-5 of the jumper block SW3 control the IRQ level.
+Jumpers 1-5 of the jumper block SW3 control the IRQ level::
 
     Jumper              |  IRQ
     1   2   3   4   5   |
@@ -2902,23 +2984,24 @@ Jumpers 1-5 of the jumper block SW3 control the IRQ level.
 
 
 Setting the Timeout Parameters
-------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The jumpers 6-7 of the jumper block SW3 are used to determine the timeout 
+The jumpers 6-7 of the jumper block SW3 are used to determine the timeout
 parameters. These two jumpers are normally left in the OFF position.
 
 
-*****************************************************************************
 
-** No Name **
 (Generic Model 9058)
 --------------------
   - from Andrew J. Kroll <ag784@freenet.buffalo.edu>
   - Sorry this sat in my to-do box for so long, Andrew! (yikes - over a
     year!)
-                                                                      _____
-                                                                     |    <
-                                                                     | .---'
+
+::
+
+								      _____
+								     |    <
+								     | .---'
     ________________________________________________________________ | |
    |                           |     SW2     |                      |  |
    |   ___________             |_____________|                      |  |
@@ -2936,7 +3019,7 @@ parameters. These two jumpers are normally left in the OFF position.
    |  |________________|     |              |    : B   |-           |  |
    |    1 2 3 4 5 6 7 8      |              |    : O   |-           |  |
    |                         |_________o____|..../ A   |-    _______|  |
-   |    ____________________                |      R   |-   |       |------,   
+   |    ____________________                |      R   |-   |       |------,
    |   |                    |               |      D   |-   |  BNC  |   #  |
    |   > 2764 PROM SOCKET   |               |__________|-   |_______|------'
    |   |____________________|              _________                |  |
@@ -2945,23 +3028,24 @@ parameters. These two jumpers are normally left in the OFF position.
    |___                                               ______________|  |
        |H H H H H H H H H H H H H H H H H H H H H H H|               | |
        |U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U_U|               | |
-                                                                      \|
-Legend:
+								      \|
 
-SL90C65 	ARCNET Controller / Transceiver /Logic
-SW1	1-5:	IRQ Select
+Legend::
+
+  SL90C65 	ARCNET Controller / Transceiver /Logic
+  SW1	1-5:	IRQ Select
 	  6:	ET1
 	  7:	ET2
-	  8:	ROM ENABLE 
-SW2	1-3:    Memory Buffer/PROM Address
+	  8:	ROM ENABLE
+  SW2	1-3:    Memory Buffer/PROM Address
 	3-6:	I/O Address Map
-SW3	1-8:	Node ID Select
-BNC		BNC RG62/U Connection 
+  SW3	1-8:	Node ID Select
+  BNC		BNC RG62/U Connection
 		*I* have had success using RG59B/U with *NO* terminators!
 		What gives?!
 
 SW1: Timeouts, Interrupt and ROM
----------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 To select a hardware interrupt level set one (only one!) of the dip switches
 up (on) SW1...(switches 1-5)
@@ -2976,10 +3060,10 @@ are normally left off (down).
 
 
 Setting the I/O Base Address
-----------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The last three switches in switch group SW2 are used to select one
-of eight possible I/O Base addresses using the following table
+of eight possible I/O Base addresses using the following table::
 
 
    Switch | Hex I/O
@@ -2996,7 +3080,7 @@ of eight possible I/O Base addresses using the following table
 
 
 Setting the Base Memory Address (RAM & ROM)
--------------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The memory buffer requires 2K of a 16K block of RAM. The base of this
 16K block can be located in any of eight positions.
@@ -3004,13 +3088,16 @@ Switches 1-3 of switch group SW2 select the Base of the 16K block.
 (0 = DOWN, 1 = UP)
 I could, however, only verify two settings...
 
+
+::
+
    Switch| Hex RAM | Hex ROM
    1 2 3 | Address | Address
    ------|---------|-----------
    0 0 0 |  E0000  |  E2000
    0 0 1 |  D0000  |  D2000  (Manufacturer's default)
    0 1 0 |  ?????  |  ?????
-   0 1 1 |  ?????  |  ?????  
+   0 1 1 |  ?????  |  ?????
    1 0 0 |  ?????  |  ?????
    1 0 1 |  ?????  |  ?????
    1 1 0 |  ?????  |  ?????
@@ -3018,7 +3105,7 @@ I could, however, only verify two settings...
 
 
 Setting the Node ID
--------------------
+^^^^^^^^^^^^^^^^^^^
 
 The eight switches in group SW3 are used to set the node ID.
 Each node attached to the network must have an unique node ID which
@@ -3026,8 +3113,9 @@ must be different from 0.
 Switch 1 serves as the least significant bit (LSB).
 switches in the DOWN position are OFF (0) and in the UP position are ON (1)
 
-The node ID is the sum of the values of all switches set to "1"  
-These values are:
+The node ID is the sum of the values of all switches set to "1"
+These values are::
+
     Switch | Value
     -------|-------
       1    |   1
@@ -3039,70 +3127,80 @@ These values are:
       7    |  64
       8    | 128
 
-Some Examples:
+Some Examples::
 
-    Switch#     |   Hex   | Decimal 
-8 7 6 5 4 3 2 1 | Node ID | Node ID
-----------------|---------|---------
-0 0 0 0 0 0 0 0 |    not allowed  <-.
-0 0 0 0 0 0 0 1 |    1    |    1    | 
-0 0 0 0 0 0 1 0 |    2    |    2    |
-0 0 0 0 0 0 1 1 |    3    |    3    |
-    . . .       |         |         |
-0 1 0 1 0 1 0 1 |   55    |   85    |
-    . . .       |         |         + Don't use 0 or 255!
-1 0 1 0 1 0 1 0 |   AA    |  170    |
-    . . .       |         |         |
-1 1 1 1 1 1 0 1 |   FD    |  253    |
-1 1 1 1 1 1 1 0 |   FE    |  254    |
-1 1 1 1 1 1 1 1 |   FF    |  255  <-'
-  
+      Switch#     |   Hex   | Decimal
+  8 7 6 5 4 3 2 1 | Node ID | Node ID
+  ----------------|---------|---------
+  0 0 0 0 0 0 0 0 |    not allowed  <-.
+  0 0 0 0 0 0 0 1 |    1    |    1    |
+  0 0 0 0 0 0 1 0 |    2    |    2    |
+  0 0 0 0 0 0 1 1 |    3    |    3    |
+      . . .       |         |         |
+  0 1 0 1 0 1 0 1 |   55    |   85    |
+      . . .       |         |         + Don't use 0 or 255!
+  1 0 1 0 1 0 1 0 |   AA    |  170    |
+      . . .       |         |         |
+  1 1 1 1 1 1 0 1 |   FD    |  253    |
+  1 1 1 1 1 1 1 0 |   FE    |  254    |
+  1 1 1 1 1 1 1 1 |   FF    |  255  <-'
 
-*****************************************************************************
 
-** Tiara **
+Tiara
+=====
+
 (model unknown)
--------------------------
+---------------
+
   - from Christoph Lameter <christoph@lameter.com>
-  
 
-Here is information about my card as far as I could figure it out:
------------------------------------------------ tiara
-Tiara LanCard of Tiara Computer Systems.
 
-+----------------------------------------------+
-!           ! Transmitter Unit !               !
-!           +------------------+             -------
-!          MEM                              Coax Connector
-!  ROM    7654321 <- I/O                     -------
-!  :  :   +--------+                           !
-!  :  :   ! 90C66LJ!                         +++
-!  :  :   !        !                         !D  Switch to set
-!  :  :   !        !                         !I  the Nodenumber
-!  :  :   +--------+                         !P
-!                                            !++
-!         234567 <- IRQ                      !
-+------------!!!!!!!!!!!!!!!!!!!!!!!!--------+
-             !!!!!!!!!!!!!!!!!!!!!!!!
+Here is information about my card as far as I could figure it out::
 
-0 = Jumper Installed
-1 = Open
+
+  ----------------------------------------------- tiara
+  Tiara LanCard of Tiara Computer Systems.
+
+  +----------------------------------------------+
+  !           ! Transmitter Unit !               !
+  !           +------------------+             -------
+  !          MEM                              Coax Connector
+  !  ROM    7654321 <- I/O                     -------
+  !  :  :   +--------+                           !
+  !  :  :   ! 90C66LJ!                         +++
+  !  :  :   !        !                         !D  Switch to set
+  !  :  :   !        !                         !I  the Nodenumber
+  !  :  :   +--------+                         !P
+  !                                            !++
+  !         234567 <- IRQ                      !
+  +------------!!!!!!!!!!!!!!!!!!!!!!!!--------+
+	       !!!!!!!!!!!!!!!!!!!!!!!!
+
+- 0 = Jumper Installed
+- 1 = Open
 
 Top Jumper line Bit 7 = ROM Enable 654=Memory location 321=I/O
 
 Settings for Memory Location (Top Jumper Line)
+
+===     ================
 456     Address selected
+===     ================
 000	C0000
 001     C4000
 010     CC000
 011     D0000
 100     D4000
 101     D8000
-110     DC000     
+110     DC000
 111     E0000
+===     ================
 
 Settings for I/O Address (Top Jumper Line)
+
+===     ====
 123     Port
+===     ====
 000	260
 001	290
 010	2E0
@@ -3111,23 +3209,26 @@ Settings for I/O Address (Top Jumper Line)
 101	350
 110	380
 111	3E0
+===     ====
 
 Settings for IRQ Selection (Lower Jumper Line)
+
+====== =====
 234567
+====== =====
 011111 IRQ 2
 101111 IRQ 3
 110111 IRQ 4
 111011 IRQ 5
 111110 IRQ 7
-
-*****************************************************************************
-
+====== =====
 
 Other Cards
------------
+===========
 
 I have no information on other models of ARCnet cards at the moment.  Please
 send any and all info to:
+
 	apenwarr@worldvisions.ca
 
 Thanks.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 96ffad845fd9..5da18e024fcb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -39,6 +39,7 @@ Contents:
    6lowpan
    6pack
    altera_tse
+   arcnet-hardware
 
 .. only::  subproject and html
 
-- 
2.25.4

