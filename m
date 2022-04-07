Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3978D4F7F28
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiDGMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbiDGMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:36:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA84418546C
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:34:35 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v20-20020a05600c15d400b0038e9a88aee7so418624wmf.3
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 05:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZFiuAZbuydiA9btLqLVb581DR1o6O6mFFjJkx/OtSas=;
        b=IYDazVwMq+3IqkU+dzCpOWsCzbJjZRYduUrAUJM3xiCmE7dFwq6MR89y0BLD0lsw+s
         HryTdJYY9NSJRB1MA7iQzawrrNOHznMkLoHsuWg6s15hItT84/i0pSz2zjJ5t1apYr1S
         xUriuRuXYZuJoygZLLRcCnqr+yX9YBVipZ0BHee/+8HzC+QVMjEcOW8AZEpkA5Etxfpi
         3/z4vIn0OOsDa0Vd2MFWQINu6v5uPbZb3Uc6gofMDKw01F6GKO7NUo/GOaj64mTFgATX
         5Ni1Wy2BPoTyDerlmwVVO2lG57bvqlMgVFJmXLJavy+KeDbgedruVqPr0vGzF/WgQBX/
         wK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZFiuAZbuydiA9btLqLVb581DR1o6O6mFFjJkx/OtSas=;
        b=Iuf1M3k6DCXGa9FWGvyIIGkuQeLoIFeL6fGRJ9awh7xEC6LntZv6h53B9hMcz/H7BD
         EGS+vcYKNAZx2LPTn5EyGKycKqcTE8XDGxd3Svr4bGPKgbMXam7NpiYsvfnPFVtcAT8T
         ZqC/vGjITKbZJ/G6QO6/JMPKgV5o/Dl7zfGr+X+BEMXfBzeSAwcQ5FCSEB8donfF/meL
         veNXSHC66Rk/AdovuyLiFMecxGV303rb74V9eyY0ncmeX7NpMLgtNPBL/rWJYpWfTRA4
         zRGRMuMPvnjgm1n016VvwoAly6EbqmW0j2AzqgozJ6MnjK8+ax6/AFRqtQrjGs7wN6+a
         F7Bg==
X-Gm-Message-State: AOAM531vj4D/dkUxhificDE169vOgLfx0rhly6lXkmR1ilVUriaeusYJ
        0WmeWZhwwZD08GnQ9oPzaY5rIOxrofgvbQ==
X-Google-Smtp-Source: ABdhPJws/8oJwLZINTtlgtxZj1J08UYGgvFbMlb9vPrSOvaeLRKNgMd0XtfQMxXicjTxMp/gCQmY5w==
X-Received: by 2002:a05:600c:b55:b0:38e:70e7:511f with SMTP id k21-20020a05600c0b5500b0038e70e7511fmr12394525wmr.178.1649334874319;
        Thu, 07 Apr 2022 05:34:34 -0700 (PDT)
Received: from [10.4.59.130] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id j31-20020a05600c1c1f00b0038e72206b3dsm8054854wms.30.2022.04.07.05.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 05:34:34 -0700 (PDT)
Message-ID: <748f0357-2527-edda-d08a-ac0b0a7bffef@wifirst.fr>
Date:   Thu, 7 Apr 2022 14:34:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 net-next 1/4] rtnetlink: enable alt_ifname for
 setlink/newlink
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
References: <20220405134237.16533-1-florent.fourcot@wifirst.fr>
 <20220405174149.39a50448@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <20220405174149.39a50448@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

> 
> This patch needs to be after patch 3, AFAICT. Otherwise someone running
> a bisection and landing in between the two will have a buggy build.
> 

I double checked and this patch compiles perfectly fine when applied 
first, at least with my .config.
Could you be more specific on what I'm missing?

> Please provide a cover letter for the series, now that it's 4 patches.

Thank you, done. I made a typo on it (v3 instead of v4) so do not 
hesitate to tell me if I should resubmit again.

Best regards,

-- 
Florent.
