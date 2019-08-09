Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B45E88334
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfHITS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:18:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfHITS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 15:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Aam4vI/+62ILkPF1gW+unOKiRx6UNBcNfmfoX5A+6Do=; b=lPqdGcF4c3Luc0UN5cJDVlRGr5
        XIEbAtYEMI8s5pPHZ+2EYE6445ajrM2IR3r7wyEDq1JfWmsB+TnA4SCclkxVl8mddvnH/1oqnkbaD
        nxyA8gGjpwkai+jHMsWX8BXbDncsxMoenZKf8Dm+jjUJBQ6YJpIo/FjdWAFG0ylP00qo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwAP8-00043H-Tf; Fri, 09 Aug 2019 21:18:22 +0200
Date:   Fri, 9 Aug 2019 21:18:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/4] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
Message-ID: <20190809191822.GZ27917@lunn.ch>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
 <49454e5b-465d-540e-cc01-07717a773e33@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49454e5b-465d-540e-cc01-07717a773e33@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	}, {
> +		PHY_ID_MATCH_EXACT(0x001cca50),

Hi Heiner

With the Marvell driver, i looked at the range of IDs the PHYs where
using. The switch, being MDIO based, also has ID values. The PHY range
and the switch range are well separated, and it seems unlikely Marvell
would reuse a switch ID in a PHY which was not compatible with the
PHY.

Could you explain why you picked this value for the PHY? What makes
you think it is not in use by another Realtek PHY? 

Thanks
    Andrew
