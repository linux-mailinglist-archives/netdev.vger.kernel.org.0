Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A9046C985
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhLHAsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhLHAsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:48:23 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C670CC061574;
        Tue,  7 Dec 2021 16:44:52 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u80so958231pfc.9;
        Tue, 07 Dec 2021 16:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TqWvKqcH/2acnkYkfhbcvqPnlsMU3+vEEL1hOExIvSc=;
        b=ZEq1jj63Vd5xqjSjvrdDmW97rtgvvfmQ5FF22l+4f0X5nwuWo4j4+OL/kNh9ZbJf2s
         bxi2FxWyi8bdt1jXdjfk3erXkDrYh2bMuPGgNmsSX8zcPeoKeFhRuI2MMnxgb4YkKOKK
         NQfVOANZEE4zdAKd75ghc6LBvqBBcbzvwF51TWwmsCmzsPd2ltslDPNiaovSBAL78GiN
         YdyqHNjjQu6mjminKacztMpw8vlpFMVZf0qGwdKxLSRAKQB6yofFUSbnl2SxWHUhDwC0
         flyXmWPX25KPZy591+TOmdeWuH1mCuHwiKokMOjLRSZqTqWm+/TyYJ8N9f+HVJOjZMW/
         puwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TqWvKqcH/2acnkYkfhbcvqPnlsMU3+vEEL1hOExIvSc=;
        b=hBdJn2hDbAWn+R6Sd/2duIghQevH3Mwf2OvpcLeyBxr9JBaSOwlVr8mL8LppVB4RGZ
         4eGQfz9ikwERUdm9Mhugf7DWeW0h+deNZXm2M65kukMg+JAVvdWM02q1YIdfeaP240+u
         GuuX98kMilDwoMem7VdX2F91RAWscI7tt1bV0SXuX8Au3WAi/IcNlu9PnqntkD2S71ww
         fGmPpkgZI4fKWnITt9oEJ/yM81zoTjgTCOt1ZLA/GMTt/1ZHGgOYbuWdRy2iCkotpsmd
         39gzukSvGiJ12OTrY5ThxrNXV9JfR0w3/kDcpsv6NZuimQXstWvhrCFo9Wyx6hBs3EKs
         lbtg==
X-Gm-Message-State: AOAM532hxoWyCCN0rfK2u5j3s8OWcMichBOMZ/S5s7DvDD72Ht0CuJbL
        fjU2WXEIjAzWfn38euVoqGY=
X-Google-Smtp-Source: ABdhPJyz72yvyOr+yhTCXnVjKpyPnauFRRrMV9CZdepq7MvTCzpxqCI14Qowi9kLnbNhqtJC7qJiXg==
X-Received: by 2002:a65:5bce:: with SMTP id o14mr13763391pgr.347.1638924292330;
        Tue, 07 Dec 2021 16:44:52 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b1sm620565pgk.37.2021.12.07.16.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:44:51 -0800 (PST)
Subject: Re: [PATCH v5 net-next 4/4] net: mscc: ocelot: split register
 definitions to a separate file
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
 <20211207170030.1406601-5-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9cec8d9d-f3c0-8a82-cdea-a3ffc4923c69@gmail.com>
Date:   Tue, 7 Dec 2021 16:44:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207170030.1406601-5-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 9:00 AM, Colin Foster wrote:
> Move these to a separate file will allow them to be shared to other
> drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
