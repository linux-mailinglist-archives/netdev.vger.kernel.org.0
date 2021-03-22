Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B0634518E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCVVLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:11:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhCVVLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:11:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lORpI-00CT0A-M0; Mon, 22 Mar 2021 22:11:04 +0100
Date:   Mon, 22 Mar 2021 22:11:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 1/2] dt-bindings: ethernet-controller: create a
 type for PHY interface modes
Message-ID: <YFkH6AKEAaPbhy9f@lunn.ch>
References: <20210322195001.28036-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210322195001.28036-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:49:58PM +0100, Marek Behún wrote:
> In order to be able to define a property describing an array of PHY
> interface modes, we need to change the current scalar
> `phy-connection-type`, which lists the possible PHY interface modes, to
> an array of length 1 (otherwise we would need to define the same list at
> two different places).

Hi Marek

Please could you include a 0/2 patch which explains the big
picture. It is not clear to me why you need these properties.  What is
the problem you are trying to solve? That should be in the patch
series cover note.

	 Andrew
