Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444764D71FD
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 01:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiCMAzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 19:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiCMAzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 19:55:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF89C26566;
        Sat, 12 Mar 2022 16:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6+maFgEV6iaPIazlZxSN5+GG0wzf0wI611DCNYloywo=; b=toNvwavk3M28Qr5YMFxN3pvTp2
        m46qGHC4UOCFZnynp94UYSq/TzjbL3nrd8yPabi6k45rg9DhFhq/BvoQI6D+UMS75Yps+m7F6DWDU
        tTNR+17OQ1AFhCemJWKAB1tBKZRZ8RGJTYTvgTkxcjyvHNk2BXjRHJ2oyiBDSNdLa+ag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nTCVD-00AXfy-35; Sun, 13 Mar 2022 01:54:31 +0100
Date:   Sun, 13 Mar 2022 01:54:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: mscc-miim: add integrated PHY reset
 support
Message-ID: <Yi1Ax5CbdGf68AoZ@lunn.ch>
References: <20220313002536.13068-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220313002536.13068-1-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 13, 2022 at 01:25:33AM +0100, Michael Walle wrote:
> The MDIO driver has support to release the integrated PHYs from reset.
> This was implemented for the SparX-5 for now. Now add support for the
> LAN966x, too.
> 
> changes since v1:
>  - fix typo in the subject in patch 3/3

Please don't repost so quickly. It would been better to just reply to
yourself saying you had spotted the typo, and will repost in a day or
two once people had had chance to review the code.

    Andrew
