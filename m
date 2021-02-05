Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25173116D2
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 00:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhBEXPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 18:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhBEKdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:33:52 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3317EC061786
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:32:56 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id c18so7118679ljd.9
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 02:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ucNiF/54fSEIyQRLlbhggIgy6UPMZeD+dP03iaABumU=;
        b=pe+m9KuPdcUIwfCDmdAy+6xleoNQd1Q4OMhbMAt6eCWzCBqs13MD9qYXTr9rpvdAvy
         7exO/AN0V92WbLsZeE+GPU2v3xaCCD4UEcpRnvbTjHG6YA+TdSRjEwbeMQp/RnKrNMio
         eT1kXwqkmGoXYPNmPu6+EkF+cWqBrghc+KtBY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ucNiF/54fSEIyQRLlbhggIgy6UPMZeD+dP03iaABumU=;
        b=H5L/DefY0RuiBYHcsAi+EnWL2eD74UexuBp6uaR0RCncEpO+Zjk6VyCAuuf0oVwAL6
         CPq1s4dofMXOOejV9wEyx9wmL5SELdmmcFz8sRxMZRz7s6+/Tlama/WUzDCc2rPvCS+m
         LimPOugbDgCmXElxmFu3pN4AEjhbkzXcHv0U3xiRh2Fwooj6g2WJwM6Xy1JJPLe8l6o3
         ekPGyiZPia8VRPtHaKRQv0cAfZNFSqfu9O6Ci4dCt30IKQYRELcWYfEGeFbjPMLaXGY0
         5sgSiqDMpQBM85Y2wAF7UvBKSJvbyhuMdNfuFZF3J0hPF7J+p7kmbp9qeXByT9XM9hk6
         YYXA==
X-Gm-Message-State: AOAM531vx+9gQ3z9nYXZ34WT9HsWnXdUCdgTYLEp27tgY9Kltz9n1BK4
        7XCAcvAvzprWZu5V9sv+caqMng==
X-Google-Smtp-Source: ABdhPJy0WU5rdenLuLUxfigpO8VvBzC3NkI8ylmrVI6rRPSZjjvg+R8Ssjtw2Tw37rH7CM8+fU+JEQ==
X-Received: by 2002:a2e:9b52:: with SMTP id o18mr2246558ljj.173.1612521174696;
        Fri, 05 Feb 2021 02:32:54 -0800 (PST)
Received: from cloudflare.com (83.24.202.200.ipv4.supernova.orange.pl. [83.24.202.200])
        by smtp.gmail.com with ESMTPSA id r16sm945426lfr.223.2021.02.05.02.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 02:32:53 -0800 (PST)
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-2-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to
 BPF_SOCK_MAP
In-reply-to: <20210203041636.38555-2-xiyou.wangcong@gmail.com>
Date:   Fri, 05 Feb 2021 11:32:52 +0100
Message-ID: <87im764xez.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Before we add non-TCP support, it is necessary to rename
> BPF_STREAM_PARSER as it will be no longer specific to TCP,
> and it does not have to be a parser either.
>
> This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
> that sock_map.c hopefully would be protocol-independent.
>
> Also, improve its Kconfig description to avoid confusion.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/bpf.h       |  4 ++--
>  include/linux/bpf_types.h |  2 +-
>  include/net/tcp.h         |  4 ++--
>  include/net/udp.h         |  4 ++--
>  net/Kconfig               | 13 ++++++-------
>  net/core/Makefile         |  2 +-
>  net/ipv4/Makefile         |  2 +-
>  net/ipv4/tcp_bpf.c        |  4 ++--
>  8 files changed, 17 insertions(+), 18 deletions(-)

We also have a couple of references to CONFIG_BPF_STREAM_PARSER in
tools/tests:

$ git grep -i bpf_stream_parser
...
tools/bpf/bpftool/feature.c:            { "CONFIG_BPF_STREAM_PARSER", },
tools/testing/selftests/bpf/config:CONFIG_BPF_STREAM_PARSER=y

[...]
