Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AD5596A74
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiHQHdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiHQHd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:33:27 -0400
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F332356DD;
        Wed, 17 Aug 2022 00:33:26 -0700 (PDT)
Received: by mail-qv1-f44.google.com with SMTP id b2so582394qvp.1;
        Wed, 17 Aug 2022 00:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=SPq3Q4TPbLE7lPoozTYrDmUtlAuvRfPohoVUSyc0jcM=;
        b=qNt41EECGChDDokode44BNhe2byNhOf7y+zMhrT6f6y0YEpHbwoZYWsXQHIwO5y3ZM
         utGBEUz8TKR7Kf7BaNu++Pu5yFidOqFahhl3H8Mugn5U8eHJmjV0kZLJGB9G5YfFuVhu
         ipSawDmtt4TBmTgSkPBzBfjHprJO0xkA2Pn7LOeg9kYZFUzkGNWqdAHMAzub2XR/LfGo
         vjoFaglWlayfOn51iy84j4anq2BNYSx6bHl2jUtsMh7CN96qBZPCKurHzCWCMdeg9lHZ
         cJieyktUtSc/dn72I7KjIqoq+qKpcVyuTT74vjfmUnwoymXuZpi1Np2Dni9aTy3mgVec
         DZdg==
X-Gm-Message-State: ACgBeo0YAsPVkd5gR66QmQrDuvdOnRYbzdfIil5SLLFKwtDQg0iziZt2
        Fs+TZT8WdgE/S8CYofRwJ9NpM3e2MQWvzg==
X-Google-Smtp-Source: AA6agR7kSI0FdlF5xw4jeTQ13xoInjFreM3MvNt7hVz9toyT07EesM5JidkthmoT1u9aTVrarMsbFA==
X-Received: by 2002:a0c:9d09:0:b0:496:a686:2c2e with SMTP id m9-20020a0c9d09000000b00496a6862c2emr1600657qvf.61.1660721605525;
        Wed, 17 Aug 2022 00:33:25 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id i17-20020a05620a405100b006b9c6d590fasm14481536qko.61.2022.08.17.00.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 00:33:24 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-324ec5a9e97so210106227b3.7;
        Wed, 17 Aug 2022 00:33:24 -0700 (PDT)
X-Received: by 2002:a25:880f:0:b0:67c:2727:7e3c with SMTP id
 c15-20020a25880f000000b0067c27277e3cmr18637000ybl.36.1660721604426; Wed, 17
 Aug 2022 00:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <edc5763d90054df7977ae24976e80533c7a1bff9.1660663653.git.geert+renesas@glider.be>
 <20220816112522.05aac832@kernel.org>
In-Reply-To: <20220816112522.05aac832@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Aug 2022 09:33:12 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU=xtnPCAd8SF+MyeFNHfsVE17++CcsBtDA3veZ0wo74w@mail.gmail.com>
Message-ID: <CAMuHMdU=xtnPCAd8SF+MyeFNHfsVE17++CcsBtDA3veZ0wo74w@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Fix incorrect "the the" corrections
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Slark Xiao <slark_xiao@163.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Aug 16, 2022 at 8:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 16 Aug 2022 17:30:33 +0200 Geert Uytterhoeven wrote:
> > Lots of double occurrences of "the" were replaced by single occurrences,
> > but some of them should become "to the" instead.
> >
> > Fixes: 12e5bde18d7f6ca4 ("dt-bindings: Fix typo in comment")
>
> No empty lines between tags.

Ooops, thanks. Shall I resend?

> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> > Documentation/devicetree/bindings/net/qcom-emac.txt         | 2 +-
> > Documentation/devicetree/bindings/thermal/rcar-thermal.yaml | 2 +-
>
> Who takes it then? :S

The tree that took 12e5bde18d7f6ca4, i.e. the DT tree?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
