Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB98B231D96
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgG2LnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:43:22 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41047 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2LnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:43:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 134894B8;
        Wed, 29 Jul 2020 07:43:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 07:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l38fM3
        lfQzmFl33A4ZEsdirrgbJNyipF5taLaKCC1rM=; b=jcTXLUVb1txLf2jpLP3OY8
        Db4Z6hT6lcTSI+mTr+TT9OExa5zTZApMula3YS4z/RebeAxkauljY5hSSFrjSIi6
        vOtqJPG807XjrSyJlRtyiPexV1f+nbgW3YlMaat4fumoXA6+82mJVoaEgWVe7RFl
        lrUUe6Vx3IT7NyTqaIyB1WHB5KIl3nRfJmYTjjt7u//8TODwjeAABzCN0HZqCdaT
        d9AJOuEVwqVtRY7HccI1xnIcKmoq4Bd7WSyOY0EYwh6/3YbmFGxkPZP7cmNsilWT
        eBid4EyV9xwOEPGLJ0+vjSWXvY5LgSwHrs42ii27XE3OXgjxGEqp6DnOiBX2rDCg
        ==
X-ME-Sender: <xms:2GAhXzBIWndntwWHz_5mtMeDYGalSNlTVr1TVP5BFO9rIN38B_P__g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppedutdelrdeihedrudefjedrvdehtdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2GAhX5j4gWIR-crCvs52P0QvCy6CIAX1bN2cDBpLqelBc3gmgN1ZrA>
    <xmx:2GAhX-nAL6r3sAfAJfIOvSz5fwjfeDxmHXTJ4mdIPvUpV5fXMDQ1GQ>
    <xmx:2GAhX1zlVYfKtjAWW8yialBCarQuduXUYm7KOdThS0-ywfqF3yqUIg>
    <xmx:2GAhX3Om4zG2k5wlgQjErx8rCx9Tlocs7BxZBMPabaEIAod8fxfYtQ>
Received: from localhost (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1474E30600B1;
        Wed, 29 Jul 2020 07:43:19 -0400 (EDT)
Date:   Wed, 29 Jul 2020 14:43:17 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Ashutosh Grewal <ashutoshgrewal@gmail.com>, dsahern@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Bug: ip utility fails to show routes with large # of multipath
 next-hops
Message-ID: <20200729114317.GA2120829@shredder>
References: <CAKA6ep+EFNOYY8k8PFP9kf_F5GY+5g8qu_LphEAX6N7iEFTs9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA6ep+EFNOYY8k8PFP9kf_F5GY+5g8qu_LphEAX6N7iEFTs9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:52:44PM -0700, Ashutosh Grewal wrote:
> Hello David and all,
> 
> I hope this is the correct way to report a bug.

Sure

> 
> I observed this problem with 256 v4 next-hops or 128 v6 next-hops (or
> 128 or so # of v4 next-hops with labels).
> 
> Here is an example -
> 
> root@a6be8c892bb7:/# ip route show 2.2.2.2
> Error: Buffer too small for object.
> Dump terminated
> 
> Kernel details (though I recall running into the same problem on 4.4*
> kernel as well) -
> root@ubuntu-vm:/# uname -a
> Linux ch1 5.4.0-33-generic #37-Ubuntu SMP Thu May 21 12:53:59 UTC 2020
> x86_64 x86_64 x86_64 GNU/Linux
> 
> I think the problem may be to do with the size of the skbuf being
> allocated as part of servicing the netlink request.
> 
> static int netlink_dump(struct sock *sk)
> {
>   <snip>
> 
>                 skb = alloc_skb(...)

Yes, I believe you are correct. You will get an skb of size 4K and it
can't fit the entire RTA_MULTIPATH attribute with all the nested
nexthops. Since it's a single attribute it cannot be split across
multiple messages.

Looking at the code, I think a similar problem was already encountered
with IFLA_VFINFO_LIST. See commit c7ac8679bec9 ("rtnetlink: Compute and
store minimum ifinfo dump size").

Maybe we can track the maximum number of IPv4/IPv6 nexthops during
insertion and then consult it to adjust 'min_dump_alloc' for
RTM_GETROUTE.

It's a bit complicated for IPv6 because you can append nexthops, but I
believe anyone using so many nexthops is already using RTA_MULTIPATH to
insert them, so we can simplify.

David, what do you think? You have a better / simpler idea? Maybe one
day everyone will be using the new nexthop API and this won't be needed
:)

> 
> Thanks,
> Ashutosh
