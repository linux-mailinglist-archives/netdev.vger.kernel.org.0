Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F6629119F
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 13:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437377AbgJQLXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 07:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437364AbgJQLUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 07:20:55 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02185C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 04:20:54 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z33so3174186qth.8
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iO43315qBfYGtGokZ+gPkiWt6oTytvXYPKts7n4ZNK4=;
        b=bdq6U5cb1D+ENXQ9bu3KYdHbpGZCAt3FR4a3WYe9rQZ31TxAUXA+GPe85Au3IJ+ycC
         uKI6GdrMYwjoIq8J2NFuoQLGcKK/D1+0+LMKwrQR/ZW3COVHeFYLlgfVpwyWYbJ8ACFj
         +OH3gyJdKdvFEEmSxEugri5W7mzMCFWTOc41+wh5CXjZb6MsfwlV0uEPeJzXHleCZLOd
         LUF8YdWwTXCYr6eJ8zahPzlHNcWFFdzPw+lgzhfrgmIRTGEhlvFGjDz1mjywjGRZFSCK
         H5hif8BFHAouBmuHp//JB8HoyWhv2lynoEWGYwTYhyqzi7ILi7fhvbZz3Yb+J3d4A52b
         R7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iO43315qBfYGtGokZ+gPkiWt6oTytvXYPKts7n4ZNK4=;
        b=Bb5sKwQyFMX5PP0fNzXG9iyjIs0ZfIqLbotBiGbvlQPqswATLQvZKJ1tY0gU9HMjdu
         nz9uoxhBZJ8+/5z8y2r86lWS700X5GhbakrcOLC9g8tFpczHXLlGVmqXSt3FTPmg1IAT
         zAa4rQR7fL6JMmlIGukfX+574dPHUFsKIHREmGkvI/h7H6CMZAlr+hs+/lM8bKJGdr6Z
         Q9F5h0twhDz7sKslCn7UDH+rQlhDLQu1vMy1TU+PjULQGRHSjIjkFwfU5hHzuRPCJvgF
         GODef4r0Et9SzfWSt5noLuB7qAU5rjPOplGjslyEmUtwJ1recMe/Q9qq6IkZgTWDmxUo
         fQPw==
X-Gm-Message-State: AOAM533PAPsoy9oDr6PzRgAqqPcUQgdwLaOtYQb84a8y44dLxFHcNhT2
        H6Q+0GB/q5ns/xF43ow3j4JLCQ==
X-Google-Smtp-Source: ABdhPJzrN0WYevZbugupMFviYq39+gS4LKd59UwdgNtR9HmXGfAz5J3Bv+wI7NKxXlj+uxd+8cPobw==
X-Received: by 2002:ac8:4295:: with SMTP id o21mr6859607qtl.313.1602933653975;
        Sat, 17 Oct 2020 04:20:53 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id n7sm2040431qtp.93.2020.10.17.04.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 04:20:53 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
Date:   Sat, 17 Oct 2020 07:20:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87a6wm15rz.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-16 12:42 p.m., Vlad Buslov wrote:

> 
> All action print callbacks have arg==NULL check and return at the
> beginning. To print action type we need either to have dedicated
> 'brief_dump' callback instead of reusing print_aop() or extend/refactor
> print_aop() implementation for all actions to always print the type
> before checking the arg. What do you suggest?
> 

Either one sounds appealing - the refactoring feels simpler
as opposed to a->terse_print().

BTW: the action index, unless i missed something, is not transported
from the kernel for terse option. It is an important parameter
when actions are shared by filters (since they will have the same
index).
Am i missing something?

cheers,
jamal
