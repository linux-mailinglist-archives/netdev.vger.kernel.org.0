Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3481F1E4622
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbgE0OiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389341AbgE0OiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:38:21 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EBCF20C09;
        Wed, 27 May 2020 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590590300;
        bh=suJ353lRv1UQx7HSHjKB0euqpTIy3Nz0DHiPmdHpvHU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dz0t6hwefzpF3FUmlaHc8XA8cVnWy5nxuMwqo6MyQfhb9xnuOh25xZ5iEUMLyIraK
         +i2k40cRkMt3FPAIXWsizHEIFFw0WHp53r2Sktwd72HtGOBbqLdNz6flS5gYvS4s3H
         E8c8qsLiDCajLBRwCnN3Lstkh4l0DvqpsjkGPKjY=
Received: by mail-ot1-f45.google.com with SMTP id d26so19301394otc.7;
        Wed, 27 May 2020 07:38:20 -0700 (PDT)
X-Gm-Message-State: AOAM533afaxOT08GXEm65d7/tfSCsCn8wb3x2opy1uFC+7mqBU84kPx9
        xgrj9T74bDEf/TT3JlUcqDi2pVsjR9f1GkQOSA==
X-Google-Smtp-Source: ABdhPJyp+iNzxT9P6anI85WQIrsM8pRrlKHEOY9o2oN/zH/c34nmR9QO5xYjGblk5qKho8HgjNiUwGAutpyoqXPmJrk=
X-Received: by 2002:a05:6830:3104:: with SMTP id b4mr4930496ots.192.1590590299856;
 Wed, 27 May 2020 07:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200527013136.GA838011@bogus> <CA+V-a8t6mXkTUac69V=T8_27r_sdN+=MktDTM1mmtbXRn8SSQQ@mail.gmail.com>
In-Reply-To: <CA+V-a8t6mXkTUac69V=T8_27r_sdN+=MktDTM1mmtbXRn8SSQQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 27 May 2020 08:38:08 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJUn9iOy5FT6VRmsC-uAhSdN8_Sne0Vn_7Q1dHudbzopw@mail.gmail.com>
Message-ID: <CAL_JsqJUn9iOy5FT6VRmsC-uAhSdN8_Sne0Vn_7Q1dHudbzopw@mail.gmail.com>
Subject: Re: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
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

On Wed, May 27, 2020 at 5:23 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
>
> Hi Rob,
>
> On Wed, May 27, 2020 at 2:31 AM Rob Herring <robh@kernel.org> wrote:
> >
> > On Fri, May 15, 2020 at 04:08:56PM +0100, Lad Prabhakar wrote:
> > > RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
> > > therefore add relevant documentation.
> > >
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > > ---
> > >  Documentation/devicetree/bindings/watchdog/renesas,wdt.txt | 1 +
> > >  1 file changed, 1 insertion(+)
> >
> > Meanwhile in the DT tree, converting this schema landed. Can you prepare
> > a version based on the schema.
> >
> This was kindly taken care by Stephen during merge in linux-next [1].

Yes, I'm aware of that. I was hoping for a better commit message which
stands on its own (essentially the one here).

Rob
