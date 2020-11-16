Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38722B4A4A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgKPQGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729467AbgKPQGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 11:06:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65F4B20729;
        Mon, 16 Nov 2020 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605542813;
        bh=3UwiqAr5SzNLGmr7WOyZYJ4hK+K9YmO3ZFl1kuum5sA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AEXxjJ1IJdvCOge4p1Nzz0VrFbMdhbAYLRqVxhXee0gFTH/amoZn0lV4+bDbiOa8z
         gfRnSmgZsIaPCpxTonJ6CELs44CiqTCeHZperi47dsCRp8Pd9QlZIxIuGA8SC1IphJ
         KRagF6SCNy+46NDH0oYYpXUVIrHnH47Jkk3nJsYw=
Date:   Mon, 16 Nov 2020 08:06:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francis Laniel <laniel_francis@privacyrequired.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Message-ID: <20201116080652.5eae929c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7105193.AbosYe1RmR@machine>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
        <202011131054.28BD6A9@keescook>
        <20201114161837.10f58f95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7105193.AbosYe1RmR@machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 18:05:39 +0100 Francis Laniel wrote:
> Le dimanche 15 novembre 2020, 01:18:37 CET Jakub Kicinski a =C3=A9crit :
> > On Fri, 13 Nov 2020 10:56:26 -0800 Kees Cook wrote: =20
> > > Thanks! This looks good to me.
> > >=20
> > > Jakub, does this look ready to you? =20
> >=20
> > Yup, looks good, sorry!
> >=20
> > But it didn't get into patchwork cleanly :/
> >=20
> > One more resend please? (assuming we're expected to take this
> > into net-next) =20
>=20
> I will send it again and tag it for net-next.
>=20
> Just to know, is patchwork this:
> https://patchwork.kernel.org/project/netdevbpf/list/

Yes, that's the one.
