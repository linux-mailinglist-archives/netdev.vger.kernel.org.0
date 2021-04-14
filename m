Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB25935EB74
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhDND3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhDND3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 23:29:22 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30238C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 20:28:57 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id k25so19223587oic.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 20:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w+wKPsBndIAk59kUjztAbwdC6NY3tfBVe4Fkw5UECpI=;
        b=FNYm8R2ZSyaIGNUFaVjYIuACF1aN6h07Ur1nbAx4fTDUz4vo1EDhsGdISdnxSa55+J
         UpdsuBQs/jRdICC708FjjO+iyplQieUjavaQqSMUEIsGQ9+q1P9dLrm3o+ndPRoZN/TU
         Conll7br4lBsA/4IhyLooSKaQH0A+gP4JB2rqCrLj+PhUEls8eKwWRh5HHVEgvV7zrOE
         FKxLnufnbi58GadEsGULD8KMlP+OZPpBBHWsBIE3EkIrTIFG/Bj3M/aYpP92t5jhFhEt
         BTS9l1Vxy8mndbZ9YKj3jziAD1uGC6lsPmVr9HaqgQS1us3p42B3K5rQOw/1SdZNfcTf
         j0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w+wKPsBndIAk59kUjztAbwdC6NY3tfBVe4Fkw5UECpI=;
        b=ToZuw8LRwvaMWPq00j3MPxfoPKMFmJKTzCxABDbz8auEAriQ3O3tcNS9GSfFSmFGbt
         W57E/FEERjHZf4zvyIiGSxkuUsq9OO7lAWNIS0LStddk2tyJ6vHjoCbJ3dFI8xMvDrnU
         3w85YV0LQp69gxbXclej6vjskvUqZtqOsrW1N4io6scgCVRDIIiCNwUWO4KTDljCWGo3
         Sf2Oc8Wxipqc6d4djHQ2Z6BAuHmi7Z3kQV+9CofFWpwqfCNUuyD79g/Sl0n5Z0djgSID
         fgI5zFQk9N+i2vJcp0WQOWYtYMQwceTqAfu0vyg+RnSJm0az/VdUdctyiS9eowxCNnz7
         0sYw==
X-Gm-Message-State: AOAM533zHFEL/n1+ho8yEKryIcz7N4upAbmqywpArJPkdQAGgbBOOF3w
        4gvWV6nTGUUuH+mXvxrkIf0=
X-Google-Smtp-Source: ABdhPJzjbOneb1PqqE2ZxVRHFnbSW4aJajvUg3qOq6MBpTZGbI1NZAXKM2/Z8/A5qqTyW/tam8QRew==
X-Received: by 2002:aca:4188:: with SMTP id o130mr763004oia.101.1618370935962;
        Tue, 13 Apr 2021 20:28:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.157])
        by smtp.googlemail.com with ESMTPSA id w207sm2940892oia.48.2021.04.13.20.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 20:28:55 -0700 (PDT)
Subject: Re: [PATCH v3 net-next] net: multipath routing: configurable seed
To:     Balaev Pavel <balaevpa@infotecs.ru>, netdev@vger.kernel.org
Cc:     christophe.jaillet@wanadoo.fr, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <YHWGmPmvpQAT3BcV@rnd>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08aba836-162e-b5d3-7a93-0488489be798@gmail.com>
Date:   Tue, 13 Apr 2021 20:28:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YHWGmPmvpQAT3BcV@rnd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 4:55 AM, Balaev Pavel wrote:
> Ability for a user to assign seed value to multipath route hashes.
> Now kernel uses random seed value to prevent hash-flooding DoS attacks;
> however, it disables some use cases, f.e:
> 
> +-------+        +------+        +--------+
> |       |-eth0---| FW0  |---eth0-|        |
> |       |        +------+        |        |
> |  GW0  |ECMP                ECMP|  GW1   |
> |       |        +------+        |        |
> |       |-eth1---| FW1  |---eth1-|        |
> +-------+        +------+        +--------+
> 
> In this use case, two ECMP routers balance traffic between
> two firewalls. If some flow transmits a response over a different channel than request,
> such flow will be dropped, because keep-state rules are created on
> the other firewall.
> 
> This patch adds sysctl variable: net.ipv4.fib_multipath_hash_seed.
> User can set the same seed value on GW0 and GW1 for traffic to be
> mirror-balanced. By default, random value is used.
> 
> Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
> ---
>  Documentation/networking/ip-sysctl.rst |  14 ++++
>  include/net/flow_dissector.h           |   4 +
>  include/net/netns/ipv4.h               |  20 +++++
>  net/core/flow_dissector.c              |   9 +++
>  net/ipv4/af_inet.c                     |   5 ++
>  net/ipv4/route.c                       |  10 ++-
>  net/ipv4/sysctl_net_ipv4.c             | 104 +++++++++++++++++++++++++
>  7 files changed, 165 insertions(+), 1 deletion(-)
> 

This should work the same for IPv6.

And please add test cases under tools/testing/selftests/net.


