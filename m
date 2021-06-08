Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0B639F7EE
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbhFHNkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:40:05 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:46734 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:40:03 -0400
Received: by mail-vk1-f178.google.com with SMTP id 184so163439vkz.13;
        Tue, 08 Jun 2021 06:37:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFBGRyF0SVyL5gp+laaTF2trM1KaVtWovTdNQuQCpaI=;
        b=kmR0Gn148hehCkYfzLDMf/tBX1ZJAn9isGxrv1CT2fllCax8TylhJl4x0wSrckp9fu
         or4IwDE93KeMy9w+9iUy03+gtn47uKX3bG7bdoEgpXmwwB5Wr59II7Cr9pdGZMnI43VT
         TjwLbQZ39gFn9ih6UbpPJ0MlD2duJkvyQ0CRsAOV303SXMf8yr+Gb50CVdhgkCXCjFYv
         sP9GLOiWpmrdZR2VzmrR3g/YUfeb1dHeq90BvgiMjlwvz6PmCrgjrg2geEUp32vsapFp
         u+eX8qnl9JX0rsCWPYBaVqsTbs+Z6zjKK8DG0bZx9VxPul91y4Io77xYRhmjlXfQpGjJ
         l7tQ==
X-Gm-Message-State: AOAM530GOa1G4U4YQS7Gb219D7OtIXZzo1KYr5n6Y34NjHFz6DHj7zL0
        Qd1nLOWWcxFFW2b9t1L7Ekebj7ZsW+Sc1Fa91gHjjee+1G4=
X-Google-Smtp-Source: ABdhPJzZpyfnwLGoBlfNX9l9wAC4rUovi8VQg3eXsLNLgoL0OHDkqdxJ2vRdBZLHTWRUeXJBZZqNSzFEalIOgTNWy2E=
X-Received: by 2002:a1f:ac45:: with SMTP id v66mr10780808vke.1.1623159478179;
 Tue, 08 Jun 2021 06:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <39b1a3684880e1d85ef76e34403886e8f1d22508.1623149635.git.geert+renesas@glider.be>
 <20210608121925.GA24201@lst.de>
In-Reply-To: <20210608121925.GA24201@lst.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 8 Jun 2021 15:37:47 +0200
Message-ID: <CAMuHMdWgLf8GJfOaRUyx=AvOTnuOs8FS-2=C+OCk02OLDCyrDg@mail.gmail.com>
Subject: Re: [PATCH] nvme: NVME_TCP_OFFLOAD should not default to m
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Dean Balandin <dbalandin@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Shai Malin <smalin@marvell.com>,
        Petr Mladek <pmladek@suse.com>, linux-nvme@lists.infradead.org,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Tue, Jun 8, 2021 at 2:19 PM Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Jun 08, 2021 at 12:56:09PM +0200, Geert Uytterhoeven wrote:
> > The help text for the symbol controlling support for the NVM Express
> > over Fabrics TCP offload common layer suggests to not enable this
> > support when unsure.
> >
> > Hence drop the "default m", which actually means "default y" if
> > CONFIG_MODULES is not enabled.
> >
> > Fixes: f0e8cb6106da2703 ("nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Err, where did this appear from?  This code has not been accepted into
> the NVMe tree and is indeed not acceptable in this form.

It was applied to net-next.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
