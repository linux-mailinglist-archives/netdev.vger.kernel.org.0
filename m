Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66EF2663C7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgIKQYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:24:39 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43297 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbgIKQYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:24:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8FCEC7F4;
        Fri, 11 Sep 2020 12:24:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 12:24:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ezMXG/
        O1bJ0zRA6GvHA/4RhMFSGng5JDD1saqOq5JYk=; b=h3Sp4nWtdS/3hCqP2aVjT7
        SzDDSoL+FcU5eVEhZyQ0Ky01Hx8OviXnXYCqvTNwgeahqjwEOaKzpd9q4+8IzTvH
        uuHJ+DNLQ4G4ZNMTZWG1fJTNfLNzr8QjmJIPeB05E4Nvuf2HPvYyMRVKdFO0f5rJ
        nb05dz7JMJWvHy/HrbiPQJUgGMdpM+rNdQB1bMbJKQp7ofNWE/w5BUzlFqc8/J6A
        JRDWnEnom7Sue4MD3vwMY1M9kNZE3/Ess7QBDQ9uYreKQvmAT3h8n8qzWIyoySJ6
        pD7KlBX+zWFyRbbHriw9BzmIrI1XnxwaqFaQNLOmAm9niB8nTOzZkrlaYiv7q46w
        ==
X-ME-Sender: <xms:raRbXzmMMhzlKqwHY5TIk-pRnta0r7bPMGGImE2CXvcMiIIF1U5Dtw>
    <xme:raRbX20GA2YnA-3klFGH7Tu6rx1a-Jl3333OE5yQoyXLT_gbGvXVIsLDQsZD9yOdq
    RlYilKEG8bBBHY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrfeeirddufedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:raRbX5oC7JC_Uii_pgVQsRPg_jll2WrzLmPM4pehAhdFS6dq5R-gKw>
    <xmx:raRbX7njrvUpcFa-WDj75H12OQyV7MdEIGzQkcGAGRcu9bCAIVj7qA>
    <xmx:raRbXx3w3lSYma_c0AMbq8RhRIJK8MByISEB0HaGrLOP_el8oaxyWQ>
    <xmx:rqRbX6xWCTKXq5Ga8Qg2EBOW2aWnz46-OaZhaDpx1BngwdkETLF98w>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8C4DC3280060;
        Fri, 11 Sep 2020 12:24:13 -0400 (EDT)
Date:   Fri, 11 Sep 2020 19:24:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 13/22] nexthop: Emit a notification when a
 single nexthop is replaced
Message-ID: <20200911162411.GH3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-14-idosch@idosch.org>
 <d7df0551-f8ac-4c9d-5bcc-5ec67908fce1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7df0551-f8ac-4c9d-5bcc-5ec67908fce1@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:25:40AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > The notification is emitted after all the validation checks were
> > performed, but before the new configuration (i.e., 'struct nh_info') is
> > pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
> > need to perform rollback in case the notification is vetoed.
> > 
> > The next patch will also emit a replace notification for all the nexthop
> > groups in which the nexthop is used.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  net/ipv4/nexthop.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index a60a519a5462..b8a4abc00146 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -1099,12 +1099,22 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
> >  				  struct netlink_ext_ack *extack)
> >  {
> >  	struct nh_info *oldi, *newi;
> > +	int err;
> >  
> >  	if (new->is_group) {
> >  		NL_SET_ERR_MSG(extack, "Can not replace a nexthop with a nexthop group.");
> >  		return -EINVAL;
> >  	}
> >  
> > +	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
> > +	if (err)
> > +		return err;
> > +
> > +	/* Hardware flags were set on 'old' as 'new' is not in the red-black
> > +	 * tree. Therefore, inherit the flags from 'old' to 'new'.
> > +	 */
> > +	new->nh_flags |= old->nh_flags & (RTNH_F_OFFLOAD | RTNH_F_TRAP);
> 
> Will that always be true? ie., has h/w seen 'new' and offloaded it yet?

Yes. The chain was converted to a blocking chain, so it is possible to
program the hardware inline.

> vs the notifier telling hardware about the change, it does its thing and
> sets the flags. But I guess that creates a race between the offload and
> the new data being available.
> 
> > +
> >  	oldi = rtnl_dereference(old->nh_info);
> >  	newi = rtnl_dereference(new->nh_info);
> >  
> > 
> 
