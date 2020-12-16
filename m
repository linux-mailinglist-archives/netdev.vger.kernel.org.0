Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4121E2DC95F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 00:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgLPXC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 18:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgLPXC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 18:02:56 -0500
Date:   Wed, 16 Dec 2020 15:02:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608159736;
        bh=xWaUaF6H2sV0oa1UYcGurY64BS3za79d+HSSCPPGOaM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gi8igrCmv6kM/tZ5R8EKsDU8OEmyom536ACqObYJkdrySfCA/Xm/6I8ATuvbWG6be
         cXHeZqhCWOV4CMeUMUQac5kcwTVxeO+xAgB7l6H/Dx5yg17tFBVKsqiEhtMuKcBYAQ
         oZgdYeR09q+V4/V4yWXb0TYXsveHTLpwt6KD4cyQaAoM10LKaOwQg8nT6N60hl/6UJ
         iu3/Jzw05v2st3m7ln5RUQ3zT0YEl0qqRW90DfmwSdfkgkuDIQmyJN8irsoY8eIHh6
         gyNd9hv5SpRQaUT3sG6BY3KOkdDpOWZ+mG3+3Z2MeudQZXEDlHrcMofkYXz5k+7zZc
         rt8tS6Et4RwRw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: korina: fix return value
Message-ID: <20201216150215.6b7f724d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7e175246-5357-ccf6-6c7e-5f68089f30bf@gmail.com>
References: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201214220952.19935-1-vincent.stehle@laposte.net>
        <20201216124343.2848f0d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7e175246-5357-ccf6-6c7e-5f68089f30bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 13:32:26 -0800 Florian Fainelli wrote:
> On 12/16/20 12:43 PM, Jakub Kicinski wrote:
> > On Mon, 14 Dec 2020 23:09:52 +0100 Vincent Stehl=C3=A9 wrote: =20
> >> The ndo_start_xmit() method must not attempt to free the skb to transm=
it
> >> when returning NETDEV_TX_BUSY. Therefore, make sure the
> >> korina_send_packet() function returns NETDEV_TX_OK when it frees a pac=
ket.
> >>
> >> Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MA=
C")
> >> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> >> Cc: David S. Miller <davem@davemloft.net>
> >> Cc: Florian Fainelli <florian.fainelli@telecomint.eu> =20
> >=20
> > Let me CC Florian's more recent email just in case he wants to review. =
=20
>=20
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

=F0=9F=98=AC

Applied, thanks!
