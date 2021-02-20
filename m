Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762403205F9
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBTPuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 10:50:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhBTPuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 10:50:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDUVW-007X6u-1j; Sat, 20 Feb 2021 16:49:22 +0100
Date:   Sat, 20 Feb 2021 16:49:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Serge Semin <fancer.lancer@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <YDEvglPLbUcNp0dR@lunn.ch>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
 <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
 <20210210164720.migzigazyqsuxwc6@mobilestation>
 <20210211103941.GW1463@shell.armlinux.org.uk>
 <20210220090248.oiyonlfucvmgzw6d@mobilestation>
 <4dcecf82-f222-4957-f5fc-e8f9d073599c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dcecf82-f222-4957-f5fc-e8f9d073599c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If in doubt, leaving the patch as is would be fine with me.

The patch is O.K. as is, no need to export something so simple for a
single users. When the next user come along, we can reconsider.

       Andrew
