Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6361206EE0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390392AbgFXIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:36 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36439 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390368AbgFXIUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5B14058051F;
        Wed, 24 Jun 2020 04:20:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=hWdsel3yZIDUFzgyiLUxwf+JIu6803X224SK/LKIJII=; b=r4J6eC9M
        KiJ5/cUBQI0CUwDJToe6gwi6HSB9zEuw3pWA2sSbyDioBVcGH2FNXw7hNFKIYbR6
        iqzNJ761QlXXjL8+gDltZZ3WHpX/BvkNrJGUm7DGXVfnzJFL4XcXXiD7051s9agK
        1RKAwrSeoatCNbdSXvflcRNEfEKwCgAiDllrp/7CLkr7UgaN5Me/iP7mnXSUijCq
        LeeeYGEnQxXtnalI7m5GqmcmzMdCnU7avCMGzJtabKpUnaiOxnMcOeAg12rSjHnV
        GUWM/nlyLQp8fpEzaNJsgL0uZiQl31OhFcphkx3FZh+sOtFpVPt1rJJBeCI1DajP
        9NKV7zjOXntr1Q==
X-ME-Sender: <xms:zQzzXoaFi5aCdT2Z67E5UgCD0GjzMVm2OPcK3ZpD5W72kYzj8n73lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:zQzzXjZa3AZY4whGwcI66nkhliR4QOnTYC6mJUsvBAA3g7slGAHIuQ>
    <xmx:zQzzXi9FB9q-wo6qCwi-yWWSIbMZ3CP3pasAvuyhoB1pbeVNmvcbVQ>
    <xmx:zQzzXiobeCtQxWxXaNHkxjyPxc-JIGlhmkWQYj1oJ2hSaRzodZJKSA>
    <xmx:zQzzXnfXXZvIaXQxpI3mGawmtCOBXjR340eq6EAeLVgdK8mHsP4IEw>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A6DB30675F9;
        Wed, 24 Jun 2020 04:20:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/10] Documentation: networking: ethtool-netlink: Add link extended state
Date:   Wed, 24 Jun 2020 11:19:17 +0300
Message-Id: <20200624081923.89483-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add link extended state attributes.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/ethtool-netlink.rst | 110 ++++++++++++++++++-
 1 file changed, 106 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 82470c36c27a..a7cc53f905f5 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -443,10 +443,11 @@ supports.
 LINKSTATE_GET
 =============
 
-Requests link state information. At the moment, only link up/down flag (as
-provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
-extensions are planned (e.g. link down reason). This request does not have any
-attributes.
+Requests link state information. Link up/down flag (as provided by
+``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended state might
+be provided as well. In general, extended state describes reasons for why a port
+is down, or why it operates in some non-obvious mode. This request does not have
+any attributes.
 
 Request contents:
 
@@ -461,16 +462,117 @@ Kernel response contents:
   ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
   ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
   ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
+  ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
+  ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
   ====================================  ======  ============================
 
 For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
 carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
 define their own handler.
 
+``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE`` are
+optional values. ethtool core can provide either both
+``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``,
+or only ``ETHTOOL_A_LINKSTATE_EXT_STATE``, or none of them.
+
 ``LINKSTATE_GET`` allows dump requests (kernel returns reply messages for all
 devices supporting the request).
 
 
+Link extended states:
+
+  ============================    =============================================
+  ``Autoneg``                     States relating to the autonegotiation or
+                                  issues therein
+
+  ``Link training failure``       Failure during link training
+
+  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
+                                  or forward error correction sublayer
+
+  ``Bad signal integrity``        Signal integrity issues
+
+  ``No cable``                    No cable connected
+
+  ``Cable issue``                 Failure is related to cable,
+                                  e.g., unsupported cable
+
+  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
+                                  during reading or parsing the data
+
+  ``Calibration failure``         Failure during calibration algorithm
+
+  ``Power budget exceeded``       The hardware is not able to provide the
+                                  power required from cable or module
+
+  ``Overheat``                    The module is overheated
+  ============================    =============================================
+
+Link extended substates:
+
+  Autoneg substates:
+
+  ==============================================    =============================================
+  ``No partner detected``                           Peer side is down
+
+  ``Ack not received``                              Ack not received from peer side
+
+  ``Next page exchange failed``                     Next page exchange failed
+
+  ``No partner detected during force mode``         Peer side is down during force mode or there
+                                                    is no agreement of speed
+
+  ``FEC mismatch during override``                  Forward error correction modes in both sides
+                                                    are mismatched
+
+  ``No HCD``                                        No Highest Common Denominator
+  ==============================================    =============================================
+
+  Link training substates:
+
+  ==============================================    =============================================
+  ``KR frame lock not acquired``                    Frames were not recognized, the lock failed
+
+  ``KR link inhibit timeout``                       The lock did not occur before timeout
+
+  ``KR Link partner did not set receiver ready``    Peer side did not send ready signal after
+                                                    training process
+
+  ``Remote side is not ready yet``                  Remote side is not ready yet
+
+  ==============================================    =============================================
+
+  Link logical mismatch substates:
+
+  ==============================================    =============================================
+  ``PCS did not acquire block lock``                Physical coding sublayer was not locked in
+                                                    first phase - block lock
+
+  ``PCS did not acquire AM lock``                   Physical coding sublayer was not locked in
+                                                    second phase - alignment markers lock
+
+  ``PCS did not get align_status``                  Physical coding sublayer did not get align
+                                                    status
+
+  ``FC FEC is not locked``                          FC forward error correction is not locked
+
+  ``RS FEC is not locked``                          RS forward error correction is not locked
+  ==============================================    =============================================
+
+  Bad signal integrity substates:
+
+  ==============================================    =============================================
+  ``Large number of physical errors``               Large number of physical errors
+
+  ``Unsupported rate``                              The system attempted to operate the cable at
+                                                    a rate that is not formally supported, which
+                                                    led to signal integrity issues
+
+  ``Unsupported cable``                             Unsupported cable
+
+  ``Cable test failure``                            Cable test failure
+  ==============================================    =============================================
+
 DEBUG_GET
 =========
 
-- 
2.26.2

