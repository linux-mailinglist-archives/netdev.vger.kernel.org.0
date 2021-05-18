Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFF0387108
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 07:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240592AbhERFMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 01:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbhERFMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 01:12:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D98C061573;
        Mon, 17 May 2021 22:11:27 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id k16so8158696ios.10;
        Mon, 17 May 2021 22:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=JAEgSviBChxkk23B0EsHo39yWb9O00dsg5aXHej6dCA=;
        b=FDRoEIkTb0CAZrzUk3bLQEBFp7ErzWF1JMKyVIyHL7Y9xj4VmqyujEec5Icg0hvydy
         r0E1eqFmK79LXvxcZ7DIgyQhjINRvSN3vPsavJX3k0mgi36f3pMNGaW7xVKvAv9xm0JF
         u8tHDdfDIoW9o1+zntqDP8jNGVnP9TmvBOl95t8q/ZUDlk2lQIxs0AiIDpmEYISeqdG4
         3uLcS9Letf+IOU0K5NgdmimM2zalSOmFjU+K/Z5dV9AJMoEjZKhyFXOwMWHxQuru90QS
         mpdY06hWHyDOR+ekK6hKmnyXRpGcqTJTVJl62GIOyhflcAG0bo4+GM9g9hP9gd0iyKRQ
         5mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=JAEgSviBChxkk23B0EsHo39yWb9O00dsg5aXHej6dCA=;
        b=og+NPGdTLV2R2mjQe1i6ZSxp9ykLiJQAdV3WYB9XbXOuamZ+BYBYPEiIBwOTE1/G2r
         dPOH4IGfS6gfiL6SO8MYdOTv4dEHVQ7qQh0gM6kSADahrBfOj6qycgKePH+mXvlhUNcf
         l/+UAAIHdAzclZFaGkVMr5OmUUbt1KrEJ7ggKN+jpsSZ1vXfeig7mNOIQuvmElRTWcUQ
         E/c2pPmgyv/TD7NH1fk52dEUF4KxEkXbQ+AHmmOlWtBnLvC0yeQ0ypyO1bvEr3DAeecd
         eJo6ZKuQCxMWIjaZSQ2bYYZPmXm0KtzRz2QBbvf1GqxH4BjD8P54muXRRE6X3CEVJRK6
         pA9A==
X-Gm-Message-State: AOAM530Daxuwnj24S5+gJCBO/C58TY/3UalcdnzYdNUIXHa9qoV6ZTeI
        p5a2VcD0QGe7ukckCmQDlLg=
X-Google-Smtp-Source: ABdhPJwQumxZAL+cBhxgJknLvzDMyo2p7vhIAF0/910ytk+Xi7p1KsitGffKDC4v88V38xOUo5lcAQ==
X-Received: by 2002:a02:9443:: with SMTP id a61mr3608054jai.60.1621314687481;
        Mon, 17 May 2021 22:11:27 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id d15sm9873667ila.86.2021.05.17.22.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 22:11:26 -0700 (PDT)
Date:   Mon, 17 May 2021 22:11:18 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a34c768873f_56215208a1@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpUawKFmqL-XLMwoBjSTAwj+NLhZ0Su1r-W+6U_fttZp9Q@mail.gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-3-xiyou.wangcong@gmail.com>
 <609a1765cf6d7_876892080@john-XPS-13-9370.notmuch>
 <CAM_iQpUawKFmqL-XLMwoBjSTAwj+NLhZ0Su1r-W+6U_fttZp9Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, May 10, 2021 at 10:34 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> > > +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> > > +                       sk_read_actor_t recv_actor)
> > > +{
> > > +     int copied = 0;
> > > +
> > > +     while (1) {
> > > +             struct unix_sock *u = unix_sk(sk);
> > > +             struct sk_buff *skb;
> > > +             int used, err;
> > > +
> > > +             mutex_lock(&u->iolock);
> > > +             skb = skb_recv_datagram(sk, 0, 1, &err);
> > > +             if (!skb) {
> > > +                     mutex_unlock(&u->iolock);
> > > +                     return err;
> >
> > Here we should check copied and break if copied is >0. Sure the caller here
> > has desc.count = 1 but its still fairly fragile.
> 
> Technically, sockmap does not even care about what we return
> here, so I am sure what you suggest here even makes a difference.
> Also, desc->count is always 1 and never changes here.

Right, so either don't wrap it in a while() loop so its obviously
not workable or fix it so that it returns the correct copied value if
we ever did pass it count > 1.. 

> 
> Thanks.


