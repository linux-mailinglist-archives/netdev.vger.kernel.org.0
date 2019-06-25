Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9FB52818
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbfFYJ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:29:40 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49280 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfFYJ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:29:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IOs08vRJYw1qJiIbOQmayB+PkMsOoQ5W5ST49dzietI=; b=1AIJJNhrxhQNgKmIE3GuEHKhE
        D6DomYPYPrbk4HYTCd4AM/NN5Ttg+d5YcvPC6FqdT44nfSIllS1+cK4r9QbFT+Q1xkGhS+LaBbwje
        1NPdhy4DQardJmPjA3mvz2rcqOaNxepTtTCC8mqXgaZEkeSM4PWwK2qjE4MZ2iB2RMiH2GUF7HT5h
        LCTKGfrgY6w1ysjLjvUjDbLmgLnKPjcQ+ZLH1mjtPjUwl02Udp4FToA+c+bn4Id/xqDHik/UM/xKb
        vHM7AEMRAWEtJ3+diRTU20ZmjRc48quvzYmBCjRdUD9KDgh1s3kK+yYtx0D58cHy5Ma6KTqkz8V3b
        xghNvokuQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58976)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfhlc-0005TP-Q2; Tue, 25 Jun 2019 10:29:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfhla-00076N-Is; Tue, 25 Jun 2019 10:29:30 +0100
Date:   Tue, 25 Jun 2019 10:29:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v5 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190625092930.ootk5nvbkqqvfbtd@shell.armlinux.org.uk>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378274-12357-1-git-send-email-pthombar@cadence.com>
 <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
 <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 09:26:29AM +0000, Parshuram Raju Thombare wrote:
> >In which case, gem_phylink_validate() must clear the support mask when
> >SGMII mode is requested to indicate that the interface mode is not
> >supported.
> >The same goes for _all_ other PHY link modes that the hardware does not
> >actually support, such as PHY_INTERFACE_MODE_10GKR...
> If interface is not supported by hardware probe returns with error, so we don't 
> net interface is not registered at all.

That does not negate my comment above.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
