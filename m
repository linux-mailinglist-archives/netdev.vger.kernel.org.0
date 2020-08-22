Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4024E944
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 20:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgHVSaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 14:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgHVSaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 14:30:13 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23779C061573;
        Sat, 22 Aug 2020 11:30:13 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id bo3so6691813ejb.11;
        Sat, 22 Aug 2020 11:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pmwc657VcF17LG5ED0cRlkWCOFELPP7RKTL6nAzRSO4=;
        b=hzbGnIT7kuQhlZTtyKqN8mazgBdpUn6VDHVcpom3d86maYFG4Ciq36TAS/OrXwYFyv
         Dy7NF0lCN/LCyzeS04r7gOdvDc8VodGRJ5uzu6/N++R4NuZfOitsO8vtSklQ8pNVrW9H
         2AX20gLnHdCAbnyPKUwCZ7d4TVkd+pY7h2aPz6ECU1W12ObAfRMJ2XCGukjjOje/3UIK
         JQx5R1trcmwTV0PyXTurNRafPXECqoQ0s+amai5NsJS3JGl3j0IdhG/n9iXUqu9jbOfS
         Ek0JGbdAbpkF3HjiUQMLMyNXE2jQjD1R+vS5ydVmWqTBCfMDcLejfK4XBHocIR6sdC1O
         rm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pmwc657VcF17LG5ED0cRlkWCOFELPP7RKTL6nAzRSO4=;
        b=DvPWwGDUEt0gQTsb+ga35h0RDUDCnWAO93sFhDlQMtHMlpt46Xrvw6W7NozIVf24mU
         Wr3hsTx+FHD+jEXQWK6GKME/UgyJ2o9Lh/FieBfY6AkfsQWW3Q8N3YbD/8yucMvIT7Sr
         +QGY/SY1YQIU2bTdCK1h7HussfHtNfhdgTviRRthM1Xj3vkXPVZrJ0FfVJlltyyWB3DL
         VMqsFkiplJDIHR5zoERtb7pZ1agkCH8mLvLVQx7z6M36K+IPmt1BHfwO6Q8tLWqdzoGO
         BJ9eepy6uGCHcoNjPbeQ3yEVyikig79yyZ0Nshq+x+qVvxJElHa96yeG529UycogkxcP
         wgWA==
X-Gm-Message-State: AOAM5308DGXs6mve577KemIp4r/LcY31PIZ02DFkii/s7PAohRLrCqJb
        XY9bxmDMKoSGuiuMyBSAiQZPXq1h7WY=
X-Google-Smtp-Source: ABdhPJwKFRd7cNh4F6FJ82WpJg5kVdluNhakye9NZ1+MXdzeZweG9ZDTOG3uXo7fzD7j60X9WGSymA==
X-Received: by 2002:a17:906:401b:: with SMTP id v27mr8277695ejj.300.1598121011480;
        Sat, 22 Aug 2020 11:30:11 -0700 (PDT)
Received: from debian64.daheim (p4fd09171.dip0.t-ipconnect.de. [79.208.145.113])
        by smtp.gmail.com with ESMTPSA id i26sm3406551edv.70.2020.08.22.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 11:30:10 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1k9YHC-0006WS-6L; Sat, 22 Aug 2020 20:30:04 +0200
Subject: Re: [PATCH 00/32] Set 2: Rid W=1 warnings in Wireless
To:     Lee Jones <lee.jones@linaro.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200821071644.109970-1-lee.jones@linaro.org>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <a3915e15-0583-413f-1fcf-7cb9933ec0bf@gmail.com>
Date:   Sat, 22 Aug 2020 20:30:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 09:16, Lee Jones wrote:
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
>
I see that after our discussion about the carl9170 change in this
thread following your patch: <https://lkml.org/lkml/2020/8/14/291>

you decided the best way to address our requirements, was to "drop"
your patch from the series, instead of just implementing the requested 
changes. :(

> There are quite a few W=1 warnings in the Wireless.  My plan
> is to work through all of them over the next few weeks.
> Hopefully it won't be too long before drivers/net/wireless
> builds clean with W=1 enabled.

Just a parting note for your consideration:

Since 5.7 [0], it has become rather easy to also compile the linux 
kernel with clang and the LLVM Utilities.
<https://www.kernel.org/doc/html/latest/kbuild/llvm.html>

I hope this information can help you to see beyond that one-unamed 
"compiler" bias there... I wish you the best of luck in your endeavors.

Christian

[0] 
<https://www.phoronix.com/scan.php?page=news_item&px=Linux-5.7-Kbuild-Easier-LLVM>
