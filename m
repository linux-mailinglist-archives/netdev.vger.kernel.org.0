Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B817271834
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgITV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:29:47 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A624C061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:29:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fa1so6221057pjb.0
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lna2Vd5ozUBpc/m2iC746B1ZL8q6Aok/LyO+k+OUBM4=;
        b=jO7KZTGFv0bcV220yf2LnWYhdR1VDCEf/n6PxRmqnvP6u4T4eGyGApdzexDTbU9oFW
         e2W23yVqRIbwMUJDBjy8aWKyABN+0rCQAaWc7sgLH9d/uWFcqvcyloQCUugWUuB8Tztb
         vzxFiRFPCkIlWtQtSe1lsdaGzi/bl3ITdFrQHhTv7R1ZJ2JfuUJtihfye0xNoyjqHJ4C
         ac8CBfFVLW6dE367psX7/oh3M0ml7NjF1f2DRu+IiW4MpsXm2MDC5z7KKuVjMkG8U+S0
         nQahp+gl3MebOVBStG902xHr5dqyijgREtz6JSQo6wuUV1N7nlETt/j8Y5SyOik6PyA3
         ljWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lna2Vd5ozUBpc/m2iC746B1ZL8q6Aok/LyO+k+OUBM4=;
        b=fZRqGtl4hgQJBC1sf6Lmn51e56EMfedat81OJyPLIER//2yjyZJKdS5sYCRGT3wQC6
         FkcDdco4CavdDgnNvrCJiNFkrzWofww+dEUiSFC7QUNr2ZSU06JvlyaWtpO4cRERXAQP
         +z2O3WKdM85Z+KS1CnRVxBXErSWOjpJ7pIDoNeFToloLwsriRIm15/tVvldNjJqKSa3Z
         r0VTqzCqls+waPSiwk4Rq9X7zaqSQbfcI2uQb/XRM3UfUpYf4JywM4yPhu2Zdy2DmTi1
         qTpmfs5jMXYtrDpvDy88Jf60jzSYo+vuUFFeYBfRmQA8uVdOrYnEkCCgtTCcuDDLwgkf
         pfcw==
X-Gm-Message-State: AOAM530RJosGrU1Dszn23+EEAwhjuYaeuzMDMks0fPML6r8Kbx2EXS7U
        sLt8zzvPlnYASHToxcda3Mg=
X-Google-Smtp-Source: ABdhPJxe3Pkm7fgqemSeD1Q/ALSurJAsWqgmtFj1mZ2XckgGEJ6f/afYn6Zu40srSWOkj8VPSkElYA==
X-Received: by 2002:a17:90a:d514:: with SMTP id t20mr20780075pju.134.1600637386569;
        Sun, 20 Sep 2020 14:29:46 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e1sm10571413pfl.162.2020.09.20.14.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 14:29:45 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200920171703.3692328-1-andrew@lunn.ch>
 <20200920171703.3692328-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: Document core PHY structures
Message-ID: <3b0df238-bedc-3030-f81d-2c50d3e99be2@gmail.com>
Date:   Sun, 20 Sep 2020 14:29:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920171703.3692328-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 10:17 AM, Andrew Lunn wrote:
> Add kerneldoc for the core PHY data structures, a few inline functions
> and exported functions which are not already documented.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Looks good for the most part, if you can capitalize Phy, phy or any 
variant in the process that would be great. See below for more specific 
feedback.

> ---

[snip]

> -/* Interface Mode definitions */
> +/**
> + * enum phy_interface_t - Interface Mode definitions
> + *
> + * @PHY_INTERFACE_MODE_NA: Not Applicable - don't touch
> + * @PHY_INTERFACE_MODE_INTERNAL: No interface, MAC and PHY combined
> + * @PHY_INTERFACE_MODE_MII: Median-independent interface
> + * @PHY_INTERFACE_MODE_GMII: Gigabit median-independent interface
> + * @PHY_INTERFACE_MODE_SGMII: Serial gigabit media-independent interface
> + * @PHY_INTERFACE_MODE_TBI: ???

Ten Bit interface, you can find some information about it here: 
http://www.actel.com/ipdocs/CoreSGMII_HB.pdf

> + * @PHY_INTERFACE_MODE_REVMII: Reverse Media Independent Interface
> + * @PHY_INTERFACE_MODE_RMII: Reduced Media Independent Interface
> + * @PHY_INTERFACE_MODE_RGMII: Reduced gigabit media-independent interface
> + * @PHY_INTERFACE_MODE_RGMII_ID: RGMII with Internal RX+TX delay
> + * @PHY_INTERFACE_MODE_RGMII_RXID: RGMII with Internal RX delay
> + * @PHY_INTERFACE_MODE_RGMII_TXID: RGMII with Internal RX delay
> + * @PHY_INTERFACE_MODE_RTBI: Reduced TBI
> + * @PHY_INTERFACE_MODE_SMII: ??? MII
> + * @PHY_INTERFACE_MODE_XGMII: 10 gigabit media-independent interface
> + * @PHY_INTERFACE_MODE_XLGMII:40 gigabit media-independent interface
> + * @PHY_INTERFACE_MODE_MOCA: Multimetia over Coax

Multimedia.

[snip]

>   
> +/**
> + * struct mdio_bus_stats - Statistics counters for MDIO busses
> + * @transfers: Total number of transfers, i.e. @writes + @reads
> + * @errors: Number of MDIO transfers that returned an error
> + * @writes: Number of write transfers
> + * @reads: Number of read transfers
> + * @syncp: Synchronization for incrimenting statistics

typo: incrementing.

[snip]

> + * struct mii_bus - Represents an MDIO bus
> + *
> + * @owner: Who owns this device
> + * @name: User friendly name for this MDIO device, or driver name
> + * @id: Identifer for this bus, typical from bus hierarchy

s/Identifer/Identifier/g even unique identifier would be better.

[snip]

> -	/* list of all PHYs on bus */
> +	/** @mdio_map: list of all PHYs on bus */

s/PHYs/MDIO devices/

[snip]

> + * @mdio: MDIO bus this PHY is on
> + * @drv: Pointer to the driver for this PHY instance
> + * @phy_id: UID for this device found during discovery
> + * @c45_ids: 802.3-c45 Device Identifers if is_c45.

Identifiers.

[snip]

> + * @interface: mii, rmii, rgmii etc.

You could reference the enumeration now that you defined its values.
-- 
Florian
