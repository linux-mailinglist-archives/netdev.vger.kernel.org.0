Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF743B3A4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhJZOMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:12:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36031 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234708AbhJZOMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:12:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 302545C02BD;
        Tue, 26 Oct 2021 10:09:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 Oct 2021 10:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1pi7Dn
        yCJxHjq8VFuSFfU9Tcfpd1EhkRMUL4XIaIqYk=; b=QrlahmCTIPku+TP0CjDAAC
        cVGIUYQvrGptvPkk7O/1KKAaIJIDTaY8GRVDKnYMDTQ3qnSvgNl7sFhAdggwUi+F
        NYM4BE1nFppQxVtILS7bIM/ne67+av4iT6Ess6Io2igVN9+TfpqavbokfvhyOZYt
        f/xWZE72+UB632sWSs8FM14YpLOzQSHYT1JHaMv96d5WR43AC9R/PY7ChgS+GWjg
        ToQW2DJXzxOomQ5G6SQTTDfM+oW5rpoWQrPOgvmK1Zb16cv5I4A3SVlC98qawDDP
        jROwpB85dJe/nFs8hdx3UScUWg5cWKiUIiYTds+pOnqr7L5fazhAl73VbGs1wJ1A
        ==
X-ME-Sender: <xms:Mgx4YUXqdnjA4d40DuLCAFi0eJVmY8pKuvAEkn7MjPXeE8OX0SqwFw>
    <xme:Mgx4YYnZrTY6CshOQ8YLWM5NsM03FgiBVM0l32FEl-_6sDNglMYGW56hojby6OyJu
    SOFLXqZSV75grk>
X-ME-Received: <xmr:Mgx4YYYNI8looNiqBB5ewVOvB7-QAwHKHmpyIQAwBU5ALUq7OJKDsXadFnJ0Ok6DeQDZhjVASn3rPk_a5bGfqQflWAPVMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefkedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Mgx4YTWSfhIpGkJ_2CmQzudvWEF9mCdNOS25hRR3jfnFWpp2UImS4Q>
    <xmx:Mgx4YemiX5K6-qdX0VNQYtmnXgxnqdpEYeFd8EwX2Rj29arhfgH4vQ>
    <xmx:Mgx4YYdPyPyDBlLWjuYUVqN11FRm01eXf9BIHFyxONF8OeeWaD5q0A>
    <xmx:Mwx4YVt9NO7G7av2i2tEkFfg2ANjrjWACGktSFHCAOdtJz5LPF5YNA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 10:09:53 -0400 (EDT)
Date:   Tue, 26 Oct 2021 17:09:47 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXgMK2NKiiVYJhLl@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <YXaNUQv8RwDc0lif@unreal>
 <YXelYVqeqyVJ5HLc@shredder>
 <YXertDP8ouVbdnUt@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXertDP8ouVbdnUt@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:18:12AM +0300, Leon Romanovsky wrote:
> On Tue, Oct 26, 2021 at 09:51:13AM +0300, Ido Schimmel wrote:
> 
> <...>
> 
> > > 
> > > Can you please explain why is it so important to touch devlink SW
> > > objects, reallocate them again and again on every reload in mlxsw?
> > 
> > Because that's how reload was defined and implemented. A complete
> > reload. We are not changing the semantics 4 years later.
> 
> Please put your emotions aside and explain me technically why are you
> must to do it?

Already did. The current semantics are "devlink-reload provides
mechanism to reinit driver entities, applying devlink-params and
devlink-resources new values. It also provides mechanism to activate
firmware."

And this is exactly what netdevsim and mlxsw are doing. Driver entities
are re-initialized. Your patch breaks that as entities are not
re-initialized, which results in user space breakage. You simply cannot
introduce such regressions.

> 
> The proposed semantics was broken for last 4 years, it can even seen as
> dead on arrival,

Again with the bombastic statements. It was "dead on arrival" like the
notifications were "impossible"?

> because it never worked for us in real production.

Who is "us"? mlx5 that apparently decided to do its own thing?

We are using reload in mlxsw on a daily basis and users are using it to
re-partition ASIC resources and activate firmware. There are tests over
netdevsim implementation that anyone can run for testing purposes. We
also made sure to integrate it into syzkaller:

https://github.com/google/syzkaller/commit/5b49e1f605a770e8f8fcdcbd1a8ff85591fc0c8e
https://github.com/google/syzkaller/commit/04ca72cd45348daab9d896bbec8ea4c2d13455ac
https://github.com/google/syzkaller/commit/6930bbef3b671ae21f74007f9e59efb9b236b93f
https://github.com/google/syzkaller/commit/d45a4d69d83f40579e74fb561e1583db1be0e294
https://github.com/google/syzkaller/commit/510951950dc0ee69cfdaf746061d3dbe31b49fd8

Which is why the regressions you introduced were discovered so quickly.

> 
> So I'm fixing bugs without relation to when they were introduced.

We all do

> 
> For example, this fix from Jiri [1] for basic design flow was merged almost
> two years later after devlink reload was introduced [2], or this patch from
> Parav [3] that fixed an issue introduced year before [4].

What is your point? That code has bugs?

By now I have spent more time arguing with you than you spent testing
your patches and it's clear this discussion is not going anywhere.

Are you going to send a revert or I will? This is the fourth time I'm
asking you.
