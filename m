Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F498BA394
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 20:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfIVSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 14:02:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46929 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388344AbfIVSCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 14:02:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id q24so5398509plr.13
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 11:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mrl6ejKSGWJLMwxsRHLh1k9qil6RYs6Dld08LtQ9Xvo=;
        b=jFku/OtNmZkehaalok4G4mV3DNroK/gZqoDfOdS0/D5Zir4ebdrUB1XgCOlG1BEFAk
         tKbARFwDSJbi47Yl7TRfaC0NbHoFsbJXg2pbAfpIXCu1JTVdG3zXif4JB/ileP9lQ2Vd
         velwQbrsKXJke36PLAzrwCNYrHD9XXQQZXv70kef8ipfs1EWQNtB5FYO89wL9AoVGQJi
         QQ2V4d5ScOPEOgdTQqwTBV2d6BKj3brbh2njmNDalGWxkzG1BZa5R2tJrnLAoeAib0DM
         D5E+N8hQzs/5P+K5vyNUwCo4SBaApywkabywDvYIMRgek0qRd5hOcGE9pK8JnPtK5kqx
         bysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mrl6ejKSGWJLMwxsRHLh1k9qil6RYs6Dld08LtQ9Xvo=;
        b=gHAcTSU2kUcmnOg27p6tl/J+/HNtS8+XswV7dZT47uDGARJOVWWUwMZjKuDWyjimmq
         /Vn1G3F1ejLgUmi1Aq3JYaouzvqHBVigUv4YVTp/v4suc5mIvv3IydCX6nz9v3Wd7Xsd
         2Etb+XM7bit0W7VgxzxoSWV/ZgKKpGyuYdrTl61skmDyzw8UI+9UGJwwNvizWODnVqsJ
         EKvsQUje4lfY4oHBI4gKGLEJO3AmMgAxywJk8VI+0GrMSNJd+TiM7OHOjB+cZdy8lXlR
         KYWA9GaayxY/4w9s8mt2TNF0xJlWUJWPAzBlY/NlBVhmTM16jAL1spaG7h5JU8fLFnGe
         1zMw==
X-Gm-Message-State: APjAAAW9Id3lMRQVKi4xm5HdeYGIz8GEEsR1CgtuXai+wX/SleGeMg2H
        IsEHD/bjFFx9ZAXeaHmvWaugtqoyB6o=
X-Google-Smtp-Source: APXvYqyEPevXDLM3/PU0s3SuxuCfeoHc9Tg7y8BuIwu66LcCuj+vWybjDGbHGWS7TTOKXMJS8cefYA==
X-Received: by 2002:a17:902:7c89:: with SMTP id y9mr27516817pll.115.1569175334856;
        Sun, 22 Sep 2019 11:02:14 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm10142496pfn.90.2019.09.22.11.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2019 11:02:14 -0700 (PDT)
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed downgrade
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <20190922165335.GE27014@lunn.ch>
 <20190922175246.GR25745@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <268c0ea0-8b77-23eb-26cf-820cec1343e4@gmail.com>
Date:   Sun, 22 Sep 2019 11:02:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190922175246.GR25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2019 10:52 AM, Russell King - ARM Linux admin wrote:
> On Sun, Sep 22, 2019 at 06:53:35PM +0200, Andrew Lunn wrote:
>> On Sun, Sep 22, 2019 at 11:59:32AM +0100, Russell King - ARM Linux admin wrote:
>>> Hi,
>>>
>>> tinywrkb, please can you test this series to ensure that it fixes
>>> your problem - the previous version has turned out to be a non-starter
>>> as it introduces more problems, thanks!
>>>
>>> The following series attempts to address an issue spotted by tinywrkb
>>> with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
>>> the negotiated link.
>>
>> Hi Russell
>>
>> This all looks sensible.
>>
>> One things we need to be careful of, is this is for net and so stable.
> 
> Since the regression was introduced in 5.1, it should be backported
> to stable trees.
> 
>> But only some of the patches have fixes-tags. I don't know if we
>> should add fixes tags to all the patches, just to give back porters a
>> hint that they are all needed? It won't compile without the patches,
>> so at least it fails safe.
> 
> I only put Fixes: tags on patches that are actually fixing something.
> Quoting submitting-patches.rst:
> 
>   A Fixes: tag indicates that the patch fixes an issue in a previous
>   commit.
> 
> Since the preceding two patches are just preparing for the fix, and
> not actually fixing an issue in themselves, it seems wrong to add a
> Fixes: tag for them.  However, mentioning it in the commit message
> for the patch that does fix the issue is probably worth it.  Thanks.
> 

This is not a criticism of your patch series, which is fine.

I believe Andrew's angle is that if you have fixes that rely on
non-functional changes, then the fixes cannot be back ported as a
standalone patch set towards specific stable trees. This means that
people who do care about such fixes may have to come up with a slightly
different fix for earlier kernels affected by those bugs, such fixes
would not rely on patch #2 and #3 in this series and open code
phy_resolve_aneg() and genphy_read_lpa() within the at803x.c PHY driver.
-- 
Florian
