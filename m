Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA12FAF03
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 04:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394770AbhASDD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 22:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388503AbhASDDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 22:03:54 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E5EC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 19:03:14 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id r189so10130603oih.4
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 19:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tihzjS3DFmFRT5SLDpmRBYlDAmCR9F9/E59MzOJ4R0I=;
        b=fGCg5wuS92r5DJD5pVNazNQ12yKWaTXUhGNTzP039+8QB2hEO/7ZguzeTOG3ONARoz
         YY5zHJY3aIkB5YGnGgQaYDcBTLvjHJj2AENRzIFd9M59GYRGSgYV/fFISkfdR6zoQN2E
         ip7uYjGOvEP4VPw86QCfA99jcX62xwCm8lhRgelsZOtzJGRp8AIeaWIf0CPML0R5e1id
         4ULaxoI9OoHztt6PT9hOMPSdw0UNUnUbyyEEtZjaqNdp2+wKH6ujTtSoGinTJjrm1IgF
         O+KyiuVsaeZs/gRKKO5XCgBGc2u4eIba39pHjFdzelvtYpSmG96r1yM2SzT/ze0GxByi
         AdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tihzjS3DFmFRT5SLDpmRBYlDAmCR9F9/E59MzOJ4R0I=;
        b=WYOZuHgeZCCcClB+MdRq3QcYZyOOzoorWCpdRaGtYhrnISS2fjgMytc+j6dJoXqOtc
         +EYmnQzgIK9afymqf9/hQqK4+PFQpNBzRLbXG/LcQdBn1H8Cf++XUD0f8WQVYcGG6XcX
         gKnZskjJdCYVOqykYdN76Pw7vNKkWVxTWYMnD0TCohPNQ3krZ9EdbdRX75GP0OFs/MHA
         gTMEoEotyDP63/0QdwaSdtPotG298Rcq9y3IKSxyQd8n+vOrfkbFaLambgSO3Uhc9WWe
         S6Q5D3Bd4nm0NeU9MZ0d3p/OMhHOn22QT6G1Bu4A9rTUzHEZg38HVesYLbjXPlj+DNuT
         sJXA==
X-Gm-Message-State: AOAM532fn7xu8GHY6eBNQ2CdhO9i6tDKPHwVxJSQf20UtjvqjF7SgMQE
        0GHhe4rG24ELGnJVSwGnogI=
X-Google-Smtp-Source: ABdhPJyGiTgz2F9HNUFCc4QYrA6SYDxXh6nOqbXbYqFuz3dJiUc9+mbtzarJPr+9Qzs+vzB1LnYckA==
X-Received: by 2002:aca:3306:: with SMTP id z6mr1270370oiz.141.1611025393530;
        Mon, 18 Jan 2021 19:03:13 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.22])
        by smtp.googlemail.com with ESMTPSA id d20sm4315673ote.48.2021.01.18.19.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 19:03:13 -0800 (PST)
Subject: Re: [PATCH net] selftests/net/fib_tests: remove duplicate log test
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@redhat.com>
References: <20210119025930.2810532-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <03dfec85-56db-b3a6-5fbc-c97868cd8cbf@gmail.com>
Date:   Mon, 18 Jan 2021 20:03:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119025930.2810532-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 7:59 PM, Hangbin Liu wrote:
> The previous test added an address with a specified metric and check if
> correspond route was created. I somehow added two logs for the same
> test. Remove the duplicated one.
> 
> Reported-by: Antoine Tenart <atenart@redhat.com>
> Fixes: 0d29169a708b ("selftests/net/fib_tests: update addr_metric_test for peer route testing")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 1 -
>  1 file changed, 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
