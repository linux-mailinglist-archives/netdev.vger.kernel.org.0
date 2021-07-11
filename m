Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D8A3C3CBE
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 15:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhGKNM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 09:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231658AbhGKNM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 09:12:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B3C0610A7;
        Sun, 11 Jul 2021 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626008982;
        bh=CPopi/6VucVgtuP6wNJQWL88ep64+0x8+PQZEG4nrlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z0QVRGlhNTyby5GNHh5xnFrSNptr7YAdg4xWNqt8F5VDHVK5pFuJZROIxYgXj7j+w
         fvhjuZTdOvuBTybXKrh/q1TDJA3VCBW36v5YPND7/5XK2JtjOqRgnaUXWcqKtNVvnO
         pVdJj+37gFbuah6akbdgh9fYBqpKWGWaSeSadrUrY0HsL64yIUVUE5wQFGePK0SeLW
         CDjfOlsrEnhOUCNPmHY+VudNammKdt1QFFlb0EBZrMNN/fjmP6RbLzOAj8Pb8t248C
         O+Ga38FmXKxYWrB7zODjyhLy3ebpt1WPY6BkjAOrAaHQdUMNbR4ECXVY7gapYmfrQu
         OoW/B+mS0hjfA==
Date:   Sun, 11 Jul 2021 15:09:36 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v4 11/16] net: phy: marvell10g: add separate
 structure for 88X3340
Message-ID: <20210711150936.776497a3@thinkpad>
In-Reply-To: <CAFnufp3CokRFn5zfsWgJdZTE2TrHPtqjpPJnBxhDXowUQfxLwQ@mail.gmail.com>
References: <20210407202254.29417-1-kabel@kernel.org>
        <20210407202254.29417-12-kabel@kernel.org>
        <CAFnufp3CokRFn5zfsWgJdZTE2TrHPtqjpPJnBxhDXowUQfxLwQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 18:12:24 +0200
Matteo Croce <mcroce@linux.microsoft.com> wrote:

> On Wed, Apr 7, 2021 at 10:24 PM Marek Beh=C3=BAn <kabel@kernel.org> wrote:
> >
> > The 88X3340 contains 4 cores similar to 88X3310, but there is a
> > difference: it does not support xaui host mode. Instead the
> > corresponding MACTYPE means
> >   rxaui / 5gbase-r / 2500base-x / sgmii without AN
> >
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > --- =20
>=20
> Hi,
>=20
> this breaks the 10G ports on my MacchiatoBIN.
> No packets can be received with this commit in, but booting an old
> kernel and rebooting into net-next fixes it until the next power
> cycle.
>=20
> I tried to revert it and the 10G ports now works again, even after a cold=
 boot.
>=20
> Regards,

Will look into this and send a fix.
Marek
