Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC604A52FB
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbiAaXMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 18:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiAaXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 18:12:21 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BDDC061714;
        Mon, 31 Jan 2022 15:12:21 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x11so13864581plg.6;
        Mon, 31 Jan 2022 15:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SJizipcR4GYK9nZ18E+KFW96TyLTsYwihcN1C/AM448=;
        b=aWcXVKRxL+6ZRKa44EMDdVBXQi/0d5gY3CC0jRPi0ZLah6xWVOcPeCvcWa6ToGjzAX
         GumvRzizw2AWbmS9gVIUcY4rZzeY45R6mxL1c0tvHm96/gDQAIT/j9weywQ1Iui6ntzJ
         1Iqa1Q/UI+f/0iZPMwTmVHiYFM3PpQltIQuJFe50NgwNWf8DDjMV3md5V4+658HfMz3T
         1+41XUufuKEMVyxiGx8Xr+Q0+Wl7IaIt+XwDVK5fa1QiK5whCfdwuLbSylX5bUxpmXQf
         rxjZJekm49lpXhOfL5d2GiACLHCEM5tWafMcdhmgVQ0Oe7wNMcuAC+bu5Yj48Vhfx90X
         5NGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SJizipcR4GYK9nZ18E+KFW96TyLTsYwihcN1C/AM448=;
        b=apRVKccIdWo1jVoDMrISMf44vL1xioIB44kkirM8wP3USxnZryyPoxDwDcPlMEqU1D
         2IRMaS9guE+LB6FIwi0uuoTWiGsmgJlEPCpDw10xLpZ1B6T7s2FkprsUT7fl+N5ZI9Xf
         jsicSj6k7vBq9lkFwg6xsTn+O/HcWD/BAGE2n/RwS3XUZKiwlnKNGOvbJUNI1j0LfKOQ
         oKGIj60sBl+IT3FFtNT96QBWR+SV1Jtfzjb9TQ3ndFEgaGQg8F9F7BHMKlI8g7BS3jbG
         z7MAJT8FRV+oPKHa4dwwGiAU1xe9nALAqwgJ0ARLn4lAjo0GkqjOIFtxF/iR+Vfip1LQ
         J/CA==
X-Gm-Message-State: AOAM533MDfN4rXm+LK3HCnbsBpEFaY+G8n6cFgARb50bPVHLxuALudTb
        uKGKKRzs4TkHI5AeKiXTd8U=
X-Google-Smtp-Source: ABdhPJzzRA8kg9q+xkPzZK046dUYTxAY+zYEU2m/UOB49ny4N0aYJ8rvgEAf+IQD1BWOoAwe65eTyQ==
X-Received: by 2002:a17:902:b414:: with SMTP id x20mr23623108plr.14.1643670741027;
        Mon, 31 Jan 2022 15:12:21 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t11sm4581778pgi.90.2022.01.31.15.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:12:20 -0800 (PST)
Message-ID: <f7860ae9-4cdf-206e-a0d9-31ced5bb21e7@gmail.com>
Date:   Mon, 31 Jan 2022 15:12:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC v6 net-next 3/9] net: mdio: mscc-miim: add local dev
 variable to cleanup probe function
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-4-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220129220221.2823127-4-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2022 2:02 PM, Colin Foster wrote:
> Create a local device *dev in order to not dereference the platform_device
> several times throughout the probe function.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
