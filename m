Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5990E19AC65
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732619AbgDANGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 09:06:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732252AbgDANGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 09:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HcjlV2smdDYCCZAC2jlXo1gRdBbS5p7g45iucSysgk4=; b=DZy3HHYZq1xFx/KImjVqmgThHr
        ObMDtbCS5JMuQXgr/e0XQGbiLnxKS/1LmlgFzGT9ptc7cI799OCijiQajMci6lInB5OutZFa1/EeI
        gsfPfP2AMlrbW87d8AH7wYMPjYvwSY+sWahYVLFCDxjPHRrPQibZMhcr9sS6pJeKWWCc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jJd4v-000QDr-SS; Wed, 01 Apr 2020 15:06:45 +0200
Date:   Wed, 1 Apr 2020 15:06:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin.Ciubotariu@microchip.com
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200401130645.GB71179@lunn.ch>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330163028.GE23477@lunn.ch>
 <9bbbe2ed-985b-49e7-cc16-8b6bae3e8e8e@gmail.com>
 <bd9f2507-958e-50bf-2b84-c21adf6ab588@microchip.com>
 <20200331125908.GB24486@lunn.ch>
 <12cdbe77-b932-9194-5d5e-5058622cef6c@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12cdbe77-b932-9194-5d5e-5058622cef6c@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew
> 
> > 
> > There are some still using this deprecated feature. But macb is the
> > only one doing this odd looping over child nodes. It is this looping
> > which is breaking things, not the use of the deprecated feature
> > itself.
> 
> Yes, its due to the fact that the MDIO node is missing. Should we have 
> in mind to add an MDIO node under the macb node, where we could add the 
> PHY nodes?

Yes, you can make the driver complient any time you want. But as you
said, you need to keep with backwards compatibility. But net-next is
closed now, for the merge window. So you probably want to wait two
weeks before posting code.

      Andrew
