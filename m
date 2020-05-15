Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E4C1D5CC8
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgEOX3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 19:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726231AbgEOX3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 19:29:46 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A0BC061A0C;
        Fri, 15 May 2020 16:29:45 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id j3so3979793ljg.8;
        Fri, 15 May 2020 16:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8VigufgJ5fsxUJ8a9xBU0qdGLHvxNR7SyMmYLBhsMlE=;
        b=ov/JM1bgmg/5vtRtRn+14wr9DisBdBRDSiCam9zcqZ1dRmn12wMV1LU2R/uKUVPkL9
         EaNNXabQ63w1Tv9KPU/n8iyWydOhIAXW0XFsCGUoV6LrsZV2ztq8J47DzSSRVJ189P1D
         UvkVDOtgVDoCoTYsLc//qsfTcOHpBE0Nyu0F38rb5qGJdgtHazUoKImvq8ubcKGlc/nt
         O7AZuDaEqTm24qK6y8HlOQTVnAEpYIzEwc4Bo6MMgV7lemTP4xAVHVB0KP1tF7Tzjbka
         EkUo6dzWy8XEyXI6gNCz8VVWQoej9uQ/vweAJxrnfGLARv05Td06u5TzpF2oS6SlhLhL
         tukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8VigufgJ5fsxUJ8a9xBU0qdGLHvxNR7SyMmYLBhsMlE=;
        b=B0FDdVeVcNNb1yvHmtc7vI0lGb6h07Ul8ezGRiMEAH5UWT8f/R1KBtPWRVYfsYcgo1
         6ObcUGWmVdoeQLJ4Ibm7SKOOzWssnyZY2Fptar9keoDta2BQBQqoh39ZWKowdwygbf3k
         LRQeKU91+54wWhC6BKlIqzgz4EVz73W33TWnLNAgkgJ2lwAAZpS4IjO5laa6kz6W/7mq
         lVHH/1YW4t8cLEbkZ0yHilMeyaBXX3cbuzmvmXMZzmHiUAbOQZA8eQhopkP0kWw/Ipha
         IkeHWnhc2naBrXWA1Mn/piLOsCVXRkCskQqlLKwLsImyRh0Sw5J9BFuoV7mM0ZGNg3M5
         Ds2w==
X-Gm-Message-State: AOAM530S25Xs0/ul8RAzlu6EofpOvrCB9eMNki08A5dLsRdTXKKWA7fL
        ivCWD52y8SzfJpdcR1/RzeDnPQX2ZjfuBQriJCQ=
X-Google-Smtp-Source: ABdhPJwAI42AQwjxaTMgfouWAsDJpRDKIo1PfmMFI9xbQ1M6rOU3tUVECVACKdx/som2N3F7ZxKY/4EyfVT9QbT2ods=
X-Received: by 2002:a05:651c:48a:: with SMTP id s10mr3413878ljc.7.1589585384365;
 Fri, 15 May 2020 16:29:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200512174607.9630-1-anders.roxell@linaro.org>
 <CAADnVQK6cka9i_GGz3OcjaNiEQEZYwgCLsn-S_Bkm-OWPJZb_w@mail.gmail.com>
 <alpine.LRH.2.21.2005141243120.53197@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
 <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com>
In-Reply-To: <CAADnVQJRsknY7+3zwXR-N4e6oC6E87Z32Msg4EXaM8iyB=R3qQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 15 May 2020 16:29:32 -0700
Message-ID: <CAADnVQ+WXa62R6A=nk1kOTbX8MqkbMEKDx=5KCdx5Th0NnFm7Q@mail.gmail.com>
Subject: Re: [PATCH] security: fix the default value of secid_to_secctx hook
To:     James Morris <jamorris@linux.microsoft.com>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:47 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 14, 2020 at 12:43 PM James Morris
> <jamorris@linux.microsoft.com> wrote:
> >
> > On Wed, 13 May 2020, Alexei Starovoitov wrote:
> >
> > > James,
> > >
> > > since you took the previous similar patch are you going to pick this
> > > one up as well?
> > > Or we can route it via bpf tree to Linus asap.
> >
> > Routing via your tree is fine.
>
> Perfect.
> Applied to bpf tree. Thanks everyone.

Looks like it was a wrong fix.
It breaks audit like this:
sudo auditctl -e 0
[   88.400296] audit: error in audit_log_task_context
[   88.400976] audit: error in audit_log_task_context
[   88.401597] audit: type=1305 audit(1589584951.198:89): op=set
audit_enabled=0 old=1 auid=0 ses=1 res=0
[   88.402691] audit: type=1300 audit(1589584951.198:89):
arch=c000003e syscall=44 success=yes exit=52 a0=3 a1=7ffe42a37400
a2=34 a3=0 items=0 ppid=2250 pid=2251 auid=0 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=ttyS0 se)
[   88.405587] audit: type=1327 audit(1589584951.198:89):
proctitle=617564697463746C002D650030
Error sending enable request (Operation not supported)

when CONFIG_LSM= has "bpf" in it.

KP, Anders,
please take a look.
