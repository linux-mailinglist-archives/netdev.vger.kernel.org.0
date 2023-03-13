Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6EF6B6DE5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 04:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCMDTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 23:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCMDTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 23:19:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49BE279BF
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 20:19:01 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ek18so12061039edb.6
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 20:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678677540;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AaTbJOlzDqoyTznkZQew61s0LEM4GBuB+uw2lDWthD4=;
        b=SreQplaOaiKXW0B6GkZdUz6D9Sa8v+5a40rGEdoJ775vEgiQ7rGzPPoJB2nGkdPgPj
         MrRQnJrU82a6hHvFFpf8YjH/URrfgV0bOVovjOaGrsudExde0AztAa92HAOCXQNViqP/
         70pOPj5yn3//8pP7ik8k8O6D36LP6LP71Cx1ezuLAL6B6Tva+t2Yy2yogC3Uqskevt7H
         LfcBAyBNUUgTv4alNcfEjT3u8gldjn0kYejutF2SuTLxD5whjtZYLSCzsTBFMhRod19Z
         JSKRelOmYUg2qG+mRrq6BrYlHo7TE/ubAUvDuM/0PqYtFQ9gUS1x0+2HCPBDSDULmXYv
         wXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678677540;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AaTbJOlzDqoyTznkZQew61s0LEM4GBuB+uw2lDWthD4=;
        b=4wI//mSmsZnr1NZjQrYXc2PZBxAtJnxlfFS8M0qVKfOplwEh6UGE2sTKyGH2Smr94P
         GmlABGgP5obQvu0Lsj+IW5dgPMQQEHEnU5av+ZJHv1K9ax3iZQQ6jiYMHnRvyMg+hhUl
         4PmvU3vFTfIFSBD22x8EU6zIAxM/aRoAhgEosi2/HSs6AeiF3GWJWHGh5HkMCNz5cpH0
         PpYmO7HSzXiLCaopy7ktuqWdtSDNhHmc9swraUQn2rbx6WWfi9lSUgW5iBuvlhOGuR05
         K85HaaICFIM7Wb0FUBDz/CS1pwyz7ZnXQ+OwlJKjUBVDRS1gLXeIcyoCXKLeBBkMrjtC
         M+ag==
X-Gm-Message-State: AO0yUKXGOudSvNqvDUU1/hDJGUV4smoMemmJCFs1bW+BGOWpKLUSDAcl
        WQydy5WHTLIBViBV1nJNF78CW13rR4iJkKAg/bwl9g==
X-Google-Smtp-Source: AK7set9w8TNcS+IZtR8IG8YLrACA9rb8f2+mU6VRo2IEjowuxVnE18r7Gt3VjLgTfeJg8cMqPLkf4sh/ejlKubZk5g8=
X-Received: by 2002:a50:9f0b:0:b0:4fb:f19:883 with SMTP id b11-20020a509f0b000000b004fb0f190883mr2233841edf.1.1678677540018;
 Sun, 12 Mar 2023 20:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230209020916.6475-1-steev@kali.org> <20230209020916.6475-3-steev@kali.org>
 <ZAoS1T9m1lI21Cvn@hovoldconsulting.com> <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
 <ZArb/ZQEmfGDjYyc@hovoldconsulting.com>
In-Reply-To: <ZArb/ZQEmfGDjYyc@hovoldconsulting.com>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Sun, 12 Mar 2023 22:18:48 -0500
Message-ID: <CAKXuJqhe3z0XrLCMZ3vc3+Ug-rMjayNuMAvh+ucuUkZQpQdb2A@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
To:     Johan Hovold <johan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johan,

<SNIP>
> > > As I mentioned elsewhere, you need to update also this function so that
> > > wcn6855 can be powered down.
> >
> > Sorry, I do have that locally, I just haven't pushed a v6 as I was
> > looking at Tim's v2 of the qca2066 and was wondering if I should or
> > shouldn't continue working on my version of the driver?
>
> I only skimmed that patch a while ago, but that ones not strictly needed
> for wcn6855, right? Things seems to work well here with just this series
> applied.

Works, but, not quite well, and with the nvm bits from Tim's patch, we
end up getting closer?  I think that is the best way to put it.  With
what we currently have, we end up loading hpnv21.bin for our nvm patch
file, however, we actually want (at least on my Thinkpad X13s) the
.b8c file from the Windows partition for our nvm patch; With the b8c
file symlinked to .bin with just my patch set, I am able to connect a
pair of Air Pods Gen1 to the ThinkPad and play back audio, as well as
use them for input.  With the .bin file that comes from
linux-firmware, they will still connect, however, they will randomly
disconnect, as well as the audio output is all garbled.  I think,
ideally, we get v6+ in, and then we can figure out what to do about
the bits that Tim's patch adds.  I've tried them locally, but I'm not
confident enough in my knowledge to address the issues that are
brought up in the code review there.

> > > With power-off handling fixed, this seems to work as quite well on my
> > > X13s with 6.3-rc1. Nice job!
> > >
> > > Btw, apart from the frame reassembly error, I'm also seeing:
> > >
> > >         Bluetooth: Received HCI_IBS_WAKE_ACK in tx state 0
> > >
> > > during probe.
> > >
> > I'm still not sure where the frame reassembly error comes from, and I
> > don't know how to get more info to figure it out either, if anyone
> > happens to have any guidance for that, I would love some.
> > Additionally, it doesn't always happen.  It seems to happen on the
> > first load of the module, however, running modprobe -r && modprobe in
> > a loop (with the powerdown properly modified so the log isn't full of
> > splats),  it doesn't seem to occur every time. Likewise for the
> > WAKE_ACK.
>
> Ok. Looks like the Chromium team tried to suppress these errors when
> switching line speed by toggling rts, but the frame-assembly error I get
> appears to happen before that.

I am still trying to figure it out here as well, but I want to get v6 out there.

> Johan
