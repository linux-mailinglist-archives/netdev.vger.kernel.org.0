Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A924BD73
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgHTNFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:05:47 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46206 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730133AbgHTNFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:05:38 -0400
Received: by mail-ot1-f68.google.com with SMTP id v6so1353927ota.13;
        Thu, 20 Aug 2020 06:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sg8ZwoLVDdjGpQuxoN9M/5AY3B7WmgGus1lYO1T9dMo=;
        b=VOje/ZOvdbR4Kzl9Pq7i5MK4qY0v4TY9gexkiK5NB+alFvQorGZ9GvZmbGJ75n1ZO0
         2kItntJC6uMsGNxfsVtIx/59/U0Fg1tWWjBxxvl7RbKmk0WAx4BhQxlm31qPPm2QHj1U
         K1hYhOpl7Y+uq2G5+Gkm1OcMqmLMyNKGedpYwDSCPrc3pEcHoP9R9Gv6TYs2tz6l/pAT
         4sl0h5kD0RjIhoa8ikpUeJjeN+4aLfmehasNlgmZgStUKRCNKgcdJLLbVWjqW2Zsr5lf
         OClGZI0FZa8B5kLi6/zhaKz6OEZoJwyY17AASdTYOk/LxK+SzhnLLg3JhPmqEzboD0Of
         08Qg==
X-Gm-Message-State: AOAM53358gS8tGTqrCyeEHZe1TKQBGTAxOd617qtUQRNNboBzfozQBCG
        pIN27BejbKdA8BgiJuex/G3HulECZvTI6lk109w=
X-Google-Smtp-Source: ABdhPJwUV3KXd1HI11sLhl5ptjIK3LAapipNtJfRztkV8qdLHzVc7KCPljUS3MazWyrN26NRAgTnugJUC1FbS8aKnic=
X-Received: by 2002:a05:6830:1b79:: with SMTP id d25mr1920248ote.107.1597928737463;
 Thu, 20 Aug 2020 06:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200819124539.20239-1-geert+renesas@glider.be> <df7f61fe-3103-168e-0744-d6b20ee42224@gmail.com>
In-Reply-To: <df7f61fe-3103-168e-0744-d6b20ee42224@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 20 Aug 2020 15:05:25 +0200
Message-ID: <CAMuHMdVA2-c+T_XHEV9GrQ0Dmf9OfsmiO4UeNKvPu26fQXKU-w@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: renesas,ether: Improve schema validation
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
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

Hi Sergei,

On Thu, Aug 20, 2020 at 2:26 PM Sergei Shtylyov
<sergei.shtylyov@gmail.com> wrote:
> On 8/19/20 3:45 PM, Geert Uytterhoeven wrote:
>
> >   - Remove pinctrl consumer properties, as they are handled by core
>
>    So you're removing them even from the example?

Yes, as they're completely generic.

> >     dt-schema,
> >   - Document missing properties,
> >   - Document missing PHY child node,
> >   - Add "additionalProperties: false".
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> [...]
>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
