Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8AB1AF50B
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDRVDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgDRVDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:03:21 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD25CC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:03:20 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z6so6862543wml.2
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zLoykTiD6hme906aNNmsW6dCviz55aPQTU0p3EofrUQ=;
        b=e6kVu9vjJ3mZd38HyrcwXF/F5wcCpPS3ULrZ7zfxMm+TB4IqLiOdUAbkvZfNqczPr4
         hS8lT8e6seFZ6RUk9gxAebP19X9Ypvq7j633EVu4IA/dqfltBnlnbWDh9q695/7lYNtb
         je2yf92xUUXCiXr4YOzTPkwf8FRsdC28OFtHDm7kYuo31Y4BL+8+CI8tx0MsZEfIAvj/
         1xqNZCWh392fMJBGBFF5h2PTH9i+/EWO22dr7wtAQKXfNesvZ2v7gPChdQxEwqrJpzcO
         P3g53+wEXGwxNug95jzcuxtlBiel/amvMjqO0/DG3aVxl0vD26VHN/bT8k71IJALgOKl
         LGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLoykTiD6hme906aNNmsW6dCviz55aPQTU0p3EofrUQ=;
        b=U5b5pwBR3ieCQqcPr+W+DUWgk1fZqozZ8k1OpddQJIm2oR9zY8ymYUqmS2pqDuGqcY
         3W09sHQUhoaqs4A0NkqPMXLbT4IJ3oRHwc0f3dVYgK1qro2+eKaqvlXS9tHQK7troMTi
         21UGyF3qUWZypjVRTxrZgPFxEdupvq0tIhTgjOARUHwZ8u5VPn3WGF9cvJzP9NRbOt4P
         ouIHjB76utNpRq49l/HZTaK+atXcv/c21Iv+krVBcaibWv/gcmEQiI4SB3X/kWCzJE4a
         oJ10wDHs1fbAqYDQrvDX2jLWlEJE9uEpEKm4JFKwUGy0xmB5mym5q9Hna1VMSGDTTySh
         v8Ww==
X-Gm-Message-State: AGi0PuZNwjaxsofj9K4i5TAI7tE7RkBG/Nb4AxiigoUwZijXYDxISDxi
        PbrAINHim8pitqcHdivxrZwgyeVm
X-Google-Smtp-Source: APiQypK93OYcIT6OjwmL74DYaOoU9MHCtivEXYJxOZBKH0tO46VbaZsvoIzUvxtO/g7pyg7wfvBVlg==
X-Received: by 2002:a1c:990d:: with SMTP id b13mr9394370wme.179.1587243799317;
        Sat, 18 Apr 2020 14:03:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j13sm11193428wrq.24.2020.04.18.14.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:03:18 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] r8169: remove PHY resume delay that is
 handled in the PHY driver now
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
 <84800b8b-8f38-5288-5845-6fb5e940a072@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d129e833-8a97-3183-4dfb-6b2c2bae7686@gmail.com>
Date:   Sat, 18 Apr 2020 14:03:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <84800b8b-8f38-5288-5845-6fb5e940a072@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 1:09 PM, Heiner Kallweit wrote:
> The Realtek PHY driver takes care of adding the needed delay now,
> therefore we can remove the delay here.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
