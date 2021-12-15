Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3A475BF4
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbhLOPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbhLOPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:38:54 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48840C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:54 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so25381864otu.10
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R/OSQAVM8VD2Gy20ABTeFXuWH5lD5SyBla6mXJoXGkk=;
        b=LrNUVjFwDPAribkbWuWK6N94pN+7CyiBpcA3vooQn/QzLygpISDBs8jyIJcITbfOoK
         reSDDQsDdfPElL+jvqawprJNSRAQS8LxvQb9/lCM78mRccSdcTQhsy96f9L69sjSE3jQ
         L2yCg+YJd2qRg0EEzG9v+HCdx3h1JpoDYnLKd0JAZxOoZOYxv0ZR9L5Jeig+TgWIgBSz
         Q2DW0mo87RJq/c2gMZAOrrqcQQjspaTSIy3kQnaJepIb7/M7MwLoxwpUrzkox+DAvJAE
         zxfokvCmhFtR9z/vMhtEKUnIjfhD8d+3JSYbg5wQn2zhDkH4HZLQydYxhsHHRzlP0lnp
         FAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R/OSQAVM8VD2Gy20ABTeFXuWH5lD5SyBla6mXJoXGkk=;
        b=gmpJXYw2FJ6EchGbY8FjA9z76N7Y2IO9Y6eTR8jVsKjpsNjR8HlpkG76YxO/5bLoy2
         x1T1wg9yAi9jUgRM5+EpVDJFEJOOxDdoG4coVhVFcDHt7w4jOgtKRiTzoweyOYht/zfN
         7esEB67qP9jutDopwPO4Lq6Sm3QByrgbFvDRrK57/6RGoxxQdjAoGJkKlzkMP52qprzQ
         u/YErMBcYf638pwdIDlCCl8HQVQTROS97/ALGOinwXNRW4sLTaV/gGcSpsLnlagnRBMn
         nzvPF3N76myZDX8kyzWvh6Qtpo9qpSlgmdpoEJAl+XooHyWis1fTxXUUaSNSKHQwxZH0
         T2Tw==
X-Gm-Message-State: AOAM531EvHNjEUtlhCjCcqaJNjCPIaU2oPZKVnCVpgETYjXPhMvCXblF
        /nDcdzRNX/HkAjN/XWAnTus=
X-Google-Smtp-Source: ABdhPJxxo++0gb1q3AcYh670Y5IJqAKXsdMHrOR5iWwi/iZr8lBlvSL5Q4w7DbyTSWQw0JNM5ZBRBg==
X-Received: by 2002:a05:6830:4195:: with SMTP id r21mr9092634otu.33.1639582733727;
        Wed, 15 Dec 2021 07:38:53 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id t13sm403641oiw.30.2021.12.15.07.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 07:38:53 -0800 (PST)
Message-ID: <a29fe36c-419a-330a-50d2-cf7dc3285bfc@gmail.com>
Date:   Wed, 15 Dec 2021 08:38:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 net-next 2/2] fib: expand fib_rule_policy
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
References: <20211215113242.8224-1-fw@strlen.de>
 <20211215113242.8224-3-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211215113242.8224-3-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 4:32 AM, Florian Westphal wrote:
> Now that there is only one fib nla_policy there is no need to
> keep the macro around.  Place it where its used.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  resend without changes.
> 
>  include/net/fib_rules.h | 20 --------------------
>  net/core/fib_rules.c    | 18 +++++++++++++++++-
>  2 files changed, 17 insertions(+), 21 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


