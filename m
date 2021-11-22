Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6BD458E16
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbhKVMUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhKVMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 07:20:12 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8CEC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 04:17:06 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id x6so1273888iol.13
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 04:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LsmZyHguOS7mmAclBoJyBI0jnZksvj7/IhwoVpOwbCE=;
        b=lAGWbjlwxL6Kd0Lz2rqA+d/E9g3MMbopC7wkutoioIL8difr8AJEFTOyYCJkXI+d7M
         naCjxSiJZRxCk2Wjad0mFLdmajRKHNCD8xR6RUzGCM/vtndbLF+5kmjNg1UbaEMpBxSA
         4tffVzRoo3keagzfmiUEWGjq9vrj4jzbV2Lp+oUwe46y1tS1VYNILGdkqLPr9xTba8zv
         UTZKQFT46ztvTB/LBhQQC+7tPa1b5yMqLOOy6YaiN+L8KPYYKUv2wXaafVeOlXjvIcgY
         r515T4aJ0CfLMLGlhabn35fYCVpviCK3gx5XTyu7NKf7hbgw7/XW3pEG34LL5PFq7v4p
         nrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LsmZyHguOS7mmAclBoJyBI0jnZksvj7/IhwoVpOwbCE=;
        b=Hc2uDqQar9UX916LuSGD4389MtU3HCB9NG3NXFCC2qhtP5H7ZEOpsggYoP/neejgKq
         R3gkZLJ7aOkEeam2iGMifKkODBDlfF0K+WwZ6lBjUyaa1MQUkFQxG5iBrKXAFJX1syxH
         La0w9FXeHoqHkxdXZodxjSxVnQ4MB0OhqZEnyJ0xBs3zqI6EKihEVS4QbMxOe6HI13WF
         GgZVuUJuSiPnhvQ3RXYUZPGa9BoJvNE6C1A8GFqYqATeexE5F9JBf35owLvVDW23jWQJ
         2M584zjKM5u2P1HTRKJbNreOykVKRqLtEdFYPqx8jfBIPyK648vEwm2a9BVU5vTO/WRO
         GkAA==
X-Gm-Message-State: AOAM531OHfloWRgABt1/II+12+qMP31ITaL4IJQx3QLJCjK6t15U3sD3
        t7RcM9jvoq/pcf9Be39nDBhwCg==
X-Google-Smtp-Source: ABdhPJygT81ZalAc7udxUaNCVa3aJ3HqKp50nBuvnOezYCYrnFUMghlFwkjHBuUGeavFeSbX4lv4yg==
X-Received: by 2002:a05:6638:3899:: with SMTP id b25mr48993812jav.39.1637583424906;
        Mon, 22 Nov 2021 04:17:04 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id f16sm5269008iov.33.2021.11.22.04.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 04:17:04 -0800 (PST)
Message-ID: <d1a69d88-e963-a64e-5db3-735dad42fc4e@mojatatu.com>
Date:   Mon, 22 Nov 2021 07:17:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 net-next 0/10] allow user to offload tc action to net
 device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211118130805.23897-1-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-18 08:07, Simon Horman wrote:
> Tc cli command to offload and quote an action:
> 
>    tc qdisc add dev $DEV ingress
>    tc qdisc show dev $DEV ingress
> 
>    tc actions add action police rate 100mbit burst 10000k index 200 skip_sw
>    tc -s -d actions list action police
> 

Could you show the output above?

>    tc filter add dev $DEV protocol ip parent ffff: \
>      flower skip_sw ip_proto tcp action police index 200
>    tc -s -d filter show dev $DEV protocol ip parent ffff:
Same here..

>    tc filter add dev $DEV protocol ipv6 parent ffff: \
>      flower skip_sw ip_proto tcp action police index 200
>    tc -s -d filter show dev $DEV protocol ipv6 parent ffff:

Same here..

>    tc -s -d actions list action police

Same here...

cheers,
jamal
