Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1649617B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351186AbiAUOqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:46:51 -0500
Received: from mail-ua1-f54.google.com ([209.85.222.54]:39616 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345996AbiAUOqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:46:44 -0500
Received: by mail-ua1-f54.google.com with SMTP id p7so10085675uao.6;
        Fri, 21 Jan 2022 06:46:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J85u4F+foj+qau0xIxcqBu51Qlat9siUCbInzEtZHx4=;
        b=FrgPDhNpfucF1IqErH3hVj84WW83B0CdxOq6QjxKTHwUzUMjnXqfpGaNFgDyUuzRws
         eRtWnX791VIqjmiTUxLAyi1EAXNFmLvQm7JqucCrLdQ2aJkaLr4TO9xQj4cUFZlkqI5j
         FKQpu0gKQuiYCoesTHEV869QwNmnyA9PIWwwMgAnqim1jFi7FT1IPPEz91vNQDQj+n14
         wGRe0NuwksVl8vVGHy285j0Hnb3vUu6tMxtOA2jVE1CUd+tzZyZIdkHDtSumztulSuMv
         oAQ2dshcQbICswQNFpSB/lCyDYWHY8Q1HIT8puNGpjoYhsCPuwbI4rvXJcvi8HZnVHhY
         Hoqg==
X-Gm-Message-State: AOAM533w0DF1YVwUYhTxJF5uVHuDFvZygszyoPR8P0fLYE0SFroOIbnb
        1bRWSeAqb4iMqMr+I/m83mbCNwbLKBeoSw==
X-Google-Smtp-Source: ABdhPJz4quqZkUxgv+K4WgoggS9/Nm/yZo4FDp8QvywLb1YveRjffiBKSGPr3HbrHFQqHh83Jmr04Q==
X-Received: by 2002:a05:6102:3a68:: with SMTP id bf8mr1659029vsb.63.1642776403082;
        Fri, 21 Jan 2022 06:46:43 -0800 (PST)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id j6sm1347564uae.4.2022.01.21.06.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 06:46:42 -0800 (PST)
Received: by mail-vk1-f169.google.com with SMTP id d189so5707859vkg.3;
        Fri, 21 Jan 2022 06:46:42 -0800 (PST)
X-Received: by 2002:a1f:5702:: with SMTP id l2mr1757097vkb.33.1642776402171;
 Fri, 21 Jan 2022 06:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20220110134659.30424-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20220110134659.30424-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20220110134659.30424-10-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Jan 2022 15:46:30 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU9nssOkq_cv9R5sHOW=CD19e0=7kanuwM9_kgQjSv8Vg@mail.gmail.com>
Message-ID: <CAMuHMdU9nssOkq_cv9R5sHOW=CD19e0=7kanuwM9_kgQjSv8Vg@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] dt-bindings: net: renesas,etheravb: Document
 RZ/V2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 2:47 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> Document Gigabit Ethernet IP found on RZ/V2L SoC. Gigabit Ethernet
> Interface is identical to one found on the RZ/G2L SoC. No driver changes
> are required as generic compatible string "renesas,rzg2l-gbeth" will be
> used as a fallback.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
