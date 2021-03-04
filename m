Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B91632CEDA
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 09:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhCDIwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:52:46 -0500
Received: from mail-vs1-f49.google.com ([209.85.217.49]:42307 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbhCDIwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:52:30 -0500
Received: by mail-vs1-f49.google.com with SMTP id v123so9962453vsv.9;
        Thu, 04 Mar 2021 00:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDI3GVzsclOwd12hM+WQtQ81DeT8ZdoQrDFqcDwcMEQ=;
        b=heNtwQ8ZB1Xx1tY/7Xbkc8vSMBCo/ZdYjaIT4Xj46roEP4UAewkdpoe6Pi9oiBHFc8
         FhpwEBTbOm9F0Ac/V6RN+EcvNAk2DFFq9/UO1J6S81KnqXRL4YBsVgUHoinAibOWb6oY
         OG5oV7U2310fFXgbUmi03fM4Eas9/qcQELFxIeLBQ9ZygTMCNcPCff9lgdLGTUQvRmHc
         qmE5I6mvEZbTHElzFwQNAw6v9CMCQDWMoO2igg0BYSmk9K94j0C1JkW5BzFVHKHqledX
         pQO3912SeNzUWoYXzX6eM14MU7JCiKg8gc5LlbRUOcvtKjceaBaMBs23sBtL4VF6d9uu
         rCiA==
X-Gm-Message-State: AOAM530qtgOLeuboDfgDIHXpRVPhNZzlo/CFXqRzGYktlGQtaQbH0lrt
        ed0w2n1BH97JmH7XxPv6CxhQg7KQEFr660IhH9o=
X-Google-Smtp-Source: ABdhPJwjZmtIh0CFIAwuYhIQ8PgSynPMCx37GHCObbI0F0rEqTBraRWAW8fP80F5ifsnThMm+wQ/E4bfnAYjWgw6m+s=
X-Received: by 2002:a67:f7c6:: with SMTP id a6mr1831304vsp.42.1614847910002;
 Thu, 04 Mar 2021 00:51:50 -0800 (PST)
MIME-Version: 1.0
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru> <75bbbe07-60c0-c556-41fa-8a4ddd117f5a@omprussia.ru>
In-Reply-To: <75bbbe07-60c0-c556-41fa-8a4ddd117f5a@omprussia.ru>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 4 Mar 2021 09:51:38 +0100
Message-ID: <CAMuHMdV72Zqf4s8ouRM4stM0KfnPO3bWYHvFzd2PH8zUEPN1kA@mail.gmail.com>
Subject: Re: [PATCH net 3/3] sh_eth: fix TRSCER mask for R7S9210
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 28, 2021 at 9:56 PM Sergey Shtylyov <s.shtylyov@omprussia.ru> wrote:
> According  to the RZ/A2M Group User's Manual: Hardware, Rev. 2.00,
> the TRSCER register has bit 9 reserved, hence we can't use the driver's
> default TRSCER mask.  Add the explicit initializer for sh_eth_cpu_data::
> trscer_err_mask for R7S9210.
>
> Fixes: 6e0bb04d0e4f ("sh_eth: Add R7S9210 support")
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
