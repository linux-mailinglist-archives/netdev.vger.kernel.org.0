Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2C6218A9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiKHPoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiKHPoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:44:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C73646C;
        Tue,  8 Nov 2022 07:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8TqbaU07aclaomhChPLaLFd7kSDN7P7+FmqiwxgjVgI=; b=R514F4pQyViqLQ2jiq8GIh3fqK
        +NjNt+Sc2YLEPOnL3WhncT9XkdhyQpiyPjDF+8u3H8QYWGUY+AbGs+JfJR1r1xZaXaMGI2/bHCxqI
        mtBswEA3BzjYjnLAEzj7dTD6xwwRQ7DO+ySy6YEZaw48IpRBbOUYCe6P+toAuYR6pT2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osQlf-001pox-Tf; Tue, 08 Nov 2022 16:44:03 +0100
Date:   Tue, 8 Nov 2022 16:44:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tan Tee Min <tee.min.tan@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: dp83867: add TI PHY loopback
Message-ID: <Y2p5Q1D1/HSW+lrb@lunn.ch>
References: <20221108101527.612723-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108101527.612723-1-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 06:15:27PM +0800, Michael Sit Wei Hong wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> The existing genphy_loopback() is not working for TI DP83867 PHY as it
> will disable autoneg support while another side is still enabling autoneg.
> This is causing the link is not established and results in timeout error
> in genphy_loopback() function.
> 
> Thus, based on TI PHY datasheet, introduce a TI PHY loopback function by
> just configuring BMCR_LOOPBACK(Bit-9) in MII_BMCR register (0x0).
> 
> Tested working on TI DP83867 PHY for all speeds (10/100/1000Mbps).
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
