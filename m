Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8B30C2BD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhBBO6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234927AbhBBO6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:58:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A37264F58;
        Tue,  2 Feb 2021 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612277848;
        bh=x80ikcQCXibw96rrG3IZPOwWRAOBGuEpB8MSkepn+wQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uw5Wu4ZUfl/PbEyx9gNxBYHc4EJPUXnDaLSEQmaWx9EHCK69Q8+dbKc0W3K7IxaGW
         DGDgM2WPjMy1/PLFkhmhUlt9U3WAeldm6KBdlNRVXMlPa7orTvy5PuUE40hW0lsWhj
         YLuIRDavEZD4BuLbQ3GM66fpi0Ze8PMMPwKhyoxr0oFDyjqipm9IycUCt5t4AIwM7U
         BfpOIq3ZAdRsv0QvVtVrdO3knTCnBsUn3yoTWKUZYcufdyCK1vfMWRnwS8azNwWf84
         Bh4Wielzhi6aNUHZy4AqLrJy1umym8Wkr1t32136DAcYRvr2FKMeSpnGyFZG5rEwOL
         hgZbLT8oEZ0iA==
Date:   Tue, 2 Feb 2021 16:57:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        coreteam@netfilter.org, Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>,
        LKML <linux-kernel@vger.kernel.org>, lvs-devel@vger.kernel.org,
        Matteo Croce <mcroce@redhat.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net 0/4] Fix W=1 compilation warnings in net/* folder
Message-ID: <20210202145724.GA3264866@unreal>
References: <20210202135544.3262383-1-leon@kernel.org>
 <CANn89iL4jGbr_6rr11nsHxmdh7uz=kqXuMhRb0nakWO3rBZwsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL4jGbr_6rr11nsHxmdh7uz=kqXuMhRb0nakWO3rBZwsQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 03:34:37PM +0100, Eric Dumazet wrote:
> On Tue, Feb 2, 2021 at 2:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Hi,
> >
> > This short series fixes W=1 compilation warnings which I experienced
> > when tried to compile net/* folder.
> >
>
> Ok, but we never had a strong requirement about W=1, so adding Fixes:
> tag is adding

I added because Jakub has checker that looks for Fixes lines in "net"
patches.

> unnecessary burden to stable teams all around the world.

It is automatic.

Thanks
