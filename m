Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09B03DEE34
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhHCMum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbhHCMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:50:41 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53462C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 05:50:29 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z24so19674586qkz.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PepLjEmjA+3NniRM+4NQ2XwzUjCl0m6eM3ogl66GoWs=;
        b=JMIcSawo/AF/9g7dk+nSyVoTUJhG+0d6Ocxw/QvQZONd9XVdrP9MQExM5HiNQTeDRT
         n3yrtwIboDEC0NQsY1e/MLDUdAbBK7Y7a5OUxOZHDTAqyv8IkC3ZN6w1etgOk+oBMHMi
         e0G0xJG1BzUdPUk4iKJ7YIWNvbcNlqKmkol4svCmzA0KEvlzUm4tm/mn+KsbmAiWaCG0
         DwGPtePBADOzD1SF1hxLeu/MJGai32eOe+TajIo3Spjqb7a7gKpphKB9+tVSSZl5Z1Uz
         e2N+AoX7jb31XWckIm8AasjPuzAkunCVQwLl1xNI0aXk5+WzSicljNdSBr2HaN6/BXJ8
         zM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PepLjEmjA+3NniRM+4NQ2XwzUjCl0m6eM3ogl66GoWs=;
        b=IKu9qEoMfyPcGsZVfeQvmKtYt3Hci8753M9GbFW2GdSyPXgJ/vTo76qhXkGwlout49
         5n6KZ08fTVBAmj6RAIrd5G9hJEkCqabsaS0cz0/QdticlXpavx14wD681l79v7vxgBs+
         moSKNSceW7wzDCDvkll8nNwa0YqS/s76leQe4Cu6lgaaSYAHhR/jui9unHo5dffRzWhg
         99VbqwbZWDV9dLSuhsmM+4El8WhpKbfHPyITXBEo/hEd3rBDKP5SmlqhSDpjYqktReYv
         ab0eN8dtxTl0F3dqz2sjycm3HZTHpXyR2S5vb5mKYkZzLge9mcxb4EwF8qOIVFlwXsn6
         Ljew==
X-Gm-Message-State: AOAM532L5iZzUofGNZXS67AGCNU4VvSGsZ5t2yg7ACzl0RIhzoBmQbqW
        SGANq/gh9VOUdKRc/ElhEnOcKQ==
X-Google-Smtp-Source: ABdhPJyG/6WtPsK6lD4EAaWApEk+DeInq6wNOQEOptJwPc8hQ6ng0H1NqJQL9m0EOP1EcDTN2m5faA==
X-Received: by 2002:a05:620a:903:: with SMTP id v3mr19949626qkv.235.1627995028591;
        Tue, 03 Aug 2021 05:50:28 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id r4sm6138655qtc.66.2021.08.03.05.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 05:50:28 -0700 (PDT)
Subject: Re: tc offload debug-ability
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <ygnhv94sowqj.fsf@nvidia.com>
 <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
 <996ecc2d-d982-c7f3-7769-3b489d5ff66c@mojatatu.com>
 <ygnhsfzqpvwd.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <092765ac-ffc6-5ccb-2dff-46370edb2e44@mojatatu.com>
Date:   Tue, 3 Aug 2021 08:50:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ygnhsfzqpvwd.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-03 8:14 a.m., Vlad Buslov wrote:
> 
> On Tue 03 Aug 2021 at 15:02, Jamal Hadi Salim <jhs@mojatatu.com> wrote:

[..]

>>
>> So unless i am mistaken Vlad:
>> a) there is no way to reflect the  details when someone dumps the rules.
>> b) No notifications sent to the control plane (user space) when the
>> neighbor updates are offloaded.
> 
> Correct.
>

Feels like we can adopt the same mechanics. Although, unless i am
misreading, it seems Ido's patches cover a slightly different use
case: not totally synchronous in successfully pushing the rule to
hardware i.e could be sitting somewhere in firmware on its way to
the ASIC (and at least your connectx driver seems to only be
relinquishing control after confirming the update succeeded).
Am i mistaken Ido?


cheers,
jamal
