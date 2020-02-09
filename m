Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7049156BCF
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 18:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBIRYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 12:24:43 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:44675 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727397AbgBIRYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 12:24:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 941B9180A68BF;
        Sun,  9 Feb 2020 17:24:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:69:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3870:3872:3873:4321:5007:7514:7875:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12295:12297:12555:12663:12740:12760:12895:13071:13161:13229:13439:14096:14097:14180:14181:14659:14721:21080:21451:21611:21627:21740:30012:30054:30062:30070:30083:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: hook20_bb392dfc3436
X-Filterd-Recvd-Size: 3915
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sun,  9 Feb 2020 17:24:40 +0000 (UTC)
Message-ID: <80495d71d156ed8bb44da5b46eac458b497af691.camel@perches.com>
Subject: Re: [PATCH v2] staging: qlge: remove spaces at the start of a line
From:   Joe Perches <joe@perches.com>
To:     Mohana Datta Yelugoti <ymdatta.work@gmail.com>,
        gregkh@linuxfoundation.org
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 09 Feb 2020 09:23:26 -0800
In-Reply-To: <20200209171431.19907-1-ymdatta.work@gmail.com>
References: <ymdatta.work@gmail.com>
         <20200209171431.19907-1-ymdatta.work@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-02-09 at 22:44 +0530, Mohana Datta Yelugoti wrote:
> This patch fixes "WARNING: please, no spaces at the start of a
> line" by checkpatch.pl by replacing spaces with the tab.

> Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
> ---

Hello Mohana.

What changed in the v2?

When you send a new revision of a patch, it's good form to describe
the differences between the patches below the --- line

So here you should write something like

V2: Improved patch description

Also, the form of the code could be rewritten using //
comments while aligning all the options, even those
commented out currently with /* ... */

Something like:

 drivers/staging/qlge/qlge_main.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index ef8037..f25cd2 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -52,16 +52,22 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg =
-    NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
-/* NETIF_MSG_TIMER |	*/
-    NETIF_MSG_IFDOWN |
-    NETIF_MSG_IFUP |
-    NETIF_MSG_RX_ERR |
-    NETIF_MSG_TX_ERR |
-/*  NETIF_MSG_TX_QUEUED | */
-/*  NETIF_MSG_INTR | NETIF_MSG_TX_DONE | NETIF_MSG_RX_STATUS | */
-/* NETIF_MSG_PKTDATA | */
-    NETIF_MSG_HW | NETIF_MSG_WOL | 0;
+	NETIF_MSG_DRV |
+	NETIF_MSG_PROBE |
+	NETIF_MSG_LINK |
+//	NETIF_MSG_TIMER |
+	NETIF_MSG_IFDOWN |
+	NETIF_MSG_IFUP |
+	NETIF_MSG_RX_ERR |
+	NETIF_MSG_TX_ERR |
+//	NETIF_MSG_TX_QUEUED |
+//	NETIF_MSG_INTR |
+//	NETIF_MSG_TX_DONE |
+//	NETIF_MSG_RX_STATUS |
+//	NETIF_MSG_PKTDATA |
+	NETIF_MSG_HW |
+	NETIF_MSG_WOL |
+	0;
 
 static int debug = -1;	/* defaults above */
 module_param(debug, int, 0664);

>  drivers/staging/qlge/qlge_main.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index ef8037d0b52e..86b9b7314a40 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -52,16 +52,16 @@ MODULE_LICENSE("GPL");
>  MODULE_VERSION(DRV_VERSION);
>  
>  static const u32 default_msg =
> -    NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
> +	NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
>  /* NETIF_MSG_TIMER |	*/
> -    NETIF_MSG_IFDOWN |
> -    NETIF_MSG_IFUP |
> -    NETIF_MSG_RX_ERR |
> -    NETIF_MSG_TX_ERR |
> +	NETIF_MSG_IFDOWN |
> +	NETIF_MSG_IFUP |
> +	NETIF_MSG_RX_ERR |
> +	NETIF_MSG_TX_ERR |
>  /*  NETIF_MSG_TX_QUEUED | */
>  /*  NETIF_MSG_INTR | NETIF_MSG_TX_DONE | NETIF_MSG_RX_STATUS | */
>  /* NETIF_MSG_PKTDATA | */
> -    NETIF_MSG_HW | NETIF_MSG_WOL | 0;
> +	NETIF_MSG_HW | NETIF_MSG_WOL | 0;


>  
>  static int debug = -1;	/* defaults above */
>  module_param(debug, int, 0664);

