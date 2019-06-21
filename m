Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E814E8B9
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfFUNQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 09:16:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47164 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfFUNQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 09:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HDnd7MGUz6RZFugWRFFyzyZ4pVlG0vvny4MEkedN3y4=; b=QMUECDO3fFi097LwOMFnnxM64d
        wXiAYZ/hViRWhvrGQ14LNLSEOs66m3eKrzvWWIEC3KAEtRFbfHY1sDaxyERrkwLWpqk1RethMZjQP
        4aaEGZ1QOjtlfpwWZe5KEsCRX+Rxj7NI0snjJmGe+1yTEwihEzP/SQ0wkL2uNgAD0N38=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1heJOl-0005mE-4F; Fri, 21 Jun 2019 15:16:11 +0200
Date:   Fri, 21 Jun 2019 15:16:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v3 0/5] net: macb: cover letter
Message-ID: <20190621131611.GB21188@lunn.ch>
References: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561106037-6859-1-git-send-email-pthombar@cadence.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 09:33:57AM +0100, Parshuram Thombare wrote:
> Hello !
> 
> 2. 0002-net-macb-add-support-for-sgmii-MAC-PHY-interface.patch
>    This patch add support for SGMII mode.

Hi Parshuram

What PHYs are using to test this? You mention TI PHY DP83867, but that
seems to be a plain old 10/100/1000 RGMII PHY.

      Thanks
	Andrew
