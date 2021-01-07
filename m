Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729682ED434
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 17:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbhAGQXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 11:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbhAGQXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 11:23:33 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FC5C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 08:22:53 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id 15so7941726oix.8
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/Pz08p6ac7rZJxvLPhpu9wNS2TmL4BdD3vdITJdwcc=;
        b=ehtImW4QcOdiJEUjwa8Ag4XEU3tklRns6kb6fN6dgyXJ7Pj1ZVfSbcNjWqpOwCHkdP
         odvIuPx8HrajxrAAjq01Gm7mt1rDFiQUp3dqlGmLdBOAJf44YgzDUcwufkzW809s8hpL
         4ypP8nDW5FiMH/5HHn7DHOxVtomNIXhj3RLQCyshfC3ZbkM4RIFf9vHGBm2tvCdOF7fG
         +bBmt6MU2VLArpgqEDeqAVo7t6KcQcqd0KcFAUJMPdGsRoDytP9ZQBD7oxeEIq8wH7IK
         QCH6nZmn7eWB0jd3hVqTYPgpztAdEQDH9R600dm4nePhiFETPjlYWm1pjVmRQqba5d3G
         b+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/Pz08p6ac7rZJxvLPhpu9wNS2TmL4BdD3vdITJdwcc=;
        b=mCYkuYQH3p92+CzMT+HfK3rj1A8VYs6YpvHjXRvvLgSWkbL/XIbZ6xiGSQMWcdP+/a
         cTDUIpHlS13F9w/QXpJu+yqq2eb8k3TiZ/ncH91c03FjSz5Vcmsh1dRlVgU3y9k2GAja
         1uaOsYoiZhQj8VRFYZ6p+kIsrZF6o8J6NF/aZfdz5lydKnQnS/e4JarI+L1ELLN+INyH
         7gaZ/b5PIaEEEI4w9lqxofITDncRAoK+XdLBNspDxUSK/0B1n2Z50eq+w5YHefDEvgsW
         YG+hbQvwjstyrMmUUww9XCGHQMGbS8M8cgTyPmhyY1CuI798vY5aE9EWeKqxmiJ9txg0
         LCPw==
X-Gm-Message-State: AOAM5308yC540V+W/2GMFRlUFrYhhaNXhxy5mEUmOLiGwlFbgdm0MAE0
        f0f9wBK6G8RgWGRtP8WezTw=
X-Google-Smtp-Source: ABdhPJwiUKSqLp+0+2j6/cx0MEcTwL1td1777aW0K0IVo8jSz4IUs17YVx9QdKRDockd9sZwa7xf3Q==
X-Received: by 2002:aca:aa83:: with SMTP id t125mr1753871oie.103.1610036572569;
        Thu, 07 Jan 2021 08:22:52 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:800d:24b4:c97:e28d])
        by smtp.googlemail.com with ESMTPSA id p18sm1212710ood.48.2021.01.07.08.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 08:22:52 -0800 (PST)
Subject: Re: [PATCH net 4/4] selftests: fib_nexthops: Fix wrong mausezahn
 invocation
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
References: <20210107144824.1135691-1-idosch@idosch.org>
 <20210107144824.1135691-5-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a7de9593-b639-17f9-c9ae-5dddedb10717@gmail.com>
Date:   Thu, 7 Jan 2021 09:22:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107144824.1135691-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/21 7:48 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> For IPv6 traffic, mausezahn needs to be invoked with '-6'. Otherwise an
> error is returned:
> 
>  # ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn"
>  Failed to set source IPv4 address. Please check if source is set to a valid IPv4 address.
>   Invalid command line parameters!
> 
> Fixes: 7c741868ceab ("selftests: Add torture tests to nexthop tests")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


