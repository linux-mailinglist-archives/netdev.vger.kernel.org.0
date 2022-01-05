Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3EF485A58
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiAEU6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiAEU6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:58:07 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED8FC061245;
        Wed,  5 Jan 2022 12:58:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id k27so833504ljc.4;
        Wed, 05 Jan 2022 12:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=OuBwVyhaLKrzX8V2kCywchmIuhlf+ueUVQIdWaq/xTo=;
        b=gN7fMUeZLlKceIPR9LV2wKCRlYF7itBA0+qZ0gBl+jrnEjUYfw1S0mlH1prEU4jzZo
         qqPD/KKQbCC3S8i10PlUMjYbg5+ns2HwD91GSjtJ5DW8gEi0jXQT2Ra3HRUPjGRdynqm
         2t+3KJ+gdTpRBvDK9RV+UNX2ol9aFlZImRGtJk6/oYJz7oBlqaDE73juZ9xLr6LhXBb2
         Tshoqv9Z5Mo3Y8vHlVQAw+qhTxwNO4EWa864qDk74zmzgqZNl5LeQir/gYqeP79g/ycx
         CfElcKeg2glHc7M9ar3w9RbqhheoabiT8vJSIGSv7R55XbCPbePWEOleO5Q2kiybSzcR
         vD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OuBwVyhaLKrzX8V2kCywchmIuhlf+ueUVQIdWaq/xTo=;
        b=VCnib2MzydqyylmMxlmntS5o2jE0tU912kqLpjD1/WrzGg/Wffv5cMEmPN9zhd1uI5
         c8PgFSoDxwYH/jKewWyAw0gK+LCUrLPlGQKiKroyH7/JKuRBBl5FFLp986uDzhL11d1O
         UVVXQd/7feujRNV3+JqnBLbNm+ubPpnmZDG4vK2gS/7JSj8OP56w6TUdGsJ1iF9nGzoG
         h95RluMRvqGolQ1bFYYRJwVVdNTDgJvTWgW+HO7C6CyjR22dglBMliLQ7zud4NOVTvtu
         C4R2xuQyfRP3i7sx1IbwnsdOBQjNRcZIjxWvo7U8BwoSDGEz2cvy40whOKCaBQNdusRJ
         agOg==
X-Gm-Message-State: AOAM53219/rqKX5aA2TspNT9x3LMsYVokmcwr2/woMGUpX9HiiI6A7D1
        1fEBlSqYv3baVIljYAFL+7Y=
X-Google-Smtp-Source: ABdhPJwTKKy1PKfhf5An5kszlTKHG1YQ2C+JWzaDKi1CXN3/nZ66eYhaGh5+GtONrjCdnriMXb2Ddw==
X-Received: by 2002:a2e:b5a8:: with SMTP id f8mr48237403ljn.130.1641416284784;
        Wed, 05 Jan 2022 12:58:04 -0800 (PST)
Received: from [192.168.1.11] ([94.103.227.53])
        by smtp.gmail.com with ESMTPSA id l5sm2488lfk.167.2022.01.05.12.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 12:58:04 -0800 (PST)
Message-ID: <8da136c2-a4f8-bc3b-7c61-de29217153fa@gmail.com>
Date:   Wed, 5 Jan 2022 23:58:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH -next] ieee802154: atusb: move to new USB API
Content-Language: en-US
To:     Stefan Schmidt <stefan@datenfreihafen.org>, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220105144947.12540-1-paskripkin@gmail.com>
 <4186d48a-ea7e-39c1-d1fa-1db3f6627a3a@datenfreihafen.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <4186d48a-ea7e-39c1-d1fa-1db3f6627a3a@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On 1/5/22 23:27, Stefan Schmidt wrote:
>> +	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
>> +				   0, RG_PART_NUM, &atusb, 1, 1000, GFP_KERNEL);
> 
> This needs to be written to &part_num and not &atusb.
> 

Oh, stupid copy-paste error :( Thanks for catching this!

> Pretty nice for a first blind try without hardware. Thanks.
> 
> Will let you know if I find anything else from testing.

Ok, will wait for test results. Thank you for your time ;)


With regards,
Pavel Skripkin
