Return-Path: <netdev+bounces-8194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C647723126
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80BED1C20D92
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E46D261CB;
	Mon,  5 Jun 2023 20:21:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A9261CA
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB36C433D2;
	Mon,  5 Jun 2023 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685996494;
	bh=3uQVwGOLFaI4BuNA3c7TJLcVOBzsB/Nr14Qh97bt0kA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cRDZI9xqWgJ1jmSIAdA91mN/bIjkFUjrEi6UjA7TPalx7VRmMtihm31lev67U3R4E
	 zZq2bK2eyWKb1WaHpmNUfg+WKm9q1DXnehJYu7Wwku3YXyU7rCgsKuTWtvdpIdeTYW
	 jnmFhBfYPVpw9fkmZ/vqMoikfLd5gsUX6V6ex2wpJXHuGrxvXTrX2++hL29RktEv1w
	 wrZiunfJ0jseUORH1Q2t6bh91iBo1h2DLm3FRUVuLP3qednblGM7nQ5G67/AFzJsIn
	 qIbyvljh3owpvgTua1O9J811/J4Mn+uxiJWixw+S/u52d7gIUkh+RhrC+ndzMpnWj3
	 8gAhanuDMLzew==
Date: Mon, 5 Jun 2023 13:21:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
Cc: Christian Lamparter <chunkeey@gmail.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "luizluca@gmail.com" <luizluca@gmail.com>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>, "andrew@lunn.ch"
 <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
 "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Message-ID: <20230605132133.42eeee14@kernel.org>
In-Reply-To: <6uu5s53xi6b7s5yzjfrl7fh3pxotoyge2iyt3avwggwrn3i6vc@xywb2jpqxfro>
References: <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
	<xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
	<802305c6-10b6-27e6-d154-83ee0abe3aeb@gmail.com>
	<6uu5s53xi6b7s5yzjfrl7fh3pxotoyge2iyt3avwggwrn3i6vc@xywb2jpqxfro>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Jun 2023 19:19:45 +0000 Alvin =C5=A0ipraga wrote:
> > so that's why I said it was "by accident" in the commit message.
> > Since the other macros stayed intact. =20
>=20
> Yes, agree. Do you agree with me though that this doesn't warrant backpor=
ting to
> stable as there is no functional change with just the patch on its own?
> i.e. this should be part of a broader series adding RTL8363SB-CG support
> targetting net-next.

+1

> (The Fixes: tag is absolutely fine ofc - stable maintainers
> will tell you that this does not necessarily mean it should go in stable,=
 that's
> what cc: stable@vger is for). If so please add [PATCH v2 net-next] so it =
goes in
> the right place.

I'd remove the Fixes tag as well, and clearly state in the commit msg
that this patch is a noop for all devices currently supported upstream.
--=20
pw-bot: cr

