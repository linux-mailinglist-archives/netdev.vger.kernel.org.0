Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36C14756F8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241809AbhLOKzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:55:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56290 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhLOKzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 05:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=gv9eywbYzCFEDkiPM7dgAEuRO3TyH6NHy6r2zf5+uvY=; b=gw
        JFVADgfeEtv9qzzva6hX8Tp6vLQnzpMCO8MU5UM+MEXZmcdGn8Vogpu/A5Kt5vBeGA+Wz1GAapeQZ
        tvqRFwNzJKh5XVX8X0Koj2y4OyA8T/yHKBxVEeiZUWuMLo5rIz3ZOKKtLjWNZNkCHezKodpyOwez0
        sfepRoSO8dCSeoc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxRw4-00GdUB-Qh; Wed, 15 Dec 2021 11:55:00 +0100
Date:   Wed, 15 Dec 2021 11:55:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH devicetree 2/2] dt-bindings: phy: Add
 `tx-amplitude-microvolt` property binding
Message-ID: <YbnJhI2Z3lwC3vF9@lunn.ch>
References: <20211214233432.22580-1-kabel@kernel.org>
 <20211214233432.22580-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211214233432.22580-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:34:32AM +0100, Marek Behún wrote:
> Common PHYs often have the possibility to specify peak-to-peak voltage
> on the differential pair - the default voltage sometimes needs to be
> changed for a particular board.

Hi Marek

Common PHYs are not the only user of this. Ethernet PHYs can also use
it, as well as SERDESes embedded within Ethernet switches.

That is why i suggested these properties go into something like
serdes.yaml. That can then be included into Common PHY, Ethernet PHYs,
switch drivers etc.

Please could you make such a split?

       Andrew
