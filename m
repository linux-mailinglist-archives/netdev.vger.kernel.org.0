Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39561FD701
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgFQVS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:18:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgFQVS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:18:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlfSN-0011ed-3S; Wed, 17 Jun 2020 23:18:51 +0200
Date:   Wed, 17 Jun 2020 23:18:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: net/dsa/microchip: correct placement of dt property phy-mode?
Message-ID: <20200617211851.GD240559@lunn.ch>
References: <20200617082235.GA1523@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617082235.GA1523@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If nothing else, it makes the device tree unintuitive to use.
> 
> Is this placement of the phy-mode on the switch intentional?

That i cannot answer.
> 
> If yes: I think this should be prominently documented in
> Documentation/devicetree/bindings/net/dsa/ksz.txt.

Yes, it needs to be documented.

> If no: The microchip driver should follow the documented dsa convention
> and place the phy-mode on the relevant port nodes.
>
> If no: Do we have to support old device trees that have the phy-mode
> property on the switch?

We should not break existing DT blobs. So the driver should be
extended to first look in the port node. If it does not find it there,
look in the switch node. And maybe give a warning if it is found in
the switch node, saying the DT should be updated.

    Andrew
