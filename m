Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183074D671F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350527AbiCKRF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiCKRF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:05:56 -0500
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087C11D639A;
        Fri, 11 Mar 2022 09:04:53 -0800 (PST)
Received: by mail-qv1-f41.google.com with SMTP id b12so7463536qvk.1;
        Fri, 11 Mar 2022 09:04:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U2EzJeKP2pg6VmPIZ+R6lKKHZOiHE3M5gtD8vP+xTcw=;
        b=j5zrP/8KgVWZSwWOr2DRhLREPxpKLGxD20kINxpFfJK3eG/XIpdNMzTUgi19Hpx4Qp
         bQvolIYvyFpkFmUAaod2wSFgsf307aFGfLTt8Bd93P0W+fk5RAlYoJAhdX+M7Ps4kcBb
         6XDsFL90uHZWQdpscpKbLBbumo+Ini+vSTU8IQzyvlC7vCtcy4WagWBCxjS/mVe9WCyQ
         jdBzKFyjpe9AyuZSJmDRM+DS+fpx6wKJxFNnH0sjIJg5rmV9u6j+WljDyXEKHbe/1BVL
         N//NnQsm43C4a5q714Ex6XmoEnXGpmv8gT/nfgJPexG3YYaP8JvT+ssaFN1Cd5Tsyz4e
         U0/g==
X-Gm-Message-State: AOAM532QX+UhlPsQHZvKMNY9jyFPAayBP+kIYXIJLAnrjRzB12KS3ir2
        jhgHQqgf1PVhBVfLO6edKkc+Ani05vd5rA==
X-Google-Smtp-Source: ABdhPJyV6M+ow1hyCgPBT8fK39tf4Tp0omiAck36cXSmMYM+FPpugI2x+dbmFfoTRTOhgnJvgXeCHA==
X-Received: by 2002:ad4:5ce4:0:b0:435:bf3a:3e48 with SMTP id iv4-20020ad45ce4000000b00435bf3a3e48mr8491824qvb.93.1647018291761;
        Fri, 11 Mar 2022 09:04:51 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id i192-20020a379fc9000000b0067b314c0ff3sm3991057qke.43.2022.03.11.09.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 09:04:50 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id x200so18212158ybe.6;
        Fri, 11 Mar 2022 09:04:49 -0800 (PST)
X-Received: by 2002:a25:c54a:0:b0:628:9d7f:866a with SMTP id
 v71-20020a25c54a000000b006289d7f866amr8885630ybe.546.1647018289554; Fri, 11
 Mar 2022 09:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20220309162609.3726306-1-uli+renesas@fpond.eu> <20220309162609.3726306-3-uli+renesas@fpond.eu>
In-Reply-To: <20220309162609.3726306-3-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 11 Mar 2022 18:04:38 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWSw=jmawsGG9K6QKTV9-sjM6w0fgDqv1qQHqrbNvAeuw@mail.gmail.com>
Message-ID: <CAMuHMdWSw=jmawsGG9K6QKTV9-sjM6w0fgDqv1qQHqrbNvAeuw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] arm64: dts: renesas: r8a779a0: Add CANFD device node
To:     Ulrich Hecht <uli+renesas@fpond.eu>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfram Sang <wsa@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        socketcan@hartkopp.net,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
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

On Wed, Mar 9, 2022 at 5:26 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> This patch adds a CANFD device node for r8a779a0.
>
> Based on patch by Kazuya Mizuguchi.
>
> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, will queue in renesas-devel for v5.19.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
