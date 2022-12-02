Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD34640256
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbiLBIjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiLBIih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:38:37 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143001182A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:37:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso3696706wmo.1
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/xIgmLq/C17zsRVPkarsENL7GSZIci+87q7Y9/uooIw=;
        b=1uOrZ8sJ+PUYOTzvGs7uUF7vsYQs+WGpstKt6MC1HMItS/GAt+aHFnMkKpmjT9sgZZ
         847FWIlH3ePBuRhq4Eq0ZSHytatsrdHwQ0oCPKxOhikB6wBRdkjlKKwoCBqLG7WFseiO
         X0ta0WXs0VDBJMKNGldtPEmE8p8Eo6W7h9w677Y5lJfdesMJwZTi+q3Cw1kaFldOSamb
         hwm3Kt8mqJO8Tobt6cF1JR3dweBM4GZquziZayrw02hJjNKdxxreNigjQvurqttedJe3
         2YPJO1NJZKNMtit6TAWRZLV6nALKySXjSGOjZzpuRhHKO1iU4tAp6//PLPKMfF9Is71Q
         aiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xIgmLq/C17zsRVPkarsENL7GSZIci+87q7Y9/uooIw=;
        b=EMgwORFy2vNGq3wf+1U5vwix13J6SpnoYVsqIa5YKRdJZosUB6wMUngYAEXoho+CSI
         1T5n79TFe9OFqsJH5Nu/QwJmaGl6IwAVdgFbEyz2qDSpWjNLButFH/lir6zG3W+k37Ti
         pu+DG/WAg0VdFq5mDkViMYojTGh6RDq9sLE9ZnDuWY5WT83I2zYY1DO2FI0jF1evpRQl
         cLtYmvIZ3v7ZQxQYHaJYVpRMR6kX1aLKwljzeNN7/C+aJVE+xSDA9m5VKXqSNLr+7WBb
         Xk8gZ9dAM2VdqDMlufvZtVGXBTvk8d6aAg/dHkHelPbN+ekSXSByslr2O62xElbq8HLx
         fObw==
X-Gm-Message-State: ANoB5pk8fAsD5mudoaZMZF6yY3yukLfh3W0H/j/uKCfdwvIQryJ0f5rR
        AYmbhpB46e5rwykpVN1Wfjpxwg==
X-Google-Smtp-Source: AA0mqf7nzU7iZ6L5WcgsuHh7L6H7KyqvASHV+E3NzK4ANsBmu7fRw/+rARI/Q5oyv3SzYTVTF/nQtQ==
X-Received: by 2002:a7b:cb83:0:b0:3cf:96da:3846 with SMTP id m3-20020a7bcb83000000b003cf96da3846mr53105100wmi.10.1669970261507;
        Fri, 02 Dec 2022 00:37:41 -0800 (PST)
Received: from blmsp ([185.238.219.82])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b003cf54b77bfesm12948650wmq.28.2022.12.02.00.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 00:37:41 -0800 (PST)
Date:   Fri, 2 Dec 2022 09:37:40 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] can: m_can: Cache tx putidx and transmits in flight
Message-ID: <20221202083740.moa7whqd52oasbar@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-4-msp@baylibre.com>
 <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201111450.fpadmwscjyhefs2u@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Thu, Dec 01, 2022 at 12:14:50PM +0100, Marc Kleine-Budde wrote:
> On 16.11.2022 21:52:56, Markus Schneider-Pargmann wrote:
> > On peripheral chips every read/write can be costly. Avoid reading easily
> > trackable information and cache them internally. This saves multiple
> > reads.
> > 
> > Transmit FIFO put index is cached, this is increased for every time we
> > enqueue a transmit request.
> > 
> > The transmits in flight is cached as well. With each transmit request it
> > is increased when reading the finished transmit event it is decreased.
> > 
> > A submit limit is cached to avoid submitting too many transmits at once,
> > either because the TX FIFO or the TXE FIFO is limited. This is currently
> > done very conservatively as the minimum of the fifo sizes. This means we
> > can reach FIFO full events but won't drop anything.
> 
> You have a dedicated in_flight variable, which is read-modify-write in 2
> different code path, i.e. this looks racy.

True, of course, thank you. Yes I have to redesign this a bit for
concurrency.

> If you allow only power-of-two FIFO size, you can use 2 unsigned
> variables, i.e. a head and a tail pointer. You can apply a mask to get
> the index to the FIFO. The difference between head and tail is the fill
> level of the FIFO. See mcp251xfd driver for this.

Maybe that is a trivial question but what's wrong with using atomics
instead?

The tcan mram size is limited to 2048 so I would like to avoid limiting
the possible sizes of the tx fifos.

Best,
Markus

> 
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


