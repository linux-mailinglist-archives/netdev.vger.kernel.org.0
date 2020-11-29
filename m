Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7742C7BE3
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 00:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgK2XFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 18:05:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgK2XFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 18:05:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjVjs-009PfU-JB; Mon, 30 Nov 2020 00:04:16 +0100
Date:   Mon, 30 Nov 2020 00:04:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang
 option
Message-ID: <20201129230416.GT2234159@lunn.ch>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com>
 <20201129224113.GS2234159@lunn.ch>
 <CABkfQAFcSNMeYEepsx0Z6tuaif-dQhE2YBMK54t1hikAvzdASg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABkfQAFcSNMeYEepsx0Z6tuaif-dQhE2YBMK54t1hikAvzdASg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 11:51:43PM +0100, Adrien Grassein wrote:
> Hi Andrew,
> 
> Please find my answers below.
> 
> Le dim. 29 nov. 2020 à 23:41, Andrew Lunn <andrew@lunn.ch> a écrit :
> 
>     On Sun, Nov 29, 2020 at 10:59:58PM +0100, Adrien Grassein wrote:
>     > Add dt-bindings explanation for the two new gpios
>     > (mdio and mdc) used for bitbanging.
> 
>     Hi Adrien
> 
>     What is missing is an explanation of why!
> 
> I'm sorry, it's my first upstreaming attempt.

Hi Adrien

Please take a look at

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

It is normal to have a patch 0/X which explains the big picture.

Then the commit message for each patch should explain why you are
doing something. That is much more important than what you are doing,
i can see that from the patch itself.

> I am currently upstreaming the "Nitrogen 8m Mini board" that seems to not use a
> "normal" mdio bus but a "bitbanged" one with the fsl fec driver.

Any idea why?

Anyway, you should not replicate code, don't copy bitbanging code into
the FEC. Just use the existing bit-banger MDIO bus master driver.

	   Andrew
