Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB6260938
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgIHELL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHELI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:11:08 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F51C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:11:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so9128885pgl.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DkA4ZjtU+wT3jLz9JaMTG9kcNVdMmoOVUH+quDVWp7s=;
        b=fvMOkX7yU51JD96natzl1NYXzU5D4uo5Anddnp5oN+k7YRm6QfwWlO7XcpTq8RW9Sw
         FfSfzaiZRQXQ+pTAKED2EFwe4Xf8SkQFWhPk5QQMD8NhyqdAJvJPk09p4GAZegCG66xy
         9eG01ldnLai1UUZbf+ZcgQI0xQgf+M0Ao0DZqJTQLT8N04RZtX91I+jAGi/EuYL9xPBp
         4B9ysKqvIVTopbthOAXYglHgRcSx0XU8jZaKdDisp8m9jMTuVXej5uegekpBKK0G89ee
         ovdZnamHW52HxA5fgMTAJCeCDe3YE6L9hFgf+cuZzPgkjWvBBjKXhINVyMCfiooS2qSR
         H4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DkA4ZjtU+wT3jLz9JaMTG9kcNVdMmoOVUH+quDVWp7s=;
        b=FyrG4ztjwsqb/cBtKP0Luxj8z5I+TSVKzfokDykMPbZSOB7br7UJJdr0gFkHqGjPnT
         JkIE2nF9eEU/GHAQYpk83En3YkUi8F968io5kobZLk/14AyQv27eV/0UiJNoGielm2DL
         u3FylX0G8yedkBvHLsqUQ7k7pLVvTpggtfmUeK5kS+i44uQq3G40lHP2x9A9FO1l2gk1
         sM2ETTx4KYsBCdcB4H5TC77SE755qXdXCXKodKuwFW7H8ntNjp7tWsthdV9Q3IUeyt3a
         Z2aFSVKslChXFGIlQ25gJbcMmOsnyz0yt5MnbklBeEXbDxHmrPrqY1F2AClczdTOaJ6y
         +/dQ==
X-Gm-Message-State: AOAM531jLL3A+Tl4x8dZXPPGtFPpS24mh7yCOVaxlu/m7BjzSbakwyJM
        VjKW8EDrJF51/nq7QE8e+18wVT26t0A=
X-Google-Smtp-Source: ABdhPJwGdVA1unGSoRPdF8zxlBAT1uK0OKhxbWJpKtB1gC2HcDSBoUCzrqmnjgwEvRP5+1wSqNEfpw==
X-Received: by 2002:a65:5aca:: with SMTP id d10mr18961015pgt.362.1599538266831;
        Mon, 07 Sep 2020 21:11:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x9sm11304329pfj.96.2020.09.07.21.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:11:06 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] net: dsa: microchip: Improve phy mode message
To:     Paul Barker <pbarker@konsulko.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200907101208.1223-1-pbarker@konsulko.com>
 <20200907101208.1223-3-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <533a04a2-cdd6-2f09-20da-1d4147d53e6c@gmail.com>
Date:   Mon, 7 Sep 2020 21:11:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907101208.1223-3-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 3:12 AM, Paul Barker wrote:
> Always print the selected phy mode for the CPU port when using the
> ksz9477 driver. If the phy mode was changed, also print the previous
> mode to aid in debugging.
> 
> To make the message more clear, prefix it with the port number which it
> applies to and improve the language a little.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Once you fix the kbuild robot complaint about prev_mode not being a 
const char *:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
