Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA577D44A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 06:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfHAEGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 00:06:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52958 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfHAEGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 00:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0nEIRUfN3zxsNAh48LslJgJUypuGqC8H3HJtRe8muw4=; b=Ed/qRiSwHqaqhTMRwJLrcoWg42
        SMVd6TmaE41zAaBb6SGmyGCHZm5ShtqqJYzCOueWexv7cnO9CAkY964OCQhgmLQtaF9OBUglTP0SH
        dXgfmyJrC4ejwk71xvV5iQqrdbMte5S+WfZP5JeMn9RsFLwg76O09D2zXFIUzQWbKjb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht2Ma-0001XR-44; Thu, 01 Aug 2019 06:06:48 +0200
Date:   Thu, 1 Aug 2019 06:06:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH 2/2] net: gmii2rgmii: Switch priv field in mdio device
 structure
Message-ID: <20190801040648.GJ2713@lunn.ch>
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 03:06:19PM +0530, Harini Katakam wrote:
> Use the priv field in mdio device structure instead of the one in
> phy device structure. The phy device priv field may be used by the
> external phy driver and should not be overwritten.

Hi Harini

I _think_ you could use dev_set_drvdata(&mdiodev->dev) in xgmiitorgmii_probe() and
dev_get_drvdata(&phydev->mdiomdio.dev) in _read_status()

       Andrew
