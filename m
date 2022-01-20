Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C414954D5
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiATTU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 14:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238482AbiATTU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:20:59 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDDFC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:20:58 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z19so8206595ioj.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vkvfAYkMXs/+fO/YUx0pphb+NryNFVJf6ab/suZfnCc=;
        b=C0SA9jLX+48Hbxx6xbg49SA4LwRr+fB0HusQLYx85G6BMVYBWBs9+WEOkxKOQwxY/c
         vgQ8/jyz/pda5CrA7ODoLHSA9sEzfqYCjNpvsYE5YSTVpWz4xpSCq4e/xj+1x+PbzTdb
         Bspjgf2a7eHPvViQD7fLJY80Y8qZbMZLn1XSvHsZNmrK6jSZasjr/tYrbZaB+oZEa3am
         9Kj+4eLdQUr1/d3Qrc5YT7rGYSt1652AFMHWQnIHvMhGQ3FaElRDwvOum/TzTC8qKiAB
         iXkLt4ctzC/9mB4sqoV0f306xN4uUvAr4Mvl/UfP3s26gm5D5txio1OneTEa3K8Sw8cp
         NzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vkvfAYkMXs/+fO/YUx0pphb+NryNFVJf6ab/suZfnCc=;
        b=WmFEdcKmAyqQUQb62NwE72Q5QzI4x1+cHeCmPOfoU7nah8FV39brYzDMBPgC8vAWlj
         WEGTV8Tz/BYgXJmQAOVOp4thXX9rSrOqUoWdxy3y4otKLizdcLUgTc889dAduCpWbSqj
         r3OdXHiBkM9Q3qUIQW3Jmm8p3JOBgyrvWKjNZatXrvmK+HDbIGuif3UyUNqvyeAK5gML
         xeK96HMxZbBLNzJ5NUHR9JNAMrtLgt1Ok9WKo6MhrjM0OOkaGJ8r4dkv1QJTUS/zk/zB
         ZIVVjdBSxuUgrXHdhI580pzfu+k9WLTSTLf31+8b1RobKz8j06VPfsSzXlO1Lx6Wp4Z8
         RZpg==
X-Gm-Message-State: AOAM532FJH9s0DGMdCGUjMN+FZ/KMBJuBOxl5YMsuqGzGnXwWB7+DSSH
        weWid5yxj0r2apCBd01exOE=
X-Google-Smtp-Source: ABdhPJwM1vkvHXJeQp0s2qq1d9o8Pfo9l6o/C7QcY4FOdOL/pwfxTxCLpb2MQz9xFOxUcXVynFNG9g==
X-Received: by 2002:a02:c8c5:: with SMTP id q5mr139881jao.42.1642706458360;
        Thu, 20 Jan 2022 11:20:58 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:f132:4fd1:92c1:404d? ([2601:282:800:dc80:f132:4fd1:92c1:404d])
        by smtp.googlemail.com with ESMTPSA id e18sm17644ioe.24.2022.01.20.11.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 11:20:57 -0800 (PST)
Message-ID: <b3917b75-9420-c965-e6cf-0dcfeb35b1bd@gmail.com>
Date:   Thu, 20 Jan 2022 12:20:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 iproute2-next 00/11] clang warning fixes
Content-Language: en-US
To:     Victor Nogueira <victor@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
 <95299213-6768-e9ed-ea82-1ecb903d86e3@gmail.com>
 <e8e78f5e-748b-6db4-7abe-4ccbf70eaaf0@mojatatu.com>
 <CA+NMeC8ksPxUbg_2M9=1oKFWAPg_Y8uaVndTCAdC+0xvFRMmFQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CA+NMeC8ksPxUbg_2M9=1oKFWAPg_Y8uaVndTCAdC+0xvFRMmFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/22 5:48 AM, Victor Nogueira wrote:
> Hi,
> Sorry for not responding sooner. I patched iproute2 and several
> existing tests failed.
> Example:
> Test 696a: Add simple ct action
> 
> All test results:
> 
> 1..1
> not ok 1 696a - Add simple ct action
> Could not match regex pattern. Verify command output:
> total acts 1
> 
> action order 0: ct
> zone 0 pipe
> index 42 ref 1 bind 0
> 
> The problem is the additional new line added.
> 
> WIthout this patch:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220117175019.13993-6-stephen@networkplumber.org/
> it the output of tc actions list action ct is:
> 
> total acts 1
> 
> action order 0: ct zone 0 pipe
> index 42 ref 1 bind 0
> 
> With it it is:
> 
> total acts 1
> 
> action order 0: ct
> zone 0 pipe
> index 42 ref 1 bind 0
> 
> So I believe the problem is just formatting, however it still breaks some tests
> 

Thanks, Victor. Hopefully that is addressed in v3 of the set.

