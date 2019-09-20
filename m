Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA76EB9790
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 21:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436607AbfITTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 15:09:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57864 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436593AbfITTJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 15:09:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEYcJbwc0b5owsJ1Y12CtX9k8f7ucXl77/PXjuW38ms=; b=UXH5KhNetDMFVTYsI3W1JUMYoG
        HUsQkM3gVXTIdlIY859PQMmOvtcCOzrGdXozF9bSqJN+IDzpr5lcwrvAh/Hz+UILfnZPruJYYeP5T
        mbI7YZKQGJ+ASgIeZfnLFUAOm1bfke2aAtndh0PevXXAG3y6FovperxJh6ippVpRmOiM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iBOHE-00074d-CJ; Fri, 20 Sep 2019 21:09:08 +0200
Date:   Fri, 20 Sep 2019 21:09:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] net/phy/mdio-mscc-miim: Use
 devm_platform_ioremap_resource() in mscc_miim_probe()
Message-ID: <20190920190908.GH3530@lunn.ch>
References: <189ccfc3-d5a6-79fd-29b8-1f7140e9639a@web.de>
 <506889a6-4148-89f9-302e-4be069595bb4@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506889a6-4148-89f9-302e-4be069595bb4@web.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 09:02:40PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 20 Sep 2019 20:20:34 +0200
> 
> Simplify this function implementation by using a known wrapper function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
