Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A98342673
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhCSTrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhCSTrg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:47:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2F8F6197B;
        Fri, 19 Mar 2021 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616183255;
        bh=CgFrEtJjrIrteM61RV+ReBqXzV/w19WksIQ9MjkW6Vw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bjF5FOl7oVri4FEUBxhr38QMvcE4yj+DCvcdP2XR6RU/mgm3N+qVxN91n4jzabvKk
         MJufaSrP4n9gYzS03gbQBz0Bi6OSfkZFVzz2aMuY+fWX5rzRPpzqgEx3K9Mk78w/nv
         LTlpFn10xtB09tr+HSjJjOIt6KMfANx7dfJNt8RI1JtZPXFxRAzo/3g+jNRPqlJPyw
         r1aDfnRp+yt6FuK6QJXtZuvKks8kNjQwSHof43/u0hFXUVh/W06jM/FYtLWSzzDw4f
         SRL1nM3Mk1Rtce+1cw7Nim0y87pnJBvNpPjrajvLsh4Z4RqbPtPZKv9VDEdJoqggEu
         +F4bFJb/gnBMg==
Date:   Fri, 19 Mar 2021 20:47:32 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
Message-ID: <20210319204732.320582ef@kernel.org>
In-Reply-To: <20210319185820.h5afsvzm4fqfsezm@skbuf>
References: <20210319143149.823-1-kabel@kernel.org>
        <20210319185820.h5afsvzm4fqfsezm@skbuf>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Mar 2021 20:58:20 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Beh=C3=BAn wrote:
> > We know that the `lane =3D=3D MV88E6393X_PORT0_LANE`, so we can pass `l=
ane`
> > to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
> >=20
> > All other occurances in this function are using the `lane` variable.
> >=20
> > It seems I forgot to change it at this one place after refactoring.
> >=20
> > Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> > Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
> > --- =20
>=20
> Either do the Fixes tag according to the documented convention:
> git show de776d0d316f7 --pretty=3Dfixes

THX, did not know about this.

> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x fam=
ily")
>
> or even better, drop it.

Why better to drop it?
