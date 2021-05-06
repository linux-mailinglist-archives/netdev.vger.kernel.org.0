Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68303755CB
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhEFOmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhEFOmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:42:46 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFDCC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:41:45 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso5083912ote.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bzaU7wPABkJIdBC657+8ohKvMkzFviJtl3hyZNnP51U=;
        b=ACBsZZtwC7LQLVCSnP5r1Xcik2D+jJJRSwkgnyQmRqklk+/2d5wuDc3anWsQ/oS7+L
         lZQVBDIpBsLw+hJxGqNcqDQwtagvCPiI5nd2jveDudIXs/cuwftaNngkLwkES6onJkHz
         trM0S7+/kWJrJqAcNx8IXzsXVEjwPFDusMoMlz7R6dVAgK0hg5X2r0NaPiWzGaRW9Vki
         tkAs36QCeKhsxd+jtBtRcQe00U19SvwiR2y3gH1Nh6BqHs5hwLssbcAhH7bvr4lv65Er
         f1U1jvhsYpPQ2Ar4G1f3K8rAoT1oBvGXnx4qcd/AQCofhcE6s2mcLTA2fjd9eYtkc5Zc
         EDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bzaU7wPABkJIdBC657+8ohKvMkzFviJtl3hyZNnP51U=;
        b=hgsiDzTkCtSXblEZLjCEGng/M7NbcZLU6BZDhNApiMzvaQNz/Lg0cBmRS3y4v4q0cN
         FJns1IclxqmrOaE4J18qrNouarN0gEq7/sHRppP5LlEJcjdSW2sRFD6dgSXSfNKqHvsp
         kgWC3CvaXKS4pzl4ZLh/QreO8T4e57tRy4f2fNo98nTmdJ9ZQKOK/oKBmDimVMQnWVLM
         L2vLKDkcLIut7TPOHmD6iWzdZnGgGCB5l/6z4UEUUVVQdr0M8u6l6TFUxTwmK1Awv8Ww
         dOndKKL1fwN0Ijc9e91uxcU2X2DU8juHVWVg07PZIdUZD8DEMddnJwDOcx9baDZhIQTX
         zkZA==
X-Gm-Message-State: AOAM533Ns82Qt3nLHPmyVOktWXI54ZsDAXBFckiqtcdElBatD0KDHOA0
        wAZcnQcwqf5tqhjv4aQ0kN7c8xoSrgM=
X-Google-Smtp-Source: ABdhPJw/Z/fFp+JR/ZbDX7B0EnEjXZF85WfWQZ7uMhCVbluywG16Bf6D/BOBj6gXIbtievd6SZ5zzQ==
X-Received: by 2002:a9d:77c7:: with SMTP id w7mr3965551otl.131.1620312105056;
        Thu, 06 May 2021 07:41:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:73:7507:ad79:a013])
        by smtp.googlemail.com with ESMTPSA id g16sm533260oof.43.2021.05.06.07.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 07:41:44 -0700 (PDT)
Subject: Re: [PACTH iproute2] ip: align the name of the 'nohandler' stat
To:     Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20210501030854.529712-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <59b67304-8d62-2ee1-6150-8fc6e0579d79@gmail.com>
Date:   Thu, 6 May 2021 08:41:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210501030854.529712-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 9:08 PM, Jakub Kicinski wrote:
> Before:
> 
>     RX: bytes  packets  errors  dropped missed  mcast
>     8848233056 8548168  0       0       0       0
>     RX errors: length   crc     frame   fifo    overrun   nohandler
>                0        0       0       0       0       101
>     TX: bytes  packets  errors  dropped carrier collsns compressed
>     1142925945 4683483  0       0       0       0       101
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       14
> 
> After:
> 
>     RX: bytes  packets  errors  dropped missed  mcast
>     8848297833 8548461  0       0       0       0
>     RX errors: length   crc     frame   fifo    overrun nohandler
>                0        0       0       0       0       101
>     TX: bytes  packets  errors  dropped carrier collsns compressed
>     1143049820 4683865  0       0       0       0       101
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       14
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  ip/ipaddress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

applied

