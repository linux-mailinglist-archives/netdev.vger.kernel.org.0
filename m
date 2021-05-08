Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF263772C2
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhEHPsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhEHPsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:48:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705CCC061574;
        Sat,  8 May 2021 08:47:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q15so5322688pgg.12;
        Sat, 08 May 2021 08:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hl6GPdnktUsPtgmMwG3aTCuQF5GcVx+5iL+jkQalr64=;
        b=Ifby7yjOkHxCs6R0IvKjcJOzuV+KLcYpFasOIFKXXB9H5eSkRW6khFLa4gYlVrueot
         QeFIDbpE3nRNlmQK8Pf+qvtlrVHczkOn16MBvGkxzZJZfRMoScv6fkWzIpuFDXP+qduK
         7PHar/J++2YyyMy7jpD82lcD/DY4YQooqQrFH9Lk4ixBTUyLlT4KsK17mCisPP+5N22e
         d1Kv8+96GpyijycyeZnx4S9TEXWhM3it6K/m3wamg5vdvGsZX6PcoTKUju+szqj6P5db
         9H2kSZGxhISMLavm41xnsdC/4qvH1SPNVP4pmFLggI+mlvlrRQQyju+P7YJRdocgx3xW
         81Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hl6GPdnktUsPtgmMwG3aTCuQF5GcVx+5iL+jkQalr64=;
        b=SPYHawZ5XCJFffro+3+G8XFcllciY0s/ivCj1GEo8DRjvXoA+AaTY1ORkfhn4H53gY
         +zgRWPVY81ZVf5mB5zga+9N0FOJbTQHPAE62t2TM9bIyRUq9hi8L0doCC3mX0HCedl8J
         0jAr2Ts6l29BaMWitG2QFZZgXEHSYc0V+/yI5nV90pxqwMG4d1EoXshRg/d53HAd//Jw
         xp/S1LrHi10uphv3669DtcTPEjYGctM1MEMX2Q+qZxX/dHHHJm5bxNy4bQqULhQ1dI3m
         c5jw54MaybEJMghgfgNziv9ooninCegJX11sxIZ1H8ZGeeIsZ2Y85b152SpJAi8IhEHq
         qG8A==
X-Gm-Message-State: AOAM533qXJ7pd60qjIl6XtUR4Vc65ZqmKH5mxAvkxS2KMBovwmXMdrN/
        JhAoCHRx0DMnRYVIRPZ8mji01k0BMBE=
X-Google-Smtp-Source: ABdhPJwXwzdFQtlTgv6OG95KH+1calQ+XuKvaXiKJXT9npi6DYCS6pSSRu01tuSMnnEao/lwQXtepw==
X-Received: by 2002:a62:140f:0:b029:2b5:7c49:45ae with SMTP id 15-20020a62140f0000b02902b57c4945aemr1756558pfu.61.1620488868644;
        Sat, 08 May 2021 08:47:48 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id q8sm7168472pgn.22.2021.05.08.08.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:47:48 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 13/28] devicetree: net: dsa: qca8k:
 Document new compatible qca8327
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-13-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <793ab298-1310-bbc6-9ef5-f48eeee347a8@gmail.com>
Date:   Sat, 8 May 2021 08:47:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-13-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:29 PM, Ansuel Smith wrote:
> Add support for qca8327 in the compatible list.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
