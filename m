Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E083513ECC
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353104AbiD1W7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353101AbiD1W7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:59:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DDB33A21
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bsa3ed6zjZqpHN7x9cIUsIEHErX/6rB0U8bP9Uir9MI=; b=XS2DZHUgY5EoRdwO+qrS/oTBjv
        iOioSGAnUSX5DuPVS0GtSFJ9JwJ8vqyTDZ+Ac++6TRPpso6BHDsppctTMfHpSBJzwyCHTr9o2H0IJ
        xwOlf7E8nj8Hvzc8OVQ9PaHLfWg4gbE8rnyMgUykMNXt4/P0uBf4Qqc2A04L9OUHgVFc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkD3S-000O6s-6y; Fri, 29 Apr 2022 00:56:10 +0200
Date:   Fri, 29 Apr 2022 00:56:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, noltari@gmail.com
Subject: Re: [PATCH] net: mdio: Fix ENOMEM return value in BCM6368 mux bus
 controller
Message-ID: <YmsbipglEOK/ODW7@lunn.ch>
References: <20220428211931.8130-1-dossche.niels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428211931.8130-1-dossche.niels@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 11:19:32PM +0200, Niels Dossche wrote:
> Error values inside the probe function must be < 0. The ENOMEM return
> value has the wrong sign: it is positive instead of negative.
> Add a minus sign.
> 
> Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi Niels

If you find any more issues like this in the network stack and its
drivers, please take a read of

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

    Andrew
