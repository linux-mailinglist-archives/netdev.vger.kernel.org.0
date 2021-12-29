Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BBD48167E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhL2T5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:57:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50728 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhL2T5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:57:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B09B2B81A02;
        Wed, 29 Dec 2021 19:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D45C36AE9;
        Wed, 29 Dec 2021 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640807830;
        bh=9iIKxDJ6rdWTzuq1xxra5GTy79QIwPqyaKLFoL4xSOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gaIkoqwI2RMRrnSlF6O5dzhFeD9W91RPWBojSflrZOHRy1KnqS4Slum49fjD7jfHI
         nXxMa52nltTN8ve/CODNTD6qGPxt2dIZX1frpHleUeH6XxMuumIGY4IUP0hs/9x1bW
         e8xTJqXAM9zX0eOw6hgs/uA0kxwVPKgT1Nx19INGoDGTBULYK74/IlkZL6vXQh3WDJ
         SbA1JLgUnrIjKpSser9HPTYGLRlIKN4zVRPrv66gncS8raz6/3tE+wEFVghnK+zBRc
         PhsRju6YN9H2LtpZcCvJEQdxsVgeIK7KofwpjtRoKhyEMFk+GT24ORfuKAx995Gy05
         CZDGtj7GKTt1w==
Date:   Wed, 29 Dec 2021 11:57:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Tamir Duberstein <tamird@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: check passed optlen before reading
Message-ID: <20211229115708.53ec5f8e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+FuTSe0yPhca+2ZdyJD4FZumLPd85sChGhZPpXhu=ADuwtYrQ@mail.gmail.com>
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
        <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
        <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com>
        <CAJ-ks9=3o+rVJd5ztYbkgpcYiWjV+3qajCgOmM7AfjhoZvuOHw@mail.gmail.com>
        <CA+FuTSe0yPhca+2ZdyJD4FZumLPd85sChGhZPpXhu=ADuwtYrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 14:53:10 -0500 Willem de Bruijn wrote:
> On Wed, Dec 29, 2021 at 2:50 PM Tamir Duberstein <tamird@gmail.com> wrote:
> >
> > I'm having some trouble sending this using git send-email because of
> > the firewall I'm behind.
> >
> > Please pull from
> >   git://github.com/tamird/linux raw-check-optlen
> > to get these changes:
> >   280c5742aab2 ipv6: raw: check passed optlen before reading
> >
> > If this is not acceptable, I'll send the patch again when I'm outside
> > the firewall. Apologies.  
> 
> I can send it on your behalf, Tamir.

Or we can use this opportunity to try out the infra Konstantin had been
working on:

https://lore.kernel.org/all/20211217183942.npvkb3ajnx6p5cbp@meerkat.local/

b4 submit --send seems to support sending via some web thing?

Dunno if anyone tried it, yet.
