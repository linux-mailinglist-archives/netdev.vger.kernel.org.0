Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D684A58C8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 09:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiBAIvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 03:51:11 -0500
Received: from mail-ua1-f48.google.com ([209.85.222.48]:43557 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbiBAIvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 03:51:09 -0500
Received: by mail-ua1-f48.google.com with SMTP id r2so4567140uae.10;
        Tue, 01 Feb 2022 00:51:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQaxXxX2TEhzmOUyxZ8RJ1jCaru/41Ti8LVSzxlH72g=;
        b=uXHD3EsFN89G9uXUgSAzOoSjCX/9LOLwyIww+vyajjPeKKTMMEVyqJQFgJQnnMmzrL
         GBJ09x4BfG5Zt3qbOkMATQ6QHoZATANinqccWoSyM/FZ+ukvUAbjtqxrgDe0pD8s2MZ2
         rN4kuvYBKSNrysreatL5VCsRGD5QcKWiw/so5YPH1qZ4WndJqK4gpQzkAbm3DwZAATsY
         3BgcFasmeXko917mW0iKA3g6qCdI/Syj9f6E7oFT8/qWiFh0dcDw8KO6WNzjPrEl68gK
         1fFx4CAd6ndarcVKYTAt4LmRDPjduAJpOkU3y+uYI64H2apI00u9wssfmnqy75Tl+hbf
         wD9A==
X-Gm-Message-State: AOAM53203uMgBqic/Qbipu37I8jSmR5mrVKG+1d1Uhj4FFSeUwEeJkbM
        wc+5pE42vOTVCbGNwbasf+ZR0+Pbuk4mdQ==
X-Google-Smtp-Source: ABdhPJzCuUf5alGU7I/vcI1g44zVfVIGbphZenden1NCI+S7NNVuxmUKQHm8yW81Vk2kuhLpHbZnPw==
X-Received: by 2002:ab0:184a:: with SMTP id j10mr9440265uag.124.1643705469093;
        Tue, 01 Feb 2022 00:51:09 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id v129sm1959184vsb.15.2022.02.01.00.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 00:51:08 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id n15so13438012uaq.5;
        Tue, 01 Feb 2022 00:51:08 -0800 (PST)
X-Received: by 2002:a9f:2c0a:: with SMTP id r10mr9851777uaj.89.1643705467496;
 Tue, 01 Feb 2022 00:51:07 -0800 (PST)
MIME-Version: 1.0
References: <f09d7c64-4a2b-6973-09a4-10d759ed0df4@omp.ru>
In-Reply-To: <f09d7c64-4a2b-6973-09a4-10d759ed0df4@omp.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 1 Feb 2022 09:50:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUyeiHyPcHNFMGWOTtVWUwN8cv8r7anmX-bwEpy9DLSYA@mail.gmail.com>
Message-ID: <CAMuHMdUyeiHyPcHNFMGWOTtVWUwN8cv8r7anmX-bwEpy9DLSYA@mail.gmail.com>
Subject: Re: [PATCH net-next] sh_eth: kill useless initializers in sh_eth_{suspend|resume}()
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 9:24 AM Sergey Shtylyov <s.shtylyov@omp.ru> wrote:
> sh_eth_{suspend|resume}() initialize their local variable 'ret' to 0 but
> this value is never really used, thus we can kill those intializers...
>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
