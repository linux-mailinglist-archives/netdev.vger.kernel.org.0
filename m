Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D34F6A056A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbjBWJzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbjBWJzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:55:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA36CE38D;
        Thu, 23 Feb 2023 01:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AKftNY723KmclwsWzZq7Oqf21ng23SCV0xcJQHieTI0=; b=qE7Cbp6VFo4R5JX7hcQT7cHh1L
        amJPzW9szzqSph/a18BGMSvDoT2Ms71JZk9dnzqkGOvPAvc9yn5dASB15NP/PBZT7BTtTlYvvoklf
        F/Khl8a6t8Au2TIXlzk08lRCnZfyECCwZYTm2UB3kvY05khE/lRnmes8+vpk8KKkskyEclwRF8HBD
        QM7aZKPTyrycAB8BGnTSQ+eB+3UyDFPqm5WmiEtR89KlZyYrGe7URvOBpIG5R44ThBMA10j8mJDf5
        0bKuq+iRx8TwVa/8mdNdFtrIZQdwcOMD2R1R5yjoRRMUrptAywauvdwhMNWDnlqgvSyid8bJyBhG6
        idsdaUsQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33690)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pV8K7-0007qq-9K; Thu, 23 Feb 2023 09:55:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pV8K6-00044o-IN; Thu, 23 Feb 2023 09:55:34 +0000
Date:   Thu, 23 Feb 2023 09:55:34 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 4/4] net: phy: c45: genphy_c45_ethtool_set_eee:
 validate EEE link modes
Message-ID: <Y/c4Fugr+Zc4qpBb@shell.armlinux.org.uk>
References: <20230222055043.113711-1-o.rempel@pengutronix.de>
 <20230222055043.113711-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222055043.113711-5-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 06:50:43AM +0100, Oleksij Rempel wrote:
> Currently, it is possible to let some PHYs to advertise not supported
> EEE link modes. So, validate them before overwriting existing
> configuration.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
