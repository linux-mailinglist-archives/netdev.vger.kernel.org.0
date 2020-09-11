Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB93A266603
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgIKRTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgIKO6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 10:58:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F129C0612EF;
        Fri, 11 Sep 2020 07:48:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d190so11315220iof.3;
        Fri, 11 Sep 2020 07:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IRHtAxZizOydZ9DBGosyH446zFOSQHExSwdB0MTaW5A=;
        b=hxWNVc+ME2BuN4ZdQ1wDo5wApR+q/VTnX/Wlj2bRhmFGltA3RcpiTwiGxJvgMQVn7K
         7rlwk0/fZ/kRb8QqUKi7h9+kMivuD65HNIZ+OTsUDw5fyF2SoV8n8B6loIuD5cimIw3L
         CQrv3tR7OrFPXWmTs81563WAcmVSXod+xK32G+4hxVqWRWeR6tv/YMGE64YVXK67/jRd
         UVIoRR0zx0nLbKaARLYxR7IxIPbesqPxIcy+YG1cNI9jVdb9m8RL+Cp7VmjcqSdL3gF5
         rvtqRZ6u98yQnPNh2YWTrFXRY4hXHjYbJE3znKdiwNVY23kA0HY/btJAgVabT2/BJjmg
         DZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IRHtAxZizOydZ9DBGosyH446zFOSQHExSwdB0MTaW5A=;
        b=WSOLnSN/krDmTcZ5Gjm2ul5zYlJIKfTLBBw8KGMR437bxtZ+x0H86aKG7m2mv5RzxO
         E9mwCKxphegTiwtj8teR0baf2lRaruoqqKeudCHBUP3zDm3NFHxoySil3FCkazi8/Khi
         uGjkPETpMWBu375JXPzW7TkWYYXG3a0RYe547l3cgqx7GKjnySyFTi0W49sloQ/bo2Ac
         js82EkLWpI00f2IMcudWROnfe1VgCQ6ay6A8FB3LKzQw3dQcU/oVOkHEPNwp9vKq6HxF
         vm6DSIxZ3OKaiEsC+pN52Aqj3/8Psd22dWfLPbMSft+/UUB4oF0kqHOi34tkAxm45g97
         MuLA==
X-Gm-Message-State: AOAM5307w6MCMHYRaTLN1D9+54aehFqiidKeK5Anb6QgOx6pBzh88AwB
        X1ylyup4Rg0SbHE1Px9lsAJPGS01/dsH/w==
X-Google-Smtp-Source: ABdhPJzQq9t7YiA8qCNRdeo3jUS+beivCnAe93THebMKuxyDgl1FX09/VllsRsLrX+A+PlMTy5Vylw==
X-Received: by 2002:a02:6623:: with SMTP id k35mr2282719jac.105.1599835694446;
        Fri, 11 Sep 2020 07:48:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9823:5439:510e:c509])
        by smtp.googlemail.com with ESMTPSA id s2sm1394768ili.49.2020.09.11.07.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 07:48:13 -0700 (PDT)
Subject: Re: [PATCH] ipv6: remove redundant assignment to variable err
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200911103509.22907-1-colin.king@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a243b2e5-8d6e-dddf-3e3d-a89949f5ccb6@gmail.com>
Date:   Fri, 11 Sep 2020 08:48:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200911103509.22907-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/20 4:35 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is never read and
> it is being updated later with a new value. The initialization is redundant
> and can be removed.  Also re-order variable declarations in reverse
> Christmas tree ordering.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv6/route.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

