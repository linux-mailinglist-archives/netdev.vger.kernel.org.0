Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D200857DCCA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbiGVItz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiGVIty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:49:54 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB4E01CB05;
        Fri, 22 Jul 2022 01:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=812F7
        aMPt0o1Pmi3AnCYkux6HBSJ0u2enTRidOLHdWA=; b=bpHYGO8z1F/DloHfkUyTi
        kIyRkzpB5OZg/y7If2X8JTM+Erogcdk5J3lMi7ZMtfmrEmVZdbOOa9VM0jQQHYuQ
        R5tNvJtu96hOFDVFsJwDAbDvXk+/Rye9y8BbPPWAY7TYp6ZU6c5eI3x4zAx7WM0J
        s5+BfKNLAc/Sni4lBr12OY=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp1 (Coremail) with SMTP id GdxpCgAXJKRmZNpisiUjPw--.2467S2;
        Fri, 22 Jul 2022 16:48:40 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] wl1251: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:48:33 +0800
Message-Id: <20220722084833.76159-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAXJKRmZNpisiUjPw--.2467S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWUWr13KF45XFyDtr1fZwb_yoW3Zrb_Gw
        1xKan7G3W8AF1093yYkr95AayIy34UuF1F9F1jqa9agay5ZrW7WF93Zr17J345GFW2gFnx
        X3sxJF1UC345WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRZYFWPUUUUU==
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiGQhGZFyPdmxXywAAsm
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/wireless/ti/wl1251/acx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index 1da6ba95d3d4..1da6ab664e41 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -1229,7 +1229,7 @@ struct wl1251_acx_arp_filter {
 	u8 address[16];	/* The IP address used to filter ARP packets.
 			   ARP packets that do not match this address are
 			   dropped. When the IP Version is 4, the last 12
-			   bytes of the the address are ignored. */
+			   bytes of the address are ignored. */
 } __attribute__((packed));
 
 struct wl1251_acx_ac_cfg {
-- 
2.25.1

