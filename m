Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6C468628
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345717AbhLDQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242107AbhLDQWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 11:22:19 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1E0C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 08:18:53 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id 7so12301779oip.12
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 08:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uDr2cPa/l+QEOcb4YhZdgXpA/BqSWxcIfaqPcp93c1w=;
        b=EXgItvrNoR3cUAUPHjMUpA78x2tMejDcYW1+iLycIgbP30e1DKCWhUIkVc1IsePKYm
         9BtekP20LHMElJ1yDwng8FHzHLeYzdhMZykZElhSh83mTyv+WYPp0I7htLw5dC2YO2el
         KJwuTMxx+neJoqk4k9UiD3EpqyHAP0h9vmvvR2uXrqUHDJ1YyxuZw9mY4yKGyCUMLBqa
         sSZHw2DPQYZb4GUhlRODWgQ+FBVitad9x52q2tq4lwmS40hPIm0gY1b9vyNvMUvjQmzD
         kyP8D3V/09eKeCBozfr575VYPbPnaQY31ReHM9PMZPzngfaneztaP8M7ePHcgCZrsTAD
         dYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uDr2cPa/l+QEOcb4YhZdgXpA/BqSWxcIfaqPcp93c1w=;
        b=Eutrkw5Qpg8ASwX5es/SNHAjyjE6LJKFW2+HUVpNKwFNIljaolz1f9IbJ8CwbVqI3N
         jgFKFca40PyX8f1+ZAQj+2fnks1Avt0I6hD5Ng+8uNztve/f8ybUruqivi+tWqZcY1PK
         Z+FmLrTlQn9x+IINGpJWdt3j5Zm9av/HpAVZxQpW4kSEBZo508h/kOAy5yn9+zReZjLN
         3+kmHWTxPWVZovB2fMN7m2gsHExAy23qWkneh9udXlVSkM4G/anqKL3Lx3cEfNbelQaj
         TRZeRoDI9pbspRKoE3NzNzC+x7KKK95E2rRAz5AkWwEEGQbkmdHzYadsDJDOUB+iaHuR
         gFNg==
X-Gm-Message-State: AOAM530DYoLpUKKadXJI2VmM+Ce0lsNM26DMLEkhUxRTkaWfz91P34+G
        WDVPUTQ2UFMmmCLbFkKBVCU=
X-Google-Smtp-Source: ABdhPJznpq7o2cp6O86XZDHYfL6EDlQRCw81sgch/n+InbZRj/P2M2/dsP0In6PvfQLMf89fAFcOKw==
X-Received: by 2002:a05:6808:1894:: with SMTP id bi20mr15703243oib.151.1638634733304;
        Sat, 04 Dec 2021 08:18:53 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bl33sm1626998oib.47.2021.12.04.08.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Dec 2021 08:18:52 -0800 (PST)
Message-ID: <acf1de03-9b81-70f6-6e72-8267499ffe1f@gmail.com>
Date:   Sat, 4 Dec 2021 09:18:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Cc:     kuba@kernel.org
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <9b8c306a-eea0-3d77-c4a3-3406e5954eaa@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <9b8c306a-eea0-3d77-c4a3-3406e5954eaa@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/21 3:15 AM, Nikolay Aleksandrov wrote:
> 
> I like the idea, but what happens if the same device is present twice or more times?
> I mean are you sure it is safe to call dellink method of all device types multiple
> times with the same device?
> 

Very good point. Can't rely on dellink callbacks being able to handle
multiple calls.
