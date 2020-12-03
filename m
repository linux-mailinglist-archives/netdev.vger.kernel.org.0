Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59772CCD76
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbgLCDvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLCDvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:51:02 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AEEC061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 19:50:16 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id p15so188845oop.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=98JTO5O5OZlhsZlss8Ob6ucLjdMdqlPcAQY49MtPx/w=;
        b=dHYJME5Ir8gXGkzEFA5p7BceDT+e27kQk9rKGUw5pVnrpRd7n/rT6pzYSjvwwos0Qu
         iq9Lw9LOTqXOQivEIJUzY/OSpnnT3ysHU7C+d+92YKFOhIT2j5X/Ae3G3wAOpaqHFFBo
         aSAFOj7jZtJUXH3xzA8HoDn2o4EXlceDUMKpFSir5lVqiVOQW/giEj/tSNXbQeVMKt9T
         ozKFtOxDGXfanR4w0K7kEG75YiBxrI5+YKvEnWBBks1qVsxGl6r4mk6oB8BnLTQBaz2D
         AYfq/ehSDhtvBuW/dhpLCTsjS6j/b4A/KE3pQqTuH4zQEmLRh/9VLGztJ37mSZONQ1Ho
         S0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=98JTO5O5OZlhsZlss8Ob6ucLjdMdqlPcAQY49MtPx/w=;
        b=srK0PuyOiAkGhU+cz2CCYqe57C/tRUvbQ3zFlRYiwKdgvVIpWxK4kTi3ELck5N8wMv
         8Tit2ANuZnxgorq8Im/LhpG/0SYjdQszqxoOW2zmOH0eyyH+j+olQqo3adNzP/qBwmQ4
         tqwtAqS65fhEnPmRqKQsLKjrASNE7xKGX+Nv9d6uL6u0PqONyIdMFrgqJqitrDlF/SA/
         H6JtORk6rgIOlUakdwwOzo5pEwvoVTgLGXkVt7ROjP+LvmWHjTJLiGGbuXvZ0zA/A8Ni
         jvZidV+YBrbXamFZKS097g7ToBdBvPvJT0guuH4946fE8Nqc72iMVKfnLQwcM+fPh88/
         YxCw==
X-Gm-Message-State: AOAM531Z//++I25xQaMwgXnaH98UrtSoTFeAjyo2cmTE/Pl5KkLEu7s1
        MYzUtRowL5sIlJLhOtZRHxY=
X-Google-Smtp-Source: ABdhPJyJdU07pOuni3o9/ggJ2XYyvgTXeFKzw9kC6MzcVrSk9YlAPKp3AopgY+Ivtf1I9WBitwusTA==
X-Received: by 2002:a4a:8e16:: with SMTP id q22mr795621ook.81.1606967415531;
        Wed, 02 Dec 2020 19:50:15 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id v12sm195657ooi.46.2020.12.02.19.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 19:50:14 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/2] Implement action terse dump
To:     Vlad Buslov <vlad@buslov.dev>, jhs@mojatatu.com,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20201130193250.81308-1-vlad@buslov.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5df33877-f01b-f856-b1e2-8190eeb67eb9@gmail.com>
Date:   Wed, 2 Dec 2020 20:50:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130193250.81308-1-vlad@buslov.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/20 12:32 PM, Vlad Buslov wrote:
> Refactor action flags according to recommended kernel upstream naming using
> TCA_ACT_ prefix. Implement support for new action terse dump flag.
> 
> Vlad Buslov (2):
>   tc: use TCA_ACT_ prefix for action flags
>   tc: implement support for action terse dump
> 
>  include/uapi/linux/rtnetlink.h | 12 +++++++-----
>  man/man8/tc.8                  |  2 +-
>  tc/m_action.c                  | 13 +++++++++++--
>  3 files changed, 19 insertions(+), 8 deletions(-)
> 

applied to iproute2-next. Thanks,
