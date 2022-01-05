Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541F3484B9F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 01:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiAEAWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 19:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235309AbiAEAWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 19:22:13 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8DCC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 16:22:13 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id w7so27611210plp.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 16:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FozRK3vT14KhsxHc79uIsxJNZdcUDuEwftP7RWz0rTY=;
        b=JKcbx49EdMiX6fb+r5PG+pVsq9Sn8A78AXvSinJUtxyaMgWEkCcuSH2pHgmreYPbMP
         LthEZOEqeqYOf+HHReSNTdni072lxUjsbkEhOEdyOJFpFdfIVXhSGqUfwc6XjuiuB6kG
         W7rhIM/ILF/QOWZNTvrxd6hIUIQ9nanX3PuqYNkVIi8hA/spH+/3PGnF0P0ojAGcdFFe
         SAA1Ke2qCpizPA5OWmuOkkVBNBis672UtpzPwwKL4OLGfj5Pu0mTSeyoqdVMxx2i8CM2
         70ZBR7r0ITx0WNN8kvXbL/UtCJHzAi5ZCLZe7rt4r5erL62sNDxL69guA7mESil4B/Gb
         8cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FozRK3vT14KhsxHc79uIsxJNZdcUDuEwftP7RWz0rTY=;
        b=ffOZcfg9bk0iuDceCYTUZY85769lYFerwGIuUWBf6YYF4wNyuWLlus+glkdRoe/qO0
         NrLx6KA+PBQDYQYdbwIc/tcLPxSz0IZlzaMXQFw8dpF7gk10tU+Uej2VJ+X/sD+CUfQa
         prVnr3pcIHwV8t4di7CsV7hL4QhBZpD8ipW8I/MkDjjtWDHUHHKkJ4s4U97UkPxxANZ8
         zYPVQJxEqJM5fbMQ/7QjZrF06h+u/FNIw8/B9zwdBfxLADlxOfrUg9XQvjHdsAqPbYYr
         sdL28tuAocSAuUz3IphnNLT85to6meiF5HExD25MZrxe8fJuuqPF7t106MEdjA6BBjxY
         bhqg==
X-Gm-Message-State: AOAM531OPnkqqPEr1mNAbJJL/opQWAYrAgWMjIL22piIQ78B0LVdfCaG
        vkkND8wpcD+kvLC2b5j/oeDphhKGd+2wNKC64bM=
X-Google-Smtp-Source: ABdhPJz5nBDr1oEhvbTSiXW3pl+2UMnSlcy01Zlx1B+oQ+bwzKBMK00pyWiqHIZ9YpxgfXlwTix9ApDOlQ/oTxmrDzg=
X-Received: by 2002:a17:90a:f405:: with SMTP id ch5mr1119785pjb.32.1641342132960;
 Tue, 04 Jan 2022 16:22:12 -0800 (PST)
MIME-Version: 1.0
References: <20211231043306.12322-1-luizluca@gmail.com> <20211231043306.12322-3-luizluca@gmail.com>
 <20220103190701.pvd7ixfcomlqlbgm@skbuf>
In-Reply-To: <20220103190701.pvd7ixfcomlqlbgm@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 4 Jan 2022 21:22:01 -0300
Message-ID: <CAJq09z5Uf0LCUg9kGvhgJtE3EVNONtdaMqqzr+SHw5AoSiTUEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 02/11] net: dsa: realtek: rename realtek_smi
 to realtek_priv
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  static int realtek_smi_probe(struct platform_device *pdev)
> >  {
> > -     const struct realtek_smi_variant *var;
> > +     const struct realtek_variant *var;
>
> Undocumented change.
>
> >       struct device *dev = &pdev->dev;
> > -     struct realtek_smi *smi;
> > +     struct realtek_priv *priv;
> >       struct device_node *np;
> >       int ret;
> >  /**
> > - * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
> > + * struct realtek_ops - vtable for the per-SMI-chiptype operations
> >   * @detect: detects the chiptype
> >   */
> > -struct realtek_smi_ops {
>
> Undocumented name change.

I'll mention them in the commit message. Thanks
