Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E73476642
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 23:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhLOW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 17:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLOW7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 17:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9CC061574;
        Wed, 15 Dec 2021 14:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D522EB8220E;
        Wed, 15 Dec 2021 22:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6453AC36AE3;
        Wed, 15 Dec 2021 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639609137;
        bh=6wtUxpxxkQXGyhFTYjYTzm3dj/MLwrbAYE1bbjq+OVE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pT+at12aFtDF3DnJ9pIyL/Lsz2K6JJYNRk38KPK/JFq+sj/QK89ewJ7P4kKuprwH6
         kakCkCvbfJmPsbisb4Zr+f9bt4VUezJ9T1QhUs18M/odEq5JCptmdj1sSyzgzpIG2w
         01ZbNfmUboAM69FaYIZVWf34xU2nJoe8RgFg8UtwxmBZA6b+ATo4kr0J72JIfJK1IN
         6ifE7OUuR+/StjfqQoxAxLFxUn73yYxuq4IMnVyBJDdIhFW9Jwsbd+HjD1g0Np9cG4
         ydF1iKazNGjM88Uq58MuMXMvkGJwMZhdYdTDFXf5Fo/pokR1DKLW3J5dAgFAURHQCB
         KQe6GOoTPypcw==
Date:   Wed, 15 Dec 2021 14:58:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
Message-ID: <20211215145856.4a29e48b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
References: <20211215184945.185708-1-saeed@kernel.org>
        <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a0bf02eb4f7ca5501910521a0b32f18a0499cef9.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 22:14:11 +0000 Saeed Mahameed wrote:
> On Wed, 2021-12-15 at 11:23 -0800, Jakub Kicinski wrote:
> > On Wed, 15 Dec 2021 10:49:45 -0800 Saeed Mahameed wrote: =20
> > > This pulls mlx5-next branch into net-next and rdma branches.
> > > All patches already reviewed on both rdma and netdev mailing lists.
> > >=20
> > > Please pull and let me know if there's any problem.
> > >=20
> > > 1) Add multiple FDB steering priorities [1]
> > > 2) Introduce HW bits needed to configure MAC list size of VF/SF.
> > > =C2=A0=C2=A0 Required for ("net/mlx5: Memory optimizations") upcoming=
 series
> > > [2]. =20
> >=20
> > Why are you not posting the patches? =20
>=20
> already posted before :
> [1] https://lore.kernel.org/netdev/20211201193621.9129-1-saeed@kernel.org/
> [2] https://lore.kernel.org/lkml/20211208141722.13646-1-shayd@nvidia.com/

Post them as a reply to the pull request like you usually do, please.
