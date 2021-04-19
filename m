Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362C4364D53
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhDSVxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 17:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229914AbhDSVxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 17:53:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 841EE61279;
        Mon, 19 Apr 2021 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618869157;
        bh=PBnIVD7MH6H2z4ya39nMtH6Fh250om4ofY3TAielTIg=;
        h=From:To:Cc:Subject:Date:From;
        b=WSLZhYgMSKzhX5dp3+qQgC774ltZ/lW5DLlVZXQK7h60IZpLGlc6kw11+Cw0kpwzD
         dKTEEVbRpAt3DSwzbClggMcMQ1cHY+hdFAAaUCRTXklQz0qlc+GTbNZJFVMkd953Cm
         aL1aDIU1Rr9gSjXF4fUmDE3nhu1Vbn0kSrS+qD0OIEk4wjGW7WrGf6CaJNoMSEUDJj
         B1iF83OAd4SGLqFqtfmJ2qyyddjbYt6y1nii/0zoqJbZuXFKycdpe6c8oamOCeipFJ
         kYzUFgpsgVg/MB0X1BOfEZxezyYqzwhCwljiaTpVORgEoaDIxau3rv2jEXIjwMF3O7
         P+lMkgwLI97Dg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, vladyslavt@nvidia.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] ethtool: add missing EEPROM to list of messages
Date:   Mon, 19 Apr 2021 14:52:35 -0700
Message-Id: <20210419215235.3075587-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_MSG_MODULE_EEPROM_GET is missing from the list of messages.
ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY is sadly a rather long name
so we need to adjust column length.

v2: use spaces (Andrew)

Fixes: c781ff12a2f3 ("ethtool: Allow network drivers to dump arbitrary EEPROM data")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 70 ++++++++++----------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 48cad2fce147..25131df3c2bd 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -210,45 +210,47 @@ All constants identifying message types use ``ETHTOOL_CMD_`` prefix and suffix
   ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
   ``ETHTOOL_MSG_FEC_GET``               get FEC settings
   ``ETHTOOL_MSG_FEC_SET``               set FEC settings
+  ``ETHTOOL_MSG_MODULE_EEPROM_GET``     read SFP module EEPROM
   ``ETHTOOL_MSG_STATS_GET``             get standard statistics
   ===================================== ================================
 
 Kernel to userspace:
 
-  ===================================== =================================
-  ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
-  ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
-  ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
-  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
-  ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
-  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
-  ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
-  ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
-  ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
-  ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
-  ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
-  ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
-  ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
-  ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
-  ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
-  ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
-  ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
-  ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
-  ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
-  ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
-  ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
-  ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
-  ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
-  ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
-  ``ETHTOOL_MSG_EEE_NTF``               EEE settings
-  ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
-  ``ETHTOOL_MSG_CABLE_TEST_NTF``        Cable test results
-  ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``    Cable test TDR results
-  ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY`` tunnel offload info
-  ``ETHTOOL_MSG_FEC_GET_REPLY``         FEC settings
-  ``ETHTOOL_MSG_FEC_NTF``               FEC settings
-  ``ETHTOOL_MSG_STATS_GET_REPLY``       standard statistics
-  ===================================== =================================
+  ======================================== =================================
+  ``ETHTOOL_MSG_STRSET_GET_REPLY``         string set contents
+  ``ETHTOOL_MSG_LINKINFO_GET_REPLY``       link settings
+  ``ETHTOOL_MSG_LINKINFO_NTF``             link settings notification
+  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``      link modes info
+  ``ETHTOOL_MSG_LINKMODES_NTF``            link modes notification
+  ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``      link state info
+  ``ETHTOOL_MSG_DEBUG_GET_REPLY``          debugging settings
+  ``ETHTOOL_MSG_DEBUG_NTF``                debugging settings notification
+  ``ETHTOOL_MSG_WOL_GET_REPLY``            wake-on-lan settings
+  ``ETHTOOL_MSG_WOL_NTF``                  wake-on-lan settings notification
+  ``ETHTOOL_MSG_FEATURES_GET_REPLY``       device features
+  ``ETHTOOL_MSG_FEATURES_SET_REPLY``       optional reply to FEATURES_SET
+  ``ETHTOOL_MSG_FEATURES_NTF``             netdev features notification
+  ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``      private flags
+  ``ETHTOOL_MSG_PRIVFLAGS_NTF``            private flags
+  ``ETHTOOL_MSG_RINGS_GET_REPLY``          ring sizes
+  ``ETHTOOL_MSG_RINGS_NTF``                ring sizes
+  ``ETHTOOL_MSG_CHANNELS_GET_REPLY``       channel counts
+  ``ETHTOOL_MSG_CHANNELS_NTF``             channel counts
+  ``ETHTOOL_MSG_COALESCE_GET_REPLY``       coalescing parameters
+  ``ETHTOOL_MSG_COALESCE_NTF``             coalescing parameters
+  ``ETHTOOL_MSG_PAUSE_GET_REPLY``          pause parameters
+  ``ETHTOOL_MSG_PAUSE_NTF``                pause parameters
+  ``ETHTOOL_MSG_EEE_GET_REPLY``            EEE settings
+  ``ETHTOOL_MSG_EEE_NTF``                  EEE settings
+  ``ETHTOOL_MSG_TSINFO_GET_REPLY``         timestamping info
+  ``ETHTOOL_MSG_CABLE_TEST_NTF``           Cable test results
+  ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``       Cable test TDR results
+  ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY``    tunnel offload info
+  ``ETHTOOL_MSG_FEC_GET_REPLY``            FEC settings
+  ``ETHTOOL_MSG_FEC_NTF``                  FEC settings
+  ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
+  ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
+  ======================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
-- 
2.30.2

