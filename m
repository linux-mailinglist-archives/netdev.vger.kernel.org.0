Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A085436494
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhJUOpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhJUOpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 10:45:17 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB66DC061243
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:43:01 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id r6so1151115oiw.2
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0tKBlLu00abhQZgtMtvTb7FMPM0Yxu4GsNVOLevTRcs=;
        b=cfg01zAYQtiuPUjrsk6EBTKLJG+cw1+m+FMdKUdkGInMtOzmm+wAVahLCFY6zh92Mq
         w6Cgg6xdYJplo8EZFZ0OkXMYWVI8MQg/fimRsasoBYZcTKsezp1PEqkVGfwGNhxJXX2i
         1M25dKnzPYq2MCG41Rgue0TS0z0OMG+TIQ2wkzbhQdDhmrEmvmQocRdADSEtMEApNVS3
         UbyKJBWLML2lV/1sEgHruHAKNVUWSKyaBTBR9N0povaUuTGVH1wbLqUCECLWmNFQFbaX
         mxBtRZJ3w8HQmyY3c3Z15DEkk9zNWNbHu30CM+ytf8wdxzbS6VXIrK0HDTcUD5rCP9Kz
         +L4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0tKBlLu00abhQZgtMtvTb7FMPM0Yxu4GsNVOLevTRcs=;
        b=T7x5sSHgcdbRpoOSKIitSl78C51IFozvxuU7x6vrliBFz5/sLyhRhwV1gc35SFTEN3
         QfvlXlN7wE01OXV3swRNCWp7d8t0VXi0v0juKX/XSvVIyoRWQncnH/pcQqUgjo/iErei
         j0eNtC36M7LaVZEmKYAibIf592eaAZXLNQO+7DK49zKSU8EYP7X/OA6ptEqs4FJpFG42
         3LCuyqd5x/TXZRQoi7EhMJF4Ofy6l8Tl8uAzLvsJ/e7gGx/xxNEtyxspoWX3Mn6225s3
         hwESoFrR2UVHM26MKy8Fg5xoJWqh1/o9YMs7CSBw279KTyLxU30onAIXxpR6z2EPIOZc
         axRQ==
X-Gm-Message-State: AOAM5328iMJGUbxv7n1ux0MGeFu/eBQ5eQ0tn8sGV+ZyG1QPy5NouVBm
        wXUz+XRZaQgkO+6DZCRX4rrYzVevHyY=
X-Google-Smtp-Source: ABdhPJySaCljho6LqFuBGTGg0ztzyQtIKjxsTeFwEOrIXGn6gCNrblSG/Kh9k2hCY9YSoC/ADMAQzQ==
X-Received: by 2002:aca:6109:: with SMTP id v9mr4942484oib.59.1634827381244;
        Thu, 21 Oct 2021 07:43:01 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id r14sm1204925oiw.44.2021.10.21.07.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:43:00 -0700 (PDT)
Message-ID: <6e7eecb2-0e14-f8c5-34df-6f1268cc2446@gmail.com>
Date:   Thu, 21 Oct 2021 08:42:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH net] fcnal-test: kill hanging ping/nettest binaries on
 cleanup
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     dsahern@kernel.org
References: <20211021140247.29691-1-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211021140247.29691-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/21 8:02 AM, Florian Westphal wrote:
> On my box I see a bunch of ping/nettest processes hanging
> around after fcntal-test.sh is done.
> 
> Clean those up before netns deletion.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 13350cd5c8ac..5aba16c52c2b 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -439,10 +439,13 @@ cleanup()
>  		ip -netns ${NSA} link set dev ${NSA_DEV} down
>  		ip -netns ${NSA} link del dev ${NSA_DEV}
>  
> +		ip netns pids ${NSA} | xargs kill 2>/dev/null
>  		ip netns del ${NSA}
>  	fi
>  
> +	ip netns pids ${NSB} | xargs kill 2>/dev/null
>  	ip netns del ${NSB}
> +	ip netns pids ${NSC} | xargs kill 2>/dev/null
>  	ip netns del ${NSC} >/dev/null 2>&1
>  }
>  
> 

Acked-by: David Ahern <dsahern@kernel.org>

