Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9257B363EB1
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbhDSJir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:38:47 -0400
Received: from mail-ua1-f51.google.com ([209.85.222.51]:42665 "EHLO
        mail-ua1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhDSJiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:38:46 -0400
Received: by mail-ua1-f51.google.com with SMTP id 23so1394399uac.9;
        Mon, 19 Apr 2021 02:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qz7eHg+GDhB5/+UldzTXRkP4L7o5XFBAhOrV0CebfS8=;
        b=NpLBTFuoQnYPSKDN3QIGdnckJ9HK9IIVmGIAwvdMSN25C1/MoO3eYmQhhAyEv57ivu
         P9bH4kIihlc0r5+JWSkjfuj/Ch5SbN2+2bZeiKQRWS9A8gWHNcZR+ekMMiBvTwWd/P7B
         PCGwkaiQWa9MRjxkeOC4El3gRy781kkYxCnyGNEBJS0aoIJIJbHNCI75XQcl57h2goAk
         sV51OZa5e0SRSw5RR2QwuxjDofgVZ5uvw0bt10CMBFlZzMM3X8id0Yu8b/Y1ztrr0TjA
         VOuL6zLN5v0n3ggk6IHsNZq3anl3jFyQVQkjvxbEdUkU5C6HQmYu4cwAnkoPlVvJPbzl
         bugQ==
X-Gm-Message-State: AOAM531JuGkvXGb3cNIS1FWYxX4aqVeRb+Fj+0U+GNA/kqAb7hNZ1Nsv
        oBPJB1Qy+uMbnxFdMcH0lIcwKR001cMJfuat4qw=
X-Google-Smtp-Source: ABdhPJwd2fxrRVcezspfqpd49brhoi5lLIDhZwfeLnamGRZertBmVP+kBGQLGSvBRrowPHG+qjcTR166Fl0LF3PPrz8=
X-Received: by 2002:a9f:3852:: with SMTP id q18mr6058483uad.58.1618825096295;
 Mon, 19 Apr 2021 02:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210224115146.9131-1-aford173@gmail.com> <20210224115146.9131-3-aford173@gmail.com>
In-Reply-To: <20210224115146.9131-3-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 19 Apr 2021 11:38:05 +0200
Message-ID: <CAMuHMdWozQPDTDMPtqqoHJJoshHAUCBCxWkGYEe6eV1q2xL6jw@mail.gmail.com>
Subject: Re: [PATCH V3 3/5] arm64: dts: renesas: Add fck to etheravb-rcar-gen3
 clock-names list
To:     Adam Ford <aford173@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 12:52 PM Adam Ford <aford173@gmail.com> wrote:
> The bindings have been updated to support two clocks, but the
> original clock now requires the name fck.  Add a clock-names
> list in the device tree with fck in it.
>
> Signed-off-by: Adam Ford <aford173@gmail.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

queueing in renesas-devel for v5.14, with an additional update for
the recently added r8a779a0.dtsi.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
