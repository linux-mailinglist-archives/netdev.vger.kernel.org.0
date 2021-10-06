Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBDF423565
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhJFBXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236969AbhJFBXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB2B610A3;
        Wed,  6 Oct 2021 01:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633483300;
        bh=kX/KhW74MgFnvaW6gH/eZQswdnlMQFt2a04nGsWlLmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jvoVYgls0AeCPZv6ekQhUcoiDw8JOd3f3XyR2rA3U2HaSO24Le2vFgWg/bka19DLv
         HELQ6bMqLx5BQ3Mu7zMrRpHL/u8SrxzwRAReXFDEgiImptZkqhefKFEb8qJ2+32Yz2
         vx3ka1z8Narmy/LBsfmTI56uGV0QZaCDmcEuaDLklwkRPxBF260hVDo54KwtcXiKWA
         lgkuTtfGqaPFqqqTBRjx1ySbBm7hqrp+aRorR9dW7jJjL+mZ7UK+wQ4ot1To6vMn8N
         zA6wc0lmR/1Y2GI1Cj3oAD8JY0D6CAipgnjfXKY4VraigUDmf7ItTiMmh9uu/OXXK7
         X9SJaYANY84DQ==
Date:   Tue, 5 Oct 2021 18:21:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 net-next 1/2] net: bgmac: improve handling PHY
Message-ID: <20211005182138.01b1bf98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211002175812.14384-1-zajec5@gmail.com>
References: <20211002175812.14384-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  2 Oct 2021 19:58:11 +0200 Rafa=C5=82 Mi=C5=82ecki wrote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> 1. Use info from DT if available
>=20
> It allows describing for example a fixed link. It's more accurate than
> just guessing there may be one (depending on a chipset).
>=20
> 2. Verify PHY ID before trying to connect PHY
>=20
> PHY addr 0x1e (30) is special in Broadcom routers and means a switch
> connected as MDIO devices instead of a real PHY. Don't try connecting to
> it.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> V2: Promote it out of RFC and send together with MDIO patch per
>     Florian's request.

Florian, ack?
