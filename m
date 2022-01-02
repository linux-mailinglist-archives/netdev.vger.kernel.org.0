Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EA3482CF9
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 23:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiABWVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 17:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiABWVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 17:21:36 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8431C061761;
        Sun,  2 Jan 2022 14:21:35 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id r22so53211775ljk.11;
        Sun, 02 Jan 2022 14:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KV6JjPRe31wWSA2vdPikR0rw/SIDmr8VFEMbJalDcrc=;
        b=KI/M7iOY2gYCBJXT+C+bOW0dc7REzvKcjrhXE0ejMunOEJhK+d6OyEVoESx6F61vYx
         RdScJJ+j6LXCxTHD6rb3+zygVBPJADm+bE8AZx5INGCAhX37/g6vA/PymdbNm5+xg3eK
         CfPsDLJJ0nIYCLVJ2UNolGJ+FHvN9nyVXBqUzbYLSdq3uyhxcnz8JR2hDNW/01m8FjPL
         I3MIoDj1RjQZja85nLH2E90Yz3f5KTstHJMM1BECijPjqC2r+btnbe+6eYTf14W33BPY
         lm5zFfq68k2FpNdE14eP99amKGhNPFILdpKEC6KUlhTXaX3pH7puhlL2l5UpdEzrjPYj
         10Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KV6JjPRe31wWSA2vdPikR0rw/SIDmr8VFEMbJalDcrc=;
        b=uTOSX39yH7G8lKb5b+ZxNIiW9A9howJMMqP3mCplCWtfu9zcKTvE0NevkZInKtBUkt
         9UbaxXzQtHkjCDT/5Jfj8UnD6XgymtbjM7xtZBLNJpKjsCtQk8uTkCfdhlmP6WPjq1c7
         gtPB5Bh35dS6GRL7X38yrAlnCvZuxyp+8AcVIe0p+W09p3b9wzPb8cCk93eoIqxaxwx9
         rYhWzcWtDBXVIZULLzfR1rewYc0GVNNAokTYrNEngzMwwSdwnMO5jOboLl3YT0F9/4Ab
         VlOuf6KF++iHFSlFWyc64fMDPmB7WL7cdGPaAeDf1nr4ctZ47muyioXZSvkPd+Wvdv+P
         sNag==
X-Gm-Message-State: AOAM531KZb+V5pyIYeQYjbjYUf8wUYwtpdaBEeNTVSlITmFVKb8uqRD6
        Bg9u4J3T4lfqykiRbWp7ZoQwjL+flU0=
X-Google-Smtp-Source: ABdhPJyNWxjAqH4qq4FVJDqCnL8zYQkh/gj6v1iHSuUEnYoRiGL0MMwRdP+pZFj4+qlB/NBN4ilp9g==
X-Received: by 2002:a2e:9f15:: with SMTP id u21mr34720542ljk.9.1641162094091;
        Sun, 02 Jan 2022 14:21:34 -0800 (PST)
Received: from [192.168.1.11] ([217.117.245.177])
        by smtp.gmail.com with ESMTPSA id f19sm2560715lfv.100.2022.01.02.14.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 14:21:33 -0800 (PST)
Message-ID: <81467464-630a-25c4-425d-d8c5c01a739c@gmail.com>
Date:   Mon, 3 Jan 2022 01:21:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com>
 <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/22 01:15, Alexander Aring wrote:
> Hi,
> 
> On Sun, 2 Jan 2022 at 12:19, Pavel Skripkin <paskripkin@gmail.com> wrote:
>>
>> Alexander reported a use of uninitialized value in
>> atusb_set_extended_addr(), that is caused by reading 0 bytes via
>> usb_control_msg().
>>
> 
> Does there exist no way to check on this and return an error on USB
> API caller level?
> 
>> Since there is an API, that cannot read less bytes, than was requested,
>> let's move atusb driver to use it. It will fix all potintial bugs with
>> uninit values and make code more modern
>>
> 
> If this is not possible to fix with the "old" USB API then I think the
> "old" USB API needs to be fixed.
> Changing to the new USB API as "making the code more modern" is a new
> feature and is a candidate for next.
> 

It can be fixed with the old one. Something like that should work:

-	if (ret < 0) {
-		atusb->err = ret;
+	if (ret < size) {
+		atusb->err = ret < 0: ret: -ENODATA;		

But I thought, that moving to new API is better fix, just because old 
one prone to uninit value bugs if error checking is wrong



With regards,
Pavel Skripkin
