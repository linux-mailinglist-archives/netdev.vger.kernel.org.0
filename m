Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04E02B4D16
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732849AbgKPRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:32:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730530AbgKPRcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 12:32:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B930322245;
        Mon, 16 Nov 2020 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605547965;
        bh=ZjCJR55S4lkuCHgNJg6II0tkGYCD7CG3pNzOIOnyG9U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FD093mg86lzvk9XcHSAIR2+2k/wZiMmJivx6vc3zJkGGlbN9RD1dYGISyLLNwUzZF
         dAnbQZFfHqmWFXgrMHmuVf9VJFUd50I8lb21c3vsoPHYn4Km6x/wit2MVhKU1AORiw
         vl2ULIcVvIYo8Q3UVzNq//zBh19ZLgP1g/3PjcQE=
Date:   Mon, 16 Nov 2020 09:32:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francis Laniel <laniel_francis@privacyrequired.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Message-ID: <20201116093243.3557280a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3291815.yzSIL3OBH5@machine>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
        <7105193.AbosYe1RmR@machine>
        <20201116080652.5eae929c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3291815.yzSIL3OBH5@machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 18:06:33 +0100 Francis Laniel wrote:
> Le lundi 16 novembre 2020, 17:06:52 CET Jakub Kicinski a =C3=A9crit :
> > On Sun, 15 Nov 2020 18:05:39 +0100 Francis Laniel wrote: =20
> > > Le dimanche 15 novembre 2020, 01:18:37 CET Jakub Kicinski a =C3=A9cri=
t : =20
> > > > On Fri, 13 Nov 2020 10:56:26 -0800 Kees Cook wrote: =20
> > > > > Thanks! This looks good to me.
> > > > >=20
> > > > > Jakub, does this look ready to you? =20
> > > >=20
> > > > Yup, looks good, sorry!
> > > >=20
> > > > But it didn't get into patchwork cleanly :/
> > > >=20
> > > > One more resend please? (assuming we're expected to take this
> > > > into net-next) =20
> > >=20
> > > I will send it again and tag it for net-next.
> > >=20
> > > Just to know, is patchwork this:
> > > https://patchwork.kernel.org/project/netdevbpf/list/ =20
> >=20
> > Yes, that's the one. =20
>=20
> OK! The tool seems cool.
>=20
> So normally I resend the patches, but I do not see them in patchwork.
> Is there something am I supposed to do so they can be visible through=20
> patchwork?

They were visible, this is your resend:

https://patchwork.kernel.org/project/netdevbpf/list/?series=3D384457&state=
=3D*

(note the * at the end, sometimes it gets stripped when clicking on a
link)

Maybe you checked after I already applied them, patches which had been
"handled" (aka "Action required=3Dno") are not displayed by default.
