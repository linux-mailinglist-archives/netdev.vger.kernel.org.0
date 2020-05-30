Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709551E9324
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 20:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgE3Sko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 14:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgE3Sko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 14:40:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5773C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 11:40:43 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so7476620wrp.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 11:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dTzCOh/VSbQViq7fS5I6qkh3UwkALyj3gfg3p60oA38=;
        b=CS91Szb33pTypJt6vPO33NhyVjK6v7Th9B9HDHSONCHolDTsUtbRxUrMCV+pydDcS3
         s8iYqlsIbplry/049PRKPAXJKU/rTc/6U2t2ytrPNSgZHneB8Hq0vYvSYedCvUvWQIyx
         lsLEhq3fi3nwTw+EHyQR8WktSCZTYRj2FwPU8olPh/KhZIBopEPKBCc6KOcaUXLqTaaO
         A7RIXKplOyfoXR4kRT3IwOLYnxONog/B27s/+RP17a7IhsrJjLOY2POVGg4V0Ymqhx3q
         +H8Fe90tnaOXrX/GheCvHiEmFOO0GPC/iffYyCiKC559E2FpxS3q0Q8NQS6NTD6zE6zU
         hj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dTzCOh/VSbQViq7fS5I6qkh3UwkALyj3gfg3p60oA38=;
        b=cgAvdM/g0bCQK7c6+4Yg1O89N1S2a+T8V4ekdFwb7Wo8XW/YtkR4VK/3PkmZ7C2ecB
         n/gEjybNDof/d/kV6CHOtoxLfn6ia5DvqGNg5ld5XXF9G2k+L1QZtI55hmgebiuzMmqj
         0ANsbGqYvL+YEsPlUkpMLsoA4EQmmW/OUlw17YWvOPhoGVYDtvdvv84SNeI/RbdON0DQ
         dZkO0HLIMilT2JcS9LyRAbzXljq3XG/ZunehGiQr2DGJ7JcI0+4BWTpqSLgcD0gwR0tM
         AhquhSarBCaccU33YBN+4gk5fVU8NUazV3aWNaPfFB/zmJVXJKwv4yd56Mavsh66fbJG
         98wg==
X-Gm-Message-State: AOAM533IdTp7K1c+CoNiOWEoXte42n8mPlzbM77WHvp7dwKK4IHlSTem
        0Bdzb2aIUNgHLqsYUTo5FSNL9qL0
X-Google-Smtp-Source: ABdhPJwGDaLZ71h9o4bu7evcbKMzyx6D8UeAOM9wBeOcjyhAba877ue0okZPYwJJxuEhdz/n0/TbMA==
X-Received: by 2002:a5d:6a89:: with SMTP id s9mr12022099wru.15.1590864042262;
        Sat, 30 May 2020 11:40:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id r11sm14843283wre.25.2020.05.30.11.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 11:40:41 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: sja1105: suppress
 -Wmissing-prototypes in sja1105_static_config.c
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200530102953.692780-1-olteanv@gmail.com>
 <20200530102953.692780-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <85524d08-bdb3-bbfb-4e01-c126ce429430@gmail.com>
Date:   Sat, 30 May 2020 11:40:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530102953.692780-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 3:29 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Newer compilers complain with W=1 builds that there are non-static
> functions defined in sja1105_static_config.c that don't have a
> prototype, because their prototype is defined in sja1105.h which this
> translation unit does not include.
> 
> I don't entirely understand what is the point of these warnings, since
> in principle there's nothing wrong with that. But let's move the
> prototypes to a header file that _is_ included by
> sja1105_static_config.c, since that will make these warnings go away.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
