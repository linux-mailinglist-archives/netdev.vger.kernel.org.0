Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6696308427
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 04:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhA2DO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 22:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 22:14:23 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8959CC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:13:43 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id p5so8441132oif.7
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 19:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5T1o78L+2p5eRH5xGnvJfvUbzzFItWboXCVzo4GMMPI=;
        b=CbcJdYtOL/9pYMshGwnuXjiEjSnSi2B/yZ/2kztrIfPog1L8k7rrtElPvQ77w/kmQN
         LWwCea8PnH5Jeco2qpbURnnp3hKDga3YmALgQGrugIJlkZWpH6mq3vi9p5sSiC/xelja
         yVCZet5HiNWjgMiMO8N9lZjZTVq4lZa6bgqB1odO7K7R9crwDBzg6T1Nk6uMF023kOnf
         olRYDm2KBIT/n9i7qfQGKFn1IJ+pHKBO4k2jt5G2KwrKppYn4VRKEBNR+/8+8b5lTizD
         QEU0DJFOU2D8yJLjLfFkgYGLdq3LXoAPvCLqbViiqRSBXki6D8ZLcgSwLCePF348dF60
         rR4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5T1o78L+2p5eRH5xGnvJfvUbzzFItWboXCVzo4GMMPI=;
        b=KJU2fWsC4sCbzniFFw3B49ogEZuLmpJO2cQfysVGsq28qyb7Bc+P2XKp7MYvIwDNaD
         KfPh2zQqJlcpQhdzRZVB/Yox1XCp1+MgH/LHVIPC0osjgJARH2ZXh+2RtPcxKHNQGly2
         p4ifGZQoSN9vJvLBTPYH6CpyPp0kqKGNdSd+Kss4Mx0zQLaQ6MJyVg8mtWwJYs3E7a9E
         96plnRhp0dm0D7ukS79ur68fsqxaMlCT1FSc230XVaZClzn8rCz9SXb1+a8qMAvNboKR
         7FqY7w6ID6s4xErLE0cXWKFJYKRidhgMxBcindHsGXzM72GSLtFWNk4nAipbucFSZKiE
         z//Q==
X-Gm-Message-State: AOAM532FXw23e3MnRIpAiSZIFvwSocgzW12IfdjPFQhoMmnYo0jCAfjo
        O7yOeJh08B/dXG2IIk2iE0A=
X-Google-Smtp-Source: ABdhPJxnko6MqDchkAEjO95ZcB2zuQPicqb/dpkcFdm7h3DJPlUuWIJeO6dwJnXm+Xtve581yE5rVg==
X-Received: by 2002:aca:911:: with SMTP id 17mr1455500oij.162.1611890023048;
        Thu, 28 Jan 2021 19:13:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id l3sm1666574ooa.12.2021.01.28.19.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:13:42 -0800 (PST)
Subject: Re: [PATCH net-next 06/12] nexthop: Dispatch notifier init()/fini()
 by group type
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
 <f10e8da9c6d7fb8be97e25a26b40e2f2fb5470f3.1611836479.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a6ded846-825f-1a01-612a-d69186cbb031@gmail.com>
Date:   Thu, 28 Jan 2021 20:13:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <f10e8da9c6d7fb8be97e25a26b40e2f2fb5470f3.1611836479.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 5:49 AM, Petr Machata wrote:
> After there are several next-hop group types, initialization and
> finalization of notifier type needs to reflect the actual type. Transform
> nh_notifier_grp_info_init() and _fini() to make extending them easier.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


