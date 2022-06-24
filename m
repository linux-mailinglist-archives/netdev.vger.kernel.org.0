Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2AA559928
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 14:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiFXMGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 08:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiFXMGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 08:06:20 -0400
X-Greylist: delayed 84089 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jun 2022 05:06:15 PDT
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2FF7E03A;
        Fri, 24 Jun 2022 05:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1656072371;
        bh=i+TLfV7Q9WtZuQ96Ed6tMGTjvVaQatLT38cfNmU5J68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=cLXPFY372oDe+pbOhU1HNAAz78ygRh06kiA6QHm4hrEbPgK3+EJRXIOreuML4S/7W
         y06ndLkcXn0bWcP6WHR/GQOWdSvvp9HU036+D5cAcsDKe+fRlBM9hd1ajWG7HUjbtT
         SEikGSmSjwu5dSmN5dmx8/rsgYl6DmtcS159oFqc=
Received: from wh-VirtualBox ([117.175.169.40])
        by newxmesmtplogicsvrszc8.qq.com (NewEsmtp) with SMTP
        id 18829089; Fri, 24 Jun 2022 20:06:08 +0800
X-QQ-mid: xmsmtpt1656072368tgl9vexc1
Message-ID: <tencent_2B372B7CD9C70750319022510DAD3C081108@qq.com>
X-QQ-XMAILINFO: MDPfhejMR4aI4PAqisrv/a5FviYMYw5okHeM8LAtB8FVYZxnhMSGffLnyl6h1r
         Rvh6D2upLqn53X9Zb58QU+PlmfEcAAuc3GNqPuhMiv7NdKKNkRAel3HU9QhReS762KW7RQhk9vG9
         uftPHNIcVk2ATN22wknZ5uf447Sc2qNXg666+Jtj1nDj+NjUFv4dA94yj2YCdwX1Jkr4a/y8Q+aw
         L80daUrzlK2rV/JPBB0/DPdDfTvbCW55F7RXea74gF+ac5AhChaM2RyVE/rAKz1SGFmQjXGGV8yV
         FBhgp0HVcJa7Vv9JNPWzydG+RIxq/aST6sTOr7G43vLgvBtz2WB58vsCxOXD/pVZK34gBR9u6hz1
         90/BPbvYsszovw/PDqHgMsi3fZRDHyh7pc9O9l6/8J2sY3Rj3dVDmtuVkkmp93LLP/1aD6+IdwIa
         0h8SR+TDjyucOX78Bqg7r/cv5gAEYUV+ON+ypWIe17cCVfgzf1k7Zj7eoAGaTtpzjgE+AxdYc7TZ
         xhYF4JTcRE62BUBP3yJSPRwj05zvupPLHK6pFDogT0mjPCmyLOVKj5QZftu39OjAiTRpjiIzddsu
         0eo3se5z5yvmSSzg4kCwhAHNVI/gRlk3AHz+faTW/eZndfCV7U4iSvdZPd64rONaFaXZdO7y1tF4
         04qplFIXOWaJbIZ+ErDkUtTAvCkCR0rpH5+qF8lg0hac6J9ab4CYrFEz2GPgNh9Klhy4qq3Y1NuM
         LRKnptbvSwV0iEv5SGSR7akvTORXJCseLC7izEt5HGjHOTGB1B7mS6gYLOz9Y7mGQ2SIpQgargN+
         /Ugek9KHBs171DCgju3obY7iMs+G6U53dA+J1XGdPgIC4kq0dz7odhHu8zDush9dgrv1f9eoH2L6
         lW/rtguGludenX44uPd+Xs+6EcdzoUv82C4VFcUkHWTlcL7zdK4tQ8ZwUzOOaVJmwpm4QuOQ2T53
         XKAlFla84kwvuzRizqM8bzji96ovru
Date:   Fri, 24 Jun 2022 20:05:30 +0800
From:   Wei Han <lailitty@foxmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lailitty@foxmail.com
Subject: Re: [PATCH] netfilter: xt_esp: add support for ESP match in NAT
 Traversal
X-OQ-MSGID: <20220624120530.GA23845@wh-VirtualBox>
References: <tencent_DDE91CB7412D427A442DB4362364DC04F20A@qq.com>
 <YrTAyW0phD0OiYN/@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTAyW0phD0OiYN/@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your reply, please see my answer below.

On Thu, Jun 23, 2022 at 09:36:41PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 23, 2022 at 08:42:48PM +0800, Wei Han wrote:
> > when the ESP packets traversing Network Address Translators,
> > which are encapsulated and decapsulated inside UDP packets,
> > so we need to get ESP data in UDP.
> > 
> > Signed-off-by: Wei Han <lailitty@foxmail.com>
> > ---
> >  net/netfilter/xt_esp.c | 54 +++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 45 insertions(+), 9 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
> > index 2a1c0ad0ff07..c3feb79a830a 100644
> > --- a/net/netfilter/xt_esp.c
> > +++ b/net/netfilter/xt_esp.c
> > @@ -8,12 +8,14 @@
> >  #include <linux/skbuff.h>
> >  #include <linux/in.h>
> >  #include <linux/ip.h>
> > +#include <linux/ipv6.h>
> >  
> >  #include <linux/netfilter/xt_esp.h>
> >  #include <linux/netfilter/x_tables.h>
> >  
> >  #include <linux/netfilter_ipv4/ip_tables.h>
> >  #include <linux/netfilter_ipv6/ip6_tables.h>
> > +#include <net/ip.h>
> >  
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
> > @@ -39,17 +41,53 @@ static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	struct ip_esp_hdr _esp;
> >  	const struct xt_esp *espinfo = par->matchinfo;
> >  
> > +	const struct iphdr *iph = NULL;
> > +	const struct ipv6hdr *ip6h = NULL;
> > +	const struct udphdr *udph = NULL;
> > +	struct udphdr _udph;
> > +	int proto = -1;
> > +
> >  	/* Must not be a fragment. */
> >  	if (par->fragoff != 0)
> >  		return false;
> >  
> > -	eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
> > -	if (eh == NULL) {
> > -		/* We've been asked to examine this packet, and we
> > -		 * can't.  Hence, no choice but to drop.
> > -		 */
> > -		pr_debug("Dropping evil ESP tinygram.\n");
> > -		par->hotdrop = true;
> > +	if (xt_family(par) == NFPROTO_IPV6) {
> > +		ip6h = ipv6_hdr(skb);
> > +		if (!ip6h)
> > +			return false;
> > +		proto = ip6h->nexthdr;
> > +	} else {
> > +		iph = ip_hdr(skb);
> > +		if (!iph)
> > +			return false;
> > +		proto = iph->protocol;
> > +	}
> > +
> > +	if (proto == IPPROTO_UDP) {
> > +		//for NAT-T
> > +		udph = skb_header_pointer(skb, par->thoff, sizeof(_udph), &_udph);
> > +		if (udph && (udph->source == htons(4500) || udph->dest == htons(4500))) {
> > +			/* Not deal with above data it don't conflict with SPI
> > +			 * 1.IKE Header Format for Port 4500(Non-ESP Marker 0x00000000)
> > +			 * 2.NAT-Keepalive Packet Format(0xFF)
> > +			 */
> > +			eh = (struct ip_esp_hdr *)((char *)udph + sizeof(struct udphdr));
> 
> this is not safe, skbuff might not be linear.
>
  Will be modified to "eh = skb_header_pointer(skb, par->thoff + sizeof(struct udphdr), sizeof(_esp), &_esp);"
> > +		} else {
> > +			return false;
> > +		}
> > +	} else if (proto == IPPROTO_ESP) {
> > +		//not NAT-T
> > +		eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
> > +		if (!eh) {
> > +			/* We've been asked to examine this packet, and we
> > +			 * can't.  Hence, no choice but to drop.
> > +			 */
> > +			pr_debug("Dropping evil ESP tinygram.\n");
> > +			par->hotdrop = true;
> > +			return false;
> > +		}
> 
> This is loose, the user does not have a way to restrict to either
> ESP over UDP or native ESP. I don't think this is going to look nice
> from iptables syntax perspective to restrict either one or another
> mode.
>
  This match original purpose is check the ESP packet's SPI value, so I
  think the user maybe not need to pay attention that the packet is 
  ESP over UDP or native ESP just get SPI and check it, this patch is 
  only want to add support for get SPI in ESP over UDP.And the iptables rules like:
  "iptables -A INPUT -m esp --espspi 0x12345678 -j ACCEPT"
> > +	} else {
> > +		//not esp data
> >  		return false;
> >  	}
> >  
> > @@ -76,7 +114,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
> >  		.checkentry	= esp_mt_check,
> >  		.match		= esp_mt,
> >  		.matchsize	= sizeof(struct xt_esp),
> > -		.proto		= IPPROTO_ESP,
> >  		.me		= THIS_MODULE,
> >  	},
> >  	{
> > @@ -85,7 +122,6 @@ static struct xt_match esp_mt_reg[] __read_mostly = {
> >  		.checkentry	= esp_mt_check,
> >  		.match		= esp_mt,
> >  		.matchsize	= sizeof(struct xt_esp),
> > -		.proto		= IPPROTO_ESP,
> >  		.me		= THIS_MODULE,
> >  	},
> >  };
> > -- 
> > 2.17.1
> > 
