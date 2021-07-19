Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11273CD016
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhGSI1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:27:37 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33785 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbhGSI1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:27:36 -0400
Received: by mail-pl1-f171.google.com with SMTP id d1so9270195plg.0;
        Mon, 19 Jul 2021 02:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CtvuLee3pr4EwzHtgTx9NE8EP/OqeelZmZ/9rdm/KUo=;
        b=G5g2y/aqzTSEw1KYR7prHpWz5+yOyX2nYC5lX5JJORhGP4KyNK8ht1fdypSlkCiBmN
         PsDXaXhhknJoOmLuT3A045U9YkmGVoiQXHtpi1yjKzjWx80QhkaUqr38iehXufS9XG3W
         a89MNyzIDkAF1F2yGFirVkcMmQfkZK+n62YWJhDKf830uSefCAezg/lSgV9MiTpWbLP8
         CKniBItZKVjIOOHPfTzxJBxfOxDds+9XKn4WtbfrS/vRuWv1sL9CoVAnZY8tsT7o1zuA
         SV9SqRKEKrAlmk7sRhZ9tgtZ8eaxmQ3a2aqqassAII33p6vLbnnmYPVXb5JnQFfNLwUm
         ZmHA==
X-Gm-Message-State: AOAM530FtSLHmFvG78HTLu5VDlijdQSM5jJLpqkyWfe1U/To60NyZKtZ
        njo8fYIJyNhWUDCxI0FpgPJSg9Gkkq7pHb3xUHHovc1a+1g=
X-Google-Smtp-Source: ABdhPJzphCu+/PQBb5pagPyZjUg/VmixCHDUZXyBafPCy7evyecNXWUaZFOmx7ljzxro/peUr4+prkEAgHfbir3Wpzo=
X-Received: by 2002:a05:6102:321c:: with SMTP id r28mr23284874vsf.40.1626683939415;
 Mon, 19 Jul 2021 01:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210719073633.1041901-1-geert@linux-m68k.org>
In-Reply-To: <20210719073633.1041901-1-geert@linux-m68k.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Jul 2021 10:38:48 +0200
Message-ID: <CAMuHMdXb6zJFc5ArGwHq2Bfm3RvKFutz2UjXFzgDLhGeDezL9g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.14-rc2
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 9:40 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v5.14-rc2[1] to v5.14-rc1[3], the summaries are:
>   - build errors: +1/-3

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/2734d6c1b1a089fb593ef6a23d4b70903526fe0c/ (186 out of 189 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/e73f0f0ee7541171d89f2e2491130c7771ba58d3/ (all 189 configs)

  + error: modpost: "xfrm_dev_state_flush"
[drivers/net/bonding/bonding.ko] undefined!:  => N/A

powerpc-gcc5/44x/fsp2_defconfig
(fixed by https://lore.kernel.org/netdev/20210716230941.2502248-1-maheshb@google.com/)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
