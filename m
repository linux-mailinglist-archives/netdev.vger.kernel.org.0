Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A152747B4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgIVRsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVRsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 13:48:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B57C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:48:35 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id v123so19908656qkd.9
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 10:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2aImMSnGp0pJrdFWOz26We7RBiEPBSUZx13H022GgJk=;
        b=DxOBv3qoM3preiXZlTrA23F8KS/0dfsZzcwtKNzDnEDOfmu2QbYS9fb2M4dVe+VwJN
         eIi4bm6z1Q32I9kCk6IouFlOV6onOMKllOQ4xmp6NiF+QMUj1sChrZFO2O13GJ2ZUGZj
         1JttwgsLZ1FXynVclf1OMeyExGb50MUINaiA5aKtI4sWnJbh2+wsqAl9bnwjXGVcvDUV
         ZOTMuTI6Yz8GZFtDOZi1keZ+JwijruT2uSo0W5y2QvNAG8IfmQ8oct/epenRAdJzn2ns
         x5Cl10PYLDejc/HxDf2bwmtIfiHALn0xBI7OfA2k69P9X8IqH7Sy5GNgQbZQcJLGjdOn
         vBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2aImMSnGp0pJrdFWOz26We7RBiEPBSUZx13H022GgJk=;
        b=LDMNd5C7N+YvBtzoT6XiWHI1bVfBueOJAmTb1AkQJAUxe9ZTue6Cn8zzDAnlA4Y1BB
         /al2M8bFuiKEoyYnDf7E1X8lHp8mMKj9+cuV1XZDe6oadbMG5nHI4F5PpoSoMdlxHJvl
         xb24NLRBtIB0aw6G8TUgStWkggfkXuxvoaOWHXy4qPXq/18zEWZKVH0EdqkQ9n0DF07o
         IMu2gusMFGwwgFpoUHGG5uHocp8N6r404u6XVvPgMJrYp5JyPuTK4ZBGQkZipUHHMwz+
         MlmjRpbsvv5NNufBhafRqr5a8bF2SKQ2snSTJEN4/+lzZnPrZZYZ4UTLbLDbU87O/lpd
         b2CQ==
X-Gm-Message-State: AOAM531jE41lmTyaBghKH65JIit3C0NRtYa8bqFSB1scrxTTTAMUZ653
        fXI+TNf23S3TFA55Iieq8aZXzq1gtzzXWbo5ge09Eg==
X-Google-Smtp-Source: ABdhPJxdVOTXA8JKluaF1GCiDQFNU/3UjvH0jLxyMa1niL5vqM7Q7sVsd4OQRFjZYcKclYl4XQXSEmIvjvQaWKMPjy8=
X-Received: by 2002:a05:620a:2450:: with SMTP id h16mr6200692qkn.326.1600796914399;
 Tue, 22 Sep 2020 10:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600773619.git.mchehab+huawei@kernel.org> <dbe62eb5e9dda5a5ee145f866a24c4cfddbd754f.1600773619.git.mchehab+huawei@kernel.org>
In-Reply-To: <dbe62eb5e9dda5a5ee145f866a24c4cfddbd754f.1600773619.git.mchehab+huawei@kernel.org>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 22 Sep 2020 10:48:23 -0700
Message-ID: <CA+HUmGhDWTKfg9BKpwKpr5j=JATaWka54rh8chAnmyaOR+HAsA@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: fix a new kernel-doc warning at dev.c
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 4:22 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> kernel-doc expects the function prototype to be just after
> the kernel-doc markup, as otherwise it will get it all wrong:
>
>         ./net/core/dev.c:10036: warning: Excess function parameter 'dev' description in 'WAIT_REFS_MIN_MSECS'
>
> Fixes: 0e4be9e57e8c ("net: use exponential backoff in netdev_wait_allrefs")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  net/core/dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index a268ff35ad38..873b50ac9668 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10021,6 +10021,8 @@ int netdev_refcnt_read(const struct net_device *dev)
>  }
>  EXPORT_SYMBOL(netdev_refcnt_read);
>
> +#define WAIT_REFS_MIN_MSECS 1
> +#define WAIT_REFS_MAX_MSECS 250
>  /**
>   * netdev_wait_allrefs - wait until all references are gone.
>   * @dev: target net_device
> @@ -10033,8 +10035,6 @@ EXPORT_SYMBOL(netdev_refcnt_read);
>   * We can get stuck here if buggy protocols don't correctly
>   * call dev_put.
>   */
> -#define WAIT_REFS_MIN_MSECS 1
> -#define WAIT_REFS_MAX_MSECS 250
>  static void netdev_wait_allrefs(struct net_device *dev)
>  {
>         unsigned long rebroadcast_time, warning_time;
> --
> 2.26.2
>
