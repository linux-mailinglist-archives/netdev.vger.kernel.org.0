Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33530187C0B
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:29:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgCQJ3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 05:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z+AyaK3ogFbvbt1mFffv+w8jqt6bs51tBylNS+LBlz0=; b=JmdSFI1+VkJio2tDPA/rdC72rd
        PfGp4Xt1rRCIRyCUzSd44ADg9K381tvFsW6iC4Vo3CQzEhLdpj2Lrm7Hystwkl8WanmwRd/F+U1Bb
        EW3/r166RNdnUKtW1n61MHGJXcQERgI4+P8sIG5TWNLYPWjwushK6JTxUyBwQphvV2iM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jE8XH-00057V-Lw; Tue, 17 Mar 2020 10:29:19 +0100
Date:   Tue, 17 Mar 2020 10:29:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] net: phy: mdio-mux-bcm-iproc: check
 clk_prepare_enable() return value
Message-ID: <20200317092919.GA19323@lunn.ch>
References: <20200317045435.29975-1-rayagonda.kokatanur@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317045435.29975-1-rayagonda.kokatanur@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 10:24:35AM +0530, Rayagonda Kokatanur wrote:
> Check clk_prepare_enable() return value.
> 
> Fixes: 2c7230446bc9 ("net: phy: Add pm support to Broadcom iProc mdio mux driver")
> Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
