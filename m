Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C63D437EC2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhJVTlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:41:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232504AbhJVTll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UbtXdGmH6ZNl4a8rI3PzE5Ir8rWJXZWxxEZkMcHo7FE=; b=sVOccO4F1QZiPz3NKQq2b7ig3/
        +p/vLY0xkO+1ohk3pSQIgmwH35a910M7+Y0X4WwPWIlvbZ90w5aLMMh6GEe724nxZMfjCOBOBgtDV
        tAcUTQugTC3zoGK+57rFBAylgBs7OUhb+Grtbqy/+Ecg1D5o4Ua6QFfSI9B94l+G16uY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0Nr-00BQLi-G7; Fri, 22 Oct 2021 21:39:19 +0200
Date:   Fri, 22 Oct 2021 21:39:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [net-next PATCH 1/2] dt-bindings: net: macb: Add mdio bus child
 node
Message-ID: <YXMTZ1zIstT5OV96@lunn.ch>
References: <20211022163548.3380625-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022163548.3380625-1-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 12:35:47PM -0400, Sean Anderson wrote:
> This adds an optional mdio bus child node. If present, the mac will
> look for PHYs there instead of directly under the top-level node. This
> eliminates any ambiguity about whether child nodes are PHYs, and allows
> the MDIO bus to contain non-PHY devices.

Hi Sean

Please always have a patch 0/X for patchsets, which explains the big
picture of the patchset. This is also used as the merge commit
message.

	Andrew
