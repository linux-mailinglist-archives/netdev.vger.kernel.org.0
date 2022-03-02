Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0424CA6CE
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiCBN6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbiCBN6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:58:46 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB1444758;
        Wed,  2 Mar 2022 05:58:03 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2dbc48104beso18333717b3.5;
        Wed, 02 Mar 2022 05:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WyKZHwQr5nHGh+e/AL2B1v9HpePCkAYLR4kSXAi9MZM=;
        b=U0iRu5f8BNM7nILytuX99wKRiCt5vyXXtohu2gzG08qdN7tcXTPoGXlhxytmpKy1iA
         aNRVUQw8yBm9ys3DsFF5OcoMDLqqmeboEw+3QfaLX5T662sg8X/+bTOD77v9lY895NDW
         wwbsulJSTGTqRpdarJ6DxHV8jQGHjiMM5IFu/dq6WY828tpsdYxnPR1ciPVinQ0C0OnS
         s9Lf5lNVUbAsmJn9xlYQDooufA2oVbtDdhQ1787jugqmSS8yo7mbJB2h2spLwaSEwjRr
         PCHg6atVK7AtntJLp8gUyNPNq2FlJS5WawBmlQMUQ2yop5685zmCPuLhSa/SoYVuyeJr
         SPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WyKZHwQr5nHGh+e/AL2B1v9HpePCkAYLR4kSXAi9MZM=;
        b=nZQRfJ9fnX2UByeUPR7q/CHIT1x8cex9vRMo+ge4q8M0dN6UHmKnLtfZiNdzJvS09C
         lNl4fIWFhRV8k9JhYvBrPDtO5u9PirrZhN8Ro6bKgDzDHyNkVKq3HZUzXMDM52+3QIfZ
         cg7aMR1P/GRJCNUkwa55AsKTW2QiHE+1mAMO9ByCLFipGuP9HHnl7VncKbM+JtudjGwP
         EE2UyROMJtfzPumzKehbcSV+LzK6xvmhvF4VwJ46j1L8C4HoBIrLc3Azs4Ne0gqnJYJc
         /6RSHdkl7xJgmX5KEfZAU10D7mVrE/XvqolxMs6p0oF3+JnKXc7rPAV9otVd9VCUPmcY
         Hagw==
X-Gm-Message-State: AOAM531dSN3bxiC0c+kIwX0+HOhNoC+WWCF8OuVM3t+/fgjYNnuQ7782
        NXvRkEPZmdOszm3o1lBsV6GOFg1X3jXNvRPECfDyYks8UTRQ9w==
X-Google-Smtp-Source: ABdhPJyPac81GZXj3hbm1zrqa6T6Hpt+Qnmao5PDX2WxpONnx7zBPrAfJH7wYFShqmnZ+sbpuc/u4K6tmZwwOpAKXuA=
X-Received: by 2002:a81:2f12:0:b0:2d7:d366:164a with SMTP id
 v18-20020a812f12000000b002d7d366164amr30593700ywv.265.1646229482232; Wed, 02
 Mar 2022 05:58:02 -0800 (PST)
MIME-Version: 1.0
References: <20220227213250.23637-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <Yh4855Np63fEUl4G@robh.at.kernel.org>
In-Reply-To: <Yh4855Np63fEUl4G@robh.at.kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Wed, 2 Mar 2022 13:57:36 +0000
Message-ID: <CA+V-a8tuLGKf1qY7Z8MP5aAWUCkSPG4Ms8JnD67yJFW4fsX_0A@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/V2L SoC
To:     Rob Herring <robh@kernel.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Mar 1, 2022 at 3:34 PM Rob Herring <robh@kernel.org> wrote:
>
> On Sun, Feb 27, 2022 at 09:32:50PM +0000, Lad Prabhakar wrote:
> > Document RZ/V2L CANFD bindings. RZ/V2L CANFD is identical to one found on
> > the RZ/G2L SoC. No driver changes are required as generic compatible
> > string "renesas,rzg2l-canfd" will be used as a fallback.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> > DTSI changes [0] have been posted as part of separate series.
> >
> > [0] https://patchwork.kernel.org/project/linux-renesas-soc/patch/
> > 20220227203744.18355-4-prabhakar.mahadev-lad.rj@bp.renesas.com/
> > ---
> >  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
> >  1 file changed, 1 insertion(+)
>
> The patch wouldn't apply, but I don't see the problem other than the
> sha hashes are not from a known base. Please send patches against a
> known rcX (rc1 is preferred) unless you have some other dependency. And
> document that dependency.
>
Sorry about that, I missed mentioning the depadancy patch [0].

> Anyways, it is applied manually now.
>
Thanks.

[0] https://patchwork.kernel.org/project/linux-renesas-soc/patch/20220209163806.18618-5-uli+renesas@fpond.eu/

Cheers,
Prabhakar
