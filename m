Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9C82B6B90
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKQRSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:18:36 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54143 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727645AbgKQRSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:18:35 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C8E10EB3;
        Tue, 17 Nov 2020 12:18:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:18:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=mnRkWdk24YVdPmxOFeFIpnziyYnvzdytd2sPvf59p
        q8=; b=cQBmivyOh54FSy36rIvLycbu4QdmogM+A+SMbnmJYAYncYIbqL1599BwR
        hxqEYh6OykHz73A1bEl+4wlsPk0DzLPaD5v5aDFktZclOB0AdelFV9mCKGzrALMk
        9Lop0Ix8Hb7IcoKR15Q4nuu4A3l3caFo/VyZ1auizNVuHNNxZXgk0OJc77OY73A5
        +qv4QC+fM6a3SJp/b0tht8DH8ZZtWUH8XrZV3x9/Ff3xqE6/sv8KhErlVuozR32n
        GfX5g6AkRpQM8+8k+RjW4azZ4t6TlKyCIATI6Q02SwTdKOIbmfsy+MKkYWE6PKtc
        e/Ad+b/7AkDsqMdBRKOFKDSK4xwag==
X-ME-Sender: <xms:6QW0Xy0Px-TniUSfgz7uxvv07maPWK8z6mChh89yplgfzVetm2M-Ag>
    <xme:6QW0X1EA1ouoVZqmg9JNX0l1yWuaB8uf5DcAoC1w_gEkiEycdED2yagIpNx_U1-GP
    c5uU8SqskAzHtE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepuefgjeefveeivdektdfggefhgeevudegvefgtedugfetveevuedtgffhkefg
    gefgnecukfhppeekgedrvddvledrudehgedrudegjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6QW0X65Ac07JwdPxuxCVgNkFj9KICMb4Pcqknut3RPtfXHSxFMcxOw>
    <xmx:6QW0Xz1KeryPDFlqPoq-ydQhLmJKGn6E6t2oNVjruWkRUP-ZcwtleQ>
    <xmx:6QW0X1EuRLHxAML6e1BqFyP6JVNXhuCx4fpyCDmlKWiXXr_2FIwTrA>
    <xmx:6gW0X5gwr7aRaAP6OUMSD9MasrdvCPLva9PPValhHZH0Hhq9bxPlGw>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 451A33064AB3;
        Tue, 17 Nov 2020 12:18:33 -0500 (EST)
Date:   Tue, 17 Nov 2020 19:18:30 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Mahesh Bandewar
         =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?=
         =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201117171830.GA286718@shredder.lan>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116123447.2be5a827@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF2d9ji24VkLipTCFSAU+L8yqKt9nfPSNfks9_V1Tnb0ztPrfA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 01:03:32PM -0800, Mahesh Bandewar (महेश बंडेवार) wrote:
> On Mon, Nov 16, 2020 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (महेश बंडेवार) wrote:
> > > > > diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> > > > > index a1c77cc00416..76dc92ac65a2 100644
> > > > > --- a/drivers/net/loopback.c
> > > > > +++ b/drivers/net/loopback.c
> > > > > @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct net *net)
> > > > >
> > > > >       BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
> > > > >       net->loopback_dev = dev;
> > > > > +
> > > > > +     if (sysctl_netdev_loopback_state) {
> > > > > +             /* Bring loopback device UP */
> > > > > +             rtnl_lock();
> > > > > +             dev_open(dev, NULL);
> > > > > +             rtnl_unlock();
> > > > > +     }
> > > >
> > > > The only concern I have here is that it breaks notification ordering.
> > > > Is there precedent for NETDEV_UP to be generated before all pernet ops
> > > > ->init was called?
> > > I'm not sure if any and didn't see any issues in our usage / tests.
> > > I'm not even sure anyone is watching/monitoring for lo status as such.
> >
> > Ido, David, how does this sound to you?
> >
> > I can't think of any particular case where bringing the device up (and
> > populating it's addresses) before per netns init is finished could be
> > problematic. But if this is going to make kernel coding harder the
> > minor convenience of the knob is probably not worth it.
> 
> +Eric Dumazet
> 
> I'm not sure why kernel coding should get harder, but happy to listen
> to the opinions.

Hi,

Sorry for the delay. Does not occur to me as a problematic change. I ran
various tests with 'sysctl -qw net.core.netdev_loopback_state=1' and a
debug config. Looks OK.
