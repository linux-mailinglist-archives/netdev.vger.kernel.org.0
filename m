Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126233880D8
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 21:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbhERT5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 15:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239073AbhERT5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 15:57:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51279C061573;
        Tue, 18 May 2021 12:56:30 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id e14so10179135ils.12;
        Tue, 18 May 2021 12:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=43mVGV8KLvYFUDiQnFtuH1ChWfJqb7nYVult5qDl1Ak=;
        b=lH6cehuYTAh4Q4jPgBZ/lS1XzoPHsDPbU56BgRtpZbXziUQ9sSju0Cv3yG3lZK02QZ
         0VpSxZ28BZ5nshMB7j6U0xSA9Vwg4TzD8j85bvlAM4B12WdFO69sIiXy0F5oTjopom1H
         O0m7OTFfwoAo6BeuGGGOUuiPxCVI/wY26qH1A6OHbt6ButPbpvmXHv5NOXgDLoxx3Ljk
         9Nz4MGLjXr9ySFBWdwPKDHjWXAKd9zsLfqPGQHVeiwDxaFciB+eA1K6FxmzaoivNISeG
         ieLnBLy/1k/xqqN/Cg5q0ryoeiNl0UOTFLjgwby1QK5bKmzc/1QYU6xMBNz3m1j3guam
         mHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=43mVGV8KLvYFUDiQnFtuH1ChWfJqb7nYVult5qDl1Ak=;
        b=Ok6ryatnXNaUsTjBEqeunTM3vyiZtcvAzQeMc19xCQI+iX3PuK8yk7EPHBKfm+HYGc
         kVNQlwNYiwygowb9vpAU1k0xtr0G/lC1Wd5cw30MvCm+h913BtTQF5pSsVr/1u2cr8u7
         /WAr/j7nsOeVDo6X9RlXguEJgggguccTs8G8zjnz4kJTI5u23EF7AFMMYKQva7LaiaSF
         uK13Gdf5TVVv2FIUPvRQmRJYOUGaxwKwdDJ8vsoOeKh6d+YsEQ7i3u1lSYMyE58Neqvj
         07IiTqdOSxl6NOhMwkDtdX7PbKWNh0kvFs23sME1lGh4BdwYApa4sF35tsGo1/aojcss
         e+Kg==
X-Gm-Message-State: AOAM532cyepNhIzbvq8WfRP4A8VPvFa/bAYADH9e59S3NcQ5AF7wLHke
        sGuQbaRsMU/elu+v0DXUPYo=
X-Google-Smtp-Source: ABdhPJxnsagkUFpqIdNAocUkAX1MBBDgrvoe3+nGQacXitoGMVR+owbdXBoQL2k4sUtNqA2FH//oCw==
X-Received: by 2002:a92:c243:: with SMTP id k3mr6361491ilo.81.1621367789838;
        Tue, 18 May 2021 12:56:29 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id c11sm9544158ilo.61.2021.05.18.12.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 12:56:29 -0700 (PDT)
Date:   Tue, 18 May 2021 12:56:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
 <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Mon, May 17, 2021 at 10:36 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > afterward, so udp_read_sock() should free the original skb after
> > > done using it.
> >
> > The clone only happens if sk_psock_verdict_recv() returns >0.
> 
> Sure, in case of error, no one uses the original skb either,
> so still need to free it.

But the data is going to be dropped then. I'm questioning if this
is the best we can do or not. Its simplest sure, but could we
do a bit more work and peek those skbs or requeue them? Otherwise
if you cross memory limits for a bit your likely to drop these
unnecessarily.

> 
> >
> > >
> > > Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/ipv4/udp.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index 15f5504adf5b..e31d67fd5183 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > >               if (used <= 0) {
> > >                       if (!copied)
> > >                               copied = used;
> > > +                     kfree_skb(skb);
> >
> > This case is different from the TCP side, if there is an error
> > the sockmap side will also call kfree_skb(). In TCP side we peek
> > the skb because we don't want to drop it. On UDP side this will
> > just drop data on the floor. Its not super friendly, but its
> > UDP so we are making the assumption this is ok? We've tried
> > to remove all the drop data cases from TCP it would be nice
> > to not drop data on UDP side if we can help it. Could we
> > requeue or peek the UDP skb to avoid this?
> 
> TCP is special because it supports splice() where we can
> do a partial read, so it needs to peek the skb, right? UDP only
> supports sockmap, where we always read a whole skb, so we
> do not need to peek here?

Its also about not dropping data. In TCP we should not drop
data at this point in the stack so if we get an error, ENOMEM
or otherwise, we need to ensure we keep the original skb.

> 
> Thanks.


