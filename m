Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507501C0181
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgD3QGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ABBF24971;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=9C1dMa3Ehy9gAHQ6OEEAo6fXYVOEg1MVQjKTqt6Kfh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPwloxsInEjj07RqZI+aYO6sQcQA7HiRfy96ApyEWWHqNYeOn1a0Z0TJzD28aMJFc
         Zp0IZfrCa0J49qQgdradEgVmd84mnx0BDE27s/2QEWXAUr1JfYZSrvPRzpIRjKlsjA
         1A7ewi7pHZ6afw8jPiXLam0MuZrPnhCYDC7pdMvg=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFh-Gc; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 20/37] docs: networking: convert ppp_generic.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:15 +0200
Message-Id: <e711e7e6de04025ff21e893b7c008fab677c55ac.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../{ppp_generic.txt => ppp_generic.rst}      | 52 ++++++++++++-------
 2 files changed, 33 insertions(+), 20 deletions(-)
 rename Documentation/networking/{ppp_generic.txt => ppp_generic.rst} (91%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 18bb10239cad..f89535871481 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -93,6 +93,7 @@ Contents:
    phonet
    pktgen
    plip
+   ppp_generic
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ppp_generic.txt b/Documentation/networking/ppp_generic.rst
similarity index 91%
rename from Documentation/networking/ppp_generic.txt
rename to Documentation/networking/ppp_generic.rst
index fd563aff5fc9..e60504377900 100644
--- a/Documentation/networking/ppp_generic.txt
+++ b/Documentation/networking/ppp_generic.rst
@@ -1,8 +1,12 @@
-		PPP Generic Driver and Channel Interface
-		----------------------------------------
+.. SPDX-License-Identifier: GPL-2.0
 
-			    Paul Mackerras
+========================================
+PPP Generic Driver and Channel Interface
+========================================
+
+			   Paul Mackerras
 			   paulus@samba.org
+
 			      7 Feb 2002
 
 The generic PPP driver in linux-2.4 provides an implementation of the
@@ -19,7 +23,7 @@ functionality which is of use in any PPP implementation, including:
 * simple packet filtering
 
 For sending and receiving PPP frames, the generic PPP driver calls on
-the services of PPP `channels'.  A PPP channel encapsulates a
+the services of PPP ``channels``.  A PPP channel encapsulates a
 mechanism for transporting PPP frames from one machine to another.  A
 PPP channel implementation can be arbitrarily complex internally but
 has a very simple interface with the generic PPP code: it merely has
@@ -102,7 +106,7 @@ communications medium and prepare it to do PPP.  For example, with an
 async tty, this can involve setting the tty speed and modes, issuing
 modem commands, and then going through some sort of dialog with the
 remote system to invoke PPP service there.  We refer to this process
-as `discovery'.  Then the user-level process tells the medium to
+as ``discovery``.  Then the user-level process tells the medium to
 become a PPP channel and register itself with the generic PPP layer.
 The channel then has to report the channel number assigned to it back
 to the user-level process.  From that point, the PPP negotiation code
@@ -111,8 +115,8 @@ negotiation, accessing the channel through the /dev/ppp interface.
 
 At the interface to the PPP generic layer, PPP frames are stored in
 skbuff structures and start with the two-byte PPP protocol number.
-The frame does *not* include the 0xff `address' byte or the 0x03
-`control' byte that are optionally used in async PPP.  Nor is there
+The frame does *not* include the 0xff ``address`` byte or the 0x03
+``control`` byte that are optionally used in async PPP.  Nor is there
 any escaping of control characters, nor are there any FCS or framing
 characters included.  That is all the responsibility of the channel
 code, if it is needed for the particular medium.  That is, the skbuffs
@@ -121,16 +125,16 @@ protocol number and the data, and the skbuffs presented to ppp_input()
 must be in the same format.
 
 The channel must provide an instance of a ppp_channel struct to
-represent the channel.  The channel is free to use the `private' field
-however it wishes.  The channel should initialize the `mtu' and
-`hdrlen' fields before calling ppp_register_channel() and not change
-them until after ppp_unregister_channel() returns.  The `mtu' field
+represent the channel.  The channel is free to use the ``private`` field
+however it wishes.  The channel should initialize the ``mtu`` and
+``hdrlen`` fields before calling ppp_register_channel() and not change
+them until after ppp_unregister_channel() returns.  The ``mtu`` field
 represents the maximum size of the data part of the PPP frames, that
 is, it does not include the 2-byte protocol number.
 
 If the channel needs some headroom in the skbuffs presented to it for
 transmission (i.e., some space free in the skbuff data area before the
-start of the PPP frame), it should set the `hdrlen' field of the
+start of the PPP frame), it should set the ``hdrlen`` field of the
 ppp_channel struct to the amount of headroom required.  The generic
 PPP layer will attempt to provide that much headroom but the channel
 should still check if there is sufficient headroom and copy the skbuff
@@ -322,6 +326,8 @@ an interface unit are:
   interface.  The argument should be a pointer to an int containing
   the new flags value.  The bits in the flags value that can be set
   are:
+
+	================	========================================
 	SC_COMP_TCP		enable transmit TCP header compression
 	SC_NO_TCP_CCID		disable connection-id compression for
 				TCP header compression
@@ -335,6 +341,7 @@ an interface unit are:
 	SC_MP_SHORTSEQ		expect short multilink sequence
 				numbers on received multilink fragments
 	SC_MP_XSHORTSEQ		transmit short multilink sequence nos.
+	================	========================================
 
   The values of these flags are defined in <linux/ppp-ioctl.h>.  Note
   that the values of the SC_MULTILINK, SC_MP_SHORTSEQ and
@@ -345,17 +352,20 @@ an interface unit are:
   interface unit.  The argument should point to an int where the ioctl
   will store the flags value.  As well as the values listed above for
   PPPIOCSFLAGS, the following bits may be set in the returned value:
+
+	================	=========================================
 	SC_COMP_RUN		CCP compressor is running
 	SC_DECOMP_RUN		CCP decompressor is running
 	SC_DC_ERROR		CCP decompressor detected non-fatal error
 	SC_DC_FERROR		CCP decompressor detected fatal error
+	================	=========================================
 
 * PPPIOCSCOMPRESS sets the parameters for packet compression or
   decompression.  The argument should point to a ppp_option_data
   structure (defined in <linux/ppp-ioctl.h>), which contains a
   pointer/length pair which should describe a block of memory
   containing a CCP option specifying a compression method and its
-  parameters.  The ppp_option_data struct also contains a `transmit'
+  parameters.  The ppp_option_data struct also contains a ``transmit``
   field.  If this is 0, the ioctl will affect the receive path,
   otherwise the transmit path.
 
@@ -377,7 +387,7 @@ an interface unit are:
   ppp_idle structure (defined in <linux/ppp_defs.h>).  If the
   CONFIG_PPP_FILTER option is enabled, the set of packets which reset
   the transmit and receive idle timers is restricted to those which
-  pass the `active' packet filter.
+  pass the ``active`` packet filter.
   Two versions of this command exist, to deal with user space
   expecting times as either 32-bit or 64-bit time_t seconds.
 
@@ -391,31 +401,33 @@ an interface unit are:
 
 * PPPIOCSNPMODE sets the network-protocol mode for a given network
   protocol.  The argument should point to an npioctl struct (defined
-  in <linux/ppp-ioctl.h>).  The `protocol' field gives the PPP protocol
-  number for the protocol to be affected, and the `mode' field
+  in <linux/ppp-ioctl.h>).  The ``protocol`` field gives the PPP protocol
+  number for the protocol to be affected, and the ``mode`` field
   specifies what to do with packets for that protocol:
 
+	=============	==============================================
 	NPMODE_PASS	normal operation, transmit and receive packets
 	NPMODE_DROP	silently drop packets for this protocol
 	NPMODE_ERROR	drop packets and return an error on transmit
 	NPMODE_QUEUE	queue up packets for transmit, drop received
 			packets
+	=============	==============================================
 
   At present NPMODE_ERROR and NPMODE_QUEUE have the same effect as
   NPMODE_DROP.
 
 * PPPIOCGNPMODE returns the network-protocol mode for a given
   protocol.  The argument should point to an npioctl struct with the
-  `protocol' field set to the PPP protocol number for the protocol of
-  interest.  On return the `mode' field will be set to the network-
+  ``protocol`` field set to the PPP protocol number for the protocol of
+  interest.  On return the ``mode`` field will be set to the network-
   protocol mode for that protocol.
 
-* PPPIOCSPASS and PPPIOCSACTIVE set the `pass' and `active' packet
+* PPPIOCSPASS and PPPIOCSACTIVE set the ``pass`` and ``active`` packet
   filters.  These ioctls are only available if the CONFIG_PPP_FILTER
   option is selected.  The argument should point to a sock_fprog
   structure (defined in <linux/filter.h>) containing the compiled BPF
   instructions for the filter.  Packets are dropped if they fail the
-  `pass' filter; otherwise, if they fail the `active' filter they are
+  ``pass`` filter; otherwise, if they fail the ``active`` filter they are
   passed but they do not reset the transmit or receive idle timer.
 
 * PPPIOCSMRRU enables or disables multilink processing for received
-- 
2.25.4

