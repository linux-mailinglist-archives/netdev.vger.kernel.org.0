Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96464DADF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 13:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiLOMJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 07:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLOMJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 07:09:26 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E242D1E5
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:09:25 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b13so15341411lfo.3
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 04:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BonayDXjelRmeYBGGJjvECoETrAi9l86oKUl2f/LTBs=;
        b=NZqx9pPeB0Pzcb5nIc5vvSOBjvvyGu7zDGqvDIpnGMLF3uCvxylvCo9HlNEZGRtdFP
         7VnsQYEW4SsYrnDPa/CwmizqbTb+7Tsn4VRbd0DwMy6iE7KfAAf6QcMoM9eMDxz5zY3b
         MITKvGFCEu1nxaKaWocTfOJ7QVeQbQ20Qwq54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BonayDXjelRmeYBGGJjvECoETrAi9l86oKUl2f/LTBs=;
        b=e2ysuO4nULSZ6CB66bUfIPG2LH13KqKSbwFWZf40zK0t8xT7JEP7utNq/PGsUzFI0a
         pEcVWLoVWVNRaIeTceZ0hpbpVif1SHvfFQnC2ozBzuZiSUbM06Vrm7gmI/oiJChLL33r
         RPRDSch4NceSbtKQcNRnXakCY08go20k9C4MrWyC12OQ4aBGXVz+ue2cVTwyBeLy0ngK
         6di1XUxzYkWc+r8RqWgEd0x2/Np/oh7KqkYUOmTzXzsYW3gYCxipOlSZViS9//e4noZy
         218j3WveLx1mNUblGizRXAuOAsSzvitfEuHJmJLbyZ7Xa2BzHksWuXiq9fSm4abw426O
         /tAg==
X-Gm-Message-State: ANoB5pknI62emghmRw3LPEgQmEo2fTtx+9h0A+MLLW1ptPGIyAJmp+I5
        cIgFqW6/E3vmYLwVvpNcc6AwNQ==
X-Google-Smtp-Source: AA0mqf6FJx7D+G5p9QQX/o7bT+pFkhw513lLD2u4U9OZ1hBHy2y58Em73i14qx/TWBY6n0pv2ql1ew==
X-Received: by 2002:a05:6512:6d1:b0:4a4:7cab:3bad with SMTP id u17-20020a05651206d100b004a47cab3badmr9344432lff.28.1671106163654;
        Thu, 15 Dec 2022 04:09:23 -0800 (PST)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a23-20020a19f817000000b0049465afdd38sm1149721lff.108.2022.12.15.04.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 04:09:23 -0800 (PST)
Message-ID: <de35cbb1-e02e-5777-b80b-738e4c695bdb@rasmusvillemoes.dk>
Date:   Thu, 15 Dec 2022 13:09:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH AUTOSEL 4.9 2/2] net: loopback: use NET_NAME_PREDICTABLE
 for name_assign_type
Content-Language: en-US, da
To:     Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20221212103704.300692-1-sashal@kernel.org>
 <20221212103704.300692-2-sashal@kernel.org> <Y5r+KyWmREm7dKbr@duo.ucw.cz>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <Y5r+KyWmREm7dKbr@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/12/2022 11.59, Pavel Machek wrote:
> Hi!
> 
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> [ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]
>>
>> When the name_assign_type attribute was introduced (commit
>> 685343fc3ba6, "net: add name_assign_type netdev attribute"), the
>> loopback device was explicitly mentioned as one which would make use
>> of NET_NAME_PREDICTABLE:
>>
>>     The name_assign_type attribute gives hints where the interface name of a
>>     given net-device comes from. These values are currently defined:
>> ...
>>       NET_NAME_PREDICTABLE:
>>         The ifname has been assigned by the kernel in a predictable way
>>         that is guaranteed to avoid reuse and always be the same for a
>>         given device. Examples include statically created devices like
>>         the loopback device [...]
>>
>> Switch to that so that reading /sys/class/net/lo/name_assign_type
>> produces something sensible instead of returning -EINVAL.
> 
> This was already part of the previous autosel:

Yup, but it was punted for a week:

https://lore.kernel.org/lkml/Y5AO7TrYsdeVqyI6@sashalap/

