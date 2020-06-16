Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E511FABF0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 11:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgFPJKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 05:10:36 -0400
Received: from gloria.sntech.de ([185.11.138.130]:34534 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgFPJKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 05:10:36 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jl7bw-0007eo-3o; Tue, 16 Jun 2020 11:10:28 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v3 1/3] net: phy: mscc: move shared probe code into a helper
Date:   Tue, 16 Jun 2020 11:10:27 +0200
Message-ID: <1656001.WqWBulSbu3@diego>
In-Reply-To: <20200615.181225.2016760272076151342.davem@davemloft.net>
References: <20200615144501.1140870-1-heiko@sntech.de> <20200615.181129.570239999533845176.davem@davemloft.net> <20200615.181225.2016760272076151342.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Dienstag, 16. Juni 2020, 03:12:25 CEST schrieb David Miller:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 15 Jun 2020 18:11:29 -0700 (PDT)
> > +	return devm_phy_package_join(&phydev->mdio.dev, phydev,
> > +				     vsc8531->base_addr, 0);
> 
> But it is still dereferenced here.
> 
> Did the compiler really not warn you about this when you test built
> these changes?

I'm wondering that myself ... it probably did and I overlooked it, which
also is indicated by the fact that  I did add the declaration of the
vsc8531 when rebasing.

> > Because you removed this devm_kzalloc() code, vsc8531 is never initialized.
> 
> You also need to provide a proper header posting when you repost this series
> after fixing this bug.

not sure I understand what you mean with "header posting" here.

Thanks
Heiko


