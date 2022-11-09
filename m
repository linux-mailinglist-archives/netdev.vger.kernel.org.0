Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F472622499
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 08:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKIH0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 02:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKIH0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 02:26:51 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E949412623;
        Tue,  8 Nov 2022 23:26:48 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667978806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=so39T/JF3Cpud2fMZPx6gtQDGCKs0N1MqLRhsfqJZgY=;
        b=IvFMVOEfiV95S2OnvdmYNfOzrNpTw32/Zshjt2WgK7IC9auGtB5cYegGHM1f+n6cpzzVIe
        QWDDj+yh6IPjs2dMoh59m+ePpQFFxGzWVXI+CkZBfNdxcDqgoDGAviCy4Lq6rUN+Fb0cLg
        GL7YrsBIKSpnDgyyoVNitNWm7yH05B8=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     netdev@vger.kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] MAINTAINERS: Update hinic maintainers from orphan
Date:   Wed,  9 Nov 2022 15:26:41 +0800
Message-Id: <20221109072641.27051-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HINIC is marked orphan for 14 months from the commit "5cfe5109a1d7",
but there are lots of HINIC in use.

I have a SP582 NIC (hi1822 inside which is a kind of HINIC SOC),
and implement based on hinic driver, and if there are some patches
for HINIC, I can test and do some code review.

I'm active in linux contribution, if possible,
I want to take the hinic maintainership.

Add my email here to receive patches.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95fc5e1b4548..2b4eacf1fa70 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9438,8 +9438,9 @@ F:	Documentation/devicetree/bindings/iio/humidity/st,hts221.yaml
 F:	drivers/iio/humidity/hts221*
 
 HUAWEI ETHERNET DRIVER
+M:	Cai Huoqing <cai.huoqing@linux.dev>
 L:	netdev@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
 F:	drivers/net/ethernet/huawei/hinic/
 
-- 
2.25.1

