Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4CB128ED6
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 17:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfLVQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 11:21:37 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37813 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfLVQVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 11:21:37 -0500
Received: by mail-yb1-f195.google.com with SMTP id x14so6189258ybr.4
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 08:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jyzVxWoX+3Ke9jGR/14mXaKnQKHb/SS+/i5zxUgwA8=;
        b=SMH2OaNFJt5fndF1gWEg74m0iSyBalwux8eQ+DxGZgiOettxulaxfUJSCWy6Psu4gd
         0KnYgRpbMVRDB9YqWn+VMP7xLl4scnSc6GiZZLq2OvWDqaEGoe3QQ9pz7o2mW3JP5uA1
         cEh7frmQLt5pzA1J44Zv7YKB7wpQwxlgRNtkGTD30ovb4DOJGBSjFm6EIB4J6YDR9ruz
         UudtVSB4sRZ7lCTQ745/bYd7loYS93uALB2F9KlCiJzq/U+OT9hqifP/6XqQF3nB6Xfa
         e9fDIbPxp1glUu4wMcW4bbqeehci+wBTMhzYS8lijxzTrlxaiUN8n4/4zdFbNw3ucc+R
         8aZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jyzVxWoX+3Ke9jGR/14mXaKnQKHb/SS+/i5zxUgwA8=;
        b=SCaSOv5ISCqMPnqMcAf/i6FS1s11h4zUwHqYPq4/hlHq4YSoBUbD3cGA0jZRx0mJyM
         5FE4GuRhSQOtHmTIgFPZpYnJ9MM8JNzBwGoJVyzvJHK+PjthvOkcRjQJ+UUNub2c69Wc
         TCprHWUGKz0+Ziia4VojYvIkrzZk+sQtUy9H+OpmMxYPRHaHlPMq4VcwTip+1zLzwN15
         TEmypYo9yyugBbSl6cqY4/fXQrEEZ78NZduQyvXo3nNKAMDhU75p+qtdUV8F6rkGyCKd
         aOfVJa1fdBM+VJpaGvgqkQoPtIBRk+bbEXdpQDFu4Y1rDIBki3EMoY64Z2diVZk38Cyh
         rYPQ==
X-Gm-Message-State: APjAAAUWxL9L2AeeI2pmoPCF6pxNlAOpvFV/F1CMseKwB3fZfdf+i1RF
        cvReVdyWiT+LUn0oJwq5Lkrk+S9O
X-Google-Smtp-Source: APXvYqwkte00rCqfTUBl600tRUAyHRmySjDkNYGw6w+W8pUGYfpEwQjcs+pPROeqourijKV4+nZX+w==
X-Received: by 2002:a25:747:: with SMTP id 68mr19245181ybh.402.1577031696190;
        Sun, 22 Dec 2019 08:21:36 -0800 (PST)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id 205sm6734147ywm.17.2019.12.22.08.21.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 08:21:35 -0800 (PST)
Received: by mail-yw1-f46.google.com with SMTP id l22so6224263ywc.8
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 08:21:34 -0800 (PST)
X-Received: by 2002:a81:a50f:: with SMTP id u15mr17885454ywg.424.1577031693989;
 Sun, 22 Dec 2019 08:21:33 -0800 (PST)
MIME-Version: 1.0
References: <1576885124-14576-1-git-send-email-tom@herbertland.com> <1576885124-14576-2-git-send-email-tom@herbertland.com>
In-Reply-To: <1576885124-14576-2-git-send-email-tom@herbertland.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Dec 2019 11:20:57 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
Message-ID: <CA+FuTSfSFtSZjstCCp4ZdwPMCiHXaskgTqQH0EJYzV4-08t2Eg@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 1/9] ipeh: Fix destopts and hopopts counters
 on drop
To:     Tom Herbert <tom@herbertland.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        simon.horman@netronome.com, Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 6:39 PM Tom Herbert <tom@herbertland.com> wrote:
>
> From: Tom Herbert <tom@quantonium.net>
>
> For destopts, bump IPSTATS_MIB_INHDRERRORS when limit of length
> of extension header is exceeded.
>
> For hop-by-hop options, bump IPSTATS_MIB_INHDRERRORS in same
> situations as for when destopts are dropped.
>
> Signed-off-by: Tom Herbert <tom@herbertland.com>
> ---
>  net/ipv6/exthdrs.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index ab5add0..f605e4e 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -288,9 +288,9 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
>         if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
>             !pskb_may_pull(skb, (skb_transport_offset(skb) +
>                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
> +fail_and_free:
>                 __IP6_INC_STATS(dev_net(dst->dev), idev,
>                                 IPSTATS_MIB_INHDRERRORS);
> -fail_and_free:
>                 kfree_skb(skb);
>                 return -1;
>         }
> @@ -820,8 +820,10 @@ static const struct tlvtype_proc tlvprochopopt_lst[] = {
>
>  int ipv6_parse_hopopts(struct sk_buff *skb)
>  {
> +       struct inet6_dev *idev = __in6_dev_get(skb->dev);
>         struct inet6_skb_parm *opt = IP6CB(skb);
>         struct net *net = dev_net(skb->dev);
> +       struct dst_entry *dst = skb_dst(skb);
>         int extlen;
>
>         /*
> @@ -834,6 +836,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
>             !pskb_may_pull(skb, (sizeof(struct ipv6hdr) +
>                                  ((skb_transport_header(skb)[1] + 1) << 3)))) {
>  fail_and_free:
> +               __IP6_INC_STATS(dev_net(dst->dev), idev,
> +                               IPSTATS_MIB_INHDRERRORS);

ip6_rcv_core, the only caller of ipv6_parse_hopopts, checks
skb_valid_dst(skb) before deref. Does this need the same?
