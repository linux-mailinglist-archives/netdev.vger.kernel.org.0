Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871B02DBAA4
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 06:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgLPFcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 00:32:20 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:37520 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPFcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 00:32:20 -0500
Date:   Wed, 16 Dec 2020 08:31:34 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] net: stmmac: Problem with adding the native GPIOs support
Message-ID: <20201216053134.xlqxr4ncbukecxuu@mobilestation>
References: <20201214092516.lmbezb6hrbda6hzo@mobilestation>
 <20201214153143.GB2841266@lunn.ch>
 <20201215082527.lqipjzastdlhzkqv@mobilestation>
 <20201215135837.GB2822543@lunn.ch>
 <20201215145253.sc6cmqetjktxn4xb@mobilestation>
 <20201216020355.GA2893264@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201216020355.GA2893264@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 03:03:55AM +0100, Andrew Lunn wrote:
> > > From what you are saying, it sounds like from software you cannot
> > > independently control the GPIO controller reset?
> > 
> > No. The hardware implements the default MAC reset behavior. So the
> > GPIO controller gets reset synchronously with the MAC reset and that
> > can't be changed.
> 

> Is there pinmux support for these pins?  Can you disconnect them from
> the MAC? Often pins can be connected to different internal IP
> blocks. Maybe you can flip the pin mux, perform the MAC reset, and
> then put the pinmux back to connect the pins to the MAC IP again?

Alas no. Pins multiplexing isn't implemented in the Baikal-T1 SoC at all.
Each pin has been assigned with a single function. In this case DW GMAC
GPO/GPI pins always serve as GPO/GPI and nothing else.

-Sergey

> 
>      Andrew
