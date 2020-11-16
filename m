Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB92B4C24
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgKPRGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:06:37 -0500
Received: from devianza.investici.org ([198.167.222.108]:42465 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbgKPRGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:06:37 -0500
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4CZb8B3sKsz6vMV;
        Mon, 16 Nov 2020 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605546394;
        bh=1728LY6WO61ZBnNeVZNds1Pd/nP78DAwyQe8T/HtmJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GP42SCO0XBsbwdUR8HapJHSXr/RkjEFAMm8eU2obxrhQvu7vTiCDouv6YgyOzdKJM
         pU5pKS+MtIhcbOCq22Ff5AVdZE8dkwWVQOKIE27ekKcAS5wJMfLtKuGF/4Dxx9vt8P
         iL7l/D9zM2GGUuhX0ds/dE+9PqskJyrSCu6K9rCk=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CZb8B1nhCz6vLs;
        Mon, 16 Nov 2020 17:06:34 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Mon, 16 Nov 2020 18:06:33 +0100
Message-ID: <3291815.yzSIL3OBH5@machine>
In-Reply-To: <20201116080652.5eae929c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com> <7105193.AbosYe1RmR@machine> <20201116080652.5eae929c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le lundi 16 novembre 2020, 17:06:52 CET Jakub Kicinski a =E9crit :
> On Sun, 15 Nov 2020 18:05:39 +0100 Francis Laniel wrote:
> > Le dimanche 15 novembre 2020, 01:18:37 CET Jakub Kicinski a =E9crit :
> > > On Fri, 13 Nov 2020 10:56:26 -0800 Kees Cook wrote:
> > > > Thanks! This looks good to me.
> > > >=20
> > > > Jakub, does this look ready to you?
> > >=20
> > > Yup, looks good, sorry!
> > >=20
> > > But it didn't get into patchwork cleanly :/
> > >=20
> > > One more resend please? (assuming we're expected to take this
> > > into net-next)
> >=20
> > I will send it again and tag it for net-next.
> >=20
> > Just to know, is patchwork this:
> > https://patchwork.kernel.org/project/netdevbpf/list/
>=20
> Yes, that's the one.

OK! The tool seems cool.

So normally I resend the patches, but I do not see them in patchwork.
Is there something am I supposed to do so they can be visible through=20
patchwork?


