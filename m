Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725273428ED
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCSWzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhCSWyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 18:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E572C61974;
        Fri, 19 Mar 2021 22:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616194485;
        bh=eWPhA/bWXkO5ZUD4ChT7CJROgoXz28loQMM4SwXzZRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KjZ3JsrAjCzmi5Q1t4xrf4MEe6x3fnYFIScjpEw6VPU2U+4d5sUdP1np6ItQzFnFm
         cRNuay7xbf93G2gJ7riBhrcuAWuOvCevqZyhkyd212Z/P6Ui2TR1VigAoY/M/UGKs/
         uPC5SRPwWf9ezM6Umwefa4p0lded3MF5bZ8xiYgLsk7CS4gvARCXYqhT9qDM3/Dz5F
         v/ti2O8Yvrvpd3JRPo02X0Ryez7/RuQeSoAIdds3u7G326IUqPAmkGV4K1xBIEfYxF
         JRpRapsFWXi8YbBJOVfn293sQFyRcdeptFdOLdB6hRwXRDmzzSglp0eFYGc5GHBSD1
         WLp1Fc/xGeO8g==
Date:   Fri, 19 Mar 2021 23:54:40 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
Message-ID: <20210319235440.3b964108@kernel.org>
In-Reply-To: <e6bfbd22-aee7-eaba-46cd-50853d243c78@gmail.com>
References: <20210319143149.823-1-kabel@kernel.org>
        <20210319185820.h5afsvzm4fqfsezm@skbuf>
        <20210319204732.320582ef@kernel.org>
        <e6bfbd22-aee7-eaba-46cd-50853d243c78@gmail.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Mar 2021 15:14:52 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 3/19/2021 12:47 PM, Marek Beh=C3=BAn wrote:
> > On Fri, 19 Mar 2021 20:58:20 +0200
> > Vladimir Oltean <olteanv@gmail.com> wrote:
> >  =20
> >> On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Beh=C3=BAn wrote: =20
> >>> We know that the `lane =3D=3D MV88E6393X_PORT0_LANE`, so we can pass =
`lane`
> >>> to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
> >>>
> >>> All other occurances in this function are using the `lane` variable.
> >>>
> >>> It seems I forgot to change it at this one place after refactoring.
> >>>
> >>> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> >>> Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
> >>> ---   =20
> >>
> >> Either do the Fixes tag according to the documented convention:
> >> git show de776d0d316f7 --pretty=3Dfixes =20
> >=20
> > THX, did not know about this.
> >  =20
> >> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x =
family")
> >>
> >> or even better, drop it. =20
> >=20
> > Why better to drop it? =20
>=20
> To differentiate an essential/functional fix from a cosmetic fix. If all
> cosmetic fixes got Fixes: tag that would get out of hands quickly.

IMO in this case the Fixes tag is not necessary beacuse the base commit
is not in any stable kernel yet.

But if the base commit was in a stable kernel already, and this
cosmetic fix was sent into net-next / net, I think the Fixes tag should
be there, in order for it to get applied into stable releases so that
future fixes could be applied cleanly.

Or am I wrong? This is how I understand this whole system...

Marek
