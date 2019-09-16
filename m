Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF82EB39D3
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbfIPL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:57:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48254 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfIPL5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 07:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4UEBmSW/CBCAG5QIZKu21BsfI/TdK0ur9EAw4ov1WC0=; b=MnS880/Oh+ouDAg0CzMdK2Yd+k
        oiyBTGdngetVphZYVVNqOSa6zu50VBLkwu4hArnslqb7BbUfVR3r+cmrw52ZXCptTb0Ebrc+HlL91
        sHoySAfa6u85292mXOo9oQuRlZ+SP7F1JvYcBmx3x3Xw5H5bbo1AwCudRbUhFqWUrpvE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i9pdG-0001Zy-DD; Mon, 16 Sep 2019 13:57:26 +0200
Date:   Mon, 16 Sep 2019 13:57:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz
Subject: Re: [PATCH v5 2/2] net: phy: adin: implement Energy Detect Powerdown
 mode via phy-tunable
Message-ID: <20190916115726.GA5552@lunn.ch>
References: <20190916073526.24711-1-alexandru.ardelean@analog.com>
 <20190916073526.24711-3-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916073526.24711-3-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 10:35:26AM +0300, Alexandru Ardelean wrote:
> This driver becomes the first user of the kernel's `ETHTOOL_PHY_EDPD`
> phy-tunable feature.
> EDPD is also enabled by default on PHY config_init, but can be disabled via
> the phy-tunable control.
> 
> When enabling EDPD, it's also a good idea (for the ADIN PHYs) to enable TX
> periodic pulses, so that in case the other PHY is also on EDPD mode, there
> is no lock-up situation where both sides are waiting for the other to
> transmit.
> 
> Via the phy-tunable control, TX pulses can be disabled if specifying 0
> `tx-interval` via ethtool.
> 
> The ADIN PHY supports only fixed 1 second intervals; they cannot be
> configured. That is why the acceptable values are 1,
> ETHTOOL_PHY_EDPD_DFLT_TX_MSECS and ETHTOOL_PHY_EDPD_NO_TX (which disables
> TX pulses).
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
