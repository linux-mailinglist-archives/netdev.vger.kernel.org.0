Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873813772D1
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHPzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhEHPzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:55:08 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D37EC061574;
        Sat,  8 May 2021 08:54:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b15so10080144pfl.4;
        Sat, 08 May 2021 08:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A4wL+A9NFIXZO6VfSDA2gKibBsfcU8LItXU93+dfo5o=;
        b=RhoOWzn+bIOM8v21/KV6+TCzr3h13tEo4CCQ9QLBCfAQgr3aLqBeJc7KGZ2DCVYOk9
         dQFbqcS1pnuIOj/YtwXQtFh8TksYU8xsCAscCaYM31jpoVYMmQCMAUta2DP9EiJKOdej
         /EMlEOIlruJUtY9XbZ4ru12+SzpjcXWoeqml/jos6CaWnawZ8TnWxg2NEVneIbF95L8y
         E/Dm1X1cPpUfGB9Jgu9/EP+0XnP5Tl5NTIqN3Y1IJglGQ/0G76V8A62jbnBfe9yWvXdM
         DI6QD2M9GX/hVDeciMv+6Gk+7MR4hhuaCnrEqAW3lFiC+lmIQZHZ3a0W5GQ3lTRm/Qtp
         Ykcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A4wL+A9NFIXZO6VfSDA2gKibBsfcU8LItXU93+dfo5o=;
        b=gAzEA+lF0O8Pv4pegBVguiNKoCdakau+remaPbaJzRwIuEkKLsXT/IlmH5AW91MDMj
         u+zV10lsS79CFEIJ8TLp2aeu0lBNRzbR/a+CZI9ZPqs5WsXWIq1ZYryGesA3SDLZCDnf
         HHGEZyNxQVisoMnjk3nb1s56cIKL9S+c0FTJcM4d2mLpQGUBiZeh0UEuuqKRJ6hNl19D
         yLnS5We45/MI3kvUgn5mUzSz6Phr6S8Fu7ePNJunygFSvfsIg8tNnVmw2tjT8Gq7rPK7
         ZR6G71oeadmo6BeO+rKtlVucToZ4BCZfr7Se5NI2wbeBEJSnaz6YjIM7G7k6/QAilgsB
         8xMg==
X-Gm-Message-State: AOAM5329EIgSrt0DPxBco6HyTBHNB9kQB1RLQk4aJZKxeA5ogvk0pEdC
        2NCU0ILwtk/J10gR6gOgMxBfvrTN6oU=
X-Google-Smtp-Source: ABdhPJyaakXZ2J65/RVzlRoauJv5DP+m0Sett6usmyuePj/OheNfCO/qD2Cs+rDiUUmiQhmQQAja0A==
X-Received: by 2002:a65:62c5:: with SMTP id m5mr15573342pgv.319.1620489245597;
        Sat, 08 May 2021 08:54:05 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id v8sm7305199pff.220.2021.05.08.08.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:54:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 03/28] net: mdio: ipq8064: enlarge sleep
 after read/write operation
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0822be80-e4ec-14f1-c319-b24ee38783a6@gmail.com>
Date:   Sat, 8 May 2021 08:53:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:28 PM, Ansuel Smith wrote:
> With the use of the qca8k dsa driver, some problem arised related to
> port status detection. With a load on a specific port (for example a
> simple speed test), the driver starts to behave in a strange way and
> garbage data is produced. To address this, enlarge the sleep delay and
> address a bug for the reg offset 31 that require additional delay for
> this specific reg.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I am still curious whether the problem is that you have lots of traffic
going through the same bus fabric (AXI?) and that eventually puts the
register accesses to a lower priority to get through. We would most
likely need someone from QCA to tell if this is even remotely a
possibility and this is unlikely to happen.
-- 
Florian
