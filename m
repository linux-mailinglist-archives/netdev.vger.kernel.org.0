Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8807F180D59
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgCKBOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:14:14 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33815 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgCKBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:14:13 -0400
Received: by mail-yw1-f67.google.com with SMTP id o186so518233ywc.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 18:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X9RdD7dG4OSnH/ITM7CpyzLcUBxqAje79nHZ8XeIV6g=;
        b=FY7/W01wzvgaIOdYQmMKo/yPAcX5tUr8fyE9PXSm5dg0lBfJjqqut+QRmbH6fe8sDo
         aCsNgyAJXvIs87SGiKHBGxPe0yoCGIjRZ9Z12r5bTKc+q2KRl6a/g3QW3TGXh48i8JBH
         VFdU1bEVxp5m4XEXuxBNsaem5cxDyuVEzaxpJ/F00Q/3fbqOEIRtuuk0Kh5Gevldzk3Y
         a04u9tzfasIpXemR3KyUivgq8HCj4lF9GQkPCCTrh4TpSEPkWBUoOQ96UtqGCU81SJOS
         p3bzk+ugjtyM0uaaWFkwForh3BEqmXWA42Z086x6RTMO1ChvbkKWSXcRGT+K5gw3ZGHR
         Y4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X9RdD7dG4OSnH/ITM7CpyzLcUBxqAje79nHZ8XeIV6g=;
        b=Lz6L4fSGOfp3Fhg+r5BrlGOWJTrZrLbLrMsp8gvM3UT3LG/cvbtJlXXaucPgpqQ/Bo
         YCbZ1QIqh7tFQKeC6HTqH7yvi/+lGdoBV0zUARY+0riU79I85TnXbVQ9jqq+8Rr+ZOn6
         hz4oQplXtgXnzv6ofhoV5B7fOhl5RJuUpyL+zemRGt2PHVmx58jY9QNxoV8+4gi27lWd
         PEyYfIQDzF5pEITQ1Po3NAEvcAACrv2+pFijDZ0jcBkm6QZUi8Q8mni4QbdgOFkD0h+e
         eYrUhSP81Yzs5anM14e+nPZaXYY41aXp9kW0qvMYe7t6Ivbz/PeArsPMAH3fnT7FfC1i
         vdww==
X-Gm-Message-State: ANhLgQ1DGb4DGpeDZtlMc1fSUdxaAy72ofyFI+wt2TExElBwu3oe/cda
        eWlSHuW9X7FhljgkYX3ccUqBpwNqoOlx8hl0Bcx2Tg==
X-Google-Smtp-Source: ADFU+vvorRI9Lt+4KrjNb6NV3EAfKk8c6LXgbMK5EVVCsuMdZYDpBAx98uZ8ZL0CtLeEszNLo+LdzSzOGYj+SmY7B34=
X-Received: by 2002:a25:2688:: with SMTP id m130mr524689ybm.408.1583889251315;
 Tue, 10 Mar 2020 18:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200311010908.42366-1-jbi.octave@gmail.com> <20200311010908.42366-4-jbi.octave@gmail.com>
In-Reply-To: <20200311010908.42366-4-jbi.octave@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Mar 2020 18:14:00 -0700
Message-ID: <CANn89iJc9e5fQEWerHgDM1g2vp_1EEj0EntbCvccCzAyusHtdg@mail.gmail.com>
Subject: Re: [PATCH 3/8] tcp: Add missing annotation for tcp_child_process()
To:     Jules Irenge <jbi.octave@gmail.com>
Cc:     boqun.feng@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 6:09 PM Jules Irenge <jbi.octave@gmail.com> wrote:
>
> Sparse reports warning at tcp_child_process()
> warning: context imbalance in tcp_child_process() - unexpected unlock
> The root cause is the missing annotation at tcp_child_process()
>
> Add the missing __releases(&((child)->sk_lock.slock)) annotation
>
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> ---
>  net/ipv4/tcp_minisocks.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index ad3b56d9fa71..0e8a5b6e477c 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -817,6 +817,7 @@ EXPORT_SYMBOL(tcp_check_req);
>
>  int tcp_child_process(struct sock *parent, struct sock *child,
>                       struct sk_buff *skb)
> +       __releases(&((child)->sk_lock.slock))
>  {
>         int ret = 0;
>         int state = child->sk_state;


Yeah, although we prefer to use lockdep these days ;)

Reviewed-by: Eric Dumazet <edumazet@google.com>
