Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5216D8D849
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfHNQlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:41:32 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:62624 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbfHNQlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:41:32 -0400
Received: from pps.filterd (m0049287.ppops.net [127.0.0.1])
        by m0049287.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x7EGbVhN008552;
        Wed, 14 Aug 2019 12:41:17 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049287.ppops.net-00191d01. with ESMTP id 2ucnaqhb58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 12:41:16 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7EGfDbd087740;
        Wed, 14 Aug 2019 11:41:15 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [135.46.181.149])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7EGfAPN087627
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 14 Aug 2019 11:41:10 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [127.0.0.1])
        by zlp30499.vci.att.com (Service) with ESMTP id 6205F4013B2F;
        Wed, 14 Aug 2019 16:41:10 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30499.vci.att.com (Service) with ESMTP id 468694013B21;
        Wed, 14 Aug 2019 16:41:10 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7EGfAhr036203;
        Wed, 14 Aug 2019 11:41:10 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x7EGf0Qr028484;
        Wed, 14 Aug 2019 11:41:01 -0500
Received: from pruddy-Precision-7520 (unknown [10.156.30.225])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 7032836023C;
        Wed, 14 Aug 2019 09:40:59 -0700 (PDT)
Message-ID: <620d3cfbe58e3ae87ef1d5e7f2aa1588cac3e64a.camel@vyatta.att-mail.com>
Subject: Re: [PATCH net-next] mcast: ensure L-L IPv6 packets are accepted by
 bridge
From:   Patrick Ruddy <pruddy@vyatta.att-mail.com>
Reply-To: pruddy@vyatta.att-mail.com
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        linus.luessing@c0d3.blue
Date:   Wed, 14 Aug 2019 17:40:58 +0100
In-Reply-To: <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
References: <20190813141804.20515-1-pruddy@vyatta.att-mail.com>
         <20190813195341.GA27005@splinter>
         <43ed59db-9228-9132-b9a5-31c8d1e8e9e9@cumulusnetworks.com>
Organization: Vyatta
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908140157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks both for the quick replies, answers inline...

On Wed, 2019-08-14 at 02:55 +0300, Nikolay Aleksandrov wrote:
> On 8/13/19 10:53 PM, Ido Schimmel wrote:
> > + Bridge maintainers, Linus
> > 
> 
> Good catch Ido, thanks!
> First I'd say the subject needs to reflect that this is a bridge change
> better, please rearrange it like so - bridge: mcast: ...
> More below,
> 
> > On Tue, Aug 13, 2019 at 03:18:04PM +0100, Patrick Ruddy wrote:
> > > At present only all-nodes IPv6 multicast packets are accepted by
> > > a bridge interface that is not in multicast router mode. Since
> > > other protocols can be running in the absense of multicast
> > > forwarding e.g. OSPFv3 IPv6 ND. Change the test to allow
> > > all of the FFx2::/16 range to be accepted when not in multicast
> > > router mode. This aligns the code with IPv4 link-local reception
> > > and RFC4291
> > 
> > Can you please quote the relevant part from RFC 4291?
> > 
> > > Signed-off-by: Patrick Ruddy <pruddy@vyatta.att-mail.com>
> > > ---
> > >  include/net/addrconf.h    | 15 +++++++++++++++
> > >  net/bridge/br_multicast.c |  2 +-
> > >  2 files changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > > index becdad576859..05b42867e969 100644
> > > --- a/include/net/addrconf.h
> > > +++ b/include/net/addrconf.h
> > > @@ -434,6 +434,21 @@ static inline void addrconf_addr_solict_mult(const struct in6_addr *addr,
> > >  		      htonl(0xFF000000) | addr->s6_addr32[3]);
> > >  }
> > >  
> > > +/*
> > > + *      link local multicast address range ffx2::/16 rfc4291
> > > + */
> > > +static inline bool ipv6_addr_is_ll_mcast(const struct in6_addr *addr)
> > > +{
> > > +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
> > > +	__be64 *p = (__be64 *)addr;
> > > +	return ((p[0] & cpu_to_be64(0xff0f000000000000UL))
> > > +		^ cpu_to_be64(0xff02000000000000UL)) == 0UL;
> > > +#else
> > > +	return ((addr->s6_addr32[0] & htonl(0xff0f0000)) ^
> > > +		htonl(0xff020000)) == 0;
> > > +#endif
> > > +}
> > > +
> > >  static inline bool ipv6_addr_is_ll_all_nodes(const struct in6_addr *addr)
> > >  {
> > >  #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
> > > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > > index 9b379e110129..ed3957381fa2 100644
> > > --- a/net/bridge/br_multicast.c
> > > +++ b/net/bridge/br_multicast.c
> > > @@ -1664,7 +1664,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
> > >  	err = ipv6_mc_check_mld(skb);
> > >  
> > >  	if (err == -ENOMSG) {
> > > -		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
> > > +		if (!ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
> > >  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
> > 
> > IIUC, you want IPv6 link-local packets to be locally received, but this
> > also changes how these packets are flooded. RFC 4541 says that packets
> 
> Indeed, we'll start flooding them all, not just the all hosts address.
> If that is at all required it'll definitely have to be optional.
> 
> > addressed to the all hosts address are a special case and should be
> > forwarded to all ports:
> > 
> > "In IPv6, the data forwarding rules are more straight forward because MLD is
> > mandated for addresses with scope 2 (link-scope) or greater. The only exception
> > is the address FF02::1 which is the all hosts link-scope address for which MLD
> > messages are never sent. Packets with the all hosts link-scope address should
> > be forwarded on all ports."
> > 
> 
> I wonder what is the problem for the host to join such group on behalf of the bridge ?
> Then you'll receive the traffic at least locally and the RFC says it itself - MLD is mandated
> for the other link-local addresses.
> It's very late here and maybe I'm missing something.. :)
> 
The group is being joined by MLD at the L3 level but the packets are
not being passed up to the l3 interface becasue there is a MLD querier
on the network

snippet from /proc/net/igmp6
...
40   sw1             ff0200000000000000000001ff008700     1 00000004 0
40   sw1             ff020000000000000000000000000002     1 00000004 0
40   sw1             ff020000000000000000000000000001     1 0000000C 0
40   sw1             ff010000000000000000000000000001     1 00000008 0
41   lo1             ff020000000000000000000000000001     1 0000000C 0
41   lo1             ff010000000000000000000000000001     1 00000008 0
42   sw1.1           ff020000000000000000000000000006     1 00000004 0
42   sw1.1           ff020000000000000000000000000005     1 00000004 0
42   sw1.1           ff0200000000000000000001ff000000     2 00000004 0
42   sw1.1           ff0200000000000000000001ff008700     1 00000004 0
42   sw1.1           ff0200000000000000000001ff000099     1 00000004 0
42   sw1.1           ff020000000000000000000000000002     1 00000004 0
42   sw1.1           ff020000000000000000000000000001     1 0000000C 0
42   sw1.1           ff010000000000000000000000000001     1 00000008 0
...

the bridge is sw1 and the l3 intervace is sw1.1

Ido is correct about the flooding - I will update the patch with the
comments and reissue.

Thanks again

-pr
>  
> > Maybe you want something like:
> > 
> 
> I think we can do without the new field, either pass local_rcv into br_multicast_rcv() or
> set it based on return value. The extra test will have to remain unfortunately, but we
> can reduce the tests by one if carefully done.
> 
> > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > index 09b1dd8cd853..9f312a73f61c 100644
> > --- a/net/bridge/br_input.c
> > +++ b/net/bridge/br_input.c
> > @@ -132,7 +132,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> >  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
> >  		    br_multicast_querier_exists(br, eth_hdr(skb))) {
> >  			if ((mdst && mdst->host_joined) ||
> > -			    br_multicast_is_router(br)) {
> > +			    br_multicast_is_router(br) ||
> > +			    BR_INPUT_SKB_CB_LOCAL_RECEIVE(skb)) {
> >  				local_rcv = true;
> >  				br->dev->stats.multicast++;
> >  			}
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index 9b379e110129..f03cecf6174e 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -1667,6 +1667,9 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
> >  		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
> >  			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
> >  
> > +		if (ipv6_addr_is_ll_mcast(&ipv6_hdr(skb)->daddr))
> > +			BR_INPUT_SKB_CB(skb)->local_receive = 1;
> > +
> >  		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
> >  			err = br_ip6_multicast_mrd_rcv(br, port, skb);
> >  
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index b7a4942ff1b3..d76394ca4059 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -426,6 +426,7 @@ struct br_input_skb_cb {
> >  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
> >  	u8 igmp;
> >  	u8 mrouters_only:1;
> > +	u8 local_receive:1;
> >  #endif
> >  	u8 proxyarp_replied:1;
> >  	u8 src_port_isolated:1;
> > @@ -445,8 +446,10 @@ struct br_input_skb_cb {
> >  
> >  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
> >  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(BR_INPUT_SKB_CB(__skb)->mrouters_only)
> > +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(BR_INPUT_SKB_CB(__skb)->local_receive)
> >  #else
> >  # define BR_INPUT_SKB_CB_MROUTERS_ONLY(__skb)	(0)
> > +# define BR_INPUT_SKB_CB_LOCAL_RECEIVE(__skb)	(0)
> >  #endif
> >  
> >  #define br_printk(level, br, format, args...)	\
> > 

