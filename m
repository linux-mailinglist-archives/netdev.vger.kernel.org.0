Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2929EEC0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgJ2Oua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:50:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52382 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJ2Ou3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:50:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY9Fy-004B8S-P3; Thu, 29 Oct 2020 15:50:26 +0100
Date:   Thu, 29 Oct 2020 15:50:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201029145026.GR933237@lunn.ch>
References: <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch>
 <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
 <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
 <20201025144258.GE792004@lunn.ch>
 <20201029142100.GA70245@apalos.home>
 <20201029143934.GO878328@lunn.ch>
 <CAMj1kXHR0TmMacVt+YR1+9kQsoOk2GAXUmvYAF7ns=+yDVJAsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHR0TmMacVt+YR1+9kQsoOk2GAXUmvYAF7ns=+yDVJAsg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> IIRC there is no public documentation for this PHY, right? So most
> people that are affected by this are not actually able to implement
> this workaround, even if they wanted to.

The information you need is in the mailing list, where a realtek
person describes what the bits do.

       Andrew
