Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CE12EF3E2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbhAHO0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:26:52 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:44453 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbhAHO0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:26:52 -0500
Received: by mail-ot1-f44.google.com with SMTP id r9so9731777otk.11;
        Fri, 08 Jan 2021 06:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ck+PkyxpVc679nAlJE4ATOc3uxubhhqpwkHVwNf7E5s=;
        b=skuaLrKgPHiOywiDUGWVHDWbKUl/+1a62E7n2eqiWo/0enJvydU7nIE018FuRY/4Z+
         SJMGVHgNhi59tH+zBWnpAtU6rnzdp5jS3wp+9DXo4kEEg+3LLjdu8BxRit0aCoXq4jEN
         eb+h+OZTFaRZkODcU+wVpN5upwDHMnyROH6uguKWTOEYLXtpvS4UmeF8J/bEulkMYzUs
         rALMm2i6Qo97htrZzrrVS+U5L3yOHhGsvhV3Q6v6JTYWaZbuW3cVZqqyVOS0OP+tbjP9
         hOZ6RY5EMVNriDYP0ieARcVinQ48odhDhh4djC+g9JQTxfpUGY4t8vwlzQDP1YZKIH42
         Lr/g==
X-Gm-Message-State: AOAM531zxmL8GA3y8Vs1OcOYomhckkK31ZgbbyF++58S52nQFV+TBfn6
        UZNY/pRNquweoINhnik1G+vLwxQc2YhxR3sKjwc=
X-Google-Smtp-Source: ABdhPJz5JHAfsxibVjT+oM8MWaLyRUS9HcK7lHJppKG9TqVJuJee5oTH5qD3EjKPGgBPw/oWteJ+VycrdZmptKHtaTM=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr2746312oth.250.1610115971373;
 Fri, 08 Jan 2021 06:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <20201228213121.2331449-3-aford173@gmail.com>
In-Reply-To: <20201228213121.2331449-3-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Jan 2021 15:26:00 +0100
Message-ID: <CAMuHMdWt2NxWEVeE9GkkqYUVTxTxN6yQzpOeJ5YWg4nBU5384g@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm64: dts: renesas: Add fck to etheravb-rcar-gen3
 clock-names list
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck.  Add a clock-names
> list in the device tree with fck in it.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel once PATCH 1/4 has been accepted.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
