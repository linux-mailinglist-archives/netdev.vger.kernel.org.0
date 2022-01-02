Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3100C482CA1
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 21:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiABULh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 15:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiABULg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 15:11:36 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F3C061761;
        Sun,  2 Jan 2022 12:11:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u22so52987853lju.7;
        Sun, 02 Jan 2022 12:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KEExCTh4jmFGHJH65BWVo+qXGRxcz9olInvy4J3P7xs=;
        b=BcAR9+Kpa/v2+jbHUgZjgrhtgTtgPhny2ghI/To+OLTZd5/lxIFCQXCEs+qlt0Vtjr
         +tACvJBSYW8TI54YGIz/Nhk3eynBC4ayOrh2rYjP97Haqwcb8Rs+3MaGEqlDMiFU6GOh
         pfq+UM3xhExZnVt9fUCwmr4otHE5DTDsbNFhnIASHxoB5Z+mKrDm4vEqus0llcCjdHHs
         oTAckFRHe2L492ApuH0xsiFlAvgbcfE7Mv+aaIKLUTNLNM6EjuDlcQ04wDoz0aDK+g1p
         t5W2DGF16eeSvMZfta5j3/iFpyrDOlAciFoyqvpAy2pdeVQR6gdQug1SLfE0NVersI+Z
         KR1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEExCTh4jmFGHJH65BWVo+qXGRxcz9olInvy4J3P7xs=;
        b=Ky2gKpwKRr4e1yR7j9HS5qivWTA7DHJdedFCfYtk5tfui9ltjP3fbAdryQ5iJhbNSy
         bt9ax/6A7Potvi5eN4dtcvaP0HZeh5dxTDd422kJe2oY78hK4jJZFKzp3o72uI0J3FY7
         T2cKcxGhI8qAIROgv/5+wZw4ggRJUP+7SXM2FXe+vPqi9oE4COgKm3jhMkbteki7oPO0
         ik653/lJX3h6l+PPDOR5CzGGP0o/ikLSnhN7b3nKzUG/Dpeq4/lv4L+bx/1Ab9+fszQJ
         t5gfr2FDGEzHFAaddYJvtQD4SMBrHFuRkq6u879X97Z/8KkX1ZGX01CnpPJ9xdZD+40A
         cEIg==
X-Gm-Message-State: AOAM53193OVZZjIYcdYREWqT/hqjbH/aUbUvdD31ADidyJLthLSke8EX
        A5EjzY/egknG/Qsz43RATzQ=
X-Google-Smtp-Source: ABdhPJzCwMDOy579517EAkWoat/vrsLvonPii9VPKKhEg/1eNhMe4/YfqPdqda9ftpo+EldJQ0O5Iw==
X-Received: by 2002:a2e:a601:: with SMTP id v1mr25302063ljp.286.1641154294137;
        Sun, 02 Jan 2022 12:11:34 -0800 (PST)
Received: from [192.168.2.145] (46-138-43-24.dynamic.spd-mgts.ru. [46.138.43.24])
        by smtp.googlemail.com with ESMTPSA id d16sm3293455ljj.96.2022.01.02.12.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 12:11:33 -0800 (PST)
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
To:     Hector Martin <marcan@marcan.st>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
 <e9ecbd0b-8741-1e7d-ae7a-f839287cb5c9@marcan.st>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <48f16559-6891-9401-dd8e-762c7573304c@gmail.com>
Date:   Sun, 2 Jan 2022 23:11:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <e9ecbd0b-8741-1e7d-ae7a-f839287cb5c9@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

02.01.2022 17:18, Hector Martin пишет:
> On 2022/01/02 15:45, Dmitry Osipenko wrote:
>> 26.12.2021 18:35, Hector Martin пишет:
>>> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
>>> +static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
>>>  {
>>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>> +	char **alt_paths;
>>>  	char suffix[5];
>>>  
>>>  	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>>> @@ -609,27 +612,46 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>>>  	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>>>  	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>>>  
>>> -	return kstrdup(alt_path, GFP_KERNEL);
>>> +	alt_paths = kzalloc(sizeof(char *) * 2, GFP_KERNEL);
>>
>> array_size()?
> 
> Of what array?

array_size(sizeof(*alt_paths), 2)

>>> +	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
>>> +
>>> +	return (const char **)alt_paths;
>>
>> Why this casting is needed?
> 
> Because implicit conversion from char ** to const char ** is not legal
> in C, as that could cause const unsoundness if you do this:
> 
> char *foo[1];
> const char **bar = foo;
> 
> bar[0] = "constant string";
> foo[0][0] = '!'; // clobbers constant string

It's up to a programmer to decide what is right to do. C gives you
flexibility, meanwhile it's easy to shoot yourself in the foot if you
won't be careful.

> But it's fine in this case since the non-const pointer disappears so
> nothing can ever write through it again.
> 

There is indeed no need for the castings in such cases, it's a typical
code pattern in kernel. You would need to do the casting for the other
way around, i.e. if char ** was returned and **alt_paths was a const.
