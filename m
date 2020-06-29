Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AF120E098
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgF2Uro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:44 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42935 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389796AbgF2Urb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0172E5801D1;
        Mon, 29 Jun 2020 16:47:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5U46paOYMng8q1RVciUGJMP4vtqUB2iki1j6JnaFSMY=; b=pCVTT6SO
        +IioJ6t4h2+XudvVSjvC9Q59dJEXw18dEphSYaK8H9d8IC8TWvjSrRxg3h0H872u
        gSg5O3l/iSwrWXiDrU+dQz5O9xsk0R3dC91Bia78dN1svFYUo1th4dpOw4PuseCm
        Di013r5I/a+s4c0ZJk4oMx+/6ypyTEY0DfRB9uBy2IcbYenGjTuFZ6aH1cBCUrc8
        51ORin6ic0Xzc1WhL1R1ZFJFOParQU6yAjCG5dJK7X8rpaGl01b/0A7/7HOeVfM7
        Gmb81xWB1BVb6HXSnh3s1DbWsbqE5O5F+IcDCu4MsDsDXAxG5jQ+0VWQlDQKDyCj
        efc799jn2n/Y/Q==
X-ME-Sender: <xms:YVP6Xrx5zuscnMRlH_mI1NrA3VxSASRziByvV8hvEvbyMEP4oiwbog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:YVP6XjTZjnGiCWYVuiEDBCbUSjQTh_U5i5UQGWHYXW2K9ldvOiDi8g>
    <xmx:YVP6XlWLR_zRqAAzWTjWjH_VBWG8LHmnHSRV5ObU5xkeesCjrz5nKw>
    <xmx:YVP6Xlgd5B5WNk39JLShCmfXFdO_42Qv_ncVoTNKPAAxzQAeXxJ3qg>
    <xmx:YVP6Xh3zc9evOxgcDgdN-KZJVWEaYblNVnHJjhkL5qX7TNcG5zuFfw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3EFCD328005A;
        Mon, 29 Jun 2020 16:47:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 04/10] Documentation: networking: ethtool-netlink: Add link extended state
Date:   Mon, 29 Jun 2020 23:46:15 +0300
Message-Id: <20200629204621.377239-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add link extended state attributes.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 Documentation/networking/ethtool-netlink.rst | 128 ++++++++++++++++++-
 1 file changed, 124 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 82470c36c27a..396390f4936b 100644
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
 
@@ -461,16 +462,135 @@ Kernel response contents:
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
+  ================================================      ============================================
+  ``ETHTOOL_LINK_EXT_STATE_AUTONEG``                    States relating to the autonegotiation or
+                                                        issues therein
+
+  ``ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE``      Failure during link training
+
+  ``ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH``      Logical mismatch in physical coding sublayer
+                                                        or forward error correction sublayer
+
+  ``ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY``       Signal integrity issues
+
+  ``ETHTOOL_LINK_EXT_STATE_NO_CABLE``                   No cable connected
+
+  ``ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE``                Failure is related to cable,
+                                                        e.g., unsupported cable
+
+  ``ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE``               Failure is related to EEPROM, e.g., failure
+                                                        during reading or parsing the data
+
+  ``ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE``        Failure during calibration algorithm
+
+  ``ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED``      The hardware is not able to provide the
+                                                        power required from cable or module
+
+  ``ETHTOOL_LINK_EXT_STATE_OVERHEAT``                   The module is overheated
+  =================================================     ============================================
+
+Link extended substates:
+
+  Autoneg substates:
+
+  ==============================================================    ================================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED``              Peer side is down
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED``                 Ack not received from peer side
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED``        Next page exchange failed
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE``   Peer side is down during force
+                                                                    mode or there is no agreement of
+                                                                    speed
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE``     Forward error correction modes
+                                                                    in both sides are mismatched
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD``                           No Highest Common Denominator
+  ==============================================================    ================================
+
+  Link training substates:
+
+  ==========================================================================    ====================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED``                    Frames were not
+                                                                                 recognized, the
+                                                                                 lock failed
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT``                       The lock did not
+                                                                                 occur before
+                                                                                 timeout
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY``    Peer side did not
+                                                                                 send ready signal
+                                                                                 after training
+                                                                                 process
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT``                                  Remote side is not
+                                                                                 ready yet
+  ==========================================================================    ====================
+
+  Link logical mismatch substates:
+
+  ===============================================================    ===============================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK``   Physical coding sublayer was
+                                                                     not locked in first phase -
+                                                                     block lock
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK``      Physical coding sublayer was
+                                                                     not locked in second phase -
+                                                                     alignment markers lock
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS``     Physical coding sublayer did
+                                                                     not get align status
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED``             FC forward error correction is
+                                                                     not locked
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED``             RS forward error correction is
+                                                                     not locked
+  ===============================================================    ===============================
+
+  Bad signal integrity substates:
+
+  =================================================================    =============================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS``    Large number of physical
+                                                                       errors
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE``                   The system attempted to
+                                                                       operate the cable at a rate
+                                                                       that is not formally
+                                                                       supported, which led to
+                                                                       signal integrity issues
+  =================================================================    =============================
+
+  Cable issue substates:
+
+  ==================================================    ============================================
+  ``ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE``    Unsupported cable
+
+  ``ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE``   Cable test failure
+  ==================================================    ============================================
+
 DEBUG_GET
 =========
 
-- 
2.26.2

