Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5800533A575
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhCNPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbhCNPaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:30:12 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C12EC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:30:12 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 75so5914855otn.4
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RIz+ceBsuyDkoEtaQJAeLc83o7y2bmS/tcI2DveqB+s=;
        b=lvk/jbSaMWtwAF4CxPA6yMnHHIxI3/jJTjh8K9/JI/YRGLGwHyfoCx+GwI81GcyeEq
         AF/s5hjrKI6gAN0jz2esqekTuzcnDnfqaAfZcHHDCPy/u3V2RuXdp60kBeFdTFP7yIBr
         /7WmU0NqYCegXoYsQUYhg33dJ0FvshBZ4AqTYTcxDOK8jK96Fd34ABpr+VibXH4InOOn
         lQjf7y6GkcYcJYruCgrCUm9VbXi2qFjT6xYZ4LCxhT0J1PTqIFMVFWpW6cUzkQHyAY3/
         /G4cnzgKo6dBUVu4mg3SDf9hGzlnG/Qg+5XSqsj1xqVn4gt6NLG3y/g45vkiqGhA8usJ
         Ej6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RIz+ceBsuyDkoEtaQJAeLc83o7y2bmS/tcI2DveqB+s=;
        b=LGaE7LoRl2PAXLq5El3f17Pc3EHzz1GQ4Lna2tXhtYo8rMCQfmARa8wEaKrFU8OhW0
         Zbh7Omua6TQMzbppCOnC14jo2IyTWKcu/hVehwPKfapYBT6x2qzxzxaVOGBlvBYtx8L0
         vzbRpSVEAnR6sf/S1Lhg4pkN+cghXYHvpD4rsso3UkK8zqiymhmROSQeSNX6Z7MHaqgz
         hfSdrfKJR0nLthtzg/gBQPX9K3nxtZgJhWce5bxS8gUJ+z1PYbCyeb06eApIbL78w+lh
         9iRsYpjZgTvV8qw0zeEYx5bHK+yC1sfDQfwOd+pfKUKtpBLvZ3kcazzWeXY+8ih5VIGa
         tvYw==
X-Gm-Message-State: AOAM532gJz9na28EU0dy4fBmfnIqnziZ+X4xP0d+KO3HAoTSc3pS61f6
        gGr6sF4ani0sbMFehARQYDI=
X-Google-Smtp-Source: ABdhPJxtHE57ucHcZL/78iD/sX2eii8Gqae7jthJnn3mDiyouB0y4ivACv8shXShXmlrVU/HmD4DOw==
X-Received: by 2002:a9d:921:: with SMTP id 30mr11044131otp.49.1615735811881;
        Sun, 14 Mar 2021 08:30:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id f189sm5330399oia.44.2021.03.14.08.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 08:30:11 -0700 (PDT)
Subject: Re: [PATCH net-next 06/10] selftests: fib_nexthops: List each test
 case in a different line
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615563035.git.petrm@nvidia.com>
 <14c08ef572c7ee338e5014842c7e66dbc9416045.1615563035.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ab9eee46-fc26-e3d7-9591-cd4c383aa989@gmail.com>
Date:   Sun, 14 Mar 2021 09:30:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <14c08ef572c7ee338e5014842c7e66dbc9416045.1615563035.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 9:50 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The lines with the IPv4 and IPv6 test cases are already very long and
> more test cases will be added in subsequent patches.
> 
> List each test case in a different line to make it easier to extend the
> test with more test cases.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 30 ++++++++++++++++++---
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


