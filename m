Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9059FE68
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiHXPc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiHXPct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:32:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862BC2252A
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Swir0/aWZZsHWMtMvmV1RCnk81SXD09SYP1lk4p8qA0=; b=LofSe8B5zHjKgHoLbvzGjhVlMa
        EatZyUGQnbR18Wx2mIlLOTG4/yhGra81JnI2KlBvknreRCylSNTuU4PY2vLyQezx4/ql7jmxhit/D
        LkJfB2Q7nY39H2lpvnGFFqyQd3p/NLypBjZyJoDEPzM51o679IgKsLIPNPUyuPoAUbNU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQsN0-00ESWE-HP; Wed, 24 Aug 2022 17:32:42 +0200
Date:   Wed, 24 Aug 2022 17:32:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tangbin@cmss.chinamobile.com, caizhichao@yulong.com
Subject: Re: [PATCH net-next] net: ftmac100: add an opportunity to get
 ethaddr from the platform
Message-ID: <YwZEmo9sVds8CJdD@lunn.ch>
References: <20220824151724.2698107-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824151724.2698107-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 06:17:24PM +0300, Sergei Antonov wrote:
> This driver always generated a random ethernet address. Leave it as a
> fallback solution, but add a call to platform_get_ethdev_address().
> Handle EPROBE_DEFER returned from platform_get_ethdev_address() to
> retry when EEPROM is ready.

Hi Sergei

This is version 2 correct, you added -EPROBE_DEFER handling?

Please add a v2 into the Subject "[PATCH v2 net-next]" so we can keep
track of the different versions.

Also, list briefly under the --- what you changed with each version.

It is worth reading:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html

and

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
