Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA856A738B
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjCASg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjCASgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:36:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E809A47402;
        Wed,  1 Mar 2023 10:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A56D9B8110A;
        Wed,  1 Mar 2023 18:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123C7C433A7;
        Wed,  1 Mar 2023 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677695808;
        bh=1PTbEGcPaUc/kPHFJ2lFOtZgCtP4SxJi0Ga247F3+QI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNzFLQusSYUt4ScKa51nAS3gNDneFjt9EfhnGqaPGbOWeeeCKaFbZL9enIGrH6Ctq
         U8bAcmr7dZLUNeIr7OFyzG+IMMKOHEQ5J/pZs5L5LWFbkL4GF4dbsGw/8dW/H4aBTU
         nV3kTtRw37ig79ynzSxJALmsMO4TvoYgfnLjeZyBVGyju3ghB/n5CmxA5WH20a71Sv
         dlNuQD1iGp2UoxVbjsjidkbf8gh5ZCmVXCpkqaswEtNysbf3QTDBqLpcyyf//4Oxcq
         CrEJrnIN5VRFp1DgEraf4e/PM6sQtu+ATRsiCq128sAncGKpj61+YmdZP/iJqQV9sr
         Y4rN44QSJ4xLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] netlink: specs: update for codegen enumerating from 1
Date:   Wed,  1 Mar 2023 10:36:42 -0800
Message-Id: <20230301183642.2168393-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301183642.2168393-1-kuba@kernel.org>
References: <20230301183642.2168393-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the codegen rules had been changed we can update
the specs to reflect the new default.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/specs/ethtool.yaml | 15 ---------------
 Documentation/netlink/specs/fou.yaml     |  2 ++
 Documentation/netlink/specs/netdev.yaml  |  2 --
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
index 08b776908d15..35c462bce56f 100644
--- a/Documentation/netlink/specs/ethtool.yaml
+++ b/Documentation/netlink/specs/ethtool.yaml
@@ -11,7 +11,6 @@ doc: Partial family for Ethtool Netlink.
       -
         name: dev-index
         type: u32
-        value: 1
       -
         name: dev-name
         type: string
@@ -25,7 +24,6 @@ doc: Partial family for Ethtool Netlink.
       -
         name: index
         type: u32
-        value: 1
       -
         name: name
         type: string
@@ -39,14 +37,12 @@ doc: Partial family for Ethtool Netlink.
         name: bit
         type: nest
         nested-attributes: bitset-bit
-        value: 1
   -
     name: bitset
     attributes:
       -
         name: nomask
         type: flag
-        value: 1
       -
         name: size
         type: u32
@@ -61,7 +57,6 @@ doc: Partial family for Ethtool Netlink.
       -
         name: index
         type: u32
-        value: 1
       -
         name: value
         type: string
@@ -71,7 +66,6 @@ doc: Partial family for Ethtool Netlink.
       -
         name: string
         type: nest
-        value: 1
         multi-attr: true
         nested-attributes: string
   -
@@ -80,7 +74,6 @@ doc: Partial family for Ethtool Netlink.
       -
         name: id
         type: u32
-        value: 1
       -
         name: count
         type: u32
@@ -96,14 +89,12 @@ doc: Partial family for Ethtool Netlink.
         name: stringset
         type: nest
         multi-attr: true
-        value: 1
         nested-attributes: stringset
   -
     name: strset
     attributes:
       -
         name: header
-        value: 1
         type: nest
         nested-attributes: header
       -
@@ -119,7 +110,6 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: header
-        value: 1
         type: nest
         nested-attributes: header
       -
@@ -132,7 +122,6 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: header
-        value: 1
         type: nest
         nested-attributes: header
       -
@@ -180,7 +169,6 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: pad
-        value: 1
         type: pad
       -
         name: reassembly-errors
@@ -205,7 +193,6 @@ doc: Partial family for Ethtool Netlink.
     attributes:
       -
         name: header
-        value: 1
         type: nest
         nested-attributes: header
       -
@@ -251,13 +238,11 @@ doc: Partial family for Ethtool Netlink.
 
       do: &strset-get-op
         request:
-          value: 1
           attributes:
             - header
             - stringsets
             - counts-only
         reply:
-          value: 1
           attributes:
             - header
             - stringsets
diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index 266c386eedf3..cca4cf98f03a 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -26,6 +26,7 @@ kernel-policy: global
       -
         name: unspec
         type: unused
+        value: 0
       -
         name: port
         type: u16
@@ -71,6 +72,7 @@ kernel-policy: global
     -
       name: unspec
       doc: unused
+      value: 0
 
     -
       name: add
diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index cffef09729f1..ba9ee13cf729 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -48,7 +48,6 @@ name: netdev
         name: ifindex
         doc: netdev ifindex
         type: u32
-        value: 1
         checks:
           min: 1
       -
@@ -66,7 +65,6 @@ name: netdev
     -
       name: dev-get
       doc: Get / dump information about a netdev.
-      value: 1
       attribute-set: dev
       do:
         request:
-- 
2.39.2

