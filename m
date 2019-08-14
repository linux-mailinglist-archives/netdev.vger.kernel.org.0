Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2818C8D744
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfHNPfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:35:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60692 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfHNPfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 11:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lZfAslkONUhm1f6rK9V682dVgFluoxF0U2TpNN1WRjQ=; b=GcMcLuBREk6VKmPE6OJ+a035/+
        /8GqIt20oQKluihFpFPIBm81AkztNblurhAZ1FVpnGgJjhxPYAk8Ea08bp99d57g+CH3XaoEGQeEP
        5M0yxzYK1PyXBVvlSV3IvUTs+QanXuySEDX/UXa4FeRZ6vY0OvV+TzJzLKydwaiqHcS4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxvIe-0002nD-Sr; Wed, 14 Aug 2019 17:34:56 +0200
Date:   Wed, 14 Aug 2019 17:34:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 1/4] net: phy: swphy: emulate register MII_ESTATUS
Message-ID: <20190814153456.GS15047@lunn.ch>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
 <5e3d85cd-43b6-c581-be99-b6b0cf025771@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e3d85cd-43b6-c581-be99-b6b0cf025771@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 11:24:56PM +0200, Heiner Kallweit wrote:
> When the genphy driver binds to a swphy it will call
> genphy_read_abilites that will try to read MII_ESTATUS if BMSR_ESTATEN
> is set in MII_BMSR. So far this would read the default value 0xffff
> and 1000FD and 1000HD are reported as supported just by chance.
> Better add explicit support for emulating MII_ESTATUS.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
