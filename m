Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C895C010B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 17:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiIUPXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 11:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIUPW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 11:22:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CF5883E1;
        Wed, 21 Sep 2022 08:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nS3hQVCmoKlHtaypdKe4LARdIFMjKrSsp4TspKSsyS4=; b=yuSGgXiTcXo0m9i2J5fXCkQ3DX
        PiYmn6Ju/Xi02zOUU/jpeNS7nDNt2ySdG325SGVNwqCVSdSAcMT5m08Po0BVHVpM3To0Hqv/ZE5ku
        ZWWAn/ggbYe1idELUbpt7n2A3g7dMPmaTNw8E/nma/ljTMgTTPpqXg40WSk9jTH6Emkw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ob1Yr-00HNq1-ER; Wed, 21 Sep 2022 17:22:53 +0200
Date:   Wed, 21 Sep 2022 17:22:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: micrel: Fix double spaces inside
 lan8814_config_intr
Message-ID: <YyssTeAgAb3skrAy@lunn.ch>
References: <20220921065444.637067-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921065444.637067-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 08:54:44AM +0200, Horatiu Vultur wrote:
> Inside the function lan8814_config_intr, there are double spaces when
> assigning the return value of phy_write to err.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
