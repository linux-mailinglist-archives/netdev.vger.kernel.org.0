Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3017269DB78
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbjBUHvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjBUHvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:51:41 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1451D901;
        Mon, 20 Feb 2023 23:51:40 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id y3so3821345qvn.4;
        Mon, 20 Feb 2023 23:51:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElMbLGKmVMgSLnKZdcPK6XbfUDqiTuYOu6y4Wvjfe/w=;
        b=zZlw7l2a9HfMIqnFAPt31jP30R/UZVL7qmk19ZKU1noTBUxUJfd0tjwOQWBhtGzQXa
         aAbH3XbVC4CNVIypK+5x5uBcLR/1ZHrxhqNCgqLHoMP9Aa1AVEvomG1rJVZwiL0ReEiy
         NMGW1ZWFqb79rGfB7rzWY0FnPGXvhnaolYNONTLQCRVmY7itUp5flfjtZcYnpVEip0Ny
         40x8ITdg6GPsWQozyKt13SojV+IEIWKbzPkH2+xAnY887wH+k3PqZ3Si83gCAQtRsJS0
         cfZvrEFw8792s+Xpwb+775Pn/4t+PBFPvQrwqErX4KuCu+qxYr8hLI3lMLiZcF8H6I9s
         lYEQ==
X-Gm-Message-State: AO0yUKWhV8HRnVjOn21T+/dH+EknI4HezuFNmcZTWejC1eCSd7KRulo3
        jfK7IyRCejglvXtGusl4CHw+PUbTEYfiAQ==
X-Google-Smtp-Source: AK7set94hpergGioyCzCUH64dMgr2S5Z+QPs4dZGIfQoMy1DurZG9CIUboxmcQX03+bfM00Lg0jB8A==
X-Received: by 2002:a05:6214:f2a:b0:56e:8a00:f3a with SMTP id iw10-20020a0562140f2a00b0056e8a000f3amr6630960qvb.32.1676965899505;
        Mon, 20 Feb 2023 23:51:39 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id t84-20020a374657000000b007203bbbbb31sm1546141qka.47.2023.02.20.23.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 23:51:39 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id i7so4295201ybu.6;
        Mon, 20 Feb 2023 23:51:38 -0800 (PST)
X-Received: by 2002:a05:6902:2d0:b0:920:2b79:84b4 with SMTP id
 w16-20020a05690202d000b009202b7984b4mr1007187ybh.386.1676965898708; Mon, 20
 Feb 2023 23:51:38 -0800 (PST)
MIME-Version: 1.0
References: <20230220203930.31989-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230220203930.31989-1-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 21 Feb 2023 08:51:27 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVqZR5C3kz36D0iUxqEiFoWJ3=o0vtMCWGJ7DNHT9zWsA@mail.gmail.com>
Message-ID: <CAMuHMdVqZR5C3kz36D0iUxqEiFoWJ3=o0vtMCWGJ7DNHT9zWsA@mail.gmail.com>
Subject: Re: [PATCH] net: phy: micrel: drop superfluous use of temp variable
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 9:44 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> 'temp' was used before commit c0c99d0cd107 ("net: phy: micrel: remove
> the use of .ack_interrupt()") refactored the code. Now, we can simplify
> it a little.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
