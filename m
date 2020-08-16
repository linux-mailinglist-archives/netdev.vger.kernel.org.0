Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C5024598D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgHPU7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 16:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgHPU7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 16:59:03 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88742C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:59:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f9so6689301pju.4
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 13:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ayK1yTU9vTtR6bNGs5XkJj9p9VDpLKUU46m/EwAT5pw=;
        b=b9yL0BHW+fZOTZkqLjXxYYRLfGXwiMEFjYSiUUcB/3JH0PsZFvgVeqqrlISIdf/i7T
         gJbHMrj1TobLVERdGqKHADlkgwjAHdgNkPlgoZLcjisNzkXPs8ilULHpLgkm/Iu6C67s
         vKPl0bVpLNCVtX+ax0kc/z2cgyH8ZLtukZdnCg29+ecorcUh74OD24YH2MG0KBrxDOwm
         +WkrIieyviZISSla+NecDGXPpT0/ylswGaIL4K3QM/ACG/cR+JsiFuWJIIO5itUgM9kC
         Pj9G55D5cN8Tpe7DaYnh0UPGJEr8FVZ1LhQVtLDOZTAtaiVoii4j1GJXJbKnSXQHnUIH
         TEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayK1yTU9vTtR6bNGs5XkJj9p9VDpLKUU46m/EwAT5pw=;
        b=mn/M0EQoa34WokZZHacrCmS5ZI+k5zj+q5i37ZDK+x3TM3nds0ICIoZ20g4KEIo2X1
         rUFIODvgvSCZQn4e7mI3lIrD8edg5oFDdGV8TtUpNZVURmbkW63LZ1+6tK09NyFmAakQ
         APCQ02Xgv0UAGS9ShB24V3f1wEjfvlFrounVS7M2Sqc+HmgsugouyopGY6CdQnlee55X
         QPz1S2hzZ07nMMNx25befb4Ia6P6/v03Ho3+pnBtF8P1j9ZpYmFnc1r5yGTso1O44Ij5
         QEc3IrtekxQCBdsdmC0uFMAWoWSsDfSkN5QdACBdTf5daRKup96/uOUw78JNKeywK4c3
         lYag==
X-Gm-Message-State: AOAM531Uv50C8XAvo1fFHe8uZzCWEeeXQBzcqnTUD0o3qc0mKuKlspeG
        fnMJncPQrPuJQpzc6eUEVzY=
X-Google-Smtp-Source: ABdhPJwaaxZ9CaOLRMchSB8+F6i7w0ju6/xP1F6wKlJerjhk7cApxwFj5SpYa4gXD3vsYhskXF0mTw==
X-Received: by 2002:a17:902:e905:: with SMTP id k5mr8534248pld.342.1597611542891;
        Sun, 16 Aug 2020 13:59:02 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u5sm2425876pfm.149.2020.08.16.13.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 13:59:02 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/5] net/phy/mdio-i2c: Move header file to
 include/linux
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200816185611.2290056-1-andrew@lunn.ch>
 <20200816185611.2290056-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8011a4b-7269-12bc-fb13-c78b68df460a@gmail.com>
Date:   Sun, 16 Aug 2020 13:59:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200816185611.2290056-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2020 11:56 AM, Andrew Lunn wrote:
> In preparation for moving all MDIO drivers into drivers/net/mdio, move
> the mdio-i2c header file into include/linux so it can be used by both
> the MDIO driver and the SFP code which instantiates I2C MDIO busses.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   drivers/net/phy/mdio-i2c.c                    | 3 +--
>   drivers/net/phy/sfp.c                         | 2 +-
>   {drivers/net/phy => include/linux}/mdio-i2c.h | 0
>   3 files changed, 2 insertions(+), 3 deletions(-)
>   rename {drivers/net/phy => include/linux}/mdio-i2c.h (100%)

Likewise, should not we create include/linux/mdio/mdio-i2c.h?
-- 
Florian
