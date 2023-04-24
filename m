Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA05B6EC34B
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 02:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDXAhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 20:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXAhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 20:37:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9853185;
        Sun, 23 Apr 2023 17:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YN/HhFoYmlaqYBSztAwFPFcb30CeITtg6OTrqxZ7Ou4=; b=Ru+CLUhdOe/cUD2D23iTWZRJBR
        3cz2HNriW8ioBKIUnyJzVypzC5C8gfckAyzTQUqHodY+flOPHoCJowEZOTOt9HG56WWaMR1v7CfeU
        z1eDZTcxHB2Vjplua1YMTVtcukooZ/5yfSirx/oIlTppHHV9QRdX+D4JxMuf6FcFbDL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqkCr-00B39G-22; Mon, 24 Apr 2023 02:37:25 +0200
Date:   Mon, 24 Apr 2023 02:37:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [net-next PATCH] net: phy: marvell: Fix inconsistent indenting
 in led_blink_set
Message-ID: <129b808d-d8b5-4466-b2c1-864bb412bae1@lunn.ch>
References: <20230423172800.3470-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423172800.3470-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 07:28:00PM +0200, Christian Marangi wrote:
> Fix inconsistent indeinting in m88e1318_led_blink_set reported by kernel
> test robot, probably done by the presence of an if condition dropped in
> later revision of the same code.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304240007.0VEX8QYG-lkp@intel.com/
> Fixes: 46969f66e928 ("net: phy: marvell: Implement led_blink_set()")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
