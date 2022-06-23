Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1A8557AB1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiFWMvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiFWMvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:51:09 -0400
X-Greylist: delayed 248 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 05:51:03 PDT
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C645AF7;
        Thu, 23 Jun 2022 05:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1655988661;
        bh=WkPDR7AEUWbovUynFMyUZJb/WXXDveepQJRcNB/88sY=;
        h=Date:From:To:Cc:Subject;
        b=eThYzUm9Qka+IrJHeUkUmW1NCcRfGySimih5DaiBE6qcjMX4/P6POR84Ur8Met9Ao
         zU7IWvVj5Bsp3t+a+zBO5oyy+brRI+06ixl5zKsgf1OxDWqG8KsIGR3gsUfoSPXRXU
         /V5gpispz8eQWo6gLRdnCIHAzRmmp0CSwGf2jOcw=
Received: from wh-VirtualBox ([117.175.169.40])
        by newxmesmtplogicsvrsza5.qq.com (NewEsmtp) with SMTP
        id ADB3EAE6; Thu, 23 Jun 2022 20:43:27 +0800
X-QQ-mid: xmsmtpt1655988207t5r5adzos
Message-ID: <tencent_DDE91CB7412D427A442DB4362364DC04F20A@qq.com>
X-QQ-XMAILINFO: MyIXMys/8kCtHWBqatw/wyopKz5hTtXjGRfWMXKeAhHky4aLsr5FnFxJYfiVJ2
         vmh+GYDNRyVjufcT9KR9j6lnRTiskEtKQaB2ikpUNwauGhDyExgknndJG05BIU7GBebRSoRte9N3
         5GJnUfUkfc8NZkMDsa/6Nd8WihoYjDnalEPRaX4rNog/40w8GP++3OKCjF3IQ72ZhwVrHByJhEIH
         w5eYHN2PzNK77nARXeIZqc+aokil7yjSIBZTYxuBJ9aKyjAAMjEaWJedjDCabWV6T9GUaoMqSJqs
         rgkAUEptV1AP0h4ALDyQlnAcWosKMFAaqfLhNc4kzyTGEafvI01KETTn64tY6yDZbUlvFLUC63Lc
         UFoJOsEIPwhkLWuoipKF1W7cukiGW0II2NjQCouja0sFmBux7GhH3kC/CUmD/BnS0Fti9deyw/wY
         DBLVUCyDbNRdEFVZqcwh5eKsbp9lrLJhRicnOUllA55m2qYVW0DY9aJlHcDSruOYP9RMHLhfmMb/
         dCp17iv5TQvvEVnRN1Tl//HQqd1THamtgQ4QGAZ7NEy4Ydc+SXdmS8q7smuRj/xqmP7GOJXCDEea
         Vqd9urW6/Y+7Alp3hksq02HMTipPx14CodJgQ8jWECRsqm1IHAERbD7Pf27IhhYQXu6cFd1mYZut
         x3PfHN6S1XjI6x+GENZ4ZH6dMprzF5pdKAUZsVz8Jd985z6XJOY6Y2iWNaWIRVHNXLYrh9IK23ik
         EVG1Of+9Oc78CaopaW+IDfp+PCyUHdYNiHWi7Vw6TEqWjvUYyMxr50oWfTbFLb66/RBdvYXXgfgl
         /9+onMOLnGbGo/9JMTTGOQ9OCtocKCUphbdOJNznGEifvgKbruQaPIijS5nJldq8/MvgbNAHiJXn
         fm1Vt8FpGxgR+TpubTkULtZYxhaw10cXSLtnRuYTCkyUp6z3OlAAUh5Ueo5Qlq8slP8kiNxTwXXj
         nmnIedB/spF8mABF7g82q5kDBr6G8mAhvHuJoXe5NZRe/1lyt+6wSIvxUzyGq7
Date:   Thu, 23 Jun 2022 20:42:48 +0800
From:   Wei Han <lailitty@foxmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lailitty@foxmail.com, linux-staging@lists.linux.dev
Subject: [PATCH] netfilter: xt_esp: add support for ESP match in NAT Traversal
X-OQ-MSGID: <20220623124248.GA10755@wh-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when the ESP packets traversing Network Address Translators,
which are encapsulated and decapsulated inside UDP packets,
so we need to get ESP data in UDP.

Signed-off-by: Wei Han <lailitty@foxmail.com>
---
 net/netfilter/xt_esp.c | 54 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 2a1c0ad0ff07..c3feb79a830a 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -8,12 +8,14 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 
 #include <linux/netfilter/xt_esp.h>
 #include <linux/netfilter/x_tables.h>
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <net/ip.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
@@ -39,17 +41,53 @@ static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct ip_esp_hdr _esp;
 	const struct xt_esp *espinfo = par->matchinfo;
 
+	const struct iphdr *iph = NULL;
+	const struct ipv6hdr *ip6h = NULL;
+	const struct udphdr *udph = NULL;
+	struct udphdr _udph;
+	int proto = -1;
+
 	/* Must not be a fragment. */
 	if (par->fragoff != 0)
 		return false;
 
-	eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
-	if (eh == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		pr_debug("Dropping evil ESP tinygram.\n");
-		par->hotdrop = true;
+	if (xt_family(par) == NFPROTO_IPV6) {
+		ip6h = ipv6_hdr(skb);
+		if (!ip6h)
+			return false;
+		proto = ip6h->nexthdr;
+	} else {
+		iph = ip_hdr(skb);
+		if (!iph)
+			return false;
+		proto = iph->protocol;
+	}
+
+	if (proto == IPPROTO_UDP) {
+		//for NAT-T
+		udph = skb_header_pointer(skb, par->thoff, sizeof(_udph), &_udph);
+		if (udph && (udph->source == htons(4500) || udph->dest == htons(4500))) {
+			/* Not deal with above data it don't conflict with SPI
+			 * 1.IKE Header Format for Port 4500(Non-ESP Marker 0x00000000)
+			 * 2.NAT-Keepalive Packet Format(0xFF)
+			 */
+			eh = (struct ip_esp_hdr *)((char *)udph + sizeof(struct udphdr));
+		} else {
+			return false;
+		}
+	} else if (proto == IPPROTO_ESP) {
+		//not NAT-T
+		eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
+		if (!eh) {
+			/* We've been asked to examine this packet, and we
+			 * can't.  Hence, no choice but to drop.
+			 */
+			pr_debug("Dropping evil ESP tinygram.\n");
+			par->hotdrop = true;
+			return false;
+		}
+	} else {
+		//not esp data
 		return false;
 	}
 
@@ -76,7 +114,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
-		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
 	},
 	{
@@ -85,7 +122,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
 		.checkentry	= esp_mt_check,
 		.match		= esp_mt,
 		.matchsize	= sizeof(struct xt_esp),
-		.proto		= IPPROTO_ESP,
 		.me		= THIS_MODULE,
 	},
 };
-- 
2.17.1

