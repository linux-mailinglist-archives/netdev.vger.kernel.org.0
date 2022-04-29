Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F215514D18
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377420AbiD2Ofo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377385AbiD2Ofl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:35:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5047091A
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 283F0B835B0
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E27C385A4;
        Fri, 29 Apr 2022 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651242738;
        bh=R6DaoES02IESG2bQ7Yp5HcgboEUjVtRT3F8eMpF9XBo=;
        h=From:To:Cc:Subject:Date:From;
        b=Oz8JeU2SfU5FdgaGAoTILbKQiA16lzAjxTadqpjGhWR4YdPfAGZThbka/41HEl12s
         q49rGNseQuUyq104iqYn4dc28FMT0tCQxVg5yUVVQEflkqYFXmHBGbsjZC2xthS1oV
         1n8swks2VArabBrEaV5DS1LUzj2FMm0AUeD26VSOXvb6THgixjwJncTyfN120NMth1
         CLTDm7O/Vitxn1lUSXBvOlXeT8jF/9R/cAyZpPwMtESKWMjKSHxsX+7FjCBOfEwju7
         uQBmcoQc0mJL+6E+G8knUTzL9CmDN7YbJ++W9t3yWohsuIxs2UBlTvTFcrccIho3Ih
         DwW5c0t9fTZaQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Cosmetic change spaces to tabs in dsa_switch_ops
Date:   Fri, 29 Apr 2022 16:32:14 +0200
Message-Id: <20220429143214.24031-1-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All but 5 methods in dsa_swith_ops use tabs for indentation.

Change the 5 methods that break this rule.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b8f956eece9c..53fd12e7a21c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6856,11 +6856,11 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_vlan_add		= mv88e6xxx_port_vlan_add,
 	.port_vlan_del		= mv88e6xxx_port_vlan_del,
 	.vlan_msti_set		= mv88e6xxx_vlan_msti_set,
-	.port_fdb_add           = mv88e6xxx_port_fdb_add,
-	.port_fdb_del           = mv88e6xxx_port_fdb_del,
-	.port_fdb_dump          = mv88e6xxx_port_fdb_dump,
-	.port_mdb_add           = mv88e6xxx_port_mdb_add,
-	.port_mdb_del           = mv88e6xxx_port_mdb_del,
+	.port_fdb_add		= mv88e6xxx_port_fdb_add,
+	.port_fdb_del		= mv88e6xxx_port_fdb_del,
+	.port_fdb_dump		= mv88e6xxx_port_fdb_dump,
+	.port_mdb_add		= mv88e6xxx_port_mdb_add,
+	.port_mdb_del		= mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
 	.port_mirror_del	= mv88e6xxx_port_mirror_del,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
-- 
2.35.1

