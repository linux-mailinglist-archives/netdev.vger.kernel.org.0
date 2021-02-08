Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F2C313F43
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhBHTij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:38:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56178 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236371AbhBHThW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:37:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9CKn-004vUw-8i; Mon, 08 Feb 2021 20:36:33 +0100
Date:   Mon, 8 Feb 2021 20:36:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] net: stmmac: Add DW MAC GPIOs and Baikal-T1 GMAC
 support
Message-ID: <YCGSwZnSXIz5Ssef@lunn.ch>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:08:04PM +0300, Serge Semin wrote:

Hi Serge

I suggest you split this patchset up. This uses the generic GPIO
framework, which is great. But that also means you should be Cc: the
GPIO subsystem maintainers and list. But you don't want to spam them
with all the preparation work, which has little to do with the GPIO
code.

So please split the actual GPIO driver and DT binding patches from the
rest. netdev can review the preparation work, with a comment in the
0/X patch about what the big picture is, and then afterwards review
the GPIO patchset with a wider audience.

And as Jakub pointed out, nobody is going to review 60 patches all at
once. Please submit one series at a time, get it merged, and then
move onto the next.

	 Andrew
