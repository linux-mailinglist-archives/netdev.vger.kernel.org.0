Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DA831A95C
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhBMBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbhBMBJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:09:42 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4725BC0617A7;
        Fri, 12 Feb 2021 17:09:02 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o7so767384pgl.1;
        Fri, 12 Feb 2021 17:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a4fFtjL7ww0xO/IE/qxhkkmF2YUH054hAtl+fB7mCaU=;
        b=iF46XJb2/5FiyXpIHQB4xb4jHKKpqaD0ojDxp1o1ybaWPBsvBdiCjYjGtzS8QYW1Xb
         sDRCQBVYQuOxUSMKUutE357WwojKt7yrSuZlbqWMNZO9G170hnEX+iJ1Wv6dfbiKWjVX
         3+4IrxgO7UT78zP1RBvdEudyrnyyN15d4LauLicdkEONif+9aOg3OgHmJkb9HBsIs2kc
         iFz+UHxtMC0RbXKdWH+tuH6kVDc/TGmDNOMgRaZli0G6LYIeBGw6o32xYioxq0yLBef4
         4CZukDaj5PNVYHO8Qfxypi05p6doiihqpWhSvvfz4Y4PBsWluM8rhR8krl8xWwbbdB9q
         948A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a4fFtjL7ww0xO/IE/qxhkkmF2YUH054hAtl+fB7mCaU=;
        b=EfDzpDU4TbMcowGi18kqyA8NQzTORByJjXMUe3TrE9wsWn05TVTn2yCl1lw4ILT8yM
         iwL4fWBYW0suZOTZrFIsEto9NBPFHO4lEBGlllY668+cwW0e/H78Y5laTMTM72xfhXf+
         au7kcdnmHCvBaQr9gvpfI9CErS9aqrR21lGM7LpSkrt+NbY5NAEROLRod27udfJjuypQ
         gkIxg9UYQypc3E9s+d+6LI3C/dzk5StWp/1o/3zAbM1I5BX69hIACE8rYT2FkfwHfjmB
         7LKhlO5V/ijzl6wBz4+lwdZy2AI4Sd7NcLMztKj19sbdHzBwGJESbYZlMHHjIWMrU3Jz
         CMzw==
X-Gm-Message-State: AOAM5330chVQW3yGxWDqjZsbjAqdxdo1nixLusIZyGQF4Sfp8r5+Svx9
        I+sLWmooKkWV8N4zg0R71KU=
X-Google-Smtp-Source: ABdhPJxasaUpvKMVgJePqu0vCksPvS5vhSj0XbO5LF+O7pnoQJqqE6xx+VUvWRjxxpFUJuW5l4xB+w==
X-Received: by 2002:a63:f202:: with SMTP id v2mr4825090pgh.24.1613178541699;
        Fri, 12 Feb 2021 17:09:01 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm10218216pfh.199.2021.02.12.17.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 17:09:01 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: phy: broadcom: Remove unused flags
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>, michael@walle.cc
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
 <20210212205721.2406849-2-f.fainelli@gmail.com>
 <20210213005659.enht5gsrh5dgmd7h@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5cd03eea-ece8-7a81-2edc-ed74a76090ba@gmail.com>
Date:   Fri, 12 Feb 2021 17:08:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213005659.enht5gsrh5dgmd7h@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 4:56 PM, Vladimir Oltean wrote:
> On Fri, Feb 12, 2021 at 12:57:19PM -0800, Florian Fainelli wrote:
>> We have a number of unused flags defined today and since we are scarce
>> on space and may need to introduce new flags in the future remove and
>> shift every existing flag down into a contiguous assignment. No
>> functional change.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> 
> Good to see some of the dev_flags go away!
> 
> PHY_BCM_FLAGS_MODE_1000BX is used just from broadcom.c, therefore it can
> probably be moved to a structure in phydev->priv.

The next step would be to move it to a private flag, indeed.

> 
> PHY_BRCM_STD_IBND_DISABLE, PHY_BRCM_EXT_IBND_RX_ENABLE and
> PHY_BRCM_EXT_IBND_TX_ENABLE are set by
> drivers/net/ethernet/broadcom/tg3.c but not used anywhere.

That's right, tg3 drove a lot of the Broadcom PHY driver changes back
then, I also would like to rework the way we pass flags towards PHY
drivers because tg3 is basically the only driver doing it right, where
it checks the PHY ID first, then sets appropriate flags during connect.
-- 
Florian
