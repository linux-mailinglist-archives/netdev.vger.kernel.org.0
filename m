Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8666303548
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbhAZFir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732050AbhAZCfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:35:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E997922597;
        Tue, 26 Jan 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611628488;
        bh=h/E3TukMgw6yPHxLONt2DoWslLEkA9x2ERLKq9CpXQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=usUg3mKQ9NtxwIsGY5jdjQ6eG4MhJHnnLGnNyaIHgrnLgoWVMUj7X69chvYxdtr2x
         v9vT6Z2496cmpk34OB3qeFTUAT+LDfy9FGh389gLGSOtB/lsvD8jI5aCv14fszMERI
         neVSYKPikcJkceAX1cVAfotdjxzmTbWRrnkOzz5NWbo3WWarqnqPyCQtZuHb8Ey2Cv
         5mvXm1s5jwueXNLe/g367tm8hGQe5D9zeXPCVTr+5oy4yFl4NuRTn7owpkpX5Urzv0
         P8rOSr/fCq+Fz1s8tLTuOrRWYEHeqVWluL0e9O0aRdWgGpiLyDctxE28op5HIZ6VwZ
         OQCt8ez9j4/Uw==
Date:   Mon, 25 Jan 2021 18:34:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next v2 0/2] dsa: add MT7530 GPIO support
Message-ID: <20210125183446.1d6243a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125044322.6280-1-dqfext@gmail.com>
References: <20210125044322.6280-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 12:43:20 +0800 DENG Qingfang wrote:
> MT7530's LED controller can be used as GPIO controller. Add support for
> it.

I added back Rob's tag and all the missing tags which patchwork 
did not register. Damn thing is really flaky right now. Anyway..

Applied, thanks everyone!
