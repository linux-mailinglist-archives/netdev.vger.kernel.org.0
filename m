Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD9F533CB8
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbiEYMcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiEYMcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:32:07 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FEF6D86D;
        Wed, 25 May 2022 05:32:06 -0700 (PDT)
Received: by mail-qk1-f182.google.com with SMTP id 190so10584111qkj.8;
        Wed, 25 May 2022 05:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gSY52yOUYVVMa0IKthoUAMnd2qVR5XAQBhwBHrssrZM=;
        b=vdGKoQ04wBc5zaq6JKf1Tb3gv2bXgAQTJ0HzfKEd167s+uZ5OApngZpCaQUUUIVE1p
         p6huAZJ+v1FDDfGxzD27Lx/l5Q1LZ4LPD5nrXZzFKyXIC4ijyd4PBpErLAyBptslNPvG
         UTNDKPu1I05VgVwGCCMO8BlN5dh7U2qhZSU8Y2ykGPRbAyu2zL6B11E5dOkED9eI6mZQ
         COkeCNYg12m1cWqywCdNqJYqXUivm7XeLg9i8cyB18rPELSBIS0S4i7locgKwtSlYCt5
         UHSHDBJLVaQdSP3DoywAyLv5Qq1BE0g90rAatSnWOfpUk2Rhlu5TDvm8cIJdJiuMz+e8
         3bsw==
X-Gm-Message-State: AOAM531Y02ViFzC3mJWaiCpVqmvJXMUIr88acIQgbJlD6OoRcqq8cBNb
        YLN70JNkz1792lAj21r4bs+WHkHkXVwirQ==
X-Google-Smtp-Source: ABdhPJxpP9y0QtXhG+t1/hDsTOXQ0LWr0ZEcxPt8Cp3O3S9OK7kxba93WGlpZHm226grEOJ5DMqc1w==
X-Received: by 2002:a05:620a:1a17:b0:69c:669c:1032 with SMTP id bk23-20020a05620a1a1700b0069c669c1032mr20411150qkb.377.1653481924985;
        Wed, 25 May 2022 05:32:04 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id z11-20020a05622a124b00b002f93ece0df3sm1306465qtx.71.2022.05.25.05.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 05:32:04 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id o80so36035186ybg.1;
        Wed, 25 May 2022 05:32:03 -0700 (PDT)
X-Received: by 2002:a05:6902:905:b0:64a:2089:f487 with SMTP id
 bu5-20020a056902090500b0064a2089f487mr31418555ybb.202.1653481923339; Wed, 25
 May 2022 05:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220524112425.72f8c6e0@kernel.org> <20220525122813.88431-1-alexandru.tachici@analog.com>
In-Reply-To: <20220525122813.88431-1-alexandru.tachici@analog.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 25 May 2022 14:31:51 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVTfgFLCJ3u9CYTZ5xUL21+ENVsmHwhkPC3FRUF=k+xGg@mail.gmail.com>
Message-ID: <CAMuHMdVTfgFLCJ3u9CYTZ5xUL21+ENVsmHwhkPC3FRUF=k+xGg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock
 description syntax
To:     alexandru.tachici@analog.com
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Josua Mayer <josua@solid-run.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
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

Hi Alexandru,

On Wed, May 25, 2022 at 2:12 PM <alexandru.tachici@analog.com> wrote:
> > On Tue, 24 May 2022 16:30:18 +0200 Geert Uytterhoeven wrote:
> > > On Tue, May 24, 2022 at 4:12 PM Geert Uytterhoeven
> > > <geert+renesas@glider.be> wrote:
> > > > "make dt_binding_check":
> > > >
> > > >     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
> > > >
> > > > The first line of the description ends with a colon, hence the block
> > > > needs to be marked with a "|".
> > > >
> > > > Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
> > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > ---
> > > >  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
> > >
> > > Alexandru Ardelean's email address bounces, while he is listed as
> > > a maintainer in several DT bindings files.
> >
> > Let's CC Alexandru Tachici, maybe he knows if we need to update
> > and to what.
>
> Yeah, I should have updated this one. You can add me instead or I will come back with a patch.
>
>   - Alexandru Tachici <alexandru.tachici@analog.com>

Please send a patch (or patches).  There are multiple files listing the
bouncing address, and I don't know which devices you have inherited.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
