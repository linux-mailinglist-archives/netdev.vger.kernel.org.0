Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1930D34B919
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 20:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhC0TSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 15:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhC0TRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 15:17:47 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD7EC0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:17:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id a8so9176624oic.11
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 12:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vbWTfP0OtAJfNreO3fPOf37Jcpa1wa1R3fLi2hl4BhE=;
        b=Ix6hyjEjzfzr0UTAfxFtisXliiLyq4q7a65u6da2acFZklRfq6xKTr6LfhgisHBg4x
         78jIEUtP7bxoQQa2X5xzAgvyqR5P5vOwkKQvvBDokbEd/3Vs+ntAF8C4ptCnwUuF4ZF9
         ckVNtrzF89911M/EUL6CQ8vk/3x1kXDjJiEgfV2l20pxHL619DmStPeCFao+9gbDLcKe
         +lP1zj0MLf/pkYIGdxSoVf2gB7do4GzmnLca+oduosVntpA9wDS+dU0EQxKrfI/j/FBz
         BkPMNeCtjp2q0ykuJnWa7k7UkmXBQqRyNp1t3CsxfIDwxy8Jhp9CcivmCOh8qjqgplpc
         FW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vbWTfP0OtAJfNreO3fPOf37Jcpa1wa1R3fLi2hl4BhE=;
        b=okEHowBVIyxCcWm7vkTjW1WMWhf+RnIbm4mRkdfvrenk1iAMv50w2y4kEfq2PHk0zx
         0taCPKfzpZj7Tz3tSpid73dUnQ06V0K5LNr8uSUg2qpNp21O/3tCv0J4bHHXPtjdXBhR
         0CqaJRfMJ7MMGl+ewYEYheIVVmX+9BmX/Pw/w4ZpE1sC+IDulAoeW1Vr3KdjddFIqTZe
         l0UzSkxML8IhyhzLC6X8Ci9yPV1rGu927FDqrjBbEggd2fchjjUw1xmlbA5q+i8Mi7Ie
         rFYQQgJHJFhudoO/7ZFBVo2FC4B9te/ilsEuBYKIXbnKDyXZuOOiZZgoEKnNAiGI2L3u
         /DNw==
X-Gm-Message-State: AOAM5316Pbw1BuVfyI1X3kwe9c1wshYJS6oJ6IUgzeDsHaBuETTicUCD
        /YS2r0S3/QE6pn1SiHL7E9+2Mxp4izs=
X-Google-Smtp-Source: ABdhPJwSHRffsK7jS1hZFOXDikT16a5N8SQal7JwhjNthfmXMiETqnvHAVHaZ65LcL34E7lCE/D4zA==
X-Received: by 2002:a05:6808:2d5:: with SMTP id a21mr14271901oid.88.1616872665788;
        Sat, 27 Mar 2021 12:17:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id u8sm2709472oot.24.2021.03.27.12.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 12:17:45 -0700 (PDT)
Subject: Re: [PATCH 8/9] ip6_tunnel:: Correct function name
 parse_tvl_tnl_enc_lim() in the kerneldoc comments
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>, dsahern@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <20210327081556.113140-1-wangxiongfeng2@huawei.com>
 <20210327081556.113140-9-wangxiongfeng2@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <83976471-05d7-803c-85fa-a9728e7a662e@gmail.com>
Date:   Sat, 27 Mar 2021 13:17:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210327081556.113140-9-wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/21 2:15 AM, Xiongfeng Wang wrote:
> Fix the following W=1 kernel build warning(s):
> 
>  net/ipv6/ip6_tunnel.c:401: warning: expecting prototype for parse_tvl_tnl_enc_lim(). Prototype was for ip6_tnl_parse_tlv_enc_lim() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  net/ipv6/ip6_tunnel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


