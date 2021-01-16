Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC722F8A02
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 01:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbhAPAmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 19:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPAmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 19:42:07 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E480BC061757;
        Fri, 15 Jan 2021 16:41:26 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id e15so2656408wme.0;
        Fri, 15 Jan 2021 16:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=86ftdUay4YL8UzEpU/3CE7EjzVx94Q7v448ik7iohsk=;
        b=lcR4SNPAwn6ZSiCPWxITBTZsXWBCd9EMdRWY9+zqEYOTwNYcbh0BZbVNgJBih0KyPO
         Q5VOwN+soXapQ+JYEN9iUb3wilPhKXI6ByCzXpQrkJ3lZgAV1CxXG+g4dYYGe13brvsN
         /GSjq8BR2qKii7xzdwEovHF3zv8dLWB/YLc3UYkJYLbjGNu79mB2IFo7EZ6qT5zaqu0T
         nVisjv3rdq1aycLJeJtn1xYjmRDbdjCDupiOlwea5gX/HW8eZalBD1XonZvnFsiabeUs
         0p17/EFaC/hENknPY7V1VqeSYvXCQOxFGRXsAzTF4NWrN9fcrH0Q4pSalkjev/FyFbTY
         Ef6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=86ftdUay4YL8UzEpU/3CE7EjzVx94Q7v448ik7iohsk=;
        b=ZGmvbJHAhILwQWpABNygkfKrGKpwMGhSv4Do/C5Y323Yjn2ki5tnN5H63NjTtva8X5
         YUSkoAlGW9Of5UJX8oZMqUT901kW5Q2h9kxZw3eJreQ5Alp1FXWGBVrt4YhsOnx+2uAy
         t64PrmUnlh2Cj23dq1kQY9g+h+/q6RXLda/qJzo9XfqJ7bjHoH8sTkPRX8xurLI6wiL4
         hOowqXMD1PnoNrN9tlgE2xCaM1bs7vSjoeU95LMNu6pxTmNrpUodcGU8Kh82BpTQQQpV
         Orv80RtJwGGt253wPMdtWR29k7QmbwMegWv4VN8lbUrRSecMr5k6DQxIXxyocSFMdR50
         4yuQ==
X-Gm-Message-State: AOAM533V36jZdS85qQGhJaISoFwRQtTDxC66gcFozwrqtvsKP/iuuv3Q
        lWZUhNw7eloWf6wwI9NQ4M3o7GQcdVo=
X-Google-Smtp-Source: ABdhPJxodeMhNSkIcJtr+tNNz4fVbUvHiijFYZHPfRJCSPi47R2WegtuXF3pSIOfpyasyL1JxGrTHQ==
X-Received: by 2002:a1c:1f86:: with SMTP id f128mr10922630wmf.174.1610757685747;
        Fri, 15 Jan 2021 16:41:25 -0800 (PST)
Received: from [192.168.1.143] ([170.253.51.130])
        by smtp.gmail.com with UTF8SMTPSA id d85sm9727579wmd.2.2021.01.15.16.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 16:41:25 -0800 (PST)
Subject: Re: [PATCH v2] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org
References: <20210102140254.16714-1-pali@kernel.org>
 <20210102183952.4155-1-pali@kernel.org>
 <20210110163824.awdrmf3etndlyuls@pali>
 <16eaf3ce-3e76-5e34-5909-be065502abca@gmail.com>
 <20210112192647.ainhrkwhruejke4v@pali>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <8e09e975-3b79-a47c-527f-84b77563d6bf@gmail.com>
Date:   Sat, 16 Jan 2021 01:41:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:84.0) Gecko/20100101
 Thunderbird/84.0
MIME-Version: 1.0
In-Reply-To: <20210112192647.ainhrkwhruejke4v@pali>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 8:26 PM, Pali Rohár wrote:
> On Sunday 10 January 2021 20:57:50 Alejandro Colomar (man-pages) wrote:
>> [ CC += netdev ]
>>
>> On 1/10/21 5:38 PM, Pali Rohár wrote:
>>> On Saturday 02 January 2021 19:39:52 Pali Rohár wrote:
>>>> Also add description for struct in6_ifreq which is used for IPv6 addresses.
>>>>
>>>> SIOCSIFADDR and SIOCDIFADDR can be used to add or delete IPv6 address and
>>>> pppd is using these ioctls for a long time. Surprisingly SIOCDIFADDR cannot
>>>> be used for deleting IPv4 address but only for IPv6 addresses.
>>>>
>>>> Signed-off-by: Pali Rohár <pali@kernel.org>
>>>> ---
>>>>  man7/netdevice.7 | 50 +++++++++++++++++++++++++++++++++++++++++-------
>>>>  1 file changed, 43 insertions(+), 7 deletions(-)
>>>
>>> Hello! Is something else needed for this patch?
>>
>> Hello Pali,
>>
>> Sorry, I forgot to comment a few more formatting/wording issues: see
>> below.  Apart from that, I'd prefer Michael to review this one.
>>
>> Thanks,
>>
>> Alex
> 
> Hello Alex! I will try to explain configuring IPv4 and IPv6 addresses on
> network interfaces, so you probably could have better way how to improve
> description in "official" manpage. I'm not native English speaker, so I
> would follow any suggestions from you.
[...]

Hi Pali,

Thanks for explaining the process to me.
However, I don't feel that I understand it enough to help you co-writing
the text.  I lack much background to understand your explanation.  I'd
help you with the language happily, if it was only that :)

Maybe someone from netdev@ can help?  Or Michael?

Regards,

Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
