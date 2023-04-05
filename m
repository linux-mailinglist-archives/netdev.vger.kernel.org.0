Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52E76D7719
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbjDEIj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbjDEIjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:39:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB72270C;
        Wed,  5 Apr 2023 01:39:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F46563891;
        Wed,  5 Apr 2023 08:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAA1C4339E;
        Wed,  5 Apr 2023 08:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680683963;
        bh=bPOrTQS7ZIV094UbHruiflRXh5AC0uL/80bRqx6d89c=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=Fya6uRzQGZM2gUC+Gy8Iyh0rpKhFNgXZoqMljg5b23Xrghx5GUr4YtA4tv1Vy5mGt
         BAV7ncAafydtmeIAefWutj++G0LjPeW0J2E5l+KZ5bhGG4oVtKlOXzBk9G4wwOWJmf
         hfOlHCryHsDo2WUnFVsobsvQWs6MN/NihyhkvH7+673+rHso4SHLNaDLrJhMAxZ17v
         EoKeVn+iG/s7DzTvTXXREPPSznNkOliiHVEdrjbl/HLtXuwkY4YJL3GwnQtzdqfS+e
         FtPkVz8yY29Z+YJu+tjA/MeSl2vrHDdZYZS+ua1IWK35kqPbd3nFz4olF+XAoAcHkO
         1CSZ8/jpxdy+g==
From:   Simon Horman <horms@kernel.org>
Date:   Wed, 05 Apr 2023 10:39:16 +0200
Subject: [PATCH net-next 1/3] ksz884x: remove commented-out #defines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-ksz884x-unused-code-v1-1-a3349811d5ef@kernel.org>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
In-Reply-To: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove commented-out #defines from ksz884x driver.
These are self-evidently unused.

These #defines may have some value in documenting the hardware.
But that information may be accessed via scm history.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index f78e8ead8c36..f70895f2174e 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -583,15 +583,6 @@
 #define PORT_REMOTE_10BT_FD		0x0002
 #define PORT_REMOTE_10BT		0x0001
 
-/*
-#define STATIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
-#define STATIC_MAC_TABLE_FWD_PORTS	00-00070000-00000000
-#define STATIC_MAC_TABLE_VALID		00-00080000-00000000
-#define STATIC_MAC_TABLE_OVERRIDE	00-00100000-00000000
-#define STATIC_MAC_TABLE_USE_FID	00-00200000-00000000
-#define STATIC_MAC_TABLE_FID		00-03C00000-00000000
-*/
-
 #define STATIC_MAC_TABLE_ADDR		0x0000FFFF
 #define STATIC_MAC_TABLE_FWD_PORTS	0x00070000
 #define STATIC_MAC_TABLE_VALID		0x00080000
@@ -602,13 +593,6 @@
 #define STATIC_MAC_FWD_PORTS_SHIFT	16
 #define STATIC_MAC_FID_SHIFT		22
 
-/*
-#define VLAN_TABLE_VID			00-00000000-00000FFF
-#define VLAN_TABLE_FID			00-00000000-0000F000
-#define VLAN_TABLE_MEMBERSHIP		00-00000000-00070000
-#define VLAN_TABLE_VALID		00-00000000-00080000
-*/
-
 #define VLAN_TABLE_VID			0x00000FFF
 #define VLAN_TABLE_FID			0x0000F000
 #define VLAN_TABLE_MEMBERSHIP		0x00070000
@@ -617,17 +601,6 @@
 #define VLAN_TABLE_FID_SHIFT		12
 #define VLAN_TABLE_MEMBERSHIP_SHIFT	16
 
-/*
-#define DYNAMIC_MAC_TABLE_ADDR		00-0000FFFF-FFFFFFFF
-#define DYNAMIC_MAC_TABLE_FID		00-000F0000-00000000
-#define DYNAMIC_MAC_TABLE_SRC_PORT	00-00300000-00000000
-#define DYNAMIC_MAC_TABLE_TIMESTAMP	00-00C00000-00000000
-#define DYNAMIC_MAC_TABLE_ENTRIES	03-FF000000-00000000
-#define DYNAMIC_MAC_TABLE_MAC_EMPTY	04-00000000-00000000
-#define DYNAMIC_MAC_TABLE_RESERVED	78-00000000-00000000
-#define DYNAMIC_MAC_TABLE_NOT_READY	80-00000000-00000000
-*/
-
 #define DYNAMIC_MAC_TABLE_ADDR		0x0000FFFF
 #define DYNAMIC_MAC_TABLE_FID		0x000F0000
 #define DYNAMIC_MAC_TABLE_SRC_PORT	0x00300000
@@ -645,12 +618,6 @@
 #define DYNAMIC_MAC_ENTRIES_SHIFT	24
 #define DYNAMIC_MAC_ENTRIES_H_SHIFT	8
 
-/*
-#define MIB_COUNTER_VALUE		00-00000000-3FFFFFFF
-#define MIB_COUNTER_VALID		00-00000000-40000000
-#define MIB_COUNTER_OVERFLOW		00-00000000-80000000
-*/
-
 #define MIB_COUNTER_VALUE		0x3FFFFFFF
 #define MIB_COUNTER_VALID		0x40000000
 #define MIB_COUNTER_OVERFLOW		0x80000000

-- 
2.30.2

