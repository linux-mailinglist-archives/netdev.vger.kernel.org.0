Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1C285B4
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfEWSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:14:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45435 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731275AbfEWSOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 14:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jFkH/OKol9syKvMTApd+XKBRYj2Ri/8nnEMaSkJkhE0=; b=tCbbqh/+icQ3DXb6GkretSV/ao
        eMLP9nNGm1Oxp+FgdRY0msdvMtsNh8GrFVCuO6EpEPVolRwe4GO5439MrRchXYAbfaWkAipiWqcOx
        RsQrCkeGJ26WMJgdrVot+SVt6mipVAweFRrJrtEv7Ru+wkRTIsaE4NyfZrHHFP+EUac0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTsE5-0008QG-23; Thu, 23 May 2019 20:14:01 +0200
Date:   Thu, 23 May 2019 20:14:01 +0200
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
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: net: document new usxgmii
 phy mode
Message-ID: <20190523181401.GD15531@lunn.ch>
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
 <60079a09-670b-268e-9ad5-014a427b60bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60079a09-670b-268e-9ad5-014a427b60bf@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 08:07:56PM +0200, Heiner Kallweit wrote:
> Add new interface mode USXGMII to binding documentation.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
