Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC88F1CE273
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbgEKSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729673AbgEKSTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:19:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133F2C061A0C;
        Mon, 11 May 2020 11:19:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so5099355pfb.10;
        Mon, 11 May 2020 11:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2yn5GXC9T6aSzTW6H4dYcP7c5PsUvDbh9LGMtXFoYdo=;
        b=Aq910p+Yyl0NUj51AIGFT5dqADLURjqwfNLwCviq2V2e6IyNRE0Woic2Vu/aZY+Wuw
         OZBtaHtiA5V1YoWxNwDk9HqxI86LWCOfn5pSOE1ZCPLXL/URY4K3uFsV5l8N42B+MOeV
         lEYiU0IYUlS7i0ge8nnR96ZL0rmsXPgwquW/ANj8qmPt03b0VJvkdlY4hK81N6qEy85W
         BagEBgfsaESW+uJS4AQYFYMizc+41KQZcwU8z5TT0M8nV66Gt9nQp7TQDICSOpTAnb6S
         AJBfioyebEQ85c33zPzvFHr8NJ+nM367a5uejlj58YxFOaJXENVK65Dxw2XlZhv5O0Fe
         4NiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2yn5GXC9T6aSzTW6H4dYcP7c5PsUvDbh9LGMtXFoYdo=;
        b=gFNOrHtIYpzHkyrs7XqMpTFgzDrYFnRR+WYiKtRJcpmz6x6K7niXr9lxA+31YoOxHT
         aHg4mVd/yFqWUxat/W/Ssr6evFUCIRtjdl/3cEK9bBcwY9GhtlZWG8Gpd4G46anQlEhL
         aKaW/1HekojX0IUshTeafhC70+KEFY0/JxnLzITBgWinP0E0V8dObP9f/qGexiWVwJPo
         1Nj04ehkFTvTqeWyMOTV0+bzwOtq9AnJ3zV4yQAeLE9IM0CWc/6ZjXT114feSKwx3HvV
         OB6HeHChhrfPYWxTUg6OVesm4Ju+khQ62+oN4n7YSblZ3654kF80CMGjHI1KJ6dYXOsG
         XSsw==
X-Gm-Message-State: AGi0PuZJwHOjOrpnjAFnNSRMk+2XGc2suyV5gZGB/s8VZB45vmrdIx1d
        4U/GcC5/3J8/Lqf59bjDQR8QDtZY
X-Google-Smtp-Source: APiQypJ4JovztU5Ka0iRgeBfoFCff5vzLGOGPv8Ai8O2UPhxnrJPg43yND7I/2OLBphSSYvOWmZQYA==
X-Received: by 2002:a63:5345:: with SMTP id t5mr14380704pgl.401.1589221183268;
        Mon, 11 May 2020 11:19:43 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g16sm9860744pfq.203.2020.05.11.11.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 11:19:42 -0700 (PDT)
Subject: Re: [PATCH net] net: broadcom: Imply BROADCOM_PHY for BCMGENET
To:     Marek Szyprowski <m.szyprowski@samsung.com>, netdev@vger.kernel.org
Cc:     nsaenzjulienne@suse.de, wahrenst@gmx.net,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tal Gilboa <talgi@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andy Gospodarek <gospo@broadcom.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <CGME20200508223228eucas1p252dd643b4bedf08126cf6af4788f9b01@eucas1p2.samsung.com>
 <20200508223216.6611-1-f.fainelli@gmail.com>
 <350c88a9-eeaf-7859-d425-0ee4ca355ed3@samsung.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <51710a87-5a99-35ee-5bea-92a5801cec09@gmail.com>
Date:   Mon, 11 May 2020 11:19:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <350c88a9-eeaf-7859-d425-0ee4ca355ed3@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 12:21 AM, Marek Szyprowski wrote:
> Hi Florian,
> 
> On 09.05.2020 00:32, Florian Fainelli wrote:
>> The GENET controller on the Raspberry Pi 4 (2711) is typically
>> interfaced with an external Broadcom PHY via a RGMII electrical
>> interface. To make sure that delays are properly configured at the PHY
>> side, ensure that we get a chance to have the dedicated Broadcom PHY
>> driver (CONFIG_BROADCOM_PHY) enabled for this to happen.
>>
>> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
>> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>> David,
>>
>> I would like Marek to indicate whether he is okay or not with this
>> change. Thanks!
> 
> It is better. It fixes the default values for ARM 32bit 
> bcm2835_defconfig and ARM 64bit defconfig, so you can add:
> 
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> There is still an issue there. In case of ARM 64bit, when Genet driver 
> is configured as a module, BROADCOM_PHY is also set to module. When I 
> changed Genet to be built-in, BROADCOM_PHY stayed selected as module. 

OK.

> This case doesn't work, as Genet driver is loaded much earlier than the 
> rootfs/initrd/etc is available, thus broadcom phy driver is not loaded 
> at all. It looks that some kind of deferred probe is missing there.

In the absence of a specific PHY driver the Generic PHY driver gets used
instead. This is a valid situation as I described in my other email
because the boot loader/firmware could have left the PHY properly
configured with the expected RGMII delays and configuration such that
Linux does not need to be aware of anything. I suppose we could change
the GENET driver when running on the 2711 platform to reject the PHY
driver being "Generic PHY" on the premise that a specialized driver
should be used instead, but that seems a bit too restrictive IMHO.

Do you prefer a "select BROADCOM_PHY if ARCH_BCM2835" then?
-- 
Florian
