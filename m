Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189BD233799
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgG3RWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:22:48 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:33894 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726353AbgG3RWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:22:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B23D8181D3028;
        Thu, 30 Jul 2020 17:22:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2731:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:4250:4321:5007:7576:9040:9592:10004:10400:10848:10967:11026:11232:11473:11657:11658:11914:12043:12296:12297:12555:12740:12760:12895:13439:14181:14659:14721:21080:21433:21451:21627:21990:30003:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: stick28_060683326f7c
X-Filterd-Recvd-Size: 3622
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Thu, 30 Jul 2020 17:22:45 +0000 (UTC)
Message-ID: <481224416317f5d690e7e28cd32b77bf06cdcec9.camel@perches.com>
Subject: Re: [PATCH v1] qede: Use %pM format specifier for MAC addresses
From:   Joe Perches <joe@perches.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Thu, 30 Jul 2020 10:22:43 -0700
In-Reply-To: <pXdhhJtDMa8Tr3tB0ugk5KdQcS3D71r1PEgqtPcJ3kBa4P_Yc0xG6HSXW9O1bQB_1FyD4wvS0xiXLiqvUb3OVzDKR9e7lLijB7jf6ZoHfaw=@pm.me>
References: <pXdhhJtDMa8Tr3tB0ugk5KdQcS3D71r1PEgqtPcJ3kBa4P_Yc0xG6HSXW9O1bQB_1FyD4wvS0xiXLiqvUb3OVzDKR9e7lLijB7jf6ZoHfaw=@pm.me>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-30 at 16:29 +0000, Alexander Lobakin wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Thu, 30 Jul 2020 19:00:57 +0300
> 
> > Convert to %pM instead of using custom code.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Thanks!
> 
> Acked-by: Alexander Lobakin <alobakin@pm.me>
> 
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 1aaae3203f5a..4250c17940c0 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -144,9 +144,7 @@ static int qede_set_vf_mac(struct net_device *ndev, int vfidx, u8 *mac)
> >  {
> >  	struct qede_dev *edev = netdev_priv(ndev);
> >  
> > -	DP_VERBOSE(edev, QED_MSG_IOV,
> > -		   "Setting MAC %02x:%02x:%02x:%02x:%02x:%02x to VF [%d]\n",
> > -		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], vfidx);
> > +	DP_VERBOSE(edev, QED_MSG_IOV, "Setting MAC %pM to VF [%d]\n", mac, vfidx);
> >  
> >  	if (!is_valid_ether_addr(mac)) {
> >  		DP_VERBOSE(edev, QED_MSG_IOV, "MAC address isn't valid\n");
> > -- 
> > 2.27.0

I would have expected the debugging output to be in the
opposite order with the valid address test first.

Something like:
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 1aaae3203f5a..30bf9aebd5b8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -144,15 +144,15 @@ static int qede_set_vf_mac(struct net_device *ndev, int vfidx, u8 *mac)
 {
 	struct qede_dev *edev = netdev_priv(ndev);
 
-	DP_VERBOSE(edev, QED_MSG_IOV,
-		   "Setting MAC %02x:%02x:%02x:%02x:%02x:%02x to VF [%d]\n",
-		   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5], vfidx);
-
 	if (!is_valid_ether_addr(mac)) {
-		DP_VERBOSE(edev, QED_MSG_IOV, "MAC address isn't valid\n");
+		DP_VERBOSE(edev, QED_MSG_IOV,
+			   "Invalid MAC address %pM for VF [%d]\n", mac, vfidx);
 		return -EINVAL;
 	}
 
+	DP_VERBOSE(edev, QED_MSG_IOV, "Setting MAC %pM to VF [%d]\n",
+		   mac, vfidx);
+
 	return edev->ops->iov->set_mac(edev->cdev, mac, vfidx);
 }
 


