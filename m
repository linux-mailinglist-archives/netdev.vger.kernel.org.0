Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0253E5253B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfFYHuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 03:50:50 -0400
Received: from gloria.sntech.de ([185.11.138.130]:38838 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfFYHuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 03:50:50 -0400
Received: from ip5f5a6320.dynamic.kabel-deutschland.de ([95.90.99.32] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1hfgDq-0002jy-Qy; Tue, 25 Jun 2019 09:50:34 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stmmac regression on ASUS TinkerBoard
Date:   Tue, 25 Jun 2019 09:50:34 +0200
Message-ID: <4489696.oEgVQY3s1y@diego>
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9D7065@DE02WEMBXB.internal.synopsys.com>
References: <8fa9ce79-6aa2-d44d-e24d-09cc1b2b70a3@katsuster.net> <78EB27739596EE489E55E81C33FEC33A0B9D7065@DE02WEMBXB.internal.synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Dienstag, 25. Juni 2019, 09:46:12 CEST schrieb Jose Abreu:
> From: Katsuhiro Suzuki <katsuhiro@katsuster.net>
> 
> > I checked drivers/net/ethernet/stmicro/stmmac/stmmac_main.c and found
> > stmmac_init_phy() is going to fail if ethernet device node does not
> > have following property:
> >    - phy-handle
> >    - phy
> >    - phy-device
> > 
> > This commit broke the device-trees such as TinkerBoard. The mdio
> > subnode creating a mdio bus is changed to required or still optional?
> 
> Yeah, with PHYLINK the PHY binding is always required ...
> 
> How do you want to proceed ? I think DT bindings can never break between 
> releases so I will probably need to cook a patch for stmmac.

Correct ... old devicetrees on new kernels should not break.
Especially as this affects a big number of boards potentially loosing
network support and in the devicetree binding the phy property is also
marked as optional.

Heiko


