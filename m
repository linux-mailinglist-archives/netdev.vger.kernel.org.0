Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170D32EB35B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbhAETKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbhAETKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:10:36 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FE3C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 11:09:56 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id u203so508913ybb.2
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 11:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KFFXx9F5UV1YJm50ohDrpl/Ohe6HyaEp0A7ey36lXDI=;
        b=Ygktf0jcy9krcTCZULYspOMLNCnljoglRWQyfguGus4mssnKgaqnWMj324hX8YdZhk
         uu1mVmv+04s076CGYMrfhFAVdGnkJQ2/8qqY8TFqO3B6W1I2mXdlTAXns8rPNaeuZWaT
         lI3YZHPfp8buBIW4YxnAdDKPI4p2sJaOUCsefiOFJIMjY/DWJuRpPntmiJ0uXZxjXV4Y
         agN80yt3gyy2Fdf9aOt4l26EqjYaWLhOAAlT9KHN3wx7mdYjKOtk0eG2kx17nirHaOjP
         zNasSap1ntVvEFo/BIFLxRTTlb3aNU0KH3m8/Po+etm+srFXiHVz20z9SGE06xzqnmCe
         p8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KFFXx9F5UV1YJm50ohDrpl/Ohe6HyaEp0A7ey36lXDI=;
        b=DwhVUK8qNocR+ybuLO88jmIYAuNTpcXj9rGzbgB8E+cZAq6vR2E1zZaqFH4Xs4H29E
         nxAL8cn9L7j6NY8ZUkWqi3RxzrxsozLnU8w832TMBkgCHqjGmx9YkZ3/HgRlRJivIfD4
         9SbDRvmfLJGjyj+XSsGoZFHHI2FJ+CASEVYWkjMSFshVdNrC0iR7cI/8112IWZXLN8qA
         r2P94P4STalVbCi0LGsrb1g5Y3WB6O8b7g8PxTyG78QcCgjxa/1UVr2cQYw/zvQ4Ma72
         ObtdahYqAouSVbE/V+viHnnR+JW/o20Vhg+rqN0QB3TIrg/AxOnpV0s048BqIi0CnIVV
         G6eQ==
X-Gm-Message-State: AOAM533kAqZXACjQrqb+N93KYrdYFIc4gOj0wpUnIFaJCTXimF+c3YsX
        ZYW0mjmzYMdU+MHkbZxo84eKFfxf5MSaEXOsSwCgMw==
X-Google-Smtp-Source: ABdhPJxCv/KCzmRWqzy+NfNVTyxaN+KFrDVrIR8mP7ReI5XHaFQYx1fFeSZcW1Openq2yS3v4af3u9La9p4Yhm/AVQo=
X-Received: by 2002:a25:c147:: with SMTP id r68mr1402408ybf.278.1609873794960;
 Tue, 05 Jan 2021 11:09:54 -0800 (PST)
MIME-Version: 1.0
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com> <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org> <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com> <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
 <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com> <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
 <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com>
In-Reply-To: <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 5 Jan 2021 11:09:43 -0800
Message-ID: <CAEA6p_CfmJZuYy7msGm0hi813q92hO2daC_zEZhhj0y3FYJ4LA@mail.gmail.com>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
To:     David Ahern <dsahern@gmail.com>
Cc:     stranche@codeaurora.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 8:58 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/4/21 8:05 PM, stranche@codeaurora.org wrote:
> >
> > We're able to reproduce the refcount mismatch after some experimentation
> > as well.
> > Essentially, it consists of
> > 1) adding a default route (ip -6 route add dev XXX default)
> > 2) forcing the creation of an exception route via manually injecting an
> > ICMPv6
> > Packet Too Big into the device.
> > 3) Replace the default route (ip -6 route change dev XXX default)
> > 4) Delete the device. (ip link del XXX)
> >
> > After adding a call to flush out the exception cache for the route, the
> > mismatch
> > is no longer seen:
> > diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> > index 7a0c877..95e4310 100644
> > --- a/net/ipv6/ip6_fib.c
> > +++ b/net/ipv6/ip6_fib.c
> > @@ -1215,6 +1215,7 @@ static int fib6_add_rt2node(struct fib6_node *fn,
> > struct fib6_info *rt,
> >                 }
> >                 nsiblings = iter->fib6_nsiblings;
> >                 iter->fib6_node = NULL;
> > +               rt6_flush_exceptions(iter);
> >                 fib6_purge_rt(iter, fn, info->nl_net);
> >                 if (rcu_access_pointer(fn->rr_ptr) == iter)
> >                         fn->rr_ptr = NULL;
>
> Ah, I see now. rt6_flush_exceptions is called by fib6_del_route, but
> that won't handle replace.
>
> If you look at fib6_purge_rt it already has a call to remove pcpu
> entries. This call to flush exceptions should go there and the existing
> one in fib6_del_route can be removed.
>
Thanks for catching this!
Agree with this proposed fix.


> Also, can you add the reproducer as another test case to
> tools/testing/selftests/net/pmtu.sh? We definitely need one for this
> sequence (route, exceptions, replace route).
