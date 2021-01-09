Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCFC2EFD63
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAIDVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbhAIDVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 369482399C;
        Sat,  9 Jan 2021 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610162433;
        bh=9fgLqNDvl5FpQW1E7Dy2WwxfxEBwHyxXARfe/Pe3qqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YQHRKzeyp174iwRhZpOYbgVUepnZKseZlBfBcVBBsiKHbuG8mwycXkxagMYzqEwi0
         nveC0JRFOaMYKWbpoC83UO2Lq9bbO0KxTTJFYSjK4FbggcApzc6MLYubluTvdzvRo7
         m37A1phxvZtuRSx79iuG3tOwh/A4HTW8gUg0zD8162h+2jd/sielDHxLtYYKS6FsUt
         MpYx2s9S4XM8Npc4Qx5ttE+w1Cj0oqbrFqxo+UvpbPWzrcgsF0BFE4/J5Z5hL/5qLq
         /ftAybDBZI3FY9fIOzUtOu9qDHZ34YATO6vBxJ5jLmQy1ubotZ9PW7ILCOUFmaSoW5
         TTtHNSt2efr0w==
Date:   Fri, 8 Jan 2021 19:20:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Doug Berger <opendmb@gmail.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Murali Krishna Policharla <murali.policharla@broadcom.com>,
        Timur Tabi <timur@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 net-next 3/3] MAINTAINERS: add bgmac section entry
Message-ID: <20210108192032.71d1610a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1a80cea6-6a53-4399-8cf0-ada4e0714b20@gmail.com>
References: <20210107180051.1542-1-zajec5@gmail.com>
        <20210107180051.1542-3-zajec5@gmail.com>
        <1a80cea6-6a53-4399-8cf0-ada4e0714b20@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 12:08:58 -0800 Florian Fainelli wrote:
> On 1/7/21 10:00 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >=20
> > This driver exists for years but was missing its MAINTAINERS entry.
> >=20
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> =20
>=20
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
