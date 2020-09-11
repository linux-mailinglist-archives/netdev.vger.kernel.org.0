Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA6266397
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgIKQU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:20:59 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49339 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgIKQUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:20:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 84AC29CC;
        Fri, 11 Sep 2020 12:20:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 11 Sep 2020 12:20:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U/9vnr
        xYsW/ICAS+r72JYTj2vZDJ14bx1fcFLOSoRrs=; b=OuFoWioEIC3UMh8tEf9rSf
        s6hnY8jUwIDwYyuLj5U84J1HuwGVkVpB1rMjfklnLKpoO/lMrNqNOkmdJlhvlPdO
        1pZclLUya9d3gXYx94k22R7n5jDU/5JptU2JiLL19z1BZZiw4AqqTN07mTrOBtCp
        07EnQ3RbD7hAiN1vA5XyHsfL5VnQ40BePmWeuq2CjCLdqTTdmCQQOMB2V6HOFdyo
        COx33l3H5n+c3Bm2J1K9VrGrp3wc8TQJNidD2tRXyr1v8X+YtRca7ubTYvVDGc0Z
        sJ8FKYJ6QQVGJqsIm4LWGZ5U8FPfW7nyG1Pwr/DIUwCFb+3FIOHqOd+VMfBFcQ1w
        ==
X-ME-Sender: <xms:2qNbX0qcMrnDWSl-uVT6ldCxFmLL61qJZXBq8-tcNff0xvG7WM7WQA>
    <xme:2qNbX6ojJdvXIxtH-s98uesKoMZCIUBwXcZWiNS1k8o_owlNKOiwhVaPbxdBKWDQk
    SpmnoykOLXj_10>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehledguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrfeeirddufedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2qNbX5ND8_B70wDqJG4xUnz81Hxw0UEIc2mjaYez2F2U6jmfjk5Xuw>
    <xmx:2qNbX75DsTC1-J7je-jPhA0c4FZk-4bZ1xlbNdLzaetc-EsRG8inUQ>
    <xmx:2qNbXz5QwnF-5r5YcIfIX8LxvWK237YH_OGRBz0l6ouxbsh8WUV2Xw>
    <xmx:26NbX1l_qhIv-cq74OUFAc_1eJKX3ekYnmvFwNAjVtjrd5vyOV0TwA>
Received: from localhost (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E9E7306467E;
        Fri, 11 Sep 2020 12:20:42 -0400 (EDT)
Date:   Fri, 11 Sep 2020 19:20:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 11/22] nexthop: Emit a notification when a
 nexthop is added
Message-ID: <20200911162040.GG3160975@shredder>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-12-idosch@idosch.org>
 <8568a626-0597-0904-c67c-a8badc4e270a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8568a626-0597-0904-c67c-a8badc4e270a@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:21:08AM -0600, David Ahern wrote:
> On 9/8/20 3:10 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Emit a notification in the nexthop notification chain when a new nexthop
> > is added (not replaced). The nexthop can either be a new group or a
> > single nexthop.
> 
> Add a comment about why EVENT_REPLACE is generated on an 'added (not
> replaced)' event.

Reworded:

"
nexthop: Emit a notification when a nexthop is added

Emit a notification in the nexthop notification chain when a new nexthop
is added (not replaced). The nexthop can either be a new group or a
single nexthop.

The notification is sent after the nexthop is inserted into the
red-black tree, as listeners might need to callback into the nexthop
code with the nexthop ID in order to mark the nexthop as offloaded.

A 'REPLACE' notification is emitted instead of 'ADD' as the distinction
between the two is not important for in-kernel listeners. In case the
listener is not familiar with the encoded nexthop ID, it can simply
treat it as a new one. This is also consistent with the route offload
API.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
"

> 
> > 
> > The notification is sent after the nexthop is inserted into the
> > red-black tree, as listeners might need to callback into the nexthop
> > code with the nexthop ID in order to mark the nexthop as offloaded.
> > 
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  include/net/nexthop.h | 3 ++-
> >  net/ipv4/nexthop.c    | 6 +++++-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> > index 4147681e86d2..6431ff8cdb89 100644
> > --- a/include/net/nexthop.h
> > +++ b/include/net/nexthop.h
> > @@ -106,7 +106,8 @@ struct nexthop {
> >  
> >  enum nexthop_event_type {
> >  	NEXTHOP_EVENT_ADD,
> 
> looks like the ADD event is not used and can be removed.

Right. I will remove it in a separate patch

> 
> > -	NEXTHOP_EVENT_DEL
> > +	NEXTHOP_EVENT_DEL,
> > +	NEXTHOP_EVENT_REPLACE,
> >  };
> >  
> >  struct nh_notifier_single_info {
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index 71605c612458..1fa249facd46 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c
> > @@ -1277,7 +1277,11 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
> >  
> >  	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
> >  	rb_insert_color(&new_nh->rb_node, root);
> > -	rc = 0;
> > +
> > +	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
> > +	if (rc)
> > +		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
> > +
> >  out:
> >  	if (!rc) {
> >  		nh_base_seq_inc(net);
> > 
> 
