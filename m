Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7096D4245C7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhJFSPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFSPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:15:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FAEC061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 11:13:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso4554286pjb.4
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2UVThjs6N22U550Mo2V30F9ZIrLLiXfB+JPVaFF/Yf8=;
        b=flCoyeWQFu70C1vdgJi0QNDDxPpcFZVVEEAeP6c6oIovSgDu3Kgfz2biVR8CtZLB1m
         2+cZYH1QYl2PUvQHhnsukeMLuol4CRsielNybrdlPNeA68CRHVg8QyEcRZj8BEq1kWqz
         PanbHGpSi9tGNYMtQhb+iJE6Ex0NExo0EwqRNibpGLDBnOGRaztq27PK+nalIVYu3BMF
         mQTMJm6XV6MfDgg0XQfOOmc/QfNXTmxy+misSBL1kf0uQzQZpeNr0nXMuRcCbK4NsmCk
         HstmT3jZhWAB+DrbEb8esUxyRrqSpV1N8VDSoncQxF/9oULvCleb2KJ7ccKVwbdfuT8X
         sBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2UVThjs6N22U550Mo2V30F9ZIrLLiXfB+JPVaFF/Yf8=;
        b=EdpuCkf/ybpd97aCe0MQe4k0Azl3nI9s+ndltvv17RD/Q5s+m1oBRdoo6hyth0pA6j
         Hl5INANDtGcAUt6Ht/DXvbOpYR//mdato/yU0kdrA/DdT3uIeWL02YMZyXSHmW0yPkTZ
         Hv5ceK36xMaUlKXe/AHdzKiw9I6B0k/800Yz2TumHc9rivmbXhm45W7oLhka3T7gQJBl
         aexVPSofrSBOYpFQO7lH6TXlkMdYVqsJkbXwqyYQ4Cc6xNvZCl8jjXJWrUcr9bCjKYuz
         7z+NfWh3EAVd628gQzEoFD3umqQXsNuxFYrFy93jKXiT6wkhJ0cq8irjOtsvajC2kli2
         JawA==
X-Gm-Message-State: AOAM531/Xb+uwaHW6GT5YddnBvQPaYqSFx7XKF+HC+bAL2CQ/QlVX0lA
        mamt/B1/5djnmO5nK4TmV0oGqg==
X-Google-Smtp-Source: ABdhPJzwOdS51cEuBF7ySwIE4r6e5mlBmEShwuingX49s48Eg4RnigE9f4rseHiHs1515C25Y4FRUg==
X-Received: by 2002:a17:90b:306:: with SMTP id ay6mr222134pjb.58.1633543995320;
        Wed, 06 Oct 2021 11:13:15 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id v6sm21235156pfv.83.2021.10.06.11.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 11:13:14 -0700 (PDT)
Message-ID: <53aadbb8-54de-fc86-29a7-818cab80e808@pensando.io>
Date:   Wed, 6 Oct 2021 11:13:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        saravanak@google.com, mw@semihalf.com, jeremy.linton@arm.com
References: <20211006022444.3155482-1-kuba@kernel.org>
 <YV23gINkk3b9m6tb@lunn.ch>
 <20211006084916.2d924104@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7d33d634-a6ba-e189-b2a0-77cfcd3a8643@pensando.io>
 <20211006104911.17779805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211006104911.17779805@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 10:49 AM, Jakub Kicinski wrote:
> On Wed, 6 Oct 2021 09:55:59 -0700 Shannon Nelson wrote:
>>>>> -	if (!device_get_ethdev_addr(dev, ndev))
>>>>> +	if (device_get_ethdev_addr(dev, ndev))
>>>>>    		eth_hw_addr_random(ndev);
>>>> That is going to be interesting for out of tree drivers.
>>> Indeed :(  But I think it's worth it - I thought it's only device tree
>>> that has the usual errno return code but inside eth.c there are also
>>> helpers for platform and nvmem mac retrieval which also return errno.
>> As the maintainer of an out-of-tree driver, this kind of change with
>> little warning really can ruin my day.
>>
>> I understand that as Linux kernel developers we really can't spend much
>> time coddling the outer fringe, but we can at least give them hints.
>> Changing the sense of the non-zero return from good to bad in several
>> functions without something else that the compiler can warn on
>> needlessly sets up time bombs for the unsuspecting.  Can we find a way
>> to break their compile rather than surprise them with a broken runtime?
> I also changed the arguments in v2, so OOT will no longer silently
> break (not that it was the main motivation ;))

That works - thanks.
sln


