Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD0762FC01
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiKRRvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234447AbiKRRvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:51:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA0327176;
        Fri, 18 Nov 2022 09:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2/tGuQk+quL8EnY2oUSo5xafrJYw/UKce+lVahsCk6o=; b=KIh8+5v3KUAWLF5XHPvuNEcRIm
        7u1Zoq/pp3aI8F0mJLH4EZ9lax3bivxTxV1UQFKlW8XD2AWrdMyis41D9TAC+V9Xg75gcL/USJgSs
        Pg4TkGf0Exys4Ld85/Vxvm1SYuJSA/nNP26oatamHmVfWys99ydawJdEegqzcKpDtB78=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow5Vu-002pAe-Qe; Fri, 18 Nov 2022 18:50:54 +0100
Date:   Fri, 18 Nov 2022 18:50:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Message-ID: <Y3fF/mCUVepTfTi+@lunn.ch>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <88VJLR.GYSEKGBPLGZC1@crapouillou.net>
 <Y3ernUQfdWMBtO9z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ernUQfdWMBtO9z@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Why is that 1 magically turned into a 0?
> 
> Because gpiod uses logical states (think active/inactive), not absolute
> ones. Here we are deasserting the reset line.

This is the same question/answer you had with me. Maybe it is worth
putting this into the commit message for other patches in your series
to prevent this question/answer again and again.

   Andrew
