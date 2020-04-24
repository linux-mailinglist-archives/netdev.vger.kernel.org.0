Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD21B7907
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgDXPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 11:12:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgDXPMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 11:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DbJzuBrGtHR1eZj0UHcEgF+IrVmFrdfzQz1lXORZb64=; b=ocipGPeimsV5QD6IgsQot/RdFt
        EsnEcfe2OMSNWRggZKf0UAtcGiZcX+sRpjT1GIdLj/lWOV7Q3w4PcT+KHOaSU0ASHzZPaXNLDEEjy
        7bl8mtpou76OzqOMQt5lo6W3GS0eF2NonxkvrgdCtb2HXO7oKQlktS+stSl0/Fc10L9Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRzzc-004ZeQ-Aa; Fri, 24 Apr 2020 17:11:52 +0200
Date:   Fri, 24 Apr 2020 17:11:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr
 driver support
Message-ID: <20200424151152.GC1088354@lunn.ch>
References: <AM0PR04MB5443BCFEC71B6903BE6EFE02FBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200424145635.GB1088354@lunn.ch>
 <AM0PR04MB54435DFD9870FA66C01E07CEFBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB54435DFD9870FA66C01E07CEFBD00@AM0PR04MB5443.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But since I am not responsible for the PHY core, I made this
> workaround only in backplane driver.

You don't need to be responsible for the core to make changes to the
code. Just send patches.

      Andrew
