Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84404280C5B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387571AbgJBCqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBCpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:45:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4184C0613D0;
        Thu,  1 Oct 2020 19:45:43 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 144so223752pfb.4;
        Thu, 01 Oct 2020 19:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O0Z5Xh7F8Sgunq9oXGphROqj/x/MPAfwrOrby64MrFg=;
        b=aWXdtf7me+ao/wzCMKLDegKTH9EqHO0YZSm6vUEXCoYrlT8HdBwV+vGlzfPNkHSqtr
         2Tk33pyqavIhxZwKegavQEO7UsI8RDlv1LPx+h6qeFRc3dgepCBmYrTGRiVo0qFdnZqU
         m/YwyS9S83q0v+M3hjC6cYRXKJgQN+mlOFkSQHoUX83upO+WP+m6EYtleqHb8MAMe/+i
         fpL3pfhQYpnCmpQEV20/0i58NaZCkPRL011lw28vxt4npPyf/RpBicbNV9U7EwGau6SL
         BZ5oZqxIw+MrQBsU1RIiGipV344YraRCSq8KVOYRSIZrrf1SfxmxXpdPGevWif0lMzlL
         VETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O0Z5Xh7F8Sgunq9oXGphROqj/x/MPAfwrOrby64MrFg=;
        b=T7OuhKIAqJ5wSSY0mMnVomvA6dJp/UgI8RJ20aNWSatejs94w4lXCXUiTW+Ufxc0SE
         W+mJYWWi3n5lDzGJgv26BgXcOHthsKFeizpuUyphqR9XgMF/HPXtsz3ngJlJ4adQMGq0
         Us5Xv3Ilfb6UFAMQYSb28lRzSljqDvmaoeSvarQT5u7jaNvWpE1x78dW99CoByRip1lz
         UmR4R0xeoz8kimXdzj6Bd3R+p4hJqKZ8Sse3rUkEB16BzrFonoJGPUdkyqv9NHg8MyFB
         ylUryjU9O26m4bFBrTPAooYiyyujMwZDOOKgCATq0uTdnbWGBDKcOTD9ESoUrfwEfcWK
         JJJg==
X-Gm-Message-State: AOAM532q+ECXXB8azBCOlpUTssaOQELactgC0GLeusshnFRhfCO3kUh2
        92YpwdAFSA0R0F/nutQlj6OHtkEFIT5cvQ==
X-Google-Smtp-Source: ABdhPJzKOX3oATYsOLO2ByPK6SGhrVxp8M3BBhRnnEtn6T7bkjkvqxNrZdYNZsIosJjWrVUcZM1VCQ==
X-Received: by 2002:a63:4459:: with SMTP id t25mr13497pgk.104.1601606743181;
        Thu, 01 Oct 2020 19:45:43 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i126sm7845882pfc.48.2020.10.01.19.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 19:45:41 -0700 (PDT)
Subject: Re: [PATCH] net/smscx5xx: change to of_get_mac_address()
 eth_platform_get_mac_address()
To:     David Miller <davem@davemloft.net>, l.stelmach@samsung.com
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com
References: <CGME20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e@eucas1p1.samsung.com>
 <20200930142525.23261-1-l.stelmach@samsung.com>
 <20201001.190539.943246074133907153.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6fad98ac-ff25-2954-8d62-85c39c16383c@gmail.com>
Date:   Thu, 1 Oct 2020 19:45:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201001.190539.943246074133907153.davem@davemloft.net>
Content-Type: text/plain; charset=euc-kr; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 7:05 PM, David Miller wrote:
> From: ¨©ukasz Stelmach <l.stelmach@samsung.com>
> Date: Wed, 30 Sep 2020 16:25:25 +0200
> 
>> Use more generic eth_platform_get_mac_address() which can get a MAC
>> address from other than DT platform specific sources too. Check if the
>> obtained address is valid.
>>
>> Signed-off-by: ¨©ukasz Stelmach <l.stelmach@samsung.com>
> 
> Failure to probe a MAC address should result in the selection of a
> random one.  This way, the interface still comes up and is usable
> even when the MAC address fails to be probed.

True, however this behavior is not changed after this patch is applied, 
I would argue that this should be a separate patch.
-- 
Florian
