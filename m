Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239BA18BE47
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgCSRim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:38:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37511 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgCSRil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:38:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id d12so114540qtj.4;
        Thu, 19 Mar 2020 10:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPbGgs4Rz2rmlkEGYcxAMjdsYAQ4dAfXfNpPuXXsgYU=;
        b=QreGGVLWyJYHh1IFERLJOEvXAy98RixUjHEQKXn5F5+8e7H9hnbWpFmUVdguLCUY2T
         V4qKC8tmI2glfuWKvVNdgba1uiISdjRZ/r/6NQp1wZOSyfdmJpNVBkkLSmAItLb6E3ur
         3hZB6IbL3Jt/0MMTTEZnzAwpsoa0yJ+jybm2JqJvb8W/FBPCAEbOmkwavuUHDgY6RN0Y
         yJOutyqjFWb8uiZXn7DdKQV0xV8fi1W8FY1Z7wXzOLbStS4ZhpWqSW8rCMzpjWivMKps
         09qc39s7ByX4vF/P4tQuPZHJ6kPIs4c1SCRL8qO1sdL5TM0usqaCCFuIYfhMRRVc74+D
         D5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPbGgs4Rz2rmlkEGYcxAMjdsYAQ4dAfXfNpPuXXsgYU=;
        b=aQs5h9qK1OaXgXxmjPE7WjkLNiVzAOvOJnEmktARzZgjxQTStVJNwOYT5F6vUedawk
         KB49SK2UTmve4MEIe6d1bor1zqVtdDGHWGmyP2oIRE+p8ei2mFVi1Bm5V6r6slATDZ+3
         fqO1t3FrklaIiZk+OTUuWHVS182vyuxx2GZkJ2G+pkwtA0cmqMFxldNcQ/d29WEYcncL
         PSAzJ8j9axjLWQ20Xr9L7TUwJOARlIzvmfBbpgioOonA+iRNoqEwcKz59C/0jHgAR/UW
         pMYq51vd6cYafoerq5lxzCZ9LoOdVkaixDwpMJSOG/HoM5CB+xxfcd1LMUYWav9fcv0A
         2pqw==
X-Gm-Message-State: ANhLgQ0EsIpMqXqJFLwUEfXEQMAfmNM5Xt27jERH0+limAKoXpU8NryL
        F+L26I6/POKD9TEMrEojYgQ8Cp8L0fTAGQ35RPg=
X-Google-Smtp-Source: ADFU+vuvyXkeruxCSr9kM6D2FDoaXom6uXzfhzHnUGEBohTdbUr3hhmsS8s+HR3XOWBKS3xhb5fXb3kaGdEkbq92mbg=
X-Received: by 2002:ac8:7448:: with SMTP id h8mr4101625qtr.117.1584639520560;
 Thu, 19 Mar 2020 10:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200319124631.58432-1-yuehaibing@huawei.com> <87fte4xot3.fsf@cloudflare.com>
In-Reply-To: <87fte4xot3.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Mar 2020 10:38:29 -0700
Message-ID: <CAEf4BzYbrXW-eYpKmr07Xba_wZkuws-7fChGw17u1nFLLmu2Zw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: tcp: Fix unused function warnings
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 10:00 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Mar 19, 2020 at 01:46 PM CET, YueHaibing wrote:
> > If BPF_STREAM_PARSER is not set, gcc warns:
> >
> > net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
> > net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
> > net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
> >
> > Moves the unused functions into the #ifdef
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
>
> In addition to this fix, looks like tcp_bpf_recvmsg can be static and
> also conditional on CONFIG_BPF_STREAM_PARSER.
>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Fixes tag is missing as well?
