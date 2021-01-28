Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869C63077AC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhA1OGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1OGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:06:50 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44438C061786;
        Thu, 28 Jan 2021 06:05:37 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l12so5535751wry.2;
        Thu, 28 Jan 2021 06:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XidhgnJaig9bBWbbOfZArdJqj9SEWN/KrzmcdjOgcRg=;
        b=OB6hTLw9kmRiwgTlP2QHLKIQmlGNLvQoxFZnHLDXA9QjahSocj/1F8PJmc9tpoHhV8
         GsYop1uSd9NSFnTjzJ+4+9P0iOS/+zivprMH6XIrx8gjCsX9KsH3PeB4WFiJORUjggxh
         oKUSRtmkrbYXp6mrBHCyilDcUk+Z2xml61iG+H0N4mrteGGcBf7D0uG19AL4EUPOY7QH
         JDIUFp5n8IadiUUopMxg2cL/Lm51h3Z707hx7DX5a1mPaf4XUxJAdYVHXalRwsDTu6ux
         NZ2dBz9gjxxqynu0RMegSFpSoMyOzGLyrRYj0CFWK94iOncwgxU36IrexkORsCVZ5ff9
         8ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XidhgnJaig9bBWbbOfZArdJqj9SEWN/KrzmcdjOgcRg=;
        b=BeLA6jWJftOvTusS9jkNTDO34cunmOmK1Q2zDZ/7eYLf49abXifQpMde2vxWkwKmlE
         5/qdr7Ph9ixDHPl1z0Hu8H22ow5pT8YOnLDzDRAcG5jw2zP+ahov/rY0sxzynJwTThZ5
         LEZbSko3Zp0mhdkim26YByHJ0nX2vtuTJZCBcvX7Fk1mntEa+QKpkVxo2mgs0OEqnq+s
         2IiOAgGeFGYXnkxhqVX8EuboQ7zRtyP3JOXC/nlEa2dNjywxsv7Q2ivNpv+rCnc81u36
         +/FEVh8StWEzLgPetWMwRnNNac0om6UZRwcyrgvGjtxhpu1jN3op1lVR5MGkqz0Uf08/
         hcng==
X-Gm-Message-State: AOAM532d2PjZVjIvag+ayOMZSzDvrhFX0s984KA5mtM2xQV5zhp2CYdP
        1eFzFJXgbl3oL1Zk8/VA5MqAZNhRkAE=
X-Google-Smtp-Source: ABdhPJzTi20dRVclbJAfD6RzSP7XprEVEHQ/4CTK9WwgqMEwCesdVHsOzc8o3A8P/WgJbUyzN/711w==
X-Received: by 2002:adf:df0a:: with SMTP id y10mr16305360wrl.214.1611842736013;
        Thu, 28 Jan 2021 06:05:36 -0800 (PST)
Received: from [192.168.0.160] ([170.253.49.0])
        by smtp.gmail.com with ESMTPSA id n125sm6291216wmf.30.2021.01.28.06.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:05:35 -0800 (PST)
Subject: Re: [PATCH v3] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
References: <20210102140254.16714-1-pali@kernel.org>
 <20210116223610.14230-1-pali@kernel.org>
 <fc4a94d4-2eac-1b24-cc90-162045eae107@gmail.com>
 <20210127192913.e6ppkqwjclmgjh4a@pali>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Message-ID: <d99e1837-1d50-9203-0082-1b60e34aaad6@gmail.com>
Date:   Thu, 28 Jan 2021 15:05:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127192913.e6ppkqwjclmgjh4a@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pali,

On 1/27/21 8:29 PM, Pali Rohár wrote:
[...]
>>
>> Please fix this for the next revision.
>> However, don't send a new one only for this.
> 
> Ok!

I fixed that already.

> 
>> I'd wait to see if someone reviews it or helps in any way ;)
> 
> Seems that nobody came up with suggestions for improvements...

Thanks for the ping.

I applied v3 with some minor fixes.

Thanks,

Alex

> 
>>
>>>  or via
>>>  .BR rtnetlink (7).
>>> +Retrieving or changing destination IPv6 addresses of a point-to-point
>>> +interface is possible only via
>>> +.BR rtnetlink (7).
>>>  .SH BUGS
>>>  glibc 2.1 is missing the
>>>  .I ifr_newname
>>>

-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
