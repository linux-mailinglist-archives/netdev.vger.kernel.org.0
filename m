Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBBB604C7A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiJSP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiJSP4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1DF491CF;
        Wed, 19 Oct 2022 08:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B491361920;
        Wed, 19 Oct 2022 15:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906F4C433D7;
        Wed, 19 Oct 2022 15:54:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hD67WuZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666194866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b4P8azf44UJBRn8ZnXfi2U1vw/msdRsaD0nyFoiSF58=;
        b=hD67WuZxf/B4mmqZpBrpogpbwkE7JLcooVMwmxgqpW5t6If+Lp0mq6WJmJEQgAq/uJV4ji
        Aw+RKyTAeYDZ/nWYZzqzjzhkXFS7kZbVdz6vbfxsUDz/H/cIK/c9PRECq1XLkuJu8fCm9S
        vi6/OyGD8VxMyV5PTmgb4VXDBEiZqOE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c36e7f9b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 19 Oct 2022 15:54:26 +0000 (UTC)
Received: by mail-ua1-f41.google.com with SMTP id i16so7487040uak.1;
        Wed, 19 Oct 2022 08:54:25 -0700 (PDT)
X-Gm-Message-State: ACrzQf2HYjEPFSTmYkKcUAKKBKFHuavYMbN6c/yEl1FDhuD3MOg0pA85
        fPSVJEH1uy/cx8xmuHxYpjvHQPdSJ6FAYbmssoI=
X-Google-Smtp-Source: AMsMyM6AiJljW4K2rOUSspq/uwHjZ5zHOUJomjnyMCDEGEoqoyFiOi/TwLZ5B9thKFxeLj6ugh35MYZs9A+RYmjqzPM=
X-Received: by 2002:ab0:488a:0:b0:3ad:4f5c:66ad with SMTP id
 x10-20020ab0488a000000b003ad4f5c66admr2025391uac.65.1666194864935; Wed, 19
 Oct 2022 08:54:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221018202734.140489-1-Jason@zx2c4.com> <20221019081417.3402284-1-Jason@zx2c4.com>
 <20221019090052.GB81503@wp.pl>
In-Reply-To: <20221019090052.GB81503@wp.pl>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 19 Oct 2022 09:54:13 -0600
X-Gmail-Original-Message-ID: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
Message-ID: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: rt2x00: use explicitly signed or unsigned types
To:     Stanislaw Gruszka <stf_xl@wp.pl>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 3:00 AM Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
> On Wed, Oct 19, 2022 at 02:14:17AM -0600, Jason A. Donenfeld wrote:
> > On some platforms, `char` is unsigned, but this driver, for the most
> > part, assumed it was signed. In other places, it uses `char` to mean an
> > unsigned number, but only in cases when the values are small. And in
> > still other places, `char` is used as a boolean. Put an end to this
> > confusion by declaring explicit types, depending on the context.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> > Cc: Kalle Valo <kvalo@kernel.org>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> <snip>
>
> > @@ -3406,14 +3406,14 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
> >               } else if (rt2x00_rt(rt2x00dev, RT5390) ||
> >                          rt2x00_rt(rt2x00dev, RT5392) ||
> >                          rt2x00_rt(rt2x00dev, RT6352)) {
> > -                     static const char r59_non_bt[] = {0x8f, 0x8f,
> > +                     static const s8 r59_non_bt[] = {0x8f, 0x8f,
> >                               0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
> >                               0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
> >
> >                       rt2800_rfcsr_write(rt2x00dev, 59,
> >                                          r59_non_bt[idx]);
> >               } else if (rt2x00_rt(rt2x00dev, RT5350)) {
> > -                     static const char r59_non_bt[] = {0x0b, 0x0b,
> > +                     static const s8 r59_non_bt[] = {0x0b, 0x0b,
> >                               0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
> >                               0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
>
> Please make those two tables u8 as well.

Nice catch. Will do.

Jason
