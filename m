Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F781D7480
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgERJ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:56:58 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44241 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERJ45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:56:57 -0400
Received: by mail-ot1-f66.google.com with SMTP id f18so3411741otq.11;
        Mon, 18 May 2020 02:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvvQG3pTFBp5MwVKAlPEHo4t/zdroDZfEuS3gh1FDEA=;
        b=Q5sgtZU8FhiKC7TwQqZszVdIKtAoPCQyT02RqRF3U9R+RUVcR7/aZ23oDAQ7+adILA
         MNhpLn5RWvQSZJCEVo/hUX+gpw5biF8MIQZnQo1d1SdLJgjQFCpz+X6oBbZLjxAYkrsZ
         06IyIsN4LnlOtActiveeE6PwoCySQzWWYiVxLUPO19zPlccSC1cZA5MY8c9VGQBbXShn
         7O5eImMQmrI4sw38ltsHGdl3bJ0y7uS8LhosO9htFeYV2OpUQgM2sJO3F4pqpyOSrqht
         cKiVnHwBdAaP1lxZi1MiVjoKLSbkP0I0PLpi6GvWHJ9UFX24dIeptvUomZl6o145lk5M
         +KpA==
X-Gm-Message-State: AOAM531WltuP1XWR462K+6IbWGpAiBDthpBD+1HSktjQIjdaaRu5c+oR
        zpIzAjxmSjePXV9vxqAMvUI4kGiZkLU4bLWMDFy4Qg==
X-Google-Smtp-Source: ABdhPJw6dshfnAJcjgUEkm76ng8qhkLcCfmGspyE6DB2cawWGoBul01Mj6ylwbF2G2nzpNFeAiSJQPLTq4MqKsPnE1Q=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr7668628ote.107.1589795816543;
 Mon, 18 May 2020 02:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 11:56:44 +0200
Message-ID: <CAMuHMdWDypz9Syi4KjP42LnF48_tjWompb9SSQhP=fLcmC6Z+A@mail.gmail.com>
Subject: Re: [PATCH 01/17] dt-bindings: i2c: renesas,i2c: Document r8a7742 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document i2c controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
