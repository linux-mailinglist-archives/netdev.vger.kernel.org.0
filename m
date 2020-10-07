Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDAE28587F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgJGGKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgJGGKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:10:11 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A1CC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 23:10:11 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id n2so1323818oij.1
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 23:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZD05cJVWvHN8j7sgr/Lfsp9C0Oe22p7vLeUFI96i7LE=;
        b=r08b32E+anzy+oDo3gsMUyx6HmDnQaOZry6esHmjjHccL3tlQbYSktSg+rsM4R8SqL
         Sk6ad8YEUMGkMVyhopp7lRffhJnf/yISLKfMhBYoQWyIJyp38zTrw1+TKsJY5f9MoK0P
         XQUE93kk09P5TcWp241n84K3MIdizXkNmbp1dKNPNhowcmEZpzJPQ4MODC33whynq2Ta
         ksFAosbHhNMB8po4XeXNmiIrP+B07U5cUL883VQbwKXi5wYvKxE0PtKymaS4T4ceHZkM
         Xmprm93btr0SNz705JyEMK+GtbpyuN2fnMHOmtQamDh9xCscSAvEYXXWqwCsPKIVAeuX
         wnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZD05cJVWvHN8j7sgr/Lfsp9C0Oe22p7vLeUFI96i7LE=;
        b=BU4m0TBNEcuxFTzMy2AoDhIEzskZln/OEZUfbYeK45/LcP4SvizLDD0HGHYu+LA4QK
         sP9yWAiFutjyTHQHIlq+BN1Hqt4X0MihO6nh4Dwfe5BxskTy9FVtRTbg6e9A6QhH3BnV
         vqLOgEXyiU1dFfF3+gZI5TMaUAVkXKYDTzKaLQIctzPudX50fnI3UF46mXGk8ZGnbRUx
         Bl+ZITmA9fDDnnHIt1nPQOBULyE8GIvClNOFG9eJZ1/f8ymvEHAHcPJ4jCCiMkzAbiNw
         AaGU56o+3rjUhlSkV8/nQBDWONRXrHlyyLisAdn22XObjkpVYrxrkkthd9KRCSiTDyJs
         Vh3Q==
X-Gm-Message-State: AOAM532xMfvb9Rk7DueXjhBeazX6MrwrqeeneEDzBCjIQamSZKeKsGjB
        vbO5MGCQ2ldAZfUCd+K9i+x9VAtArfY69g==
X-Google-Smtp-Source: ABdhPJxoky+A5ZIrzHRrA/KX1QPaauw/3Je6g2ivL/eiHC0UniFaz/jsvusg8cq6Ak7lP2x0V49AwQ==
X-Received: by 2002:a05:6808:47:: with SMTP id v7mr1116370oic.70.1602051010590;
        Tue, 06 Oct 2020 23:10:10 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:4df6:ae94:ee53:9573])
        by smtp.googlemail.com with ESMTPSA id 2sm913281oty.59.2020.10.06.23.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 23:10:09 -0700 (PDT)
Subject: Re: [patch iproute2-next] devlink: Add health reporter test command
 support
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, mlxsw@nvidia.com
References: <20201001072113.493092-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8807b62d-3d35-9624-0359-ba9c178faa84@gmail.com>
Date:   Tue, 6 Oct 2020 23:10:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201001072113.493092-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/20 12:21 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Add health reporter test command and allow user to trigger a test event.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  bash-completion/devlink   |  2 +-
>  devlink/devlink.c         | 11 +++++++++++
>  man/man8/devlink-health.8 | 16 ++++++++++++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks


