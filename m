Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB9B306BE1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhA1EGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhA1EFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:05:32 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA19C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:41:08 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h6so4636752oie.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RGmZt0itmBSdQmhxjYxT3I4pwbYM2Z33f0kt0A1ALQw=;
        b=lA8GYwS7SbdhDxp+yUfb+5e/ahpNgxmui1P7RVXpKoZ0f1CF+DYsM4dNdedbwQM7U5
         KnwpALTT3LTToNWsddhyRhZN7/SnVVesSIV4u6I0xLbsyH3WVMJ1JlpQcdD2bRgo4r4B
         MslrFyrQXbw32FT20r+aO+HTH4fGL7gid/dWOmAqtJ0g/i7T8Op7r98ZZv8fSxg9lN6c
         qnqKMJ4/bDpkyuL7EFl8hm9tqC16E5dTH9xgpBbfWT/FpbqaEueUocu+tzryp1FCUAdT
         ar3cQngqJV7PnZ7/Z9NFF4ezwy4gSf731TwnhcUUhtOde1CyxsWgWfyRRmPCLuxjyH++
         L7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGmZt0itmBSdQmhxjYxT3I4pwbYM2Z33f0kt0A1ALQw=;
        b=jdcvsNE3geJ84J/pwIIcSHzHQQQR23WwosZngr/dk5i7Q4kvGff1dUWhCEpVkYzqaW
         GWl6fmWJVoGJdVc8asvbtcUHX0fS8X7rELtqEOjLElOniuYoWbHmnZrRUQ91LkZtnsnm
         oTSzVQy0KeBeYsZ+FKKvg3FyryyvaSa7zasjWJXtgwNaQBeSvXCrb/XauqCGBT5fR0XI
         H/RcGCDC62VdAO2kYSdAddGucYdD1F4WHvfM0MBD91GDpSLX+KLfsUXWTfiWRXesqU2S
         Vt1Asa1ljVY0O4n5kUB6z0xsm2q1smSlc17iUYaMNrhpoF5VW7zWxR9jfEPDI0BE1h0W
         IIuQ==
X-Gm-Message-State: AOAM53287ggwqZzyAsutVhwW6A8tMAfsy7gUDXDoaMqa8Z+vroYX5Yfc
        XL4BvCA9TEmZmqcUjK3gfBM=
X-Google-Smtp-Source: ABdhPJzbtZlQIhd/grcg5PepQG1Eu7NHbOn9ofwliLMELKC2LhNqfX7n4xURXN8HXakdLOOaWEFY+A==
X-Received: by 2002:aca:1807:: with SMTP id h7mr5356373oih.47.1611805268296;
        Wed, 27 Jan 2021 19:41:08 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id s10sm863658ool.35.2021.01.27.19.41.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 19:41:07 -0800 (PST)
Subject: Re: [PATCH net-next 10/10] selftests: netdevsim: Add
 fib_notifications test
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        roopa@nvidia.com, sharpd@nvidia.com, bpoirier@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-11-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d36d0e07-afbc-2cf5-1fde-0f1e381e5103@gmail.com>
Date:   Wed, 27 Jan 2021 20:41:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126132311.3061388-11-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 6:23 AM, Ido Schimmel wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> Add test to check fib notifications behavior.
> 
> The test checks route addition, route deletion and route replacement for
> both IPv4 and IPv6.
> 
> When fib_notify_on_flag_change=0, expect single notification for route
> addition/deletion/replacement.
> 
> When fib_notify_on_flag_change=1, expect:
> - two notification for route addition/replacement, first without RTM_F_TRAP
>   and second with RTM_F_TRAP.
> - single notification for route deletion.
> 
> $ ./fib_notifications.sh
> TEST: IPv4 route addition                                           [ OK ]
> TEST: IPv4 route deletion                                           [ OK ]
> TEST: IPv4 route replacement                                        [ OK ]
> TEST: IPv6 route addition                                           [ OK ]
> TEST: IPv6 route deletion                                           [ OK ]
> TEST: IPv6 route replacement                                        [ OK ]
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  .../net/netdevsim/fib_notifications.sh        | 300 ++++++++++++++++++
>  1 file changed, 300 insertions(+)
>  create mode 100755 tools/testing/selftests/drivers/net/netdevsim/fib_notifications.sh
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
