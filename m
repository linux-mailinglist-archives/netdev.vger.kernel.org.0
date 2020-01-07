Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D128C131EB2
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 05:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgAGEox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 23:44:53 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45860 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAGEow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 23:44:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so27955053pfg.12;
        Mon, 06 Jan 2020 20:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VgCprQ2zva7lc9m4MxBwteE8ArwxgI7YBSV7ieJsxms=;
        b=VwWVJ/8YrxTd2D3fofttUUxCoO6+7/MX1YeCoAivguiQP398xuCuoDdLHIN+32Y1cZ
         uKlx3zDPdkqN2sPIC1FW773h27n5vnJru610By7aPvnRedESRU7CP1u8YJnXCX/l6Aur
         vq5XHHhBZ6G+pcOCGTLGEQt6nYiwptKP9XCX+bCf0imHVIHRNLZelUx1Quwpa3Ko/9y+
         M9//N6eCDVndLxObZwoFCX/N4REhRspn68IwUN+uVLY3OQzoocd0K9S7xjIDDNVXmKAZ
         2ZiKyNbgL3tC4P797k+VwYuF0Gh0YH0JUAXa18OdSvM9TdW5l8Un7Rl0tqkiDL33ju2G
         mObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VgCprQ2zva7lc9m4MxBwteE8ArwxgI7YBSV7ieJsxms=;
        b=UVRLcNds1Ur0z407hXRquImK/dQndRVJJKOJN9O0LPetA2OmYqmU69kTktRQez0igA
         X/NCn0QFCud0/N6vr5Cwm1kfYQ3UBd1GqkszsXxRJu0OPMrcEo5Q7idK5oue/2+f8Ffr
         SHKD0McVfba/DXaD+0GaVwWpPJvXmoH1e9IeeL+1lnLOX2jim8a0jClO+sAGScWK1Jg6
         OiHHJcHluzZ9xnSkuraCz4Iid2csnJI64joAQnaCBTwj4x70+joIFSv6RtcHhhYYd/zm
         VzsyYuqo3n4dG2ePSdXYTZrsjNIMg72kXGbEoPyqart7WfijnJealP8xIv0tSz6DXz5S
         +yXQ==
X-Gm-Message-State: APjAAAVi1bpg7GpQM/G9BV4Tt0nE4pDW8dpZ/6yzjQn1r6uwD9IJC+7E
        pNl3ruWVlbGaTeMhL/Kh3zji8Ymj
X-Google-Smtp-Source: APXvYqy3QjtQZbx05zCCJ4SR95V8UcajuC9bQMNtHSa02fi+o1Us9pm4YyT/GJmhNcb0rzW68gFtPw==
X-Received: by 2002:a63:f64a:: with SMTP id u10mr111518644pgj.16.1578372291678;
        Mon, 06 Jan 2020 20:44:51 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h11sm72837866pgv.38.2020.01.06.20.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 20:44:50 -0800 (PST)
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     Jiping Ma <Jiping.Ma2@windriver.com>,
        David Miller <davem@davemloft.net>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
References: <20200106023341.206459-1-jiping.ma2@windriver.com>
 <20200106.134557.2214546621758238890.davem@redhat.com>
 <15aedd71-e077-4c6c-e30c-9396d16eaeec@windriver.com>
 <20200106.182259.1907306689510314367.davem@davemloft.net>
 <99d183bc-7668-7749-54d6-3649c549dec8@windriver.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <46650899-07e1-a385-93ae-5720fa185cc8@gmail.com>
Date:   Mon, 6 Jan 2020 20:44:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <99d183bc-7668-7749-54d6-3649c549dec8@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/2020 6:59 PM, Jiping Ma wrote:
> 
> 
> On 01/07/2020 10:22 AM, David Miller wrote:
>> From: Jiping Ma <Jiping.Ma2@windriver.com>
>> Date: Tue, 7 Jan 2020 09:00:53 +0800
>>
>>>
>>> On 01/07/2020 05:45 AM, David Miller wrote:
>>>> From: Jiping Ma <jiping.ma2@windriver.com>
>>>> Date: Mon, 6 Jan 2020 10:33:41 +0800
>>>>
>>>>> Add one notifier for udev changes net device name.
>>>>>
>>>>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>>>> This doesn't apply to 'net' and since this is a bug fix that is where
>>>> you should target this change.
>>> What's the next step that I can do?
>> Respin your patch against the net GIT tree so that it applies clean.y
> OK, I will generate the new patch based on the latest linux kernel code.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

That is not quite the tree you should be using, you should be using the
"net" tree, which is here:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/

and here are some useful pieces of information in the netdev FAQ:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/Documentation/networking/netdev-FAQ.rst#n28

Also, since this is not the version version of your patch, please make
sure your subject indicates this is not the first version, I have lost
count of the exact number of times you submitted this already (4?) so
this could be [PATCH net v5] in the subject or something like that.

Given you fix a bug please also provide an appropriate Fixes tag, which
should be:

Fixes: 466c5ac8bdf2 ("net: stmmac: create one debugfs dir per net-device")
-- 
Florian
