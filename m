Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CB31E3FCF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 13:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbgE0LXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 07:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388143AbgE0LXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 07:23:08 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385E0C061A0F;
        Wed, 27 May 2020 04:23:08 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id x22so18878938otq.4;
        Wed, 27 May 2020 04:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fp0svMZCl7416GUNw4GqWtjLX0o7vCvEcznT00dMb8A=;
        b=ihOkLe3NKVS7aTB07R2E2Qb7QqfoeyQfissj2+aNNq76WhAxLMb1jn++IJg0TeYVwN
         gGhfYq9DyZbbOCNfIZlb80PNVr9RwJfsJUiKiQE/kF84HjZkM13HiT8ZvI5P15RboXX2
         xCMNJYszyXrtIsgNlhQo4ZJ/QtpvbW+6o0VlZHY1CaOYH9+Ofpj6y72R0q4cRcdIzA7B
         3exfjhEvVihaXfBKWVj9Lx681NdmYAVw2dRS3kz1IGwAiFuHD2hWkbkXE0NRaYitiG/x
         9yjiRt2gIXW2XQPiymeQIAmBwfiOuck8/eOUScEjcvaCejAYC1a7rPCYIdmDk8m9MynK
         6+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fp0svMZCl7416GUNw4GqWtjLX0o7vCvEcznT00dMb8A=;
        b=OURr7ZszvVSJO272IshNCUq2jjpBeZgBvfim5iELOac5LT15gLJjkSaBvibvlnbE/V
         WZWYAGznQwRbEBGZzwlDyHRgbGtQ1ZsbUOX28MlT7Cc3g6V3WrlwpTgRdDhRNpFI4tcw
         FuGAH9TKQ3AjQwBS0m9w6abMqwQ8fuJkpAqVSQ8lm2RxGYy+J47ibBJoApvqT7ITFdYl
         pBYAqEGLcLvji/fxW6Rdi+o9TLUF3r5zeZgFabZoDednar+IsIq1BK22RjJRba6KQcfm
         9F/lw3InI9p8BIZzM132liLmtgiR7qFKhUbuBq2G912ZRrsfIybmK6CPZMd2061VIB1M
         jJaQ==
X-Gm-Message-State: AOAM531hPpHB54kC7T7cI7mADJYS6s+Uf8lQxtOyeSqq+jmElrC0LT3e
        jGBTGUaRbmYz+1sGF1lPztVtIqLXAg8v5uqa3b0=
X-Google-Smtp-Source: ABdhPJwRs0irm8ujT4wRDJ1yNMXOLkQGDLfhS4wYsUks2EzBi7aBEZfzFaiACJYFXZ647Iot246VfuxQuYwM1M8Tfxw=
X-Received: by 2002:a9d:d83:: with SMTP id 3mr4102738ots.365.1590578587535;
 Wed, 27 May 2020 04:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200527013136.GA838011@bogus>
In-Reply-To: <20200527013136.GA838011@bogus>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Wed, 27 May 2020 12:22:41 +0100
Message-ID: <CA+V-a8t6mXkTUac69V=T8_27r_sdN+=MktDTM1mmtbXRn8SSQQ@mail.gmail.com>
Subject: Re: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
To:     Rob Herring <robh@kernel.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Wed, May 27, 2020 at 2:31 AM Rob Herring <robh@kernel.org> wrote:
>
> On Fri, May 15, 2020 at 04:08:56PM +0100, Lad Prabhakar wrote:
> > RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
> > therefore add relevant documentation.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/watchdog/renesas,wdt.txt | 1 +
> >  1 file changed, 1 insertion(+)
>
> Meanwhile in the DT tree, converting this schema landed. Can you prepare
> a version based on the schema.
>
This was kindly taken care by Stephen during merge in linux-next [1].

[1] https://lkml.org/lkml/2020/5/26/32

Cheers,
--Prabhakar

> Rob
