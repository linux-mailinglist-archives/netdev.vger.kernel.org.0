Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB94E25EC18
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 04:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbgIFB6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 21:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFB6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 21:58:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321DC061573
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 18:58:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s10so2884378plp.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 18:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TjUJAmoGNFhUd9H5GcN7KblsjtZXG6sZylgWUDpMDmE=;
        b=iyIllifnApcPYoxh5ykWAvTEf1HyfejbI1IlCWDbe/Q87aHqGYgnuOLkMsOpkj0kt3
         i6KxB139YHWLzTfuJ98Y+MU4LtqHmXpFfM3/aX+S5cfKlmHsixNsse3WUXbU9fXuBwGW
         pw0jGceWmCrs2gzt5L3s3XZBMVpPZxsgLGQYBhk+6Inlc/fMT6PxJHvLGv3tF4djXdyc
         /KU0xhJJyOGG1M/fca9YK6jskQkjyNTwvOUv0d/aYwz3qtazRsj0c+w6d3mjdNKvsBjM
         sMIklL1xK9XXyhF2ie79uKqsFYFNJXtFNTQhnNvASNWV030kxIeEFJV5BmUr0EocQSbO
         aaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TjUJAmoGNFhUd9H5GcN7KblsjtZXG6sZylgWUDpMDmE=;
        b=reo7LDp7An5szwQeWmMre5FnCMhReiQLSUQYloWcm5hxr02J+dKoq8/z6nf9dOy08C
         7PeFw6dk3uC/Zn2Ix/U/1scCGGLD1mg7ZEqFn/iWCBBre1zPWl+LsHOBM+mCybjp3snl
         NVqDMbr1ySf2g1WZ+hthb9Vr47el/jcURUjEY4oqudtg5WGBM5feHqQDT/v/oZ4M777d
         LonxBZLI/aWssrw6Fg6s/w9wz3302IHoRP6Fn8q4R3Ygc8eqPVISid5gqb8DRUkGz5kz
         mPIwr0BIXYNM+n/yGonhEIcFeJSHqA9JYl+8tXK6+cG+V++zURsavOXN85BS8/U/C7ej
         +YEA==
X-Gm-Message-State: AOAM530DJP1BLC0E8R568v3kwhAuQIoZRGbY/76Z9pPOOjSYarbDiMMo
        uMhU/oC6dNc5kFGnz+mCv2+R3nGwVt0=
X-Google-Smtp-Source: ABdhPJxPeqX4UHvBKGgcxib3jFJ7/sSQzOOlKE1UqMucrl18zH0hyr5Ts2oJrNXJCfwJfA7SEZhPdQ==
X-Received: by 2002:a17:90a:81:: with SMTP id a1mr2475275pja.136.1599357490216;
        Sat, 05 Sep 2020 18:58:10 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 25sm3620526pjh.57.2020.09.05.18.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 18:58:09 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: rtl8366rb: Support setting MTU
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200905215914.77640-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8c5a87e1-a8db-3a48-8311-cf6537723de4@gmail.com>
Date:   Sat, 5 Sep 2020 18:58:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200905215914.77640-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2020 2:59 PM, Linus Walleij wrote:
> This implements the missing MTU setting for the RTL8366RB
> switch.
> 
> Apart from supporting jumboframes, this rids us of annoying
> boot messages like this:
> realtek-smi switch: nonfatal error -95 setting MTU on port 0
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
