Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8544F651
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfFVOy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 10:54:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbfFVOy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 10:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+UsBFNXh4ENWlTV/lM1RjdOaGGLoEu+kgMsM/uuDJ84=; b=jXOJSCNHsmzaa1S7bIter8Ga1V
        ol7WvoMZlAJXSrXjLJG2K65ZkSonPpjJd9LXsw2Z+XuwUpxafCGIvJp/yT0GJeIV18ZiSMlrHm5qG
        ga7ab87IE0JDb2lmFywd+cg5/pmOFfT3o0Za5R/L7tfpvmdCX0iSBFKMh6rttOfvuPX4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hehPk-0002Vh-4X; Sat, 22 Jun 2019 16:54:48 +0200
Date:   Sat, 22 Jun 2019 16:54:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v3 0/5] net: macb: cover letter
Message-ID: <20190622145448.GA8497@lunn.ch>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
 <20190621131611.GB21188@lunn.ch>
 <CO2PR07MB2469E07AEBF64DFC8A3E3FAFC1E60@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB2469E07AEBF64DFC8A3E3FAFC1E60@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 22, 2019 at 03:18:42AM +0000, Parshuram Raju Thombare wrote:
> Hi Andrew,
> 
> >On Fri, Jun 21, 2019 at 09:33:57AM +0100, Parshuram Thombare wrote:
> >> Hello !
> >>
> >> 2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
> >>    This patch add support for SGMII mode.
> >
> >Hi Parshuram
> >
> >What PHYs are using to test this? You mention TI PHY DP83867, but that seems to
> >be a plain old 10/100/1000 RGMII PHY.
> It is DP83867ISRGZ on VCU118 board.

Thanks.

As Russell says, this is still a 10/100/1000 PHY. What are you using
for the higher speeds?

    Thanks
	Andrew
