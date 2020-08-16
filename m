Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1BC24598F
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 23:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbgHPU74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgHPU7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:59:55 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3C5C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:59:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so6466894plk.13
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3B5K2M573jBiJIfCMgTXv1apdcvHtKTSACbgMySrnoo=;
        b=BSpaLUTuVQ+j8ShO1lKjYEFl56Ql7J6B8xliR4akuV7zVDkaJUjTPVOUmdCIYgF070
         6NEgvrHwlIyBGjnGOSIufUxldWXvThaXM+TLzAvRyoC7MiMzcXbXZ/iKcSkiwYBwGDud
         uZUvu3ElWusQ24ZcevjHvAoS01k+WHNw6iPIUhBDaA1DCnjHb1K572fybypdZpTVjUxr
         j39qJjBci1/1EdjWXSXLV/qVkMxLs7BjIFm/W0WLZqnGF5+hBSEpcvcNRHljXB4ALLXd
         XH3PWqhl+80fLjfP5P8yj5ZHG+MeNddU67PAXPQmRVAJjATaCjRdmxB6o7KjFOTshhdH
         JD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3B5K2M573jBiJIfCMgTXv1apdcvHtKTSACbgMySrnoo=;
        b=R4p59fAWy4+YCWHlenj9EI2gKdRdMOfb4A9BMykQvmd+sIoe0uR4jRtTgUr/jyJMhb
         TPlD4l1H2ZLL4o/HeH9Vd37sYyvZzDhnLvjFurAozWjhJ6SOj4VKd2KjoNMPtL21WT1U
         +pBc2jSEoUWRNi3KcPhFPUXLlmUV+jckNJM8eNGPwSNeT4Kd83pUephBemmo1/Z8ffBL
         prHHtj9pZrwfsdS0SJy8h/KrnNJZVzE34kmvnkjIXccw9S5tWji3y6adVb7t/ht0cSHI
         rV4xO/Er25qD1IOoEc/ou3LqItYxlte2n/XvLpgYjmJ3s9jHmixKClsBf4/XfExEGx97
         AlQw==
X-Gm-Message-State: AOAM530E08YmL1EM7nyHmNDRrMZMkubamkTgYKgDGhmKoRmYnzyIo8T0
        ribK4dJa86gme1kyh87j0lE=
X-Google-Smtp-Source: ABdhPJy69pqqgPFH58YmgP//UQ8BefCFJlGMaDYf0kB/tauD4xcrnjYQrKTwq93n54DERU6UhG0YHw==
X-Received: by 2002:a17:902:c111:: with SMTP id 17mr8025353pli.46.1597611595028;
        Sun, 16 Aug 2020 13:59:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t25sm16205572pfe.51.2020.08.16.13.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 13:59:54 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/5] net: xgene: Move shared header file into
 include/linux
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200816185611.2290056-1-andrew@lunn.ch>
 <20200816185611.2290056-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6b10ced9-d5a6-85a6-c483-4ccd0691d05b@gmail.com>
Date:   Sun, 16 Aug 2020 13:59:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200816185611.2290056-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2020 11:56 AM, Andrew Lunn wrote:
> This header file is currently included into the ethernet driver via a
> relative path into the PHY subsystem. This is bad practice, and causes
> issues for the upcoming move of the MDIO driver. Move the header file
> into include/linux to clean this up.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   drivers/net/ethernet/apm/xgene/xgene_enet_main.h | 2 +-
>   drivers/net/phy/mdio-xgene.c                     | 2 +-
>   {drivers/net/phy => include/linux}/mdio-xgene.h  | 0
>   3 files changed, 2 insertions(+), 2 deletions(-)
>   rename {drivers/net/phy => include/linux}/mdio-xgene.h (100%)

Depending on your response on patch #2, we could create 
include/linux/mdio/mdio-xgene.h, with that addressed or not:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
