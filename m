Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3623B32B3D9
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1840217AbhCCEHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361024AbhCBXNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 18:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 600E764F32;
        Tue,  2 Mar 2021 23:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614726758;
        bh=z9EqG01IvZ2R/J+3gyDwitPywq3vgh8fZQWCdI9t8bM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i/hTSPqO4BBtCLKn6WjhsWSQaJ1Th9KHLwd4jyfi+0anCF0PugWC5fIk+d16UWEiw
         fc+CNyIf6PpzdEbm6yXrbu9pA0IjfF7p1UrHsyoqWiXMa+Psd4N75s9IpdCVuYM1Kw
         sVJFIZ3t8Ejh4h1/Pu86oK/NuyxRbRcoZNYbgkqerIbVbaboDXCKN9fI2drymhPNdr
         F4iWxoyaZctLQ3gJuEAOq5pJcI58zxM+G7JRwt9iUehJ/lP/kcfo8+qFgbrhwnQUTP
         j+YMSs8kJpVrKkBOyenbuAsk+NnZUTJ9SRW1RKc3bvSDME7F/uBKfw5FaYvGwcoSAO
         7qYwDg1xX1jPw==
Date:   Tue, 2 Mar 2021 15:12:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH v3] net: usb: qmi_wwan: support ZTE P685M modem
Message-ID: <20210302151237.3e4e83cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bb636575-e32d-5d6f-16d1-dc75ce4f4f84@gmail.com>
References: <20210223183456.6377-1-lech.perczak@gmail.com>
        <161419020661.3818.15606819052802011752.git-patchwork-notify@kernel.org>
        <bb636575-e32d-5d6f-16d1-dc75ce4f4f84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 22:13:08 +0100 Lech Perczak wrote:
> On 2021-02-24 at 19:10, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This patch was applied to netdev/net.git (refs/heads/master):
> >
> > On Tue, 23 Feb 2021 19:34:56 +0100 you wrote: =20
> >> Now that interface 3 in "option" driver is no longer mapped, add device
> >> ID matching it to qmi_wwan.
> >>
> >> The modem is used inside ZTE MF283+ router and carriers identify it as
> >> such.
> >> Interface mapping is:
> >> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
> >>
> >> [...] =20
> > Here is the summary with links:
> >    - [v3] net: usb: qmi_wwan: support ZTE P685M modem
> >      https://git.kernel.org/netdev/net/c/88eee9b7b42e
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> > =20
> I see that the usb-serial counterpart of this patch was queued up for=20
> stable [1], so just for the sake of completeness, it might be worthy to=20
> consider this one too. This would likely make OpenWrt folks happy -=C2=A0=
 I=20
> think that going for 5.4.y and upper would suffice, as 5.4 is currently=20
> used as stable kernel there, and most of targets are switching to 5.10=20
> right now.
>=20
> Upstream commit is 88eee9b7b42e69fb622ddb3ff6f37e8e4347f5b2.
>=20
> [1]=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/t=
ree/queue-5.11/usb-serial-option-update-interface-mapping-for-zte-p685m.pat=
ch?id=3Da15ddfc3cd600b31862fdde91f8988e1cfc7bffe

Please send this request directly to stable@, we're through with=20
this patch on our end. Thanks!
