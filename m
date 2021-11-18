Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A3D455F45
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKRPYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhKRPXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 10:23:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EEC161A8A;
        Thu, 18 Nov 2021 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637248853;
        bh=c55CV7rKW3TlOx26U0xXr9FALS585wsaQxOGjab2QXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZAybsLrkd/uaclDFuYwgaK3zjPYoyu+hUDQv/3FmKBhRvI6ZbJ+AhvKXV8VCWzj/U
         B1N7vY/phROBvdvSvIObZeY/4TXHqYBTIKxKgo4PUJ9UpQMOmm3mKNg5ZTJs7JH1KZ
         VbjWWQkCcOHzdDiZo/1N05ksdfb7XiguYFMB7bqDLToPZs2d+3Ctk0nNHVmFiHDcYg
         mdxkXToAoVojkHT/igfEZy0bYLr0ANGcFfEpwpaOwqLA0/D+ewCoUhp++ymSGj0yvD
         F6pk10/z82BQSlETpaGFu+ck5ANK6N49RLaW1/ckRGCFCgcW93gqYxgtNsEKrYS489
         7q4LPW9VnuXKQ==
Date:   Thu, 18 Nov 2021 16:20:21 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host
 interface configuration
Message-ID: <20211118162021.6f8613af@thinkpad>
In-Reply-To: <20211118150951.jzwl5jickilxbfhy@skbuf>
References: <20211117225050.18395-1-kabel@kernel.org>
        <20211117225050.18395-9-kabel@kernel.org>
        <20211118120334.jjujutp5cnjgwjq2@skbuf>
        <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
        <20211118142039.uocgddbpplwwsfdk@skbuf>
        <YZZnkEn76a3Q0hAY@shell.armlinux.org.uk>
        <20211118150951.jzwl5jickilxbfhy@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 17:09:51 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> Speaking of that, do you know of any SFP modules that would use USXGMII?
> It doesn't appear to be listed in the spec sheet when looking for that.

RollBall 10G SFP modules, which this series prepares support for,
contain 88X3310 PHY and thus can work in USXGMII. By defualt they use
MACTYPE=6 (10gbase-r with rate matching), but when this series and
the series that adds support for RollBall SFPs are merged, then the SFP
module will work in USXGMII if USXGMII is supported by the host MAC.

Marek
