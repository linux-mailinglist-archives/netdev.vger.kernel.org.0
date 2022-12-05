Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2B9642575
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiLEJKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiLEJKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:10:20 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BDE1928A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:09:35 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r26so14786001edc.10
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+mqkHAvBv1y5qS2y58nAD/iFpsVKp/726AYMa4PGL3o=;
        b=wjJlMPQFvu5r3taMHZ7MUIsm8Y8OlsIkDMO05PgJsPs10HD6/mSS6m0uS1B3uXHyuJ
         Zx8f3AQsRj27lhL7oAgx0ggwJvcJx5JItoPWXovLhk9mlAhoXzJNy3iokvxTjChNDLNa
         wk2TyEe/S2g+Ww12WtM9km3V/aJo1QEghKMBZkghK7EY/VOpVhfVqq3Netjy9wlLKKs8
         5a+QXKJmClAT1PPbHbqkX+T9B2zAsZZwbkpEhfd7MlAWEyy6i5DXMhpzPncwYBc6uZwO
         wiFjYkpDOqD/VLUuEWdJ6aQ4Q9GJMA94PecIzJRhQ61BFNT2r5B7YPzz+IEdax2XbDkh
         vJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+mqkHAvBv1y5qS2y58nAD/iFpsVKp/726AYMa4PGL3o=;
        b=JRcvYsPgWB4wHDizusJxeXytUoGUAYw5S5iqTuLGK/Mxkil4yIJNLagsPzfgzb7wGx
         s8oRDQ8utdTGrOyrh/9waUGAHb7MUT152JaloUCIBmsa8BAhik0ayES21BaEcGBdAvwX
         cSfjk/ri1mFMUcsZ9xzAFb3p02L2rlLmBBr/OX8J2H5iygLkA+a/4g9gnUnvWiKuGPo3
         W8XqoZOApm28xX8g6CGxECz+YZdcnH28qeqdCzyNZrP/ZZVhpDVHik1ju1yd3MddFy5+
         sJOjiov51L1GENnpzm4IN+Hk3a6N/+nYbGunCreaHOLMHUB2nN/qE/CuBkp28SENlq/J
         SBnA==
X-Gm-Message-State: ANoB5pk/VIzDjELIf7wQ2ClDqtW2fPzHvr2F8LLATmWr/wK5Sdr6cVLi
        1gwlaQZgbaZUUhbU360wQ4EcCA==
X-Google-Smtp-Source: AA0mqf7zDgFbgzzL9zXGb6oaRV02L0v0dT9PAg4S7vuf7JqCuhV2WiTd4pIf7FjDQkpvwEGAHc2Ydg==
X-Received: by 2002:a05:6402:290:b0:46b:81d2:e3d0 with SMTP id l16-20020a056402029000b0046b81d2e3d0mr23709060edv.314.1670231373853;
        Mon, 05 Dec 2022 01:09:33 -0800 (PST)
Received: from blmsp ([185.238.219.11])
        by smtp.gmail.com with ESMTPSA id b17-20020a1709063cb100b007b4bc423b41sm5917994ejh.190.2022.12.05.01.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:09:33 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:09:32 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] can: m_can: Optimizations for tcan and peripheral
 chips
Message-ID: <20221205090932.zdoqxifsf6aty4k6@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221202140306.n3iy74ru5f6bxmco@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202140306.n3iy74ru5f6bxmco@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning Marc,

On Fri, Dec 02, 2022 at 03:03:06PM +0100, Marc Kleine-Budde wrote:
> On 16.11.2022 21:52:53, Markus Schneider-Pargmann wrote:
> > Hi,
> > 
> > this series is aimed at optimizing the driver code for tcan chips and
> > more generally for peripheral m_can chips.
> > 
> > I did different things to improve the performance:
> > - Reduce the number of SPI transfers.
> > - Reduce the number of interrupts.
> > - Enable use of FIFOs.
> > 
> > I am working with a tcan4550 in loopback mode attached to a beaglebone
> > black. I am currently working on optimizing the receive path as well
> > which will be submitted in another series once it is done.
> 
> The patches I've not commented on look fine. If you re-spin the series
> only containing those, I'll include them in my next pull request, which
> I'll send out soonish.

Ok, thank you, I will send a subset of the patches today.

> 
> regards,
> Marc
> 
> > Best,
> > Markus
> > 
> > Markus Schneider-Pargmann (15):
> >   can: m_can: Eliminate double read of TXFQS in tx_handler
> >   can: m_can: Wakeup net queue once tx was issued
> >   can: m_can: Cache tx putidx and transmits in flight
> >   can: m_can: Use transmit event FIFO watermark level interrupt
> >   can: m_can: Disable unused interrupts
> >   can: m_can: Avoid reading irqstatus twice
> >   can: m_can: Read register PSR only on error
> >   can: m_can: Count TXE FIFO getidx in the driver
> >   can: m_can: Count read getindex in the driver
> >   can: m_can: Batch acknowledge rx fifo
> >   can: m_can: Batch acknowledge transmit events
> >   can: tcan4x5x: Remove invalid write in clear_interrupts
> >   can: tcan4x5x: Fix use of register error status mask
> >   can: tcan4x5x: Fix register range of first block
> >   can: tcan4x5x: Specify separate read/write ranges
> > 
> >  drivers/net/can/m_can/m_can.c           | 140 +++++++++++++++---------
> >  drivers/net/can/m_can/m_can.h           |   5 +
> >  drivers/net/can/m_can/tcan4x5x-core.c   |  19 ++--
> >  drivers/net/can/m_can/tcan4x5x-regmap.c |  45 ++++++--
> >  4 files changed, 141 insertions(+), 68 deletions(-)
> > 
> > 
> > base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
> > prerequisite-patch-id: e9df6751d43bb0d1e3b8938d7e93bc1cfa22cef2
> > prerequisite-patch-id: dad9ec37af766bcafe54cb156f896267a0f47fe1
> > prerequisite-patch-id: f4e6f1a213a31df2741a5fa3baa87aa45ef6707a
> 
> BTW: I don't have access to these prerequisite-patch-id.

I think I messed up here. I have three patches, SPI fixes and devicetree
snippet that this series is based on. I guess I shouldn't have used
--base then or rebase on something without these patches first.

Thanks,
Markus

