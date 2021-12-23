Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75DE47E93D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 22:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbhLWV67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 16:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240782AbhLWV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 16:58:59 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C116C061401;
        Thu, 23 Dec 2021 13:58:59 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y22so26426123edq.2;
        Thu, 23 Dec 2021 13:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=tHmZrintmsfr/VUUizaz4/mfgzPKrPwPFlMKH0k4wW8=;
        b=ipD+HLnlhbtF6BV3FwaIg6tOcqXdp69mRp4zQVgF2PPERKLDZvuhKmjRZVzdMxAvY5
         d+8U6MMfdpx5w13OLnFpn9dDTFWTckl4I1cAxClgpuSB7y3F6HeBe3toAhnvyWP5UNZu
         5hojP4ilGIcfK5AyhYWN5uaZbv4PTCGLZqCO3zlShYz8LvoKdx9AgqqyoNltCp7Sj6H9
         JCXGKIJcJ4VtIon+I93Do/vBx1UCZnSJQZkoLKtQW256JYL6pTcAWG1pEYtEwp4+W9cw
         qYDs22587Fedpgyp0ci35fRY8wGxC5hpEjU1xFlv6uiyUsgQ0kA4RxyUKHngMvWahvNS
         gFZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tHmZrintmsfr/VUUizaz4/mfgzPKrPwPFlMKH0k4wW8=;
        b=iZDDVWvUNDcs6h+GTwGDQVPNH8ESnZnf+1JrNeWcuEqOKaxHSspvuucrBfMjXLaJJ+
         Fm44sXXfp35QQrYEEEv0oc/T8KVWQpnnvHwTT6nJAr3MfzYBnQESf4Cx2drfGAfqptWp
         3dNchokqhad7WqjqHkV/y+hu3W/4CTOMeT+0S07dH1kQi4SAG3lxy90Zmeq/i5s1wXSN
         dCxbi/8kNKL+uumilMLKxg1+yBASB/sCMP/Jw/nVgheN619wVHamvuixIgvRELLVHTsC
         JGq5W+VOVpFQoJpcOzxm7/hbc4W6kHDT7Cd+8gV3cwlbrZ2RLWC7z/FUb93lo9feoIya
         Ewfg==
X-Gm-Message-State: AOAM530GEP77JMbhf2XeUIf2R2ppMTM2tBW/fKA0vX7+ZK8zmGdxH7Ev
        hdp6oOGJTDCYy34RITOffxbOssF6Tlk=
X-Google-Smtp-Source: ABdhPJzBQxAu318JRQ9x+W/KUbHqz2Qhd+rfY/gTD5nSlsGqJ/FRrGyV/k+ErGGpME4ZLkuB4rzx6g==
X-Received: by 2002:aa7:d2d1:: with SMTP id k17mr3650108edr.250.1640296737531;
        Thu, 23 Dec 2021 13:58:57 -0800 (PST)
Received: from [192.168.1.41] (83.25.198.180.ipv4.supernova.orange.pl. [83.25.198.180])
        by smtp.googlemail.com with ESMTPSA id gt17sm2116379ejc.151.2021.12.23.13.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 13:58:57 -0800 (PST)
Message-ID: <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
Date:   Thu, 23 Dec 2021 22:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211223110755.22722-1-zajec5@gmail.com>
 <20211223110755.22722-4-zajec5@gmail.com>
 <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.12.2021 22:18, Rob Herring wrote:
> On Thu, Dec 23, 2021 at 7:08 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> Not every NVMEM has predefined cells at hardcoded addresses. Some
>> devices store cells in internal structs and custom formats. Referencing
>> such cells is still required to let other bindings use them.
>>
>> Modify binding to require "reg" xor "label". The later one can be used
>> to match "dynamic" NVMEM cells by their names.
> 
> 'label' is supposed to correspond to a sticker on a port or something
> human identifiable. It generally should be something optional to
> making the OS functional. Yes, there are already some abuses of that,
> but this case is too far for me.

Good to learn that!

"name" is special & not allowed I think.

Any suggestion what to use? I'm not native. What about "title"? Or maybe
"term", "entity", "tag"?

