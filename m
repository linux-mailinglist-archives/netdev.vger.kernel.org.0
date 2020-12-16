Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB5C2DB8BC
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgLPCEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:04:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56562 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgLPCEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:04:42 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpMAV-00CD9O-GZ; Wed, 16 Dec 2020 03:03:55 +0100
Date:   Wed, 16 Dec 2020 03:03:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org,
        Serge Semin <fancer.lancer@gmail.com>,
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
Subject: Re: [RFC] net: stmmac: Problem with adding the native GPIOs support
Message-ID: <20201216020355.GA2893264@lunn.ch>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
 <20201214153143.GB2841266@lunn.ch>
 <20201215082527.lqipjzastdlhzkqv@mobilestation>
 <20201215135837.GB2822543@lunn.ch>
 <20201215145253.sc6cmqetjktxn4xb@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215145253.sc6cmqetjktxn4xb@mobilestation>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From what you are saying, it sounds like from software you cannot
> > independently control the GPIO controller reset?
> 
> No. The hardware implements the default MAC reset behavior. So the
> GPIO controller gets reset synchronously with the MAC reset and that
> can't be changed.

Is there pinmux support for these pins?  Can you disconnect them from
the MAC? Often pins can be connected to different internal IP
blocks. Maybe you can flip the pin mux, perform the MAC reset, and
then put the pinmux back to connect the pins to the MAC IP again?

     Andrew
