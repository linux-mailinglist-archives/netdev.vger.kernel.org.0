Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975B6266401
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgIKQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:29:19 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:40475 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726299AbgIKQ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:29:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id AF135A72;
        Fri, 11 Sep 2020 12:29:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 12:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FZovT5
        t0ZYGX8WM/7r9UIidf0CEX9iTC+Or1ksuh0Jw=; b=RwxLVYOU6UFYD9fCVWnf8s
        x11EwUG42bBJ9IDDP4+MAG3dhRwCjGx1N2aGobp0tUfP5cNUQ0gw9QNsEyDmJT9E
        D27YWB1vdNM68vJ2vfL/T7YhGaZLGjzpBVq02NFkF+XOjKKkCJXOiYCL8yoBt0MS
        fvbrG01e60tItlp8AFg7/8bH29qEKzWf06kDLtEHYfhGQJKqkdCOzGw762ukyZmJ
        iFRRvHBP9JOAfspWMv93LYiEygosRoM6PQ1QQQdptcUbMeRjeRvw438KJFDgwtK1
        hgFQE4D66+bo8Bdm+LEnsibeJF1XS7GOXZihdYmkoM58buYlKK3Vd7XJvXz4lBAQ
        ==
X-ME-Sender: <xms:06VbX-Deqn_VOwV3XjccdHkfFldxaFKM7xFpCPmUBYS1w5-7DA29BQ>
    <xme:06VbX4hBdN6CuinjUqhMtk30LPbKtHY3cqcE3FoG39TMITC9UjGdsNMMtKKSfBmaM
    FHacGibI2PnMPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrfeeirddufedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:06VbXxlvIHvVRJGFAtXnHPDZ9fhPFnOxHxzDEgV-4Muq7iWQTKnKJA>
    <xmx:06VbX8wvj-6LLjsEObgsK3-lp109t7Yu8pBoiogMb6rAQgMgqMojzg>
    <xmx:06VbXzRmPGx8hBe4kBA15-TjjF0qE2CkWLG6_ZdSpUTjhyNx3v22Vg>
    <xmx:1KVbX9eWoxUhV0ajb9a4GmYEOAzL_YZlKfwRsqQ7eDYBnSIvGC-bpA>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40E063064682;
        Fri, 11 Sep 2020 12:29:07 -0400 (EDT)
Date:   Fri, 11 Sep 2020 19:29:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 15/22] nexthop: Emit a notification when a
 nexthop group is reduced
Message-ID: <20200911162905.GI3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-16-idosch@idosch.org>
 <c9fca303-9168-1b4b-25d9-7982d05cda92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9fca303-9168-1b4b-25d9-7982d05cda92@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:33:42AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > When a single nexthop is deleted, the configuration of all the groups
> > using the nexthop is effectively modified. In this case, emit a
> > notification in the nexthop notification chain for each modified group
> > so that listeners would not need to keep track of which nexthops are
> > member in which groups.
> > 
> > In the rare cases where the notification fails, emit an error to the
> > kernel log.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  net/ipv4/nexthop.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index 0edc3e73d416..33f611bbce1f 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -893,7 +893,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
> >  	struct nexthop *nhp = nhge->nh_parent;
> >  	struct nexthop *nh = nhge->nh;
> >  	struct nh_group *nhg, *newg;
> > -	int i, j;
> > +	int i, j, err;
> >  
> >  	WARN_ON(!nh);
> >  
> > @@ -941,6 +941,10 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
> >  	list_del(&nhge->nh_list);
> >  	nexthop_put(nhge->nh);
> >  
> > +	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, NULL);
> > +	if (err)
> > +		pr_err("Failed to replace nexthop group after nexthop deletion\n");
> 
> This should refer to the notifier failing since wrt nexthop code the
> structs are ok. extack on the stack and logging that message would be
> useful too (or have the users of the notifier log why it fails).

'extack on the stack' idea is cool! I will do that

> 
> > +
> >  	if (nlinfo)
> >  		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
> >  }
> > 
> 
