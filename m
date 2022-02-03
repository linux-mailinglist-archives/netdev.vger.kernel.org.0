Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EAD4A858F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350898AbiBCNvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:51:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240877AbiBCNvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 08:51:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=BYfxvmmuCN6UPFXN7Va4Fa0uLssNm+7DZYX9yS23KC4=; b=LG
        8nVSQhbcMk3aSMJTMXMAWTXfnCnejlLfbhn0PvPfTNtfQKcPIZY/+huTwuGXsVleTgfvlg9DbRXZJ
        D9BX4tKqSgrgKwEWS1Sjt+mloabKDDmItYfXIJ9VaOXsMA4GJrtq+LipIw9HYcYoLDNagelg0xSd3
        uGuZVIDbT2VGUxM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFcWL-0047NY-Um; Thu, 03 Feb 2022 14:51:33 +0100
Date:   Thu, 3 Feb 2022 14:51:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: dsa: mv88e6xxx: populate
 supported_interfaces and mac_capabilities
Message-ID: <Yfvd5R7p0DWdPMDj@lunn.ch>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
 <E1nFcCA-006WMo-5e@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1nFcCA-006WMo-5e@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 01:30:42PM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the
> Marvell MV88E6xxx DSA switches in preparation to using these for the
> validation functionality.
> 
> Patch co-authored by Marek.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Marek Behún <kabel@kernel.org> [ fixed 6341 and 6393x ]

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
