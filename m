Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B410EDF0
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfLBRLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:11:24 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45876 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727618AbfLBRLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 12:11:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id d20so254717ljc.12;
        Mon, 02 Dec 2019 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lpXTTJYa93HPPwo+Z8D2FxtkYP9FJXZjmmqaDUf8VaQ=;
        b=E9g04maQVIBCqRxru4XzIIVPCWLg64d60N7C1BB9CogSSuFO2kAfZikv7f7ZZhlreD
         flUIUUTBprsfqCUdRLaFKdMmE7ZEEg/I49MNQznUnzw6qyyERDXxuq5IsuwzybPZIYy6
         B80djTP13Csl7cYKezxlFGhIsF28UabrGMMoHpliQB+A++RDycsneZO9RGH2k5Ofc1w9
         kT6uSocZK+b7eez1M7j2QeVVvC/EcnbKL3nLhpTAvDv3+ptL9MDm1lZNcYigsDnelktU
         4k4F6N6VvOyb+rn/iqhjfOXG88RRLUjMP8eoT+69G7eL/tMCFTPr4Nj/h6YXSOGJGBgW
         SP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lpXTTJYa93HPPwo+Z8D2FxtkYP9FJXZjmmqaDUf8VaQ=;
        b=EFGVdVMuYBAqDoh3SO12TxANHnVxu4caPRtMMgLNm+a0akmA3kKCkmgncKkvErrXxl
         rK6kjsX25gvIPJKlsQA2/6Y59SJpNNSrWahzpncy7G3+bUbA119A1/3be0B/sPzTtDzS
         RGoNNYUA4iZXVRvfo8UbBqLRgh8SU/ZVG2/UXf7GYlNWkRvYEKEGJ+qLlBKg4SLlfmUp
         1OTippBabvkFIzi81+zQJZUhUOGRG9IZxqV1H8s8X/jG2Y3uYush/VrRBNHcwbwBELZB
         FeRy12HXpgXOGzNFyaMRzrE7lciLNcEu510qKM0VrvcAO91lD92HWMRT4juojlov5dhr
         lcwA==
X-Gm-Message-State: APjAAAV0d4Z2RAEYkeOzhYrYL06IfHHFcN4Xp9EhLG7z5cpwD51gjgnA
        0RUhfCu1YTuoEr8o81yooFie+/qo+hfNNLhtphs=
X-Google-Smtp-Source: APXvYqwvX2YSTp98I8S0ycyL/X5UhxVECvuh6tjh70qyuJdgly0QGQA05gHw6kuFWXvF6MbhiYfWSc86DjT78sEyW9E=
X-Received: by 2002:a2e:58c:: with SMTP id 134mr34674239ljf.12.1575306680817;
 Mon, 02 Dec 2019 09:11:20 -0800 (PST)
MIME-Version: 1.0
References: <CAD56B7dwKDKnrCjpGmrnxz2P0QpNWU3CGBvOtqg3RBx3ejPh9g@mail.gmail.com>
 <20191129164842.qimcmjlz5xq7uupw@linutronix.de> <CAD56B7dtR4GtPUUmmPVcuc0L+7BixW9+S=CR1g4ub3_6ZgRobg@mail.gmail.com>
 <20191202162651.7jkyj52sny3yownr@linutronix.de>
In-Reply-To: <20191202162651.7jkyj52sny3yownr@linutronix.de>
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Mon, 2 Dec 2019 12:11:08 -0500
Message-ID: <CAD56B7d3tyWfweZYogywebTcTvZQqK433e5w0GeahHJRzS2cDg@mail.gmail.com>
Subject: Re: xdpsock poll with 5.2.21rt kernel
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Well, it does complain (report below), but I'm not sure it's related.
> > The other thing I tried was the AF_XDP example here:
> > https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP
> >
> > With this example poll() always seems to block correctly, so I think
> > maybe there is something wrong with the xdpsock_user.c example or how
> > I'm using it.
> >
> > [  259.591480] BUG: assuming atomic context at net/core/ptp_classifier.c:106
> > [  259.591488] in_atomic(): 0, irqs_disabled(): 0, pid: 953, name: irq/22-eth%d
> > [  259.591494] CPU: 0 PID: 953 Comm: irq/22-eth%d Tainted: G        WC
> >        5.
> >
> >                         2.21-rt13-00016-g93898e751d0e #90
> > [  259.591499] Hardware name: Enclustra XU5 SOM (DT)
> > [  259.591501] Call trace:
> > [  259.591503] dump_backtrace (/arch/arm64/kernel/traps.c:94)
> > [  259.591514] show_stack (/arch/arm64/kernel/traps.c:151)
> > [  259.591520] dump_stack (/lib/dump_stack.c:115)
> > [  259.591526] __cant_sleep (/kernel/sched/core.c:6386)
> > [  259.591531] ptp_classify_raw (/./include/linux/compiler.h:194
>
> Is this the only splat? Nothing more? I would expect something at boot
> time, too.
I should have expanded more. This seems to happen every second
starting at boot in ptp_classifier.c regardless of if I'm doing
anything with BPF.

>
> So this part expects disabled preemption. Other invocations disable
> preemption. The whole BPF part is currently not working on -RT.
OK, so I should expect more issues as we play with AF_XDP? An
application based on the other example [1] is at least running.
Preempt-rt + AF_XDP seems like an awesome combination, so I hopefully
any BPF issues can be resolved.

thanks,
Paul

[1] https://github.com/xdp-project/xdp-tutorial/tree/master/advanced03-AF_XDP
