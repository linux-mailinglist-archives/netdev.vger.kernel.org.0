Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575D42DA771
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgLOFTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgLOFTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 00:19:22 -0500
Date:   Tue, 15 Dec 2020 07:18:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608009522;
        bh=sYVoD9fQ4iG/h+hSNQcInrv0UeUccJHoIREfTQfxY7c=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=LoYz2VkhmecU0TapvJ/75sQjoZEdfvX/S4P55adPRt2I1DmlSA/FEyEi1pVtS4mJ7
         RZUlxKtZTfFY+wCMdaNBL5bfZ1qPi2QeIxaeMTyo3i8F0yoSLL8auWElbfhQySjuQF
         LoG/UhPIjgEE4zNWy55kNrt7C+bmitx0RsRRIUNTkzOocCeOjpDrIcc6mLbvdIy9li
         5cB7x+6EAWKAHLXB4oHAZOAqgdr3dv7gbbC1t86sv7BgXHTs67elMd6JZfaSnf9cQw
         KxUTRiF0PaltqTsAZQ8xnt6INwHW40Dn0TxBLuMA+xenGgl6QYGCXHcEfNM1rkVWhT
         cGQR6CdYFWnlQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vasyl Gomonovych <gomonovych@gmail.com>, tariqt@nvidia.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
Message-ID: <20201215051838.GH5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201214103008.14783-1-gomonovych@gmail.com>
 <20201214111608.GE5005@unreal>
 <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:15:01AM -0800, Joe Perches wrote:
> On Mon, 2020-12-14 at 11:03 -0800, Jakub Kicinski wrote:
> > On Mon, 14 Dec 2020 13:16:08 +0200 Leon Romanovsky wrote:
> > > On Mon, Dec 14, 2020 at 11:30:08AM +0100, Vasyl Gomonovych wrote:
> > > > It is fix for semantic patch warning available in
> > > > scripts/coccinelle/misc/boolinit.cocci
> > > > Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> > > > Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
> > > >
> > > > Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> > > > ---
> > > >  - Add coccicheck script name
> > > >  - Simplify if condition
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
> > > >  drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
> > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > Please refrain from sending new version of patches as reply-to to
> > > previous variants. It makes to appear previous patches out-of-order
> > > while viewing in threaded mode.
> >
> > Yes, please! I'm glad I'm not the only one who feels this way! :)
>
> I'm the other way.
>
> I prefer revisions to single patches (as opposed to large patch series)
> in the same thread.

It depends which side you are in that game. From the reviewer point of
view, such submission breaks flow very badly. It unfolds the already
reviewed thread, messes with the order and many more little annoying
things.

>
> There is no other easy way for changes to a patch to be tracked AFAIK.

Not really,  I'm using very simple convention to keep tracking of
changes. The changelog together with lorifier does the trick.

https://github.com/danrue/lorifier
https://lore.kernel.org/linux-rdma/20201125064628.8431-1-leon@kernel.org/

So I'm simply adding link to the previous version when sending new one.

>
> Most email clients use both In-Reply-To: and References: headers as
> the mechanism to thread replies.

Right, and this is exactly what we don't want for vX patches.

>
> Keeping the latest messages at the bottom of a thread works well
> to see revision sequences.

I have a different workflow.

Thanks
