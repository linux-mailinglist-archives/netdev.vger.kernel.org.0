Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D90230202
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgG1FsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgG1FsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:48:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52CA3C061794;
        Mon, 27 Jul 2020 22:48:17 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l23so17671714qkk.0;
        Mon, 27 Jul 2020 22:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvlM9NHcsACKHHGiZRDV7tCWZy0Y4sC2TI8QRB0PPGQ=;
        b=aK6zkF40KDA0bO12q53pkVpFYe+e73fEmE6vPRW+8PozxmR+lF8y8CsJDalWhutE9P
         GaNKLckJ683mZ66OiAoz6Hvfq9keqggBbof51sgJQ3X9y2umghAIcI+ZS3bbfdGX3ZOm
         RSfys2J7nUIra0LaZ/mbRJAGGpSxE4Y/L2r3ti1HGsRJtDCFgtuxbeBOWDrCaYWSe6VQ
         56afX33NU9PjG9KstKRHrX/X8GUXPHI4FMwiPjzAz/HtkplWT1NYoPbXI5Dtd9fh/ih4
         6dpa5xP/iyTuI0TgW536j3Cf62R984vFeQhmZ2Uw2DylCostvUzuWG7Fx1bqOA1CNKOD
         sKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvlM9NHcsACKHHGiZRDV7tCWZy0Y4sC2TI8QRB0PPGQ=;
        b=oa9m5yVy7sy3PhhRg0Xzyxzk66Z9USkqUyPoxPebT8MTtWQS2qtGS/4ut77MmDaZFt
         0HBmX/Bk9ffBIHTHTZcABKDImCuu6laD/krJLJeHaK3jVVPOcBH1nNfLMAhnXK0XvOKn
         h77lkW87jac/G8oAJhu0oauK0KTzG/ES5IKM1ttngkVndvJ6q+UImQulNIclDEAE97W8
         4wOCx2jEn+uZppGv+Ta9vVVCqODKNO/hxKQBmhIXlyGIMIQ2myKA1xqNR1R8h/N7QHDx
         o7XzaN2WrHFQH0of3dpOl2ox05m/jRbmSmygUTZc2HHKo50CKNREWJ5p3zpjBqeLGJin
         9MCw==
X-Gm-Message-State: AOAM531kak9nE3+7lNMMW10nafEQHNNjd+NABx4xaTpuL8qMHBdmjN9/
        wwJdDHZtbttN3JKuCE94jsm1QPQpvjtKM9ZJLXY=
X-Google-Smtp-Source: ABdhPJzYaowpf8c8ew54cvnOj81WmjS1ctFGJrkLtq16cmtc9r7UbP0dSQjGKtifjM/IdKtliCg1nJr8KoHA19UIXBA=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr27590585qkg.437.1595915296590;
 Mon, 27 Jul 2020 22:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200727232346.0106c375@canb.auug.org.au> <e342e8ce-db29-1603-3fd9-40792a783296@infradead.org>
In-Reply-To: <e342e8ce-db29-1603-3fd9-40792a783296@infradead.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 22:48:05 -0700
Message-ID: <CAEf4BzYD-PiA2cDvD5qRv7hHZ_GTDdKqAm1jfg2ZWBWM_3YO5w@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 27 (kernel/bpf/syscall.o)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:58 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/27/20 6:23 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Changes since 20200724:
> >
>
> on i386:
> when CONFIG_XPS is not set/enabled:
>
> ld: kernel/bpf/syscall.o: in function `__do_sys_bpf':
> syscall.c:(.text+0x4482): undefined reference to `bpf_xdp_link_attach'
>

I can't repro this on x86-64 with CONFIG_XPS unset. Do you mind
sharing the exact config you've used?

I see that kernel/bpf/syscall.c doesn't include linux/netdevice.h
directly, so something must be preventing netdevice.h to eventually
get to bpf/syscall.c, but instead of guessing on the fix, I'd like to
repro it first. Thanks!


>
> --
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
