Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47514217AB7
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgGGVvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:51:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6857CC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 14:51:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so778397wmh.2
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 14:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZQHIHJDrJSj27ixL0Q2Mok42mgwoNESaSDAyUskejSI=;
        b=O35meWRu0KM87sxrkliLgOGW9QxlPMemjJkeDPpXK7UyYAVoyOaVv1hQxNxWpypOAD
         4TcrtWT8g6GAPM66nJaNBOC/iXCM+W5020wmGcWTcZQVDPktKuLVocZk+a8qV4wf0gC3
         ZsGab75cvwaC/l/AfPq4wgyUyYlhmTnzsEKcLmtt2jHmFC5KVWSErzXY6+wbfSg+RqEq
         a83gkUDVG4ZRPg8dq/EKD9JCGjLuH9S3Sw8OC93l2gTCOrGyLAtoTzwfSZwn78jmfv0v
         wKhrxHZKDz8CrrkOiJPM3N/F1sUSI5TWbLddXRxN0HY6wd0yt/ceGfgV49lOLdmlEkPY
         56yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZQHIHJDrJSj27ixL0Q2Mok42mgwoNESaSDAyUskejSI=;
        b=sq8ZaEJXAkD1NyoDk2qskYN8fBKkKKBQX7kbBZ52MlMPx4j3tWQ7+a8/0f6/xL4AyH
         ROVmHHsUmZKAkC+U/b7ExZ0gBsbx/hviVxlKxJ01qBJ2++/T2u3txzhMDpl/10AKOQcH
         B9M7X4Q5/WZaWugiut2tPITeNWyK+zIONsIg77jhq5wYf2rfUZ4eH0n25NmRygo7+vUh
         p+/HZn/kR+Nwk4kv8x/vJZ+a7CVgIHawQ4QRC2jBbcuBIDH5c7MJQS6jHUSKq+KGQYzF
         gKNvoTh6X2ZbLx4KXAIn+QVOkz1cNaA0RDSmONn29/nwpYtjCuQty1tNGNcxD2L6QqP3
         HgeA==
X-Gm-Message-State: AOAM531N1kqSPiP18PwYIn1IEfZfxgfe1zv5KEkNiynxiD3sFvxIzFto
        dsBkzP754luulvrCZ9QM08I=
X-Google-Smtp-Source: ABdhPJwxKe9cjhJZbCTrjcX6ZdZ42dNFI4dyBHcGi1iTrLHUtcatNPfZvYqkEwV+O7s1+WRGvM2L4A==
X-Received: by 2002:a7b:ca52:: with SMTP id m18mr6036295wml.92.1594158676167;
        Tue, 07 Jul 2020 14:51:16 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w17sm2948856wra.42.2020.07.07.14.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:51:15 -0700 (PDT)
Subject: Re: [net-next PATCH 2/2 v5] net: dsa: rtl8366rb: Support the CPU DSA
 tag
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200707211614.1217258-1-linus.walleij@linaro.org>
 <20200707211614.1217258-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6a6b0715-6d82-5c96-239d-dacf338b13bd@gmail.com>
Date:   Tue, 7 Jul 2020 14:51:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707211614.1217258-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 2:16 PM, Linus Walleij wrote:
> This activates the support to use the CPU tag to properly
> direct ingress traffic to the right port.
> 
> Bit 15 in register RTL8368RB_CPU_CTRL_REG can be set to
> 1 to disable the insertion of the CPU tag which is what
> the code currently does. The bit 15 define calls this
> setting RTL8368RB_CPU_INSTAG which is confusing since the
> inverse meaning is implied: programmers may think that
> setting this bit to 1 will *enable* inserting the tag
> rather than disabling it, so rename this setting in
> bit 15 to RTL8368RB_CPU_NO_TAG which is more to the
> point.
> 
> After this e.g. ping works out-of-the-box with the
> RTL8366RB.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
