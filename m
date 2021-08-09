Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190663E4520
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhHIL55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:57:57 -0400
Received: from mail-ua1-f49.google.com ([209.85.222.49]:33538 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhHIL54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 07:57:56 -0400
Received: by mail-ua1-f49.google.com with SMTP id x21so2890446uau.0;
        Mon, 09 Aug 2021 04:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBNbNuQv/m4wBsB08WozEoy/8Rk+r8DMYH5TxndeZhY=;
        b=uNRpKs/L6A0ZSgbczLf/GV/I0ZkBzXF8D1FbdljfXN9eAhElpEzrl/Y/jn1V0wj+/B
         NML0N8WdgSIOJWtOBvzRzMPKxwcNSQ4R3ZmRQ9yUCRrojoDpjkkINuuzKnks8ii98yGG
         yCu6+e0yFvy9uB9lmjSI/VbPurwilBFIqYzve71LE02Qnd+BToehESwOq3RTyOZDIO06
         0OYdzcwtuZ1Pdn42aQK2t2338g9OhyX4yxFxUSR7hzR60A3ee9WOHf/67GnoeVOgF2vf
         ZQkqouhZBwut2Vi1vpMvgxDOnW7eXoGuGNl7TbL62WddCKQhqzZDKGZzx6qIpSA1V/r+
         GiNQ==
X-Gm-Message-State: AOAM531arvnZ6m4ExZGVNknIhMHM5iAC44O2SE0HolpraVE4hSlE1NkK
        xwQKjUlvT0ahx2jEVgxMsAe6B2SdfUguNLNjO6E=
X-Google-Smtp-Source: ABdhPJwOCjf/9mPFdoWJ6Xb7pANJTPsyeXf35S+1hqASqv8jKlv95vcogQkNOp4yKI7NSjf5sFnOy0vGeDmOVJus4AE=
X-Received: by 2002:ab0:6710:: with SMTP id q16mr14937054uam.106.1628510255863;
 Mon, 09 Aug 2021 04:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210807145619.832-1-caihuoqing@baidu.com> <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
In-Reply-To: <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Aug 2021 13:57:24 +0200
Message-ID: <CAMuHMdXzZfX_mZe==-J52kaUCuM0t-zvFw5aqJTgy8TKJ9Xmvw@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Cai Huoqing <caihuoqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 12:50 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> a number of the 8390 drivers are still in active use on legacy
> architectures. These drivers get occasional updates (not just bugfixes,

Exactly.

> but support for 'new' network cards - I have a patch to add X-Surf 500
> support somewhere in the pipline).

According to the picture on [1], the X-Surf 500 is from 2018.
The ASIX AX88796B[2] it is based on seems to be readily available,
so new designs may still use the "obsolete" 8390.

[1] https://icomp.de/shop-icomp/en/produkt-details/product/x-surf-500.html
[2] https://www.asix.com.tw/en/product/EmbeddedEthernet/1-Port_Ethernet/AX88796B

> Am 08.08.2021 um 02:56 schrieb Cai Huoqing:
> > commit <0cf445ceaf43> ("<netdev: Update status of 8390 based drivers>")
> > indicated the 8390 network drivers as orphan/obsolete in Jan 2011,
> > updated in the MAINTAINERS file.
> >
> > now, after being exposed for 10 years to refactoring and
> > no one has become its maintainer for the past 10 years,
> > so to remove the 8390 network drivers for good.
> >
> > additionally, 8390 is a kind of old ethernet chip based on
> > ISA interface which is hard to find in the market.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
