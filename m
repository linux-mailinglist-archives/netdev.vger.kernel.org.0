Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080CD24AF56
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgHTGjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:39:14 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42349 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgHTGjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 02:39:14 -0400
Received: by mail-oi1-f194.google.com with SMTP id j7so1067084oij.9;
        Wed, 19 Aug 2020 23:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8/T7jMrXbc4A5I5iQeln6XFEc6ytosFSjeoaKLVkDE=;
        b=QaCO1vhlwOXCatWqQPaWs+3lbT72lbuaLXh69fcbvJky42OR43yawaVAjFdvIbribH
         FnMtxhJzSl0NpZ5qZVsPaNT0lXI1xCD/+L7UQiTFCOrmqecgg1M48tygHARGIrV0O5Ou
         Qjx1vFVNlsdSmnRS/nMIJZXDuyefuBYe1YqFmzXD25hoY8qyh4BqTsFzeaMvz8o8XEkU
         /PvPPIYFC04Y7JH07a2W/kR2jVlkhV94CgE867RCzfSYksYxzK6MCKqxVncVJELWB8YV
         U8uCZDWWGSBUbOZ8gjedN/7NtZARJbykx6fkxBtbQOn9ntSBIKYT2TQ69pglTH9MSeU4
         Kh2g==
X-Gm-Message-State: AOAM530t2ZWRxbx77SbbgkI7uElHBoCtOp0lLl9TObLz0Y2aFeJlm5Ds
        Z7uNvN29VHLrb5ieDxKQ8EKYZkr3mvzxYHfhuCE=
X-Google-Smtp-Source: ABdhPJwCabawXvHO5zO2Gqt+jMN8cu0o45gfsmoQbx+UbhVOjYFGLv9Oj83JCeRoei4AoD/4uzXJLtFBzWuiLi9v7wY=
X-Received: by 2002:aca:b742:: with SMTP id h63mr938378oif.148.1597905553079;
 Wed, 19 Aug 2020 23:39:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200819124539.20239-1-geert+renesas@glider.be> <20200819.130529.1551760851592543597.davem@davemloft.net>
In-Reply-To: <20200819.130529.1551760851592543597.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 20 Aug 2020 08:39:01 +0200
Message-ID: <CAMuHMdWV76Eg_RRzcuhCVtyWsLOx-FEVKg1bU-0b8zH69TVjYA@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: renesas,ether: Improve schema validation
To:     David Miller <davem@davemloft.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Wed, Aug 19, 2020 at 10:05 PM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Date: Wed, 19 Aug 2020 14:45:39 +0200
>
> >   - Remove pinctrl consumer properties, as they are handled by core
> >     dt-schema,
> >   - Document missing properties,
> >   - Document missing PHY child node,
> >   - Add "additionalProperties: false".
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > ---
> > v2:
> >   - Add Reviewed-by.
>
> Who will take this patch or should it go via my networking tree?

Given Rob provided his tag, I think it should go through your networking
tree.

Thank you!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
