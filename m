Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2065D315149
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBIOMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:12:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhBIOMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 09:12:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9Tjx-0057rG-Nl; Tue, 09 Feb 2021 15:11:41 +0100
Date:   Tue, 9 Feb 2021 15:11:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <YCKYHay9PsR2o04z@lunn.ch>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <YCGSwZnSXIz5Ssef@lunn.ch>
 <20210209111609.tjxoqr6stkcf22jy@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209111609.tjxoqr6stkcf22jy@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Regarding splitting the series up. I don't see a problem in just
> sending the cover-letter patch and actual GPIO-related patches to
> the GPIO-maintainers with no need to have them added to Cc in the rest
> of the series.

The Linux community has to handle a large number of patches. I don't
particularly want patches which are of no relevance to me landing in
my mailbox. It might take 4 or 5 rounds for the preparation patches to
be accepted. That is 4 or 5 times you are spamming the GPIO
maintainers with stuff which is not relevant to them.

One of the unfortunately things about the kernel process is, there are
a lot of developers, and not many maintainers. So the processes need
to make the life of maintainers easier, and not spamming them helps.

   Andrew
