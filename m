Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D19B2EF3CF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAHOP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:15:59 -0500
Received: from mail-oi1-f171.google.com ([209.85.167.171]:45612 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbhAHOP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:15:58 -0500
Received: by mail-oi1-f171.google.com with SMTP id f132so11397744oib.12;
        Fri, 08 Jan 2021 06:15:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ck+PkyxpVc679nAlJE4ATOc3uxubhhqpwkHVwNf7E5s=;
        b=aOWdtA3R1gvpjyqBBFmhZ+GJr5QSNpXAoSLO248r6r7KHzEBKkSaSFb37bo3GtOMxg
         lAAeNG8s+Z05NBz0DYuSEkpB2+L5gccMIboQTueiVhyD3uhCvcTFHharZ4vpG5wvjLdP
         Ap0aIOuiEeh+/e8dRenHoCjp37boHipC9f4Boz2uvI8qoYIAJ7udz9wFJj2HMOvaN2+K
         7dkRqzcEiOCpUqTXW1fykHJmDspBglhAz2MJGi+ChX0QL4Zmx8gKMZo2HTNJy8ih367P
         7LQ0AFE2HhHlYB3gQnxYwF58EPOJ2ihyGpWMhNd/oiw2D66IWYQy2TZriWElQPMWgmjl
         Ro3w==
X-Gm-Message-State: AOAM533oJBrpL4ageXnTamNf6s9LvN9Q5AnhOtwj+M7h3BSn6Chtziul
        eAG+eyxyzxT/+rRDMAsvVc6hZPnD3fMXkNaIEFQ=
X-Google-Smtp-Source: ABdhPJyNdT7mG6eIwonLaCJk5adaiSzltL3YDJdJmZxbYq7Nz/EB1M/if4s3Xephc+RFWDzcH2F4uuRsDiXrx7vifxw=
X-Received: by 2002:aca:ec09:: with SMTP id k9mr2369609oih.153.1610115317303;
 Fri, 08 Jan 2021 06:15:17 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <20201228213121.2331449-2-aford173@gmail.com>
In-Reply-To: <20201228213121.2331449-2-aford173@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Jan 2021 15:15:06 +0100
Message-ID: <CAMuHMdW1R9V23wf+bB=RjMxeTw8e393vcO-8FZnUtQjWZTQ1JQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: dts: renesas: Add fck to etheravb-rcar-gen2
 clock-names list
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
