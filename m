Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58C02B4F0C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732004AbgKPSSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbgKPSSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:18:31 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB143C0613CF;
        Mon, 16 Nov 2020 10:18:31 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CZcl90C9Yz114N;
        Mon, 16 Nov 2020 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605550709;
        bh=yR555kwwCUU6ZooTL6o5K7/FoyRH7zdLKxUHBYLqnsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsQ9I23HwK3WReghUhBeMBbGKVGItNnubtBTHuAdMfGIQIEDdbaugRnXi7+NHU05I
         Awwi505TxSsIA6kVV7mVVrcqmOBqGAD54qQH592Ut4+bCqJM7YizImHfhsUA5dEl1X
         166oMxiGii3vpTEOj+5iHUsJ+EAGJqV9B29k4bRc=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CZcl85v39z10qw;
        Mon, 16 Nov 2020 18:18:28 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Mon, 16 Nov 2020 19:18:27 +0100
Message-ID: <3073458.2cBt0YhbhG@machine>
In-Reply-To: <20201116093243.3557280a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com> <3291815.yzSIL3OBH5@machine> <20201116093243.3557280a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le lundi 16 novembre 2020, 18:32:43 CET Jakub Kicinski a =E9crit :
> On Mon, 16 Nov 2020 18:06:33 +0100 Francis Laniel wrote:
> > Le lundi 16 novembre 2020, 17:06:52 CET Jakub Kicinski a =E9crit :
> > > On Sun, 15 Nov 2020 18:05:39 +0100 Francis Laniel wrote:
> > > > Le dimanche 15 novembre 2020, 01:18:37 CET Jakub Kicinski a =E9crit=
 :
> > > > > On Fri, 13 Nov 2020 10:56:26 -0800 Kees Cook wrote:
> > > > > > Thanks! This looks good to me.
> > > > > >=20
> > > > > > Jakub, does this look ready to you?
> > > > >=20
> > > > > Yup, looks good, sorry!
> > > > >=20
> > > > > But it didn't get into patchwork cleanly :/
> > > > >=20
> > > > > One more resend please? (assuming we're expected to take this
> > > > > into net-next)
> > > >=20
> > > > I will send it again and tag it for net-next.
> > > >=20
> > > > Just to know, is patchwork this:
> > > > https://patchwork.kernel.org/project/netdevbpf/list/
> > >=20
> > > Yes, that's the one.
> >=20
> > OK! The tool seems cool.
> >=20
> > So normally I resend the patches, but I do not see them in patchwork.
> > Is there something am I supposed to do so they can be visible through
> > patchwork?
>=20
> They were visible, this is your resend:
>=20
> https://patchwork.kernel.org/project/netdevbpf/list/?series=3D384457&stat=
e=3D*
>=20
> (note the * at the end, sometimes it gets stripped when clicking on a
> link)
>=20
> Maybe you checked after I already applied them, patches which had been
> "handled" (aka "Action required=3Dno") are not displayed by default.

Working of patchwork is now clearer for me, thank you!
But yes I think I checked after you applied them.



