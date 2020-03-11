Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6CE180D80
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgCKB27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:28:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41842 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbgCKB26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:28:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id s14so455685wrt.8;
        Tue, 10 Mar 2020 18:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=i2GXwUO3qDNgYDRB9ez8I/6iO72/MRbkR6e7aAcVV0A=;
        b=Ge+bTOm5BYPgFpr5KskZa8tzox1HvhGVvVAdSXCMkAgacvZTQvg25yVy2z63vxWNiZ
         wSjsxpkN6tdYJ2QpOUAd8y37Wd+4wtfDTa/bUHaBO8kHjhiqBy76RdZaTD9hOh4paPlG
         qPi1XQskPxgRlUGUXZ8Ci3JfWuFXJdQZ9ziEbrIRsQj3E2dq9+lU+W9so7Oyx0Ef82V3
         9+wODufvk02QtXrWBhpubnnSEsgTF9KRiL/qGWoH9mHmz5QVXQNrlSJdWQOL7htaCzGB
         ykIJakogtGGUZW5qDxp0WKfX6liAyLMwgtWeioo5z8WJ1HhDsQk+SWLn6EbIsyK8yiEC
         xEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=i2GXwUO3qDNgYDRB9ez8I/6iO72/MRbkR6e7aAcVV0A=;
        b=qXPhoihmodU6dMsez5EMThDioKgAvWkAApaHYYw4lQINlnbY9UumLILapEBTXWKm3N
         b3do+s4q7dkOua3qLUtJYCQ2NzWD8fsSC1ej5nfL8p1Fr2V3xOMJUNOswkIuKTJqefnp
         sf2XbZ0aCVCHFfF9ed05TjazdxTXRQjCsKrYvahYhNVVmdufjbS83ezYEzN8yxIdG3fx
         0w1lYXRnAd2XX6848KREZq3aDL64DykUXDMXPmNR4fwqpiOqXo+FsNjMbWSbtCotdUqD
         747hfLKhQZneWN/znfO5tG79w5DbnYc/RRlfVBlcKSQEtHO35lEtRAeGZLBWFhzxJbra
         M4hg==
X-Gm-Message-State: ANhLgQ0ql2yKTdCHu0ruDfTE5sjgxPlWqRBJFec6lh9/QJ/IAnB7OsKa
        pft7fdJnsycM89sxJsUjsg==
X-Google-Smtp-Source: ADFU+vuMDrEPIvbWT0QtIlkI3Vb5ORn9kagCSARcSjQ0D7WOfTVUMOL5UowmRsaSiG0hhio/8Gn8KQ==
X-Received: by 2002:adf:ef0f:: with SMTP id e15mr869826wro.213.1583890137091;
        Tue, 10 Mar 2020 18:28:57 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.gmail.com with ESMTPSA id a7sm5929804wmb.0.2020.03.10.18.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:28:56 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
X-Google-Original-From: Jules Irenge <maxx@ninjahub.org>
Date:   Wed, 11 Mar 2020 01:28:49 +0000 (GMT)
To:     Eric Dumazet <edumazet@google.com>
cc:     Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 3/8] tcp: Add missing annotation for
 tcp_child_process()
In-Reply-To: <CANn89iJc9e5fQEWerHgDM1g2vp_1EEj0EntbCvccCzAyusHtdg@mail.gmail.com>
Message-ID: <alpine.LFD.2.21.2003110127440.25519@ninjahub.org>
References: <20200311010908.42366-1-jbi.octave@gmail.com> <20200311010908.42366-4-jbi.octave@gmail.com> <CANn89iJc9e5fQEWerHgDM1g2vp_1EEj0EntbCvccCzAyusHtdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the feedbacks. Good to know I have not used lockdep but I will 
try it.

On Tue, 10 Mar 2020, Eric Dumazet wrote:

> On Tue, Mar 10, 2020 at 6:09 PM Jules Irenge <jbi.octave@gmail.com> wrote:
> >
> > Sparse reports warning at tcp_child_process()
> > warning: context imbalance in tcp_child_process() - unexpected unlock
> > The root cause is the missing annotation at tcp_child_process()
> >
> > Add the missing __releases(&((child)->sk_lock.slock)) annotation
> >
> > Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> > ---
> >  net/ipv4/tcp_minisocks.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> > index ad3b56d9fa71..0e8a5b6e477c 100644
> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -817,6 +817,7 @@ EXPORT_SYMBOL(tcp_check_req);
> >
> >  int tcp_child_process(struct sock *parent, struct sock *child,
> >                       struct sk_buff *skb)
> > +       __releases(&((child)->sk_lock.slock))
> >  {
> >         int ret = 0;
> >         int state = child->sk_state;
> 
> 
> Yeah, although we prefer to use lockdep these days ;)
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
