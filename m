Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C375B1C2E
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiIHMGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiIHMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:06:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7256F56F4;
        Thu,  8 Sep 2022 05:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z2QPXKNwl3xj4RfWENMfDvcilTWhVwYgEyxIj3EjONU=; b=02UgGaPdYjX+ypkc2aTRav8H+S
        VFyJotzrQJ1DnezBUrQ3YrvIDx7ho1cDoOnNaWgtoTKcejT2NInwsTiOFBiDcezlgonPTpzC+4VGO
        H62xYfEpVpY+hl/AjS9XIPKQiRPi1rj+cT0S5/pDceVjn5dw9BXE9qmp9nvv+d3rgHD8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWGIc-00Fxfp-3Z; Thu, 08 Sep 2022 14:06:26 +0200
Date:   Thu, 8 Sep 2022 14:06:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
Message-ID: <YxnawswbdbTtx9WQ@lunn.ch>
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
 <CACRpkdaUK7SQ9BoR0C2=8XeKWCsjbwd-KdowN5ee_BU+Jhzeqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaUK7SQ9BoR0C2=8XeKWCsjbwd-KdowN5ee_BU+Jhzeqw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 11:45:48PM +0200, Linus Walleij wrote:
> On Tue, Sep 6, 2022 at 10:49 PM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> > This patch switches the driver away from legacy gpio/of_gpio API to
> > gpiod API, and removes use of of_get_named_gpio_flags() which I want to
> > make private to gpiolib.
> >
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I think net patches need [PATCH net-next] in the subject to get
> applied.

Correct.

https://docs.kernel.org/process/maintainer-netdev.html

For the odd drive by patch, the Maintainers often do accept patches
without it. So wait and see.

	Andrew
