Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E64532C32
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbiEXOah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiEXOag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:30:36 -0400
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3526A01F;
        Tue, 24 May 2022 07:30:36 -0700 (PDT)
Received: by mail-qk1-f171.google.com with SMTP id 14so9003263qkl.6;
        Tue, 24 May 2022 07:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRVor7wHTRh8bvxUqyPVkNeugs0nGyo/FpT2aSmbf6Q=;
        b=iSFoulr6mqws1PUGqxhaLrL7skUbmGevXTDcSv3D3C4DaDzfI5sLWmEsophD2hgKpZ
         AJB0w/VlMOrxtXN9KdfZ7jKoyEAApH2+BIWpFcqTW0SmD51Efb1K0Mo+45JLiuJKahZq
         FZEYALWonrecNZWo8SZSuv2gcXtjoeLBcU0ea1nzhAN6aacXUc52lxwREZkf8pZIJdiC
         O/QldQkz2JhE0YzRYb2Uaz18l8RMIdpnR3BftI8ZxCOSnNi83JAoGEABBfvqYrIGL0gC
         pC9Q+YZLW449fgqXa2EPHz7JB6WcJ20xiMOADX87E4v262IkJTPwDGQDCcNmdK6Vbhwt
         ATaA==
X-Gm-Message-State: AOAM5319MUaWG3hxv0dNL3rnjjg67w23+LYhlTrYXdEMjDTvximA0hxe
        QB6b4G/8sBirGqQiwtpsCvWM5x+U7aaT09i2
X-Google-Smtp-Source: ABdhPJwSFgFBqRGuJVjq+34rF1w85EpkTpJZnSOR5szvW518rmkak4CZXbN5PX3wrFEBcd7lwHzQ1Q==
X-Received: by 2002:a05:620a:bcb:b0:67d:1b1c:a988 with SMTP id s11-20020a05620a0bcb00b0067d1b1ca988mr16877190qki.587.1653402635175;
        Tue, 24 May 2022 07:30:35 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id g15-20020ae9e10f000000b0069fc13ce1e9sm5877533qkm.26.2022.05.24.07.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 07:30:31 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id q184so2328780ybg.11;
        Tue, 24 May 2022 07:30:30 -0700 (PDT)
X-Received: by 2002:a25:4150:0:b0:64d:7747:9d93 with SMTP id
 o77-20020a254150000000b0064d77479d93mr27501539yba.36.1653402630217; Tue, 24
 May 2022 07:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
In-Reply-To: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 24 May 2022 16:30:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU3efmsc0-o6DJb013dg83pfdM-e3WiS+CjgzSuTceEQA@mail.gmail.com>
Message-ID: <CAMuHMdU3efmsc0-o6DJb013dg83pfdM-e3WiS+CjgzSuTceEQA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock
 description syntax
To:     Michael Hennerich <michael.hennerich@analog.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Josua Mayer <josua@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
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

On Tue, May 24, 2022 at 4:12 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> "make dt_binding_check":
>
>     Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)
>
> The first line of the description ends with a colon, hence the block
> needs to be marked with a "|".
>
> Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-

Alexandru Ardelean's email address bounces, while he is listed as
a maintainer in several DT bindings files.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
