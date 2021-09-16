Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4498140DED4
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhIPQAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 12:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbhIPQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 12:00:44 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6424C061574;
        Thu, 16 Sep 2021 08:59:23 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id r26so9700517oij.2;
        Thu, 16 Sep 2021 08:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zfRiOmblNlYEJVb2A4IXa0n4chJWwdIG0Ry3RYirmas=;
        b=Z8TcOFH8+jsKjyorX1zRbIbtVMQDN9W8CN3d72SAkXmuM9O2Nj8sExxt0lxuciJkRI
         X5ReL+BNKdQzwb51hrsQKbAbvbksfVLWbgKkNPSWYeTnw2pJQXXWVsXqaCS/nZg+LLvA
         lao5fMfxaXdtU0kxnvI6vqPX84VhzGzg3vyLgajYNUnD8ZtX43USJTbkqQ/KdddejM6h
         cdG4yJON2atRQ7eyCKofFOjl0G7TJ6wbaq+RRcSGXO3En5xrzLR/7KiDaIssUisv9VSp
         ZC29cZjf04SzjbGC7TfJM+W9ALMySzW3VGwP6m4E4lo2PiUNACqRLvTnyk8tzpuimQrD
         uNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=zfRiOmblNlYEJVb2A4IXa0n4chJWwdIG0Ry3RYirmas=;
        b=U8SuYkmZlcyf1xzcN57DWnRkhJBzjHT5HOrQEPtwzKweLtvuR4RauNOgjyjObaQIhb
         3wRrxn3CkRwilCQ4+FPIse33h/tInfZEEjknIm1/F/v4s8/qbGE3DLIlNDRCKdZ/5PJN
         QBiL1ihoY52Kqr5wgoywGU6G+3OH19FZFICgFAW5ZBO5AqUatHTPy9ExfkuwnvEFwj7W
         S7xs7anY6nQikdpGR7xIz277Rs80vPyUa1gxNvEwUSMGs6veaRQW8k/bmGpDU3Sp9KdK
         HvOdTDfBT1+/cCxS+qJclTpb0Bai0PxclaHbYQe6E/K8GObViLYOqc6C2yygfmlb5wa6
         Iblw==
X-Gm-Message-State: AOAM530vn8G7/TvzzEZUjknglkfB3FPKJkxvGS5y6BHxk46yMeLZTO82
        kNXTMs6t1jWhUDAvGPaEvvEroimiBp1T9Rt7U/qGzoLB
X-Google-Smtp-Source: ABdhPJw9UcNcXehzFHCHHEjf5+51jtB/jzfWStW3qqGBXxSjjthxkLBoooDPFw4yHMgQN/d/fVm/mpZXlMsqFU05eT8=
X-Received: by 2002:a05:6808:1787:: with SMTP id bg7mr9918512oib.39.1631807963209;
 Thu, 16 Sep 2021 08:59:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:609e:0:0:0:0:0 with HTTP; Thu, 16 Sep 2021 08:59:22
 -0700 (PDT)
In-Reply-To: <20210916122443.GD20414@breakpoint.cc>
References: <20210811084908.14744-10-pablo@netfilter.org> <20210915095116.14686-1-youling257@gmail.com>
 <20210915095650.GG25110@breakpoint.cc> <CAOzgRdb_Agb=vNcAc=TDjyB_vSjB8Jua_TPtWYcXZF0G3+pRAg@mail.gmail.com>
 <20210915143415.GA20414@breakpoint.cc> <CAOzgRdZKjg8iEdjEYQ07ENBvwtFPAqzESqrKJEppcNTBVw-RyQ@mail.gmail.com>
 <20210916122443.GD20414@breakpoint.cc>
From:   youling 257 <youling257@gmail.com>
Date:   Thu, 16 Sep 2021 23:59:22 +0800
Message-ID: <CAOzgRdbGuuvBdJRzGA_gLE3jxgey83xv6RT_rX+bDysDv3pt8Q@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register tables
 by default
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test this patch can fix kernel panic.

2021-09-16 20:24 GMT+08:00, Florian Westphal <fw@strlen.de>:
> youling 257 <youling257@gmail.com> wrote:
>> kernel 5.15rc1.
>
> Thanks, this is due to a leftover __init annotation.
> This patch should fix the bug:
>
> diff --git a/net/ipv4/netfilter/iptable_raw.c
> b/net/ipv4/netfilter/iptable_raw.c
> --- a/net/ipv4/netfilter/iptable_raw.c
> +++ b/net/ipv4/netfilter/iptable_raw.c
> @@ -42,7 +42,7 @@ iptable_raw_hook(void *priv, struct sk_buff *skb,
>
>  static struct nf_hook_ops *rawtable_ops __read_mostly;
>
> -static int __net_init iptable_raw_table_init(struct net *net)
> +static int iptable_raw_table_init(struct net *net)
>  {
>  	struct ipt_replace *repl;
>  	const struct xt_table *table = &packet_raw;
>
