Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7226F1D77E3
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgERLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:52:38 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35976 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgERLwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:52:37 -0400
Received: by mail-ot1-f65.google.com with SMTP id h7so785087otr.3;
        Mon, 18 May 2020 04:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQPXXUnEmg8VTbp2VRjyW5ecL567p223zDq4ywb5pFg=;
        b=rEIZTHKCqD0rwugx19PN7hU3StPqDGlEHMH7cADWpXkAw0ZqvdOJHxEzwuA6td8Mjf
         RdHjNdQ9KQ9c6OH/l2pu/oZIMb9epXBEHu0tzA4hlJNp8VTnlEgUZLLvf7t7LcoTODOL
         XQL68wKJoveUMae/IFMHH9ULP/dcdKw6Za/tyKkMHi7C3gEo9/+BE/eNmoi6f1bZ75Fz
         2tOvDWrUPeHdq395q1a+GCpbEG6pym3fAMV2C8Sko5RD1dqNpEvziZsSKwZ8RzZwtj5g
         SF7lup309PpO39SAbNbpcwfjUwn93yWwlZ90G5eFgH0HrnJNMQJsXr/1xUcLhZSrL8oQ
         R4oA==
X-Gm-Message-State: AOAM531ChmXx2bqoZ8s6CVRvH851Gh+AZaauXsrNmcn8mzvajhAf6g25
        wqmtG7UxNtzagz1Eiv+GJCQugLUDFETdDWh4Lk8=
X-Google-Smtp-Source: ABdhPJzztihxgVPOtuYsZok/wHHIIqbujQG/vxufZvAdRhBiuRXv7/itmwgVS6z70gUvK8jzbrnUeH9P+Xu4Db/mziM=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr7961870ote.107.1589802756351;
 Mon, 18 May 2020 04:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:52:25 +0200
Message-ID: <CAMuHMdWPMtJOXEz3CT13J1B-ubBqNhx9yYzTMHLgWTbL8pxsow@mail.gmail.com>
Subject: Re: [PATCH 09/17] ARM: dts: r8a7742: Add sata nodes
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

On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add the sata devices nodes to the R8A7742 device tree.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
