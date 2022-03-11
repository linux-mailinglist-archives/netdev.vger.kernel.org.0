Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3EC4D6722
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350579AbiCKRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241140AbiCKRGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:06:15 -0500
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036011D639C;
        Fri, 11 Mar 2022 09:05:12 -0800 (PST)
Received: by mail-qk1-f182.google.com with SMTP id c7so7457355qka.7;
        Fri, 11 Mar 2022 09:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fK39HhjEjtaaB7vXMTnZuM5o4lss/YoGvlZq7V45BAM=;
        b=WZGjR0WT3pdltX3GxuCAL3GT6r0QXMuC5t8BmQkooWxO/vEbAeMG3oQ4dgRVuze1tQ
         9RCkwBN0tVGGlT7Ee2FjjLuzmnLFszr+UlNhO+m5rzzJ5oD7I+400HX3kYXQJuZxo0K1
         MTXBSXd3XYLoEO4CEBACCtDeLk4aysEFNwpt3AOOOiOTbdYaPpNG6N+U3w1z5gh4HqYl
         2w26Mjl4LHgHYUFOhrpX8lSptqbOQBQwM1xXVKuxZRCFV2LkGoX0VO1tZFc0GemvyOAs
         fPm74qZhB7PSKW6hjbfWan/BfliKlNib7MX+p/HTUt06kOGmdlFnfXEVFRoTiDzCnyWv
         gu5A==
X-Gm-Message-State: AOAM533zmZsElY7gu7atyj/zdyAheOKaDUN+3UmNKbXwm9h6ElNtXb2B
        3sm01Kitgx8nvBxDuk+jR/YJskuPT/mR8w==
X-Google-Smtp-Source: ABdhPJyJW5IU91xssQVxZDxjcFZqj2EnWDVKEYyRl98oDYC4bO7GmsBPZAJUgHUzfKIBkNdxIfyNuw==
X-Received: by 2002:a37:347:0:b0:67b:12a8:f441 with SMTP id 68-20020a370347000000b0067b12a8f441mr7235729qkd.302.1647018310707;
        Fri, 11 Mar 2022 09:05:10 -0800 (PST)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id p12-20020a05622a048c00b002de8f67b60dsm5667237qtx.58.2022.03.11.09.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 09:05:10 -0800 (PST)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2dbd8777564so100979047b3.0;
        Fri, 11 Mar 2022 09:05:10 -0800 (PST)
X-Received: by 2002:a81:5247:0:b0:2dc:2171:d42 with SMTP id
 g68-20020a815247000000b002dc21710d42mr8960941ywb.438.1647018309818; Fri, 11
 Mar 2022 09:05:09 -0800 (PST)
MIME-Version: 1.0
References: <20220309162609.3726306-1-uli+renesas@fpond.eu> <20220309162609.3726306-4-uli+renesas@fpond.eu>
In-Reply-To: <20220309162609.3726306-4-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 11 Mar 2022 18:04:58 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW+_5UDRYUQ0aSymgXO1BUryc+AV8SAjSS4F-Lna5B_UQ@mail.gmail.com>
Message-ID: <CAMuHMdW+_5UDRYUQ0aSymgXO1BUryc+AV8SAjSS4F-Lna5B_UQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] arm64: dts: renesas: r8a779a0-falcon: enable CANFD
 0 and 1
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
> Enables confirmed-working CAN interfaces 0 and 1 on the Falcon board.
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
