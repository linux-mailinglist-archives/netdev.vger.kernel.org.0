Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFBA8D5C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732214AbfIDQrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:47:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731985AbfIDQrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/6j1Gkt1CBbHUGiBWOJj8kGsbCdFAqGjCFN3H7D6PuU=; b=waGT/2BJF4Wdba7gJY8Q4vO9Cu
        /ObCYjl1yX5vz7eA6X7V0+aby4l/+I7ugKEu1j7xPP7qhjefoNo+7Kszp18cs5hTjuYHay5uBrNCA
        iKIHyEjKdea7SKh6swiMcepWgu6M9b8Fyt1ded+YfV9HWwwWbRm6tB6BEFvf6JH1RJhw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i5YRW-0004aZ-SF; Wed, 04 Sep 2019 18:47:38 +0200
Date:   Wed, 4 Sep 2019 18:47:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH v2 2/2] net: phy: gmii2rgmii: Dont use priv field in phy
 device
Message-ID: <20190904164738.GB17114@lunn.ch>
References: <1567605621-6818-1-git-send-email-harini.katakam@xilinx.com>
 <1567605621-6818-3-git-send-email-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567605621-6818-3-git-send-email-harini.katakam@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 04, 2019 at 07:30:21PM +0530, Harini Katakam wrote:
> Use set/get drv data in phydev's mdio device instead. Phy device priv
> field maybe used by the external phy driver and should not be
> overwritten.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
