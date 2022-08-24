Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEECA59FF4D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbiHXQPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiHXQPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:15:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E070E59
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EF5GLN3tsc3GK2HEt+1IyM1vL7PA6YgIReBrOddgEGg=; b=H57JLOoqFt8ustcLwQQ6jN08Q9
        IS88SWSpTBuS86kwei766IhZCUKZSklduMbM4LFaomeTUF7MPiuQvinXQa7WhyyZQ1tH2PB08+Et0
        ZWmfnlfL29vy4iSsjr0/MJNvd/lbNGec5g1s2tHtwDxpvBmRxUAo0Wg3IV6TdZZJwWcg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQt1g-00ESmN-WC; Wed, 24 Aug 2022 18:14:45 +0200
Date:   Wed, 24 Aug 2022 18:14:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, tangbin@cmss.chinamobile.com,
        caizhichao@yulong.com
Subject: Re: [PATCH net-next] net: ftmac100: add an opportunity to get
 ethaddr from the platform
Message-ID: <YwZOdHxnA46hIyvy@lunn.ch>
References: <20220824151724.2698107-1-saproj@gmail.com>
 <YwZEmo9sVds8CJdD@lunn.ch>
 <CABikg9z4n75TdoUd-9Q-W2Ahr5-yTszKVxq09uHB9kyhQkhTng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9z4n75TdoUd-9Q-W2Ahr5-yTszKVxq09uHB9kyhQkhTng@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 24, 2022 at 06:40:44PM +0300, Sergei Antonov wrote:
> On Wed, 24 Aug 2022 at 18:32, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Aug 24, 2022 at 06:17:24PM +0300, Sergei Antonov wrote:
> > > This driver always generated a random ethernet address. Leave it as a
> > > fallback solution, but add a call to platform_get_ethdev_address().
> > > Handle EPROBE_DEFER returned from platform_get_ethdev_address() to
> > > retry when EEPROM is ready.
> >
> > Hi Sergei
> >
> > This is version 2 correct, you added -EPROBE_DEFER handling?
> 
> No, that's v1 for drivers/net/ethernet/moxa/ftmac100.c driver and
> -EPROBE_DEFER handling is present from the start.
> I previously submitted an analogous patch for another driver:
> drivers/net/ethernet/moxa/moxart_ether.c. And yes, there were v1 and
> v2.

Ah, sorry. Getting the different moxa drivers mixed up.

    Andrew
