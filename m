Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260D2216D76
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 15:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgGGNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 09:07:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726745AbgGGNHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 09:07:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsnK1-0041HM-8R; Tue, 07 Jul 2020 15:07:41 +0200
Date:   Tue, 7 Jul 2020 15:07:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     vineetha.g.jaya.kumaran@intel.com
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, weifeng.voon@intel.com,
        hock.leong.kweh@intel.com, boon.leong.ong@intel.com
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Message-ID: <20200707130741.GA938746@lunn.ch>
References: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +        mdio0 {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            compatible = "snps,dwmac-mdio";
> +
> +            ethernet-phy@0 {
> +                compatible = "ethernet-phy-id0141.0dd0",
> +                              "ethernet-phy-ieee802.3-c22";

You only need to provide the phy-id when the PHY is broken and
registers 2 and 3 don't contain a valid ID. And c22 is the default, so
also not needed. The Marvell 88E1510 will work without these
compatible strings.

	   Andrew
