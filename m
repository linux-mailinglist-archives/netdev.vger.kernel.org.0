Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194ED31B150
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBNQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhBNQu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:50:56 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567A0C061756;
        Sun, 14 Feb 2021 08:50:17 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a5so4042594otq.4;
        Sun, 14 Feb 2021 08:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ep7Dse7HKqu4k0rVQiHlEjLkpgG3iM9OzAnuQMfsNCI=;
        b=RIWcHB5TR1QRIXJbIAn5ku9YAsIVznhwQbRRF39qJ7gF4mjvjSui1aqz1itR/NBh15
         AcwLrRjwH2cC4pzWqoscdE31rwUTm3nlYef6Ia0z3RweFQFxY6axkqsUah+ciEzuclhf
         AKivDnEuqMzrlXqJHf+WM44A/JIg9x6+gv/Tv1C+2PpVY8Ty1J+qloGO99xRMw+7x6Bq
         ryBH7cq/YaUwCndyUPjokl3ri8AZzYT9cJ+yAfOLZOZH53NRihpgjjZo+JgRsQUZTgR1
         1Ioc2TZSv7vawlit6TmjKaF8uPaeP2S64D/Z97ZuSSHPmTh222DL0nEXVpOwhI4FArQI
         t3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ep7Dse7HKqu4k0rVQiHlEjLkpgG3iM9OzAnuQMfsNCI=;
        b=QyWfzPKXGnR5Adct+U5l/2JHP65roTbSsjkuValh0IGDs0CqoxdKV4qrfwjmEkoJ7l
         4djyiuuwdyBzLadUs/bYP5ta+e1tOaI86v39zPoB4PUGj1Mh+16fIh17os6Lvu+Jajrz
         aeCXE5CUBlP4STceENwETihNjk9sLl+Kex5R4LOQLJUcYViLLjCqN7lREYQ94DAp4cHu
         B0aYd2pyaF0VA/nv7xf1YZo73OK+af++sTm3NiVNsKIJp1mEBQAHCthRC+I7rSceqshj
         tqLw/cLtj9gOafqYZWTNZZx0vMcteebFN5hQrXLlmBrqOo6MJxSAN4wn7SoxmQi+/JVX
         C0Qw==
X-Gm-Message-State: AOAM530wFqYgwS3N1bozHvxlz97iFwfo2RL6s5dz3WxlzkEEB2LnIWDS
        +kHZmocFBhvxZZCZfogLQrE=
X-Google-Smtp-Source: ABdhPJz0quFeF+OlQXnJ6km+elC6aoTpFoddWnq/8GH9qAzeD2e5II7gNtd/02EZgnvngtYAmdAO4g==
X-Received: by 2002:a9d:5c8d:: with SMTP id a13mr1238226oti.341.1613321416650;
        Sun, 14 Feb 2021 08:50:16 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5500:ef1:ca58:910f? ([2600:1700:dfe0:49f0:5500:ef1:ca58:910f])
        by smtp.gmail.com with ESMTPSA id p20sm2848444oos.46.2021.02.14.08.50.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 08:50:16 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: rename PHY_IGNORE_INTERRUPT to
 PHY_MAC_INTERRUPT
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Byungho An <bh74.an@samsung.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <90101c72-99a8-c12a-9278-d99d85c43767@gmail.com>
Date:   Sun, 14 Feb 2021 08:50:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <243316e1-1fa3-dcbb-f090-0ef504d5dec7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2021 6:16 AM, Heiner Kallweit wrote:
> Some internal PHY's have their events like link change reported by the
> MAC interrupt. We have PHY_IGNORE_INTERRUPT to deal with this scenario.
> I'm not too happy with this name. We don't ignore interrupts, typically
> there is no interrupt exposed at a PHY level. So let's rename it to
> PHY_MAC_INTERRUPT. This is in line with phy_mac_interrupt(), which is
> called from the MAC interrupt handler to handle PHY events.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Heiner!
-- 
Florian
