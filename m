Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7BA4D7D5F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiCNILA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiCNIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:10:59 -0400
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258532BE6;
        Mon, 14 Mar 2022 01:09:50 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id g7so5829553qtg.7;
        Mon, 14 Mar 2022 01:09:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08Cq6sAqtL7e5hp/9ndQMfCAbW7RoUh3nfCkJLMngb8=;
        b=Rpta1+dbExJJYo9L8CHaWcJoaqFkp+NPEzSqTstaO3DtcLJQJLF/z5LXy0+nYdpW4s
         uho3sadF4eptv8rqiiG1BWjYsgZhgzJIXjyvb2iCtHIxiVQgsgSIJFg5Ly6CAwMAw2Gj
         fN8eYrIpwIB0n0TmJq+pGl2PKMUe5NGfCx6AIOrJ89yY16rsK9speNwKeng2A5+h38iI
         iid6tMf45hgNbGkqlBfuwHR0FRuH5naEWggmVRH02+bT9hn5gzp1FvVt5T6o62S2aNFi
         GlZA7LYrzycKZuQyc5LHZJ3W8R1Z+huLXcpGM1RVysvOf1ZyXKEqS8J7MC4IrfzAqvMj
         bkzg==
X-Gm-Message-State: AOAM531BJwm6agjWURWXA5hFd3kcCZ+U36fSMS1i21XLSVJk+UJ+Mixn
        +PpIIigVM2Rm0HGjGKHs+RF/HNXxwqIVgQ==
X-Google-Smtp-Source: ABdhPJx7h5gqIcM3e/AHlw5qbiSRk2nqi1/CDkfItl8tOeiJe1XH0dZmXCcQQG7nUl0/BXavn0fozQ==
X-Received: by 2002:a05:622a:1015:b0:2e0:6cd5:7ee1 with SMTP id d21-20020a05622a101500b002e06cd57ee1mr17033493qte.485.1647245388961;
        Mon, 14 Mar 2022 01:09:48 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id e12-20020ac8130c000000b002e1d84f118dsm299774qtj.39.2022.03.14.01.09.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 01:09:48 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id j2so29249859ybu.0;
        Mon, 14 Mar 2022 01:09:48 -0700 (PDT)
X-Received: by 2002:a0d:f1c7:0:b0:2db:d2bc:be11 with SMTP id
 a190-20020a0df1c7000000b002dbd2bcbe11mr17825798ywf.62.1647245083313; Mon, 14
 Mar 2022 01:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220309162609.3726306-1-uli+renesas@fpond.eu>
 <20220309162609.3726306-4-uli+renesas@fpond.eu> <CAMuHMdW+_5UDRYUQ0aSymgXO1BUryc+AV8SAjSS4F-Lna5B_UQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW+_5UDRYUQ0aSymgXO1BUryc+AV8SAjSS4F-Lna5B_UQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Mar 2022 09:04:31 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXyb8TddJwOfZOg4g8uxAe6EQNXM2y+fe=EVMydg1CN4Q@mail.gmail.com>
Message-ID: <CAMuHMdXyb8TddJwOfZOg4g8uxAe6EQNXM2y+fe=EVMydg1CN4Q@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 6:04 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Mar 9, 2022 at 5:26 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> > Enables confirmed-working CAN interfaces 0 and 1 on the Falcon board.
> >
> > Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Thanks, will queue in renesas-devel for v5.19.

... with the canfd moved up, to preserve sort order.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
