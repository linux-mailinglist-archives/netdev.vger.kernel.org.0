Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588251D3F8F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgENVE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:04:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgENVE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 17:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nIakemcvGrSlleeazZMw285DAqRzE/zcAS5fWft65g4=; b=mkSo5KN+yL3rncs/RXJLTFsuvx
        iA0px8NOntJ+lrSMHWRb1BH8gVSZeMPnqZJT8dCGnpRX42dsZHqrknRNOescpwGTDUdgOyZ7Ghp6y
        HDcXS8HHpXe8xMiW35FNlC3gzwZJ/enDY5GVxkOsmv1FgryjbJ5gmvNkePqTXn8rA1H0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZL2E-002KVz-RA; Thu, 14 May 2020 23:04:54 +0200
Date:   Thu, 14 May 2020 23:04:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
Message-ID: <20200514210454.GB499265@lunn.ch>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com>
 <20200514183912.GW499265@lunn.ch>
 <2f03f066-38d0-a7c7-956d-e14356ca53b3@ti.com>
 <20200514205028.GA499265@lunn.ch>
 <b79f8df0-add8-4ebb-1784-36cc6c50b285@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b79f8df0-add8-4ebb-1784-36cc6c50b285@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Why would we need 2?  The SFP core would need to know that the LOS is
> connected to the PHY.

That is possible today. Just don't list the GPIO when declaring the
SFP.

> The PHY is strapped to configure the LED_1 as a GPIO input.  I am
> not seeing a register that we can force this configuration.

Ah, O.K. If it is selected via strapping only, they an additional
property is not needed.

	 Andrew
