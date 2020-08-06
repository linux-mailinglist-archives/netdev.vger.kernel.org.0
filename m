Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2323E143
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgHFSm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgHFSWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:22:52 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9559C061756
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 11:22:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id a6so6620921pjd.1
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 11:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eZGw4D0hFAb3nEJ/BxXu4ur7Q7JmFu4sgP7DPLUaQCk=;
        b=Seomrp3G9pyZOfFPTaf3c0hryPLPKNktWbwPc7/XzFqO4Ig83A0Hbg4KzVZihOLtbZ
         0uAlVSAhkEyAPBIcTl2vJoziIH1i5rGKotUov4MgTVsoppdOV5tcpRGlrM218eBHpF8q
         LwXgdcFzuyf2m+vumEMsJRygBzT9w53SGgq4XUJL4y83yqLivrKAZ/3BQ+6uBm9AdHu7
         Jad78mxBaAjslErtp/Pe+hOXUYk+aQ45weABCiZr6w+JMG4VTm+poz4mlenU2KZgvBUC
         e0bTN0m+U+6iFFS9n3j71l5+ww/daNROUYp7iQ+HkHwbT3JRAXlkbg6Ptqds5B5rMVO/
         EE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eZGw4D0hFAb3nEJ/BxXu4ur7Q7JmFu4sgP7DPLUaQCk=;
        b=faT0h7qoi7I7flMWh4zHtv6KaiuVzBsnS2MPh/KObmYcRCqgVDB6C0Cco6BdSX3tDO
         v2ziNR1OLbVwaDt0noIABzTY/TnUMyRKqy+PkkmPMYJRIGSJPdSh7hd8j81Th/xrj/mV
         tPsQxN59Kuls21ZI/uQ+f48iyfczciovI9DhpxsNBMbeuUYiZ0rXWJ+yltMKhW/a5c/x
         3/CRQcPQHpr3KL0ZEX3JFJIda/93kRqpPUY0Q8494xvNKcVwhnl0/CrK3vrFtmGNOgcl
         NT6h+IhHANMs5dSvwaIY7EigmNaHY8BN3EjCbLWDHQGu21J8EZS0mbEYQE96Lauhlu/m
         RLpw==
X-Gm-Message-State: AOAM532G9eg7ICNP9XlUMR930aVrSVYOGRC384lG7bK4FEgO4ftc7EVM
        q7J4QPEElWqUJnKl/N0CEyyRtXVaEiRAEWMVZf125siI1jnXYWxnXNNgaVaWcPf8nn4r49mu7W6
        apPg9RUyEodKKSuHJj1ZqPbKvAjYPEvO9Y9FgVEzwI90bdr3TB6L1bA==
X-Google-Smtp-Source: ABdhPJzjYl3T67ANMsiVXYbzueltnnaExCsuaDVgnrJUvxLnfoaP562t4Cjb8+NmROC3jGusa63+2Zs=
X-Received: by 2002:a17:90a:f014:: with SMTP id bt20mr1601886pjb.0.1596738131438;
 Thu, 06 Aug 2020 11:22:11 -0700 (PDT)
Date:   Thu, 6 Aug 2020 11:22:09 -0700
In-Reply-To: <20200806155225.637202-1-sdf@google.com>
Message-Id: <20200806182209.GG184844@google.com>
Mime-Version: 1.0
References: <20200806155225.637202-1-sdf@google.com>
Subject: Re: [PATCH bpf] bpf: add missing return to resolve_btfids
From:   sdf@google.com
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/06, Stanislav Fomichev wrote:
> int sets_patch(struct object *obj) doesn't have a 'return 0' at the end.

> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   tools/bpf/resolve_btfids/main.c | 1 +
>   1 file changed, 1 insertion(+)

> diff --git a/tools/bpf/resolve_btfids/main.c  
> b/tools/bpf/resolve_btfids/main.c
> index 52d883325a23..4d9ecb975862 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -566,6 +566,7 @@ static int sets_patch(struct object *obj)

>   		next = rb_next(next);
>   	}
> +	return 0;
>   }

>   static int symbols_patch(struct object *obj)
> --
> 2.28.0.236.gb10cc79966-goog

Sorry, forgot:

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in  
ELF object")
