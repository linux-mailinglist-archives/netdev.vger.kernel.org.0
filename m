Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E472B36EF
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKORFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:05:43 -0500
Received: from devianza.investici.org ([198.167.222.108]:47001 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbgKORFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:05:43 -0500
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4CYz9c50Hcz6vMj;
        Sun, 15 Nov 2020 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605459940;
        bh=TCdQcphmgwyMGsoWSCbgniZ7fgrtS8ox93JBV9SE7WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQJrBPUlMHWi8HGKD4wvzfbxZ2361GTuUNefk6lVT325l5WjAe5YhdajArOwHtwOK
         FJLfEDzbLbfLTjTpuPpQy8tiN89/OZmPMWzv1n0gMMfapFtgWnd+A0q6Va0pd6esOm
         p7bAGluS9Ul/tT3LYrRtmLyiWi0RHxfTJ/gw9cn8=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CYz9c2h17z6vMh;
        Sun, 15 Nov 2020 17:05:40 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Sun, 15 Nov 2020 18:05:39 +0100
Message-ID: <7105193.AbosYe1RmR@machine>
In-Reply-To: <20201114161837.10f58f95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com> <202011131054.28BD6A9@keescook> <20201114161837.10f58f95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le dimanche 15 novembre 2020, 01:18:37 CET Jakub Kicinski a =E9crit :
> On Fri, 13 Nov 2020 10:56:26 -0800 Kees Cook wrote:
> > Thanks! This looks good to me.
> >=20
> > Jakub, does this look ready to you?
>=20
> Yup, looks good, sorry!
>=20
> But it didn't get into patchwork cleanly :/
>=20
> One more resend please? (assuming we're expected to take this
> into net-next)

I will send it again and tag it for net-next.

Just to know, is patchwork this:
https://patchwork.kernel.org/project/netdevbpf/list/
?



