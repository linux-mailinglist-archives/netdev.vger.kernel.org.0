Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D184FF86B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbiDMOGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbiDMOGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:06:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7305EDEA;
        Wed, 13 Apr 2022 07:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ec++mdzuevnsc2z2ZnZ9qDlTJhgNZHJYVtjRxWfpGdc=; b=YW1zm3FtQXXOfZfj/jIZWYnS2d
        PmDkwzxTJXiR5Mh1xAC2MVb06ppA9CT9JwHebP0lPLsI0sZHuBJsV+tdzBxzZqheTrww05QPIXSpX
        6Mywp6ky1QQ2kag2o95ytka+0yf9TCFZyJPe582vGCIOZ7T2UEWLxDixyZwvFYpXjElXMg9HJQUjS
        LkUtSTxUXBlvRW0Ci9pUo0ggV4hizRLeBHaMO1vVymjPcWYX2mXzEo1K18s/EOnf1JUGWEUIqV0tk
        G0EXTCKWlsLZBNXneAXeeIovyDv1OkO5FkoFiTuJ6bwMu8hx7iIUlO/wb4h9/R6ienh5SXzZMyFRJ
        xONCsOkw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58242)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nedb0-0003Eg-18; Wed, 13 Apr 2022 15:03:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nedau-0003Of-DC; Wed, 13 Apr 2022 15:03:40 +0100
Date:   Wed, 13 Apr 2022 15:03:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v6 1/7] ethtool: Add 10base-T1L link mode entry
Message-ID: <YlbYPGG1fXWwMRNB@shell.armlinux.org.uk>
References: <20220412130706.36767-1-alexandru.tachici@analog.com>
 <20220412130706.36767-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412130706.36767-2-alexandru.tachici@analog.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 04:07:00PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add entry for the 10base-T1L full duplex mode.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Please update drivers/net/phy/phylink.c::phylink_caps_to_linkmodes() as
well, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
