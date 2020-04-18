Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE331AF511
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgDRVI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgDRVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:08:57 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA731C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:08:57 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id nu11so2708114pjb.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2R3d+t42V1gQ/yEZojtMi3x4F1G8tamN0heS+xvn+t8=;
        b=pjrs9RUxJcixgDwSyPc2Mabri/hw4Xu757WBHdIfOKnC0zWO9HHBKyOdl7EEuesU5I
         ziHDxBujGS1b6IQhi2jvDuQtv5oEUZjhylSRsKphSsXRPCFk7LY8yW1Z95S5av7FtNip
         oEoEGVCknKlH08ePiw+N6Grjr53k9t3bfTkDoJUkN/h7h6+COYWst25NZ+S+tSpGg/nn
         2Bz1lRXrRP1UdA19QpelI3bteIIqmIWMl9e5Vs4SEAZDIREKpLub6wR1WbgFmjrt631O
         9j7e4wqdpE39AOJbXjkc273pQyoo87Hep6fJF/8lgoyiihExg5RUBxlG6pF6GVARHp9i
         Wh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2R3d+t42V1gQ/yEZojtMi3x4F1G8tamN0heS+xvn+t8=;
        b=LN5Qu1/Cs46VEc2ZUGvvUxnsY6kKRuFF/EU+zljkoO2DftnKG8qbCvq9WVqBXAPyaU
         ppfoHNOSHtQplLUJgwHnlx+DBWsUNhy2Xk24E8vLay4ROO2wm4r/x2XxypxL1nEweoyQ
         D/QeXv8uQYmg61O2/4HyZIEFgluWqpTYrAK/othHm4tjTlLTCghtvP2vraseAiZpJR+g
         05rgbEPjYPMZI9x1SGSeDL2OsiaswYbB74+K8B1GJuqnDBiF/erLMORhqNLJONjGv/zQ
         /C0bR9ENDydOkOrazw7aT5GkyImjDp0cQrrVzX2FSgAuLklakUDYYqZMRsqEdKcACVJn
         nyZg==
X-Gm-Message-State: AGi0Pua8M5Oa+CpTcUEUd46WtMIR1qopkSs0TSA81c4BGiDfOb4s1GOH
        MCzWqCVAHj4NG9vio0GGNa0=
X-Google-Smtp-Source: APiQypKgrxnNOvINRPj5dYzaerVI25wLJ6sASMMdB4MguaREULRf19nl+DhCx/Udgej+R+nMwWP+7w==
X-Received: by 2002:a17:90a:2170:: with SMTP id a103mr12508895pje.181.1587244137220;
        Sat, 18 Apr 2020 14:08:57 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r24sm19328216pfh.1.2020.04.18.14.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:08:56 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <273c5e3d-3821-bc9f-4cb6-6a18bac7f738@gmail.com>
Date:   Sat, 18 Apr 2020 14:08:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418000355.804617-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> MDIO busses typically operate at 2.5MHz. However many devices can
> operate at faster speeds. This then allows more MDIO transactions per
> second, useful for Ethernet switch statistics, or Ethernet PHY TDR
> data. Allow the bus speed to be configured, using the standard
> "clock-frequency" property, which i2c busses use to indicate the bus
> speed.
> 
> Suggested-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
