Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23464676A3
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380507AbhLCLlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380475AbhLCLlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:41:07 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02957C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 03:37:44 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y196so2090596wmc.3
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 03:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jD3dyFUpQpd8ra1mBckqXsjcLQy5IODiwzKky7B7kHg=;
        b=PAwTrBnjeNpWNvnu5qIoxa/cQZEaEBdoUa7m7o19f/5a3eRmkSjI5hxPnJdv64vZsf
         Sa0JMnyrhRQj1pnXFnLVDDE8YMIsitBMwLIDkxkJxfKNFlhH89X1a2PitmLWV1CuAd6F
         WYDZJqQRbLLcD38XnKAlAnMoWNzyBy5DGR1ZIw1kQceZwDIChPgOrsKJUvKc7YU0sFF3
         DMuQIvrOdqk2kPSaLIQBpZbxcINX6iedBq7ju7HwgHtsAOsX/7faTfnOmjNGu+d4V+y9
         OYW6LKDuruYSjvN2SAcjoMcgGqdOYIlUOHILset5uGaP+wNxJ2EGK44Cv9atCh/F/PV4
         SuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jD3dyFUpQpd8ra1mBckqXsjcLQy5IODiwzKky7B7kHg=;
        b=nl+0FY3eYQKZVsEgzVG+lvogju2nzoDHCD7mOxaGL1RWinAXkJbPWmd0A6+/sNkqZq
         uxIuIQOjPGkBYzKB/6KlSp8O3AS1Bnx8dsOxTkJ7TGAt9HDV/86D0XrjqBtGfh7E2++4
         OdAJ6triQcNS7aAUQrwisoH66ZtI9jY2lH4cBwWyjGuqWJNCebWoL5nTi70ZazX6pt1m
         gr/dQ7ajnZwW87QRMFPF3DP8JZMu6xFHTmA1Ix+gsCutQkBLFB255NV+EBmZhkDpOwzN
         6LFdu/qh54XBNs53c6w+UVkmtfol2AgKVrDXSJx0jrewfA72qcZnoKVDf8Q4ALxmQUsj
         dw4g==
X-Gm-Message-State: AOAM5320ib/eMqxdfPUqP8q1tW3H0BF8pBJLt+592wcg6Z3N4uEvx2Lk
        fezyVhD0CVPNKomB4RWeDEdfl6q+u5g=
X-Google-Smtp-Source: ABdhPJxw81j1InOPZC8tqhh5WuMZRwPEOuWajt1DB3Ea5wqel0/dZL9IoZzRsUat5iu1syxtK3rwHA==
X-Received: by 2002:a05:600c:34d6:: with SMTP id d22mr13953774wmq.160.1638531462582;
        Fri, 03 Dec 2021 03:37:42 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:ddb4:c635:82a6:bc31? (p200300ea8f1a0f00ddb4c63582a6bc31.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:ddb4:c635:82a6:bc31])
        by smtp.googlemail.com with ESMTPSA id o63sm2314986wme.2.2021.12.03.03.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 03:37:42 -0800 (PST)
Message-ID: <401273a6-37f7-8a27-457b-dbd73a0bbc97@gmail.com>
Date:   Fri, 3 Dec 2021 12:37:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC PATCH 3/4] r8169: support CMAC
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-384-nic_swsd@realtek.com>
 <3b610e64-9013-5c8c-93e9-95994d79f128@gmail.com>
 <f56cc112d886490792fcb98c8faadff6@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <f56cc112d886490792fcb98c8faadff6@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2021 08:57, Hayes Wang wrote:
> Heiner Kallweit <hkallweit1@gmail.com>
>> Sent: Tuesday, November 30, 2021 4:47 AM
>> To: Hayes Wang <hayeswang@realtek.com>; Jakub Kicinski <kuba@kernel.org>;
> [...]
>>> +struct rtl_dash {
>>> +	struct rtl8169_private *tp;
>>> +	struct pci_dev *pdev_cmac;
>>> +	void __iomem *cmac_ioaddr;
>>> +	struct cmac_desc *tx_desc, *rx_desc;
>>> +	struct page *tx_buf, *rx_buf;
>>> +	struct dash_tx_info tx_info[CMAC_DESC_NUM];
>>> +	struct tasklet_struct tl;
>>
>> Please see the following in include/linux/interrupt.h:
>>
>> /* Tasklets --- multithreaded analogue of BHs.
>>
>>    This API is deprecated. Please consider using threaded IRQs instead:
> 
> How about replacing the tasklet with work?
> It seems that the bottom half of threaded IRQ
> is the work, too.
> 
Right, it's running in process context. It's to a certain extent
comparable with the efforts to move NAPI processing from softirg
context to threads.

> Best Regards,
> Hayes
> 
> 

