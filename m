Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C800C1F950F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 13:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgFOLMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 07:12:20 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37838 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgFOLMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 07:12:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id v13so12770513otp.4;
        Mon, 15 Jun 2020 04:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NzHrWnPYObhVP39iJnXA6fy2WLMwyEQ0/MznsCSraCY=;
        b=EjQq2ksHyN/Jw7d0xrOUQuHYDw48pkCQryQFAJPfqu9c2+UNnm6p4+0wdMQsQWQZO8
         +3WhlRGCOrQtTSUYcQBj34oGCjNer+SUbK+mSrN0Tw3J+nb2YQkg4ZR82TXBHacb6Mee
         QPa1swL6TPDg8/KttePJ7T3HpkdURxx4sFKhfgK8R4RzPhswxFogCmyv3uZ1mZQsxdll
         UkFoHy7o6RiATPMvm2yE3JIqiKRiUZTL+yzGThf7v+DevejRllNBaaRWA7w1CJgx0TOe
         IiYV/K6HYfwqBzyb7kxX3qBkgR4HB+nzze+r9lbu8SlwhPtxjRGaveCv1wwTICW3Zmgk
         M7pQ==
X-Gm-Message-State: AOAM532k8sbPP7f3QpN+T4GDHBhrNss1s8GBUlZwSV/S0nAQcQOpgkll
        1btEZLoqWAxopaUa5+JytnaSHqyDBE+Z3+vMvpI=
X-Google-Smtp-Source: ABdhPJwNU7kfi0xVQVK3yR3e/enj3mxGdeSPNP6ctdSQmPoWnCYqpi9cg2YzIjosqJmPVKeIlWNM7W7afQ9Y4tVeJac=
X-Received: by 2002:a9d:c29:: with SMTP id 38mr19725517otr.107.1592219531260;
 Mon, 15 Jun 2020 04:12:11 -0700 (PDT)
MIME-Version: 1.0
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
In-Reply-To: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 15 Jun 2020 13:12:00 +0200
Message-ID: <CAMuHMdWixiv2NBQ8_Yo5LVv0wXsPaRAvL2mWYWBDF4p2moh_Og@mail.gmail.com>
Subject: Re: Good idea to rename files in include/uapi/ ?
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Sun, Jun 14, 2020 at 9:44 PM Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
> *Is it a good idea to rename files in include/uapi/ ?*

No it is not: include/uapi/ is append-only.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
