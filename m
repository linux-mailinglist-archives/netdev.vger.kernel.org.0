Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7B4BD6B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfFSQCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:02:39 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39471 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSQCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:02:39 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so3801374ljh.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2TZYFZlX9e62I/OKOgYgScEFw66m8yxPTXTWjgcCpk=;
        b=fRzB1EbE2KvLOrtDYcH6Bmx/ekekTfKr6UqmgWpisdXrEnoJmgdOSbNhSwH8IGWmJM
         x0zgMnRrBbm8rA19uw67e1raz3rUnXncZTKLdtnzrPqhu/AoNvA0EuxPb841QUtrhDz/
         CNSZNYYnZ99WL3xLojQwD6lDC1u35yUIjRoy8eenp+vvCZEKp+FtOgAPDYsT2WL9WZci
         wjH6KqBZUdsR/scmzhyDdh8SjbTY7eX0oy0Vti/mDgiwBRXrY+VzUZ2NRi3z8Yw215Z9
         Ayoj4uf7n8ccnFYMX1XSUVPQPQ72nzZGxstDzYWt/vUfXw/qybwEVOXjwNu8LYuSXd8u
         PLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2TZYFZlX9e62I/OKOgYgScEFw66m8yxPTXTWjgcCpk=;
        b=eF4nWQ7z8SP9KmKndRCHYXWuQBAc66Hp/NWpus0M9Bf7OxXr594wNzLLfFSH3jfHxp
         zh5wEz40S3fQG+2oPnBfjeiK2FoBsJhn6bV9f4ACEbAA3gcOoNkjqyCY3vrp0MHg7QtJ
         jT3t7Ue3QkLu7xd+aWNd/a/NoEjkAb+zqc9n6BHD28Kw6QaKZ4FOj7/cGgTLgMmUFO1Z
         W9scWCiMlW5t3J1FvQ/u/9sgu1PyIjBFbTjKUTk86M7eVoAjOPR38kmjdIc/170hY528
         faJYBQH/axi++maoEbUMKi0A8fMrOD9n7mNpAnfDFsSObOlJ8eDDYHZwYzr3mKl/wOik
         WX3Q==
X-Gm-Message-State: APjAAAVvurj5VLUr6R2bjF/D86CHoSVt/Fjv8q24I2ZgGcpP/fo2Jh7m
        igfLjeB1QY4RqMEhO51j0zkz95Jo5cIqpL7DbwoeUQ==
X-Google-Smtp-Source: APXvYqxiUARD7JkUyt9VKeDlYQDMGfcvoKTnLRUfAO3zrZVdUm5KJtR+u/L7XFzMK/jdLnA65048lF47M7mRlJIbDcU=
X-Received: by 2002:a2e:8847:: with SMTP id z7mr4510054ljj.51.1560960156976;
 Wed, 19 Jun 2019 09:02:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190617132636.72496-1-lifei.shirley@bytedance.com> <20190618.105548.2200622033433520074.davem@davemloft.net>
In-Reply-To: <20190618.105548.2200622033433520074.davem@davemloft.net>
From:   =?UTF-8?B?5p2O6I+y?= <lifei.shirley@bytedance.com>
Date:   Thu, 20 Jun 2019 00:02:26 +0800
Message-ID: <CA+=e4K42mM7-KprPbPjWvDbu8QOrv5=s4QxpWJieeUM73dfS_g@mail.gmail.com>
Subject: Re: [External Email] Re: [PATCH net v2] tun: wake up waitqueues after
 IFF_UP is set
To:     David Miller <davem@davemloft.net>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengfeiran@bytedance.com,
        duanxiongchun@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks.

Have a nice day
Fei

On Wed, Jun 19, 2019 at 1:55 AM David Miller <davem@davemloft.net> wrote:
>
> From: Fei Li <lifei.shirley@bytedance.com>
> Date: Mon, 17 Jun 2019 21:26:36 +0800
>
> > Currently after setting tap0 link up, the tun code wakes tx/rx waited
> > queues up in tun_net_open() when .ndo_open() is called, however the
> > IFF_UP flag has not been set yet. If there's already a wait queue, it
> > would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
> > Then the saving vhost_poll_start() will add the wq into wqh until it
> > is waken up again. Although this works when IFF_UP flag has been set
> > when tun_chr_poll detects; this is not true if IFF_UP flag has not
> > been set at that time. Sadly the latter case is a fatal error, as
> > the wq will never be waken up in future unless later manually
> > setting link up on purpose.
> >
> > Fix this by moving the wakeup process into the NETDEV_UP event
> > notifying process, this makes sure IFF_UP has been set before all
> > waited queues been waken up.
> >
> > Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
> Applied and queued up for -stable, thanks.
