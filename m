Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FC72E93EE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhADLHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:07:21 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:42021 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhADLHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:07:21 -0500
Received: by mail-ot1-f54.google.com with SMTP id 11so25600794oty.9;
        Mon, 04 Jan 2021 03:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejBhJdxe+Ypz4pmFM6jtZykDsE8NXE7rALy/vOL6RA8=;
        b=LlgyAPmzvjj92TKk7eaNa3gY+oYlfKzfUJV4jyDXnoeNXuNfR2FeAnCBk0osqov6Pq
         SH/dsiIOfU8VgWTJD/lXsMtW7+klxnHbi4U8LWy3/kPKnJ6IF7/ABWgk7VcXzqekkGdW
         59yqQm5VbGajh2sptpaPmkekQ3d0QRjAdvZn41glD9RJ4mKoGFzZWVv0zkBThC9fxDnN
         Rl9fUY8kmo3USkpmoCLsqh367lNZxkwMvkuNZHVYsTcRir2cFgzufbuvjD41NCZEUOq4
         Q2NkxX8rWGqYqHGDhISWkiRvACHtgLNF5ydAGrgKoRUfB3wb4PgG80PT7fwmDk4gICwd
         YX8g==
X-Gm-Message-State: AOAM532ZnxpDT5Flegw1nbFMUz25UMIYLMEdaqGWPFDCnQkQA8OgF7ag
        nSnwO62A9QP9Ebfii4zeCC5ZSJc6L9PsVyyZ0Y8=
X-Google-Smtp-Source: ABdhPJzw+PyrV+DkseEjjlzu9EgbZAc0gIpJeAxhpZElv1XC5IgqsQmeOJAOJHPj8fdx0f+V1VKbKYt5sGBHKGj1m5I=
X-Received: by 2002:a9d:c01:: with SMTP id 1mr37173062otr.107.1609758400285;
 Mon, 04 Jan 2021 03:06:40 -0800 (PST)
MIME-Version: 1.0
References: <20210104090327.6547-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210104090327.6547-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jan 2021 12:06:29 +0100
Message-ID: <CAMuHMdWmy85b4Tu=RxKRDeXVVj_d4AXFjQxgm=OS-aFXjrTgwg@mail.gmail.com>
Subject: Re: [PATCH v2] can: rcar: Update help description for CAN_RCAR config
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 10:03 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> The rcar_can driver also supports RZ/G SoC's, update the description to
> reflect this.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
