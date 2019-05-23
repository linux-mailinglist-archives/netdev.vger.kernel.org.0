Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFB285B6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbfEWSO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:14:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45447 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbfEWSO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 14:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4IC8R0ZhlQdaL/KSUQ7yDr8Vg9RfeeUfunFzY6EuR7o=; b=Aq66OGPGB9Ehr1k9ZlOc5y7ECw
        OcJpov1dTfOe3vD5eITO3kzBSVVeqEQFripA/ajYOlwRdMgybI5ljtVBcOV09nCTGRtS/01yJxMsk
        9FMDPuTXU+F6CVgs/+QK6JBerzR0k8e0J7OnR0chK57C1jwOiZ9zZWHS/zVCrHSEcq1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTsEt-0008SB-Tk; Thu, 23 May 2019 20:14:51 +0200
Date:   Thu, 23 May 2019 20:14:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net: phy: aquantia: add USXGMII support
 and warn if XGMII mode is set
Message-ID: <20190523181451.GE15531@lunn.ch>
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
 <96437cfa-b1f9-eeae-f9ca-c658c81f61c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96437cfa-b1f9-eeae-f9ca-c658c81f61c0@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 08:09:08PM +0200, Heiner Kallweit wrote:
> So far we didn't support mode USXGMII, and in order to not break few
> boards mode XGMII was accepted for the AQR107 family even though it
> doesn't support XGMII. Add USXGMII support to the Aquantia PHY driver
> and warn if XGMII mode is set.
> 
> v2:
> - add warning if XGMII mode is set
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
