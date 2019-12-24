Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7156712A135
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 13:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLXMMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 07:12:42 -0500
Received: from m12-17.163.com ([220.181.12.17]:36930 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfLXMMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 07:12:41 -0500
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Dec 2019 07:12:39 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=2PfFdn+GcUUgz9kOGP
        vjod/qqNrrabIvrEJCD+uVTXM=; b=GGe5+9Dq18bbXMxDrS1I0EXYN00rVR5tkY
        /ndRddEm30EXVr701RuxrHti/dJBFTWsSGqPH5w1X/NkYeKXRAy2/+1EUu/QVHpc
        o/WKkDeJgOCqsSnw+fAmXCzDOWPukCwi78Ls78A3R4pu2aCKR1Awq3TSpkE4R9rZ
        KM5Dywo/s=
Received: from localhost (unknown [106.37.187.139])
        by smtp13 (Coremail) with SMTP id EcCowACXtPj2_AFecBFYag--.27430S3;
        Tue, 24 Dec 2019 19:56:38 +0800 (CST)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: xt_LOG: remove unused headers
Date:   Tue, 24 Dec 2019 19:56:37 +0800
Message-Id: <00755cb479aeafbc88c4f8b92e99ca9ada4b9af0.1577188409.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EcCowACXtPj2_AFecBFYag--.27430S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKryDGw1kKr4xZr4xGFyUWrg_yoW3Wwb_Ca
        s29r48G3WDXr17Aw1xJFs7A345K34xJFn3WrySva15ta1DJw40g397Xr1Yvr45Wwn8CryU
        Z3WkG34xW345WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8SeHDUUUUU==
X-Originating-IP: [106.37.187.139]
X-CM-SenderInfo: 5jhoxtpqjwt0rj6rljoofrz/1tbiGRaVmVyPWWvBWgAAs5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some headers are not used so remove them.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/netfilter/xt_LOG.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index a1e79b517c01..f5086a6b700a 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -9,15 +9,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
-#include <linux/spinlock.h>
 #include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/ip.h>
-#include <net/ipv6.h>
-#include <net/icmp.h>
-#include <net/udp.h>
-#include <net/tcp.h>
-#include <net/route.h>
 
 #include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
-- 
2.17.1


