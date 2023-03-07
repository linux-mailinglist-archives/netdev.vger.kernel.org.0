Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2201B6AEFC7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjCGS0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjCGSYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FEFA17CE;
        Tue,  7 Mar 2023 10:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C637BB819C8;
        Tue,  7 Mar 2023 18:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBE9C4339B;
        Tue,  7 Mar 2023 18:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678213211;
        bh=0ernidC3WHANesMpJRzZFG2rHwt5UJnwsTY6wU8GmKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKh3ilgEITf4V+9GPFzQj6/xSj6dY9x1MvbUYNhnBVd0A9JY2ZisIIJSvGxAUGr+H
         duzfDn1CuzTKFZdAtBX1QIQWUWdv9ql0vqeY1eFFTdN8Fo0Xz8mfgW1FLbgk8bAeNj
         46ISxexD/Gr0l0RQNr0yv1wgc49iajLCDYDOYJHWfO7t+Y/ebj8EnJmXjFUH8ZI6Vv
         UJ/pb5NIzRG/LT3P7GwAwoM09ehRQQgap4cHFrEZMXmbnYI5kXzynp+OV3+1Fu84ww
         LvFouxSEAofZj16nsx/+irNXDEtZOGiwEADrli5MLVH4qnQHuQT3X4kbrRmi/5roR4
         +x8zQB2X2+fhw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH 08/28] net: hns3: remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 12:19:19 -0600
Message-Id: <20230307181940.868828-9-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
References: <20230307181940.868828-1-helgaas@kernel.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

<linux/aer.h> is unused, so remove it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 25be7f8ac7cd..5caea154362f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -13,7 +13,6 @@
 #include <linux/ipv6.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/aer.h>
 #include <linux/skbuff.h>
 #include <linux/sctp.h>
 #include <net/gre.h>
-- 
2.25.1

