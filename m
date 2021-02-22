Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9040322038
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhBVTey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbhBVTdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:33:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75641C06178B;
        Mon, 22 Feb 2021 11:32:20 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id e9so251274pjj.0;
        Mon, 22 Feb 2021 11:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MZysaavM6RaxfqjWf6Ljab3pTPx34P66aCtFaiiiW/Y=;
        b=WDlDUxF4DqR66L5hTrjxbIcNdkyuFlaMDFbQg+dZQOZNiL9rli5n6aBLu8x8ORpZye
         S+KBJIuuh6Nl5I/hnrLHr2fprO9HiONShNHshdnjhA6ANXZIMcx88I86cmiMROKgajVZ
         4h4eKJqXgl+HRIu6LZsr5GvQAa+pkiY+NbvlYaWV2KJs9VeIO3sUEED+LueV37y4P/Mv
         lbfpDNmLDStz8eUCaeOkgqxwFjwUuI+grteW1sNpaNtPdMUuUYIC6XB4Qg0LdLmqw7/n
         jOqIVxPNJnkVtUQTH6+IcunSP3yx0EpLogWTxb98tT4jsDJf5YNvo5+I+Ys1ojmB/eCa
         8KTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MZysaavM6RaxfqjWf6Ljab3pTPx34P66aCtFaiiiW/Y=;
        b=GHAw3viYLgtySwZzZbNqW65HqTgTYmDaZgEdpIjVoOxhpPNTS3Dw6y30TIxuBdYujh
         bzHSQp6MdevCsQ+LPl6TznhyzIwvDK0WFEndXKJSvIMCBzZDsXfwkDwICFB2Pcj3JVGZ
         DHEm2CF/k/yF7ZN/oaNHb+rsMCRfZAImkReFSMz6x7hbM/Hq01g10ie2siA/GFyfC7Bh
         2a3vlc848/h7Z6xq7TykXUR24MINGrjIAdYMm3PmilnX0TaejNGBbM/Jz006Ym6lUEFD
         dbvtH0xcukPAVHxccJSdLZjgDHmB9f0SQRS2aOUnpHUtLex4E1dfMpjdV11+wKP+B+iJ
         J0vw==
X-Gm-Message-State: AOAM532yfD2OiBGiJAjufYcoh3uffPqMQXv691SCGoi35yw2Bq1lHi3U
        rCa9VU4h7qod2hjXiZ2FgT2K0naIEljlnMgPKFEfBMaZf+0=
X-Google-Smtp-Source: ABdhPJzqU5OTgpS0uOI3nms7/6HfolBtBUjzooFH82UffTEDoM5+T2FDnkqdXGL1kjah6lsFjkUQp78kPgIomnhh2sU=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr24882365pjn.215.1614022340104;
 Mon, 22 Feb 2021 11:32:20 -0800 (PST)
MIME-Version: 1.0
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-6-xiyou.wangcong@gmail.com> <87czws477x.fsf@cloudflare.com>
In-Reply-To: <87czws477x.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 11:32:09 -0800
Message-ID: <CAM_iQpWMa61VhVk00cAwKFZ3KNUv6o8kvniNYT3EKWkNQxnExQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 5/8] sock_map: rename skb_parser and skb_verdict
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 4:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> skb_parser also appears in:
>
> tools/testing/selftests/bpf/test_sockmap.c:int txmsg_omit_skb_parser;
> tools/testing/selftests/bpf/test_sockmap.c:     {"txmsg_omit_skb_parser", no_argument,      &txmsg_omit_skb_parser, 1},
> tools/testing/selftests/bpf/test_sockmap.c:     txmsg_omit_skb_parser = 0;
> tools/testing/selftests/bpf/test_sockmap.c:     if (!txmsg_omit_skb_parser) {
> tools/testing/selftests/bpf/test_sockmap.c:             if (!txmsg_omit_skb_parser) {
> tools/testing/selftests/bpf/test_sockmap.c:     /* Tests that omit skb_parser */
> tools/testing/selftests/bpf/test_sockmap.c:     txmsg_omit_skb_parser = 1;
> tools/testing/selftests/bpf/test_sockmap.c:     txmsg_omit_skb_parser = 0;

These are harmless, because they are internal variables of a self test.
So, I prefer to just leave them as they are.

Thanks.
