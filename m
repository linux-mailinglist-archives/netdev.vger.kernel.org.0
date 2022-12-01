Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2902A63EAF5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 09:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLAIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 03:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLAIZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 03:25:26 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92B76034D
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 00:25:24 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ay8-20020a05600c1e0800b003d0808d2826so112735wmb.1
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 00:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MPkucWBhogscl9zWbIw6tHCv9NBDHzkjPzeEc9DlEPM=;
        b=GSt+5Adn2ECyXk0aDLQgCLpIe4OEw/AFzkl1XbLYUxsA6oxiiY8fdPYeF9ZsXvj7Uc
         B+TGzqxLkX9jzb98073SXoOQx9wcfK/+MvEcFQkri9TYmGxWpV2bkLxNabgMYFnMEdbU
         HBbW4zZkcONX1DQl22e+WcbFGwSJxIYvv62QjWqibzTxElXT/p6u30C+tFzZm5XxUrr1
         ipIKsaGCAr1XbAytG/c1EvUViT4ICf1j6MsJwkPgvrU9i5Wj5V4r/k1kbMMHcAt1hesg
         SoNfWXS/dT5UlWJekSWm7A4i4gysfF+WWUpBTqKelu9tSDWSyTbT1Pb8DFU8enbZpatr
         PzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPkucWBhogscl9zWbIw6tHCv9NBDHzkjPzeEc9DlEPM=;
        b=gXM5ewuwyzhN9o5JZkz9axzXlAWtrbZeeOn8ujjGhabAUzuMa0ee7rFvpuaMOx2W9g
         lhlPO8l22Btjkzx9F+JSAoAoj8daYdigiSup0XdpkLlK3bumpqH85OcZzMiFiMGDBuaL
         CH6KM7EK7647i1JIQePBLUou1HeqmrG3a5jFuOvpGL1Swt2R7eCsGbpuMt50qkhv/5uk
         YJsPuBDUP0B+Bu8wwMBiimgE7HTexNSB/MxRKBiSegeDdMfBBQRNJTCzYra8z8MU4dHM
         UeImm9YYFY6cIPbIPa99M1vnA09LVTI7qLJrWSGKYpTKVr4fqunlT0NjPX4TxKt9CNGF
         gcqg==
X-Gm-Message-State: ANoB5plH66MEdertxLKdZ7gaccN3Zx404SLBjzbeuVvIjlnP4X4tXfg6
        pYU9WybJBgjPa8EteQ7y+uxWa05dSUIHvQ==
X-Google-Smtp-Source: AA0mqf61/jm8tD5ncmSz9iLVMFaB46CtQJbCgP+8ehTyDB/6d/16SNWm6xXQd8Ht1WavDDI54vfHYA==
X-Received: by 2002:a05:600c:3110:b0:3cf:b07a:cd56 with SMTP id g16-20020a05600c311000b003cfb07acd56mr49133571wmo.143.1669883123387;
        Thu, 01 Dec 2022 00:25:23 -0800 (PST)
Received: from blmsp ([185.238.219.127])
        by smtp.gmail.com with ESMTPSA id l9-20020a05600c1d0900b003cf878c4468sm9433762wms.5.2022.12.01.00.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 00:25:22 -0800 (PST)
Date:   Thu, 1 Dec 2022 09:25:21 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/15] can: m_can: Use transmit event FIFO watermark
 level interrupt
Message-ID: <20221201082521.3tqevaygz4nhw52u@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-5-msp@baylibre.com>
 <20221130171715.nujptzwnut7silbm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221130171715.nujptzwnut7silbm@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Thanks for reviewing.

On Wed, Nov 30, 2022 at 06:17:15PM +0100, Marc Kleine-Budde wrote:
> On 16.11.2022 21:52:57, Markus Schneider-Pargmann wrote:
> > Currently the only mode of operation is an interrupt for every transmit
> > event. This is inefficient for peripheral chips. Use the transmit FIFO
> > event watermark interrupt instead if the FIFO size is more than 2. Use
> > FIFOsize - 1 for the watermark so the interrupt is triggered early
> > enough to not stop transmitting.
> > 
> > Note that if the number of transmits is less than the watermark level,
> > the transmit events will not be processed until there is any other
> > interrupt. This will only affect statistic counters. Also there is an
> > interrupt every time the timestamp wraps around.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> 
> Please make this configurable with the ethtool TX IRQ coalescing
> parameter. Please setup an hwtimer to enable the regular interrupt after
> some configurable time to avoid starving of the TX complete events.

I guess hwtimer==hrtimer?

I thought about setting up a timer but decided against it as the TX
completion events are only used to update statistics of the interface,
as far as I can tell. I can implement a timer as well.

For the upcoming receive side patch I already added a hrtimer. I may try
to use the same timer for both directions as it is going to do the exact
same thing in both cases (call the interrupt routine). Of course that
depends on the details of the coalescing support. Any objections on
that?

> I've implemented this for the mcp251xfd driver, see:
> 
> 656fc12ddaf8 ("can: mcp251xfd: add TX IRQ coalescing ethtool support")
> 169d00a25658 ("can: mcp251xfd: add TX IRQ coalescing support")
> 846990e0ed82 ("can: mcp251xfd: add RX IRQ coalescing ethtool support")
> 60a848c50d2d ("can: mcp251xfd: add RX IRQ coalescing support")
> 9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")

Thanks for the pointers. I will have a look and try to implement it
similarly.

Best,
Markus
