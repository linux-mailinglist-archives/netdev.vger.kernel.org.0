Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F91743275D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhJRTSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:18:02 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:32783 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231542AbhJRTSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 15:18:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 579403201DDC;
        Mon, 18 Oct 2021 15:15:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Oct 2021 15:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=ZKhBjrzlEoHsw+F3+ZV8Pu6L1KxonjN38B/4RT3CG
        Fw=; b=W8/EgBesExJfJGFda9X/yu0EBLrbTizjTE/kRns0OQHRoLj7lEweVNNnL
        muswLU1bfoeRSetJarH9NpWNWJIJ07vBGokIBeKwRkt1Il2V3Y01ZFx8zV+LXvwb
        ABZKV3aPNxmVGv8X5ZWaYHjiXwy+PNk3VH10ofSIlzlAHgorJCqkblM0RXwTk93V
        aaAPnR+bT3vBvShCVD1ibN5bOLiEuEtKzTmRkQju2desNlMjXdNHXYYFYGaut/9N
        lwgjUJXiQCp/T7EeJRth0ZyzK35Bm+Fcxa5cDalCHF3rON8hS6DZVdBXaNwp5AHX
        21/3LN3PppxhCa0lskJ4CpSVyBx2A==
X-ME-Sender: <xms:5MdtYez02mjfkm2jM5agtITjXsYwrsa-cTpQ9oC4KkoGr46os3b9rw>
    <xme:5MdtYaRszBbdgXEYpW3cZJHabp4X9pGwtqAG9jWcidGFPwR3FUqfk6mWUWmITl9TY
    Zpo58COkJgv65s>
X-ME-Received: <xmr:5MdtYQXyNbWXZFUYEexFm0YjfY88fHOZ8P1pdpzQ4UHlF6XpjlZkfno5oFdt99YFpSvTwS46Z_M4exZw9eLvV0k74e0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvtddgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeejhedtvefhkeegfeelffffueefvdfhgeffjeethfekheefgfekveeukedv
    ueffveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:5MdtYUj251bKgD1Pgf4qrTjR15g8grXBNszX8ehJzadbcY7pJyu51A>
    <xmx:5MdtYQBRrB6YBToJ82F1TgTVVYF6dvc137OWnkFJE4tIpZcMc3_G3w>
    <xmx:5MdtYVIZCw10LqUQl21PluWATQ2Wil8KDn5Wv3S_Wg2_kNfTY849sg>
    <xmx:5MdtYf4U2LPmwjNawMZuWMGKE2H1zfzj23vWAszI1_bZjMIp0A2I1Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Oct 2021 15:15:47 -0400 (EDT)
Date:   Mon, 18 Oct 2021 22:15:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vkochan@marvell.com, tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Message-ID: <YW3H4GhRWEjaHF+U@shredder>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
 <186dd3ec-6bab-fe3c-cbab-a54898d51f57@pensando.io>
 <20211018071915.2e2afdd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6dc4c0b4-8eaa-800a-a06c-a16cbee5a22e@pensando.io>
 <YW2wBJ7yoUaLkYVv@shredder>
 <443e4671-bc84-b4a9-7198-7de301a03d52@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <443e4671-bc84-b4a9-7198-7de301a03d52@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 10:54:56AM -0700, Shannon Nelson wrote:
> On 10/18/21 10:33 AM, Ido Schimmel wrote:
> > On Mon, Oct 18, 2021 at 09:26:21AM -0700, Shannon Nelson wrote:
> > > On 10/18/21 7:19 AM, Jakub Kicinski wrote:
> > > > On Sat, 16 Oct 2021 14:19:18 -0700 Shannon Nelson wrote:
> > > > > As a potential consumer of these helpers, I'd rather do my own mac
> > > > > address byte twiddling and then use eth_hw_addr_set() to put it into place.
> > > > This is disproved by many upstream drivers, I only converted the ones
> > > > that jumped out at me on Friday, but I'm sure there is more. If your
> > > > driver is _really_ doing something questionable^W I mean "special"
> > > > nothing is stopping you from open coding it. For others the helper will
> > > > be useful.
> > > > 
> > > > IOW I don't understand your comment.
> > > To try to answer your RFC more clearly: I feel that this particular helper
> > > obfuscates the operation more than it helps.
> > FWIW, it at least helped me realize that we are going to have a bug with
> > Spectrum-4. Currently we have:
> > 
> > ether_addr_copy(addr, mlxsw_sp->base_mac);
> > addr[ETH_ALEN - 1] += mlxsw_sp_port->local_port;
> > 
> > As a preparation for Spectrum-4 we are promoting 'local_port' to u16
> > since at least 257 and 258 are valid local port values.
> > 
> > With the current code, the netdev corresponding to local port 1 will
> > have the same MAC as the netdev corresponding to local port 257.
> > 
> > After Jakub's conversion and changing the 'id' argument to 'unsigned
> > int' [1], it should work correctly.
> > 
> > [1] https://lore.kernel.org/netdev/20211018070845.68ba815d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> 
> I would think that it might be clearer to do something like
> 
>     u64 addr64;
> 
>     addr64 = ether_addr_to_64(mlxsw_sp->base_mac);
>     addr64 += mlxsw_sp_port->local_port;
>     u64_to_ether_addr(addr64, addr);
>     eth_hw_addr_set(dev, addr);

This is basically what Jakub's helper is doing...

I don't know how to argue with "clearer", but the fact is that we are
not doing what you suggested right now (hindsight is always 20/20) and
that it would have taken me time to debug it.

The suggested helper already helped to avoid one bug and it's not even
merged yet, so it's safe to assume it will help to avoid more bugs in
the future.
