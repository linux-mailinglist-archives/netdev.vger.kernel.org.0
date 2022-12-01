Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AEE63ED53
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLAKM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLAKM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:12:26 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7AC7E
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:12:23 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h11so1837529wrw.13
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3n/k+1TqbNbk3XruAjVDKWfZ9x2e5CAo+VCQq43cL5Q=;
        b=Yy+5OGwxesewEX3E7NwiCzowvW3JAXr/Si1kYURjyXQ+pX2gDkAbHON4dXQ0wEniyL
         bEGAUrFRVZKutqLTLQyP4iPS3yG07Y3X5+Qcl67+wCFgxweehXruJ/fYVXBLxlhHwRQ7
         GzU0lXJTDp6NtZIrDc2tIzFjm7JuqkqjU/BP9Be/J/mZ5ZZgy8P9cpWJf0LlgUN2s5Jw
         bMP7FCVp7HKi/+mK+G12RfRYb0C5Q3cdRM5/Auub8gmzRE3T1x4F42lPBF7YwuYULmkF
         9t3dU5yn7gkF4zjVhEpdD7rVTqGyv0GVjxoxgSNUpAIyycFavzS7GVJ45rgQVhAwC9/L
         b1Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3n/k+1TqbNbk3XruAjVDKWfZ9x2e5CAo+VCQq43cL5Q=;
        b=c4gMi7Q4OtgmiA0ox2JC6pnh4O0tscSrPRTCxoUywAjIyVPuTP8/R9sSbzi+IR/FbD
         hUM1PPcxhEc/jQfi1aVwkMUpFJ9DokUNgJCXQxQOVbPdUio87sI30+p79g7+/JzUJDY9
         JUl1EEhXaa/PFfxjspFPFvEoctADwpa10Vndtixa+0VbXRVapTiL9PzZJxp7kVC4VEgp
         VQoH28aV/oerfnZAVcPODoZ2zuI1AynS9LrUpHmhzRldY3UJyf8otBewWkrKhcUOncyX
         KzMfjfU+3WhA8YtVLMJLmC+xxoxriGo32/1K8oCPPsTgtfZaLm1xj+5igzCWSrmo5a/D
         BzQw==
X-Gm-Message-State: ANoB5pnRfoOenL5fuPjYK/cNLKs/HZsqcL6oH6ZrAKbv0kYx8ow6yB0a
        /8RqmV4M7fpvITxFDckoj4Bh7A==
X-Google-Smtp-Source: AA0mqf5GWpig130H/UDLQvQ9fUwHqk3Hfh++Pdf4PEOVwnDO+5Ae+Vnk5iUJC5pSyQBFPvnvsAP2vw==
X-Received: by 2002:adf:de88:0:b0:242:15d5:7dd1 with SMTP id w8-20020adfde88000000b0024215d57dd1mr12631670wrl.207.1669889541664;
        Thu, 01 Dec 2022 02:12:21 -0800 (PST)
Received: from blmsp ([185.238.219.84])
        by smtp.gmail.com with ESMTPSA id d8-20020a05600c34c800b003cf4eac8e80sm5938699wmq.23.2022.12.01.02.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 02:12:21 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:12:20 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221201101220.r63fvussavailwh5@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
 <20221201082521.3tqevaygz4nhw52u@blmsp>
 <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201090508.jh5iymwmhs3orb2v@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Marc,

On Thu, Dec 01, 2022 at 10:05:08AM +0100, Marc Kleine-Budde wrote:
> On 01.12.2022 09:25:21, Markus Schneider-Pargmann wrote:
> > Hi Marc,
> > 
> > Thanks for reviewing.
> > 
> > On Wed, Nov 30, 2022 at 06:17:15PM +0100, Marc Kleine-Budde wrote:
> > > On 16.11.2022 21:52:57, Markus Schneider-Pargmann wrote:
> > > > Currently the only mode of operation is an interrupt for every transmit
> > > > event. This is inefficient for peripheral chips. Use the transmit FIFO
> > > > event watermark interrupt instead if the FIFO size is more than 2. Use
> > > > FIFOsize - 1 for the watermark so the interrupt is triggered early
> > > > enough to not stop transmitting.
> > > > 
> > > > Note that if the number of transmits is less than the watermark level,
> > > > the transmit events will not be processed until there is any other
> > > > interrupt. This will only affect statistic counters. Also there is an
> > > > interrupt every time the timestamp wraps around.
> > > > 
> > > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > > 
> > > Please make this configurable with the ethtool TX IRQ coalescing
> > > parameter. Please setup an hwtimer to enable the regular interrupt after
> > > some configurable time to avoid starving of the TX complete events.
> > 
> > I guess hwtimer==hrtimer?
> 
> Sorry, yes!
> 
> > I thought about setting up a timer but decided against it as the TX
> > completion events are only used to update statistics of the interface,
> > as far as I can tell. I can implement a timer as well.
> 
> It's not only statistics, the sending socket can opt in to receive the
> sent CAN frame on successful transmission. Other sockets will (by
> default) receive successful sent CAN frames. The idea is that the other
> sockets see the same CAN bus, doesn't matter if they are on a different
> system receiving the CAN frame via the bus or on the same system
> receiving the CAN frame as soon it has been sent to the bus.

Thanks for explaining. I wasn't aware of that. I agree on the timer
then.

> 
> > For the upcoming receive side patch I already added a hrtimer. I may try
> > to use the same timer for both directions as it is going to do the exact
> > same thing in both cases (call the interrupt routine). Of course that
> > depends on the details of the coalescing support. Any objections on
> > that?
> 
> For the mcp251xfd I implemented the RX and TX coalescing independent of
> each other and made it configurable via ethtool's IRQ coalescing
> options.
> 
> The hardware doesn't support any timeouts and only FIFO not empty, FIFO
> half full and FIFO full IRQs and the on chip RAM for mailboxes is rather
> limited. I think the mcan core has the same limitations.

Yes and no, the mcan core provides watermark levels so it has more
options, but there is no hardware timer as well (at least I didn't see
anything usable).

> 
> The configuration for the mcp251xfd looks like this:
> 
> - First decide for classical CAN or CAN-FD mode
> - configure RX and TX ring size
>   9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")
>   For TX only a single FIFO is used.
>   For RX up to 3 FIFOs (up to a depth of 32 each).
>   FIFO depth is limited to power of 2.
>   On the mcan cores this is currently done with a DT property.
>   Runtime configurable ring size is optional but gives more flexibility
>   for our use-cases due to limited RAM size.
> - configure RX and TX coalescing via ethtools
>   Set a timeout and the max CAN frames to coalesce.
>   The max frames are limited to half or full FIFO.

mcan can offer more options for the max frames limit fortunately.

> 
> How does coalescing work?
> 
> If coalescing is activated during reading of the RX'ed frames the FIFO
> not empty IRQ is disabled (the half or full IRQ stays enabled). After
> handling the RX'ed frames a hrtimer is started. In the hrtimer's
> functions the FIFO not empty IRQ is enabled again.

My rx path patches are working similarly though not 100% the same. I
will adopt everything and add it to the next version of this series.

> 
> I decided not to call the IRQ handler from the hrtimer to avoid
> concurrency, but enable the FIFO not empty IRQ.

mcan uses a threaded irq and I found this nice helper function I am
currently using for the receive path.
	irq_wake_thread()

It is not widely used so I hope this is fine. But this hopefully avoids
the concurrency issue. Also I don't need to artificially create an IRQ
as you do.

> 
> > > I've implemented this for the mcp251xfd driver, see:
> > > 
> > > 656fc12ddaf8 ("can: mcp251xfd: add TX IRQ coalescing ethtool support")
> > > 169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing support")
> > > 846990e0ed82 ("can: mcp251xfd: add RX IRQ coalescing ethtool support")
> > > 60a848c50d2d ("can: mcp251xfd: add RX IRQ coalescing support")
> > > 9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")
> > 
> > Thanks for the pointers. I will have a look and try to implement it
> > similarly.
> 
> If you want to implement runtime configurable ring size, I created a
> function to help in the calculation of the ring sizes:
> 
> a1439a5add62 ("can: mcp251xfd: ram: add helper function for runtime ring size calculation")
> 
> The code is part of the mcp251xfd driver, but is prepared to become a
> generic helper function. The HW parameters are described with struct
> can_ram_config and use you can_ram_get_layout() to get a valid RAM
> layout based on CAN/CAN-FD ring size and coalescing parameters.

Thank you. I think configurable ring sizes are currently out of scope
for me as I only have limited time for this.

Thank you Marc!

Best,
Markus
