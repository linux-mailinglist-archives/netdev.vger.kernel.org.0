Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C768A3A68E0
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhFNOWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:22:41 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39754 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbhFNOWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:22:40 -0400
Received: by mail-wm1-f52.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso13185572wmh.4;
        Mon, 14 Jun 2021 07:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntoCOVnrPUjM3Ofrf7H0o2SGwRtWq9U2woPrMFAIRUI=;
        b=pipNPyTV+0XIMPdEUdRFiG6oaeS1KuJDvC0rOeTbtaokK8qR9ef6fL165sNX6Vqvjj
         Y7tVPjtI98RvW3pymPX7Le13XiIF2nPqKoT3jDo+U2PI1VlIal3jG0sFMbCmyd2Vo43g
         XJTNsQAMGDeOBC9BIS+AcecIz7SusgiJgg4fDZV10hEZ7C8lXaRwy3Vvv43wuwsEcfff
         BIHPy0Ac+z5dcylq+6r0yNClifgklgEL8FEJxFHV3hzweTjTDDmFrKwGrImmI5svGfCl
         7UrNR6N4sZckxbJj8gcwxYLUcYmDKnsoe+AzRb4sPFlUNluha2R9DfJspz8LOiYtjwNM
         rEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntoCOVnrPUjM3Ofrf7H0o2SGwRtWq9U2woPrMFAIRUI=;
        b=k8G7+awP3KgS6ilayfGAe+UQTLGFpAWrQlkrk9Q6nXvjHTc0r2kBH1cGXQL96fU3Kk
         RMTMD/UeyNBcOjSofck79W+p8qRFEJsWbXzjbOv8dz3KliJ9RjemToBF7TcPvZKRIKoL
         J9iJSGXsm6UbDleudpz265Zgi3roZwb01JbK3qmT8PU1Fy36mS42faCwz+ZSpipB3h2X
         LnkC1A2Kc1nOJlolMUy95UZND4T8U/18Yff6yZ/NXMWQvdgtPYW7FWFH3hGFkkGI/pdW
         dYyqwb2EH7wsRNrWXPH3aLiGolJOCJpOv+Cosc/q8czndkdXJ8+Xsyop0AAf1soSC+Gu
         QedA==
X-Gm-Message-State: AOAM53241ZITLcrkv1FEAPnlrVtniwFaiZUNxrD9nG8ITrpIYdQTY+z8
        9zLC5pVLZ0k90YpNPG4VtS1QhtjjsfSGuU3d+IY=
X-Google-Smtp-Source: ABdhPJxyr9QlGm2IEr7AF8xI/6p2wnnmjl5Ryxs3mdGkQtjBLqaD6XtoGS55mAIissVbjmH+AWHykOudk41e/iFJV60=
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr17080728wmf.143.1623680376586;
 Mon, 14 Jun 2021 07:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
 <20210614163401.52807197@gmail.com>
In-Reply-To: <20210614163401.52807197@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 14 Jun 2021 22:19:10 +0800
Message-ID: <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
Subject: Re: Suggestions on how to debug kernel crashes where printk and gdb
 both does not work
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 14 Jun 2021 21:22:43 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > Dear kernel developers,
> >
> > I was trying to debug the crash - memory leak in hwsim_add_one [1]
> > recently. However, I encountered a disgusting issue: my breakpoint and
> > printk/pr_alert in the functions that will be surely executed do not
> > work. The stack trace is in the following. I wrote this email to ask
> > for some suggestions on how to debug such cases?
> >
> > Thanks very much. Looking forward to your reply.
> >
>
> Hi, Dongliang!
>
> This bug is not similar to others on the dashboard. I spent some time
> debugging it a week ago. The main problem here, that memory
> allocation happens in the boot time:
>
> > [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
>

Oh, nice catch. No wonder why my debugging does not work. :(

> and reproducer simply tries to
> free this data. You can use ftrace to look at it. Smth like this:
>
> $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter

Thanks for your suggestion.

Do you have any conclusions about this case? If you have found out the
root cause and start writing patches, I will turn my focus to other
cases.

BTW, I only found another possible memory leak after some manual code
review [1]. However, it is not the root cause for this crash.

[1] https://lkml.org/lkml/2021/6/10/1297

>
> would work.
>
>
> With regards,
> Pavel Skripkin
