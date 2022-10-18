Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF0660346E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 22:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJRU6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 16:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJRU6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 16:58:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671F980F6B;
        Tue, 18 Oct 2022 13:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BC51B82113;
        Tue, 18 Oct 2022 20:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E47C433B5;
        Tue, 18 Oct 2022 20:58:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="F7gObyUL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666126723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gbNrqkAmkdQNh54QMfahwNrlzGhnLQkj38mepOX8CvM=;
        b=F7gObyULOPiE7SisivTExQqZhqmi06KhNSWt1DQY0nast1V8Ad0YQd9iIMN0u59zghcZXa
        01I8l8sjW/LOPcjFgzyrK6G5KH4Bdu92IU5g38zXeZVMjHIlV+lwTpIExqbQnmNRX2pCax
        YrpCwWvxFd9uyQePGEXBZKyv2bzWUUU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c99e1dea (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 18 Oct 2022 20:58:42 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id 3so15988493vsh.5;
        Tue, 18 Oct 2022 13:58:42 -0700 (PDT)
X-Gm-Message-State: ACrzQf0Nrb0g7NqPhUHKY1FddiSuvvWyMXQN8Pi2oAxWz2YMj3RNssqf
        Mw3cLEZMk07OtxeGyWWyeHHLGSqcE+rMVTlzVvY=
X-Google-Smtp-Source: AMsMyM6bJ2VUjcb+te44+zGsDdQz0Fw+mBwnfeKnpOcuY+kiRk3c1H3JbyjXEFVtqLfZG3vGUSpq2CDwB0/Ne1pKMlo=
X-Received: by 2002:a67:ed9a:0:b0:3a7:718a:7321 with SMTP id
 d26-20020a67ed9a000000b003a7718a7321mr2099048vsp.55.1666126721398; Tue, 18
 Oct 2022 13:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <202210190108.ESC3pc3D-lkp@intel.com> <20221018202734.140489-1-Jason@zx2c4.com>
 <Y08PVnsTw75sHfbg@smile.fi.intel.com> <Y08SGz/xGSN87ynk@zx2c4.com> <Y08TQwcY3zL3kGHR@smile.fi.intel.com>
In-Reply-To: <Y08TQwcY3zL3kGHR@smile.fi.intel.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Oct 2022 14:58:30 -0600
X-Gmail-Original-Message-ID: <CAHmME9qQAqXYR0+K=32otECgrni51Z0c38iO3h1VRM4Xf3o2=Q@mail.gmail.com>
Message-ID: <CAHmME9qQAqXYR0+K=32otECgrni51Z0c38iO3h1VRM4Xf3o2=Q@mail.gmail.com>
Subject: Re: [PATCH] wifi: rt2x00: use explicitly signed type for clamping
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
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

On Tue, Oct 18, 2022 at 2:57 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Tue, Oct 18, 2022 at 02:52:43PM -0600, Jason A. Donenfeld wrote:
> > On Tue, Oct 18, 2022 at 11:40:54PM +0300, Andy Shevchenko wrote:
> > > On Tue, Oct 18, 2022 at 02:27:34PM -0600, Jason A. Donenfeld wrote:
> > > > On some platforms, `char` is unsigned, which makes casting -7 to char
> > > > overflow, which in turn makes the clamping operation bogus. Instead,
> > > > deal with an explicit `s8` type, so that the comparison is always
> > > > signed, and return an s8 result from the function as well. Note that
> > > > this function's result is assigned to a `short`, which is always signed.
> > >
> > > Why not to use short? See my patch I just sent.
> >
> > Trying to have the most minimal change here that doesn't rock the boat.
> > I'm not out to rewrite the driver. I don't know the original author's
> > rationales. This patch here is correct and will generate the same code
> > as before on architectures where it wasn't broken.
> >
> > However, if you want your "change the codegen" patch to be taken
> > seriously, you should probably send it to the wireless maintainers like
> > this one, and they can decide. Personally, I don't really care either
> > way.
>
> I have checked the code paths there and I found no evidence that short can't be
> used. That's why my patch.

Do you have a rationale why you want to change codegen?

Jason
