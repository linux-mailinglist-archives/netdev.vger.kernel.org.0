Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5209954CBE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbfFYKvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:51:13 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50514 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfFYKvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B4pLAXyDPdI8tWudLeNzlKsY9ks2pK9PyrJ5hr7IryA=; b=OqKckeaCN4sEg3NvrAAopQHHy
        p/MUnhzE2Rs8+JKnTJnWFJALJb0xRvcKxAHgk3K2t2i5KSO1Ni3FizlFz4B/Z+q0wH31F5U8L22T3
        6/IyCytoKeec2KnYFcJtpLsjHiHJz4Y2pT02Znk4Bg/AenoBuYGjVS/tSKCur7bt/oACz4aFtwZp1
        6PEzYC1UlmkLYm1TqihKjDLY+nJRZfjwFm7xKzACRqa5HRhiK3YmqOCuow1R66GMK064Hf4syylxQ
        MpesAgk9z4ktv8v9UVjHF9Dvk4+aK0cvjypvcQVMZ1bv/FS4aWKEBay3iBHDeuSRzZfuwSeblxABy
        F28vhKHtQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58984)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfj2X-0005um-7v; Tue, 25 Jun 2019 11:51:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfj2T-00079r-Lv; Tue, 25 Jun 2019 11:51:01 +0100
Date:   Tue, 25 Jun 2019 11:51:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v4 4/5] net: macb: add support for high speed interface
Message-ID: <20190625105101.xvcwgt3jh5pk7p2x@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281806-13991-1-git-send-email-pthombar@cadence.com>
 <20190623150902.GB28942@lunn.ch>
 <CO2PR07MB2469FDA06C3F8848290013B8C1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624131307.GA17872@lunn.ch>
 <SN2PR07MB2480DBE64F2550C0135335EEC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN2PR07MB2480DBE64F2550C0135335EEC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 08:26:29AM +0000, Parshuram Raju Thombare wrote:
> Hi Andrew,
> 
> >What i'm saying is that the USXGMII rate is fixed. So why do you need a device
> >tree property for the SERDES rate?
> This is based on Cisco USXGMII specification, it specify USXGMII 5G and USXGMII 10G.
> Sorry I can't share that document here.

The closed nature of the USXGMII spec makes it very hard for us to know
whether your implementation is correct or not.

I have some documentation which suggests that USVGMII is a USXGMII link
running at "5GR" rate as opposed to USXGMII running at "10GR" rate.

So, I think 5G mode should be left out until it becomes clear that (a)
we should specify it as USXGMII with a 5G rate, or as USVGMII.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
