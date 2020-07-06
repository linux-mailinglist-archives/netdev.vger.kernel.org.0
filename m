Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60093215138
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 04:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgGFC4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 22:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgGFC4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 22:56:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF1C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 19:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=zB+iDMbYROXi/HincljxaPI4dsp4ivy+5va/6El7q0A=; b=lr5/LYeelUCTqTGhkEODUTrE1Y
        T/kaSauYY8sv2J1P268yt24McD6KV+cvZVJuEWmpciFtutkJMt6uks6YWX3RsjTV3EiNj2b3+a4LP
        UyCs/NUsBQhUJm19Os3SWAXQRt7XuK3ZHzOLQoLLHzxKlwxeNBVLHJSSXlmk2rV8solYQ3dwrg2Xt
        /AXBrYkOog2ZOZSnrmjKGLZoi4Vte9bbS7jy36XeNz7G0YRyvWQyLZVXcGDkyxHmbIe5MMLxZXJSN
        /WCVT/GiQ2XEL8j24aBgqk7m0rb7jOOhI+1MVhVBF5kM1vd0AphwEZ0hrcofTe6GQn/iWsGsQELHh
        K5Zy1KSA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jsHIJ-0002Dm-Ok; Mon, 06 Jul 2020 02:55:54 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -next] Documentation: networking: fix ethtool-netlink table
 formats
Message-ID: <10c2e583-af4a-7f06-b3d0-79fbec0ebfd6@infradead.org>
Date:   Sun, 5 Jul 2020 19:55:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix table formatting to eliminate warnings.

Documentation/networking/ethtool-netlink.rst:509: WARNING: Malformed table.
Documentation/networking/ethtool-netlink.rst:522: WARNING: Malformed table.
Documentation/networking/ethtool-netlink.rst:543: WARNING: Malformed table.
Documentation/networking/ethtool-netlink.rst:555: WARNING: Malformed table.
Documentation/networking/ethtool-netlink.rst:591: WARNING: Malformed table.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/networking/ethtool-netlink.rst |   18 ++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-next-20200703.orig/Documentation/networking/ethtool-netlink.rst
+++ linux-next-20200703/Documentation/networking/ethtool-netlink.rst
@@ -506,13 +506,13 @@ Link extended states:
                                                         power required from cable or module
 
   ``ETHTOOL_LINK_EXT_STATE_OVERHEAT``                   The module is overheated
-  =================================================     ============================================
+  ================================================      ============================================
 
 Link extended substates:
 
   Autoneg substates:
 
-  ==============================================================    ================================
+  ===============================================================   ================================
   ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED``              Peer side is down
 
   ``ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED``                 Ack not received from peer side
@@ -527,11 +527,11 @@ Link extended substates:
                                                                     in both sides are mismatched
 
   ``ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD``                           No Highest Common Denominator
-  ==============================================================    ================================
+  ===============================================================   ================================
 
   Link training substates:
 
-  ==========================================================================    ====================
+  ===========================================================================   ====================
   ``ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED``                    Frames were not
                                                                                  recognized, the
                                                                                  lock failed
@@ -547,11 +547,11 @@ Link extended substates:
 
   ``ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT``                                  Remote side is not
                                                                                  ready yet
-  ==========================================================================    ====================
+  ===========================================================================   ====================
 
   Link logical mismatch substates:
 
-  ===============================================================    ===============================
+  ================================================================   ===============================
   ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK``   Physical coding sublayer was
                                                                      not locked in first phase -
                                                                      block lock
@@ -568,7 +568,7 @@ Link extended substates:
 
   ``ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED``             RS forward error correction is
                                                                      not locked
-  ===============================================================    ===============================
+  ================================================================   ===============================
 
   Bad signal integrity substates:
 
@@ -585,11 +585,11 @@ Link extended substates:
 
   Cable issue substates:
 
-  ==================================================    ============================================
+  ===================================================   ============================================
   ``ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE``    Unsupported cable
 
   ``ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE``   Cable test failure
-  ==================================================    ============================================
+  ===================================================   ============================================
 
 DEBUG_GET
 =========


