Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC25B465D2E
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344960AbhLBD7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345134AbhLBD7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:59:02 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FFAC06174A
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:55:40 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n26so26693485pff.3
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 19:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xLVu0arlLvlAz0Un1fHcVbW46Hq/49UORNZnEpiJWho=;
        b=ZQAnUV8K/c+JkwixrOSrJa4Xzed2WsITbdPUMC7exXD0KRDdLRBKarKEdyeDsGwo+R
         6K+JWcGeHRrUd+UD4DcKmN/1qba9UaFp83jdynysBHYTmzMgw/HYJgF82qNO5fteJ9NY
         eCV5bIKkieEzlduy97xse4Z4Pu3FhaA9/5jsaCd5pKyDzJK75uKY+xsGsdXs1GMiIKWe
         6tGotAtgmH3pUbPsv3wqKpVPqIBcyrwDhhzS3wovG9qAst50o372fzeV2nBExM0hnaj5
         98JXukb6w0/DFsFcptvpOArtUrLqjGyk20tg4nhdF17XONb8dzgYjfpm7tWdlMi0u5uZ
         iWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xLVu0arlLvlAz0Un1fHcVbW46Hq/49UORNZnEpiJWho=;
        b=WDXoAJRcPmns8n0uXfI9tsfinWAeUpY8G8vqf+fU4qQHx1cqRH6VgdJt5dwHXoQAX/
         RHeNZ21pFXgoIMO6Kj4+lhALk3v8/XpvMrthe32mjXATvJ1fzZ1hIA+Vzmoi00IeifFx
         izNH5FURTX9yaOOGlFk/69sqLspqiedLAoinT9M1nWfxDreVN6UnlINEIqp0clWlusAA
         nRkBkGFK+7FtRPPBfMZiR0cxNJKTpqO8G0YT8vjOxhNPNFoVcGMV0fvWctnNsdCI9+i9
         Nhd2Wy2Pugf4T3DB7L6hj8wJOqJ7VNiTpnkB0vCnr4kSAePdQAFuvN1Q5OCvTzNeeVGl
         ZH4g==
X-Gm-Message-State: AOAM532qbB/TGQ16LgMhiZHtVs7qajnCqx1xpjhMzfMd/JeznXi+lhn5
        GHOq22Y+rXMY3PIBAB1/ziE=
X-Google-Smtp-Source: ABdhPJxP+cMWnjJjvpxKYA6IUI5QutDckjY2CfOgKW87IUVc6ppr420sCnxZZbxUw/6DTZLaRXUBEQ==
X-Received: by 2002:a05:6a00:1482:b0:49f:d9af:27dc with SMTP id v2-20020a056a00148200b0049fd9af27dcmr10643136pfu.9.1638417339983;
        Wed, 01 Dec 2021 19:55:39 -0800 (PST)
Received: from [10.230.2.23] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a16sm219227pgm.57.2021.12.01.19.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 19:55:39 -0800 (PST)
Message-ID: <f105e251-e8e9-2179-ce74-3d7739844370@gmail.com>
Date:   Wed, 1 Dec 2021 19:55:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] Revert "net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname"
Content-Language: en-US
To:     Jonas Gorski <jonas.gorski@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
References: <20211117160718.122929-1-jonas.gorski@gmail.com>
 <YZUw4w3NsfuDO4qS@lunn.ch>
 <CAOiHx=kRQvOc59Xtxwa0R8XNdrSsjigPubGWiyon+Sf94s2i5g@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAOiHx=kRQvOc59Xtxwa0R8XNdrSsjigPubGWiyon+Sf94s2i5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2021 1:14 AM, Jonas Gorski wrote:
> Hi Andrew,
> 
> On Wed, 17 Nov 2021 at 17:42, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Wed, Nov 17, 2021 at 05:07:18PM +0100, Jonas Gorski wrote:
>>> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
>>>
>>> Since idm_base and nicpm_base are still optional resources not present
>>> on all platforms, this breaks the driver for everything except Northstar
>>> 2 (which has both).
>>>
>>> The same change was already reverted once with 755f5738ff98 ("net:
>>> broadcom: fix a mistake about ioremap resource").
>>>
>>> So let's do it again.
>>
>> Hi Jonas
>>
>> It is worth adding a comment in the code about them being optional. It
>> seems like bot handlers are dumber than the bots they use, but they
>> might read a comment and not make the same mistake a 3rd time.
> 
> Sounds reasonable, will spin a v2 with a comment added.

I just hit that problem as well refreshing my Northstar Plus to boot 
net-next, are you going to submit this patch in the next few days? Thanks!
-- 
Florian
