Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1400E37B331
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 02:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhELAuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 20:50:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36272 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhELAuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 20:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cYa39Ppa/s8/J47IUv/CCPv0pyDLZZpBQwjmpffJtd4=; b=gN+xRV/Gzbrg3ydw/AW6zMA3SC
        fr1aEtjvwZHuhL/lr6YGfJXe/J+CopkU3Sqs+cFq4XPUx63hSjU8iLHL0m8Rhj4UF1XBDXf2lYaR2
        napwxHV+7E89wzY5cglyMUMIStI9tqe28fYZwBXxBnOTtE3e0k/BZSHH/Gv9nqLGgFR4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgd3O-003qHX-Un; Wed, 12 May 2021 02:48:46 +0200
Date:   Wed, 12 May 2021 02:48:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v2] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YJsl7rLVI6ShqZvI@lunn.ch>
References: <20210511225913.2951922-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511225913.2951922-1-pgwipeout@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:59:13PM -0400, Peter Geis wrote:
> Add a driver for the Motorcomm yt8511 phy that will be used in the
> production Pine64 rk3566-quartz64 development board.
> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.

Hi Peter

Please can you add minimal RGMII delay support. Trying to add it later
generally end up in backwards compatibility problems.

Do you know which one of the four RGMII modes your setup needs? Is the
PHY adding the Rx and Tx delays? So "rgmii-id"?

       Andrew
