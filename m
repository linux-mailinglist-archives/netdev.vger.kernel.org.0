Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD84E43AA46
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 04:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhJZC0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 22:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229998AbhJZC0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 22:26:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2320E60FC2;
        Tue, 26 Oct 2021 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635215036;
        bh=ToJqxibE4UI0QuQXmA1DYPxxVV7vSiMlcTNF3KOtVLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=twxu8Bka6McttdF7oWeyG0j5hZULAy7xu2omrRF2j9AgYkVvzUcM8Qsudl69/0EMu
         GBPOe/iR3E9grAo+1mswwBSBT2fZ6fzyDfGy5F/0oORXtP8ivH1oF4mEfXB/RQq/R0
         eGAScUGrax50jhbkeKUOcZLnda3juv4HWwUD/pFMu5uRe63LxV/wZufrabcPhRu3EH
         lQlY8QXHKa7a3Rv/sOocqJ6z3Ry3XtOgXh10BNKo6QE3ELxJKjppOwAY0SGX+2Lla5
         p1h5ZRlKIZqkr1wz3LVFbRD2mVJCOyTZ8+Skpg6vWkKdbLl+48PCgfqjCRTyfWKMvI
         c4aNkNzTdylpA==
Date:   Mon, 25 Oct 2021 19:23:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ax88796c: fix fetching error stats from percpu
 containers
Message-ID: <20211025192355.146adf6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftj5ytkop7q.fsf%l.stelmach@samsung.com>
References: <20211023121148.113466-1-alobakin@pm.me>
        <CGME20211025195411eucas1p1f3a6830d6d0fdaac54633a0c321a55a0@eucas1p1.samsung.com>
        <dleftj5ytkop7q.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 21:54:01 +0200 Lukasz Stelmach wrote:
> It was <2021-10-23 sob 12:19>, when Alexander Lobakin wrote:
> > rx_dropped, tx_dropped, rx_frame_errors and rx_crc_errors are being
> > wrongly fetched from the target container rather than source percpu
> > ones.
> > No idea if that goes from the vendor driver or was brainoed during
> > the refactoring, but fix it either way. =20
>=20
> It may be the latter. Thank you for fixing.
>=20
> >
> > Fixes: a97c69ba4f30e ("net: ax88796c: ASIX AX88796C SPI Ethernet Adapte=
r Driver")
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  drivers/net/ethernet/asix/ax88796c_main.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > =20
>=20
> Acked-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>

Applied, thanks!
