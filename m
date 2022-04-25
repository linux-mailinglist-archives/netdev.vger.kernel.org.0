Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A7950E146
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbiDYNPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiDYNPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:15:06 -0400
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD7936337;
        Mon, 25 Apr 2022 06:11:54 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id t11so3311532qto.11;
        Mon, 25 Apr 2022 06:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EUjS5W9rwWbrvFONcfo0a44zA9TrVxWL80YbarPa1Hw=;
        b=VbmTmyE9WXdZ94BVLAcjRfcw1SLpsd7crYCxFfd+vAl/LaJME36O3xG/H/zxb7fhIN
         1GT6etcWOZcRdCb9XngcGfAZQzJmTeHL7p/NSXmM2UYd6SnakHf1zCjHlnSgZblv8bXc
         4UmTVX5O1dfd2ms2TEnf+G9sGyfXPOUbQY7pfFJCYwlMyBIMawxuEdTqyHnwvNW/2k7N
         Cbyip5CPXDb4RopWgEgyGVhyBUgyAuKgC0CbLwkQ1C1CgOz5NIJRS1MTByVe2nj0xgjm
         rmuc9zwOaV5JPjMc630zfZbY55SiZdiBSiXVtvxo74ek4p1xVak5fRT+SJI6E+QQfS8P
         NQjg==
X-Gm-Message-State: AOAM530u++Zy/e1G6/+jiZaNpl+oE0YaAwjOtSKFMtWaiE/PeAUoX2WH
        PF4plihjOcnNHQk+KF7wR4sm1pwLMAk3cA==
X-Google-Smtp-Source: ABdhPJwQMK3+S8UZxy9uctBZ6OO5kzMujFWREZdo1hZvEPlUrVl6j8OEBcoCPtP+4bM1SMSuqSz0kg==
X-Received: by 2002:ac8:58d1:0:b0:2f2:5a6:2ff0 with SMTP id u17-20020ac858d1000000b002f205a62ff0mr11591810qta.39.1650892313628;
        Mon, 25 Apr 2022 06:11:53 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id h11-20020ac8584b000000b002f3586f0efcsm6068264qth.88.2022.04.25.06.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 06:11:53 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id v59so14026521ybi.12;
        Mon, 25 Apr 2022 06:11:52 -0700 (PDT)
X-Received: by 2002:a25:d393:0:b0:648:4871:3b91 with SMTP id
 e141-20020a25d393000000b0064848713b91mr7039896ybf.506.1650892312730; Mon, 25
 Apr 2022 06:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 25 Apr 2022 15:11:40 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWGs6E4CVz_hVrWaBRDBQERWOt5Gs5y-Rk6Ffs5-q+d=A@mail.gmail.com>
Message-ID: <CAMuHMdWGs6E4CVz_hVrWaBRDBQERWOt5Gs5y-Rk6Ffs5-q+d=A@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL support
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 3:07 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
