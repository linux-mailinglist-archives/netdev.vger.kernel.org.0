Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA46E34E933
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhC3NfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:35:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhC3Nej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 09:34:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lREVk-00E1hy-W6; Tue, 30 Mar 2021 15:34:24 +0200
Date:   Tue, 30 Mar 2021 15:34:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH linux-next 1/1] phy: Sparx5 Eth SerDes: Use direct
 register operations
Message-ID: <YGMo4K4b9GIUIGu8@lunn.ch>
References: <20210329081438.558885-1-steen.hegelund@microchip.com>
 <20210329081438.558885-2-steen.hegelund@microchip.com>
 <YGIimz9UnVYWfcXH@lunn.ch>
 <2356027828f1fa424751e91e478ff4bc188e7f6d.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2356027828f1fa424751e91e478ff4bc188e7f6d.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
> > > +                                    struct sparx5_sd25g28_params *params)
> > >  {
> > > -     struct sparx5_serdes_regval item[] = {
> > 
> > Could you just add const here, and then it is no longer on the stack?
> > 
> >    Andrew
> 
> No it still counts against the stack even as a const structure.

I'm surprised. Maybe it needs static as well?

I'm just thinking you can get a much smaller patch if you don't need
to modify the table, just add additional qualifiers.

   Andrew
