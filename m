Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD2220D8F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgGONA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:00:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36738 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgGONA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 09:00:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvh1i-005FBd-Jk; Wed, 15 Jul 2020 15:00:46 +0200
Date:   Wed, 15 Jul 2020 15:00:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: look for phy-mode in port nodes
Message-ID: <20200715130046.GB1211629@lunn.ch>
References: <20200617082235.GA1523@laureti-dev>
 <20200714120827.GA7939@laureti-dev>
 <20200714222716.GP1078057@lunn.ch>
 <20200715073112.GA25047@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715073112.GA25047@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 09:31:12AM +0200, Helmut Grohne wrote:
> You seem to be in favour of more deeply encoding the "there can be only
> one CPU port" assumption. Based on that assumption, the rest of what you
> write makes very much sense to me. Is that the direction to go?

From what i understand, there is only one port which can do RGMII. It
does not really matter if that is the CPU port, or a user
port. Ideally, whatever port it is, should have the phy-mode property
in its port node.

How you store that information until you need it is up to the
driver. But KISS is generally best, reuse what you have, unless there
is a good reason to change it. If you see this code being reused when
more than one port supports RGMII, then adding a per port members
makes sense. But if that is unlikely, keep with the global.

      Andrew
