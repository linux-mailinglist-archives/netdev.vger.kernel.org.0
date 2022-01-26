Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B23A49CA78
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiAZNNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:13:30 -0500
Received: from mail-vk1-f171.google.com ([209.85.221.171]:33603 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiAZNN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:13:29 -0500
Received: by mail-vk1-f171.google.com with SMTP id 48so11452818vki.0;
        Wed, 26 Jan 2022 05:13:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xkGtktozf/u1g5YQKQwaOxUHOjH3v3y6pWsIirGR8fY=;
        b=n8eUWLfE+wUWr+SSr5K6HYOkXUdUuSwVpGSm6ag37fPVTfoJjPINxMXmSNZeHOppvn
         lXZRha4H0/JitxCJItN5nVe+aNOkpuYANImjF6WV+oFJQGMhRTIOVx0Zx+5z7IX8j4q0
         xFK4dH5y/XMg1QS+dq0F+DKAj7DhafKjI6cOP8QTvAyvmqlqcByxnVk+PPyYc2M11AEv
         Qi5HKSXkbOV0VtWh/r3Si9siQgDDrdn7yuLPtwSiqW2LnWrpCFPvr1URtwu7Y3zFJtGX
         HWuBfurwY3g2/j53dbjKFSt30UEAiaMlq5Y6uhT9a0hhf5zIBLjwG5nKcK62FpDj9c5l
         4u3A==
X-Gm-Message-State: AOAM533tkVGa7aIQtJQG5yMbXkLvncGp8+TpK0ZqfAlV3/Yqr6X5Pqzp
        MKRRWfdFMOGdjLv4z1BJbfAGrFnR/MkNGlDY
X-Google-Smtp-Source: ABdhPJzGl2EBxYDe7IgmZQw3RRrTPqh2pUBu7x2sbY9UmFop9FH1/THiOtcH4EyVP7/TUFR8A+5rnQ==
X-Received: by 2002:a67:d317:: with SMTP id a23mr9116989vsj.50.1643202808688;
        Wed, 26 Jan 2022 05:13:28 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id u8sm419935uaa.12.2022.01.26.05.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 05:13:27 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id w17so10476861vko.9;
        Wed, 26 Jan 2022 05:13:26 -0800 (PST)
X-Received: by 2002:a05:6102:34e:: with SMTP id e14mr2483928vsa.68.1643202806127;
 Wed, 26 Jan 2022 05:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20220111162231.10390-1-uli+renesas@fpond.eu> <20220111162231.10390-6-uli+renesas@fpond.eu>
In-Reply-To: <20220111162231.10390-6-uli+renesas@fpond.eu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 26 Jan 2022 14:13:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUu_K5k_C1O54=4b7wv+92XVc2esisv3+xvVD4F_nZQgA@mail.gmail.com>
Message-ID: <CAMuHMdUu_K5k_C1O54=4b7wv+92XVc2esisv3+xvVD4F_nZQgA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] dt-bindings: can: renesas,rcar-canfd: Document
 r8a779a0 support
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
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 5:22 PM Ulrich Hecht <uli+renesas@fpond.eu> wrote:
> Document support for rcar_canfd on R8A779A0 (V3U) SoCs.

R-Car V3U

> Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
