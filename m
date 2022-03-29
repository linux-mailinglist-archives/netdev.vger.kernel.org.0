Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA51C4EA464
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 03:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiC2BEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 21:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiC2BEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 21:04:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A7423FF3E;
        Mon, 28 Mar 2022 18:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=37hzCSIvKGbXFplPDb1/ys0jyRxiUWlgsZrjWpWDyNI=; b=MZnRhKz4gyBTAHWjjd7Fi5ILTN
        rPFOKDE8YKQ8WYHuDrfWcs2Km2QrOXh4Mte2QMlyH3Slx9U3jyF7vxSj7p84j/2N19BUlWJky/6gC
        rhpgClEWn5PIpHjYKWQHzYCxEHJ9cE6R/ZxTvclTHGiHEvCcwWanxkSqOuUk1yGBXR2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZ0G4-00D5dA-6I; Tue, 29 Mar 2022 03:02:52 +0200
Date:   Tue, 29 Mar 2022 03:02:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: lan966x: fix kernel oops on ioctl when I/F
 is down
Message-ID: <YkJavKgcDJUh1pLu@lunn.ch>
References: <20220328220350.3118969-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328220350.3118969-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 12:03:50AM +0200, Michael Walle wrote:
> ioctls handled by phy_mii_ioctl() will cause a kernel oops when the
> interface is down. Fix it by making sure there is a PHY attached.
> 
> Fixes: 735fec995b21 ("net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
