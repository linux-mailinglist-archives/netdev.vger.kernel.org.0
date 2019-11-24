Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBA10817A
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKXCfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:35:01 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40748 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXCfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:35:00 -0500
Received: by mail-pl1-f195.google.com with SMTP id f9so4884312plr.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aCxfmpw6xFMQsH0PMgD2wEqkiouLFZYLHWTSbq5KYkM=;
        b=Iyha71TIaAg/veuNz/2483TFLUscAexCtYPGq+oY1gUBhi/ff4cemRjG3Y4xXY+TFQ
         O9ql71hZGyWHCtMzNxJ/RWp+cvrByLph8sr7r0k/3dM3J2MKhbAS2ToJusmcOsbzf7gq
         /ccNK3wcdkJQsJYoJPYylEVx5fW4Tgaq9dv5F1IrD7PiXWMvREY5tE2PBm/vU0aFC6Yj
         PwDaj246pi8zKYDlQCdpPMhmhri+t8BXBwTSC7wdDSccAk4qwi+vOswCVI+mQDR2NBwT
         73EgZ7gs4RGQJ5OHSbbPVAzAJrvK9jzMleDsY7sTlC9EmNouohdfMTYJnQMrklie7nkm
         GQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aCxfmpw6xFMQsH0PMgD2wEqkiouLFZYLHWTSbq5KYkM=;
        b=I66vH1n2G631I14mwOrtjXaYZk0s3E9cMwYPf4SQh/odge9i31PiEWbekcPsXFib16
         ku7u8EFyxzV4KculjRxUxej912vtLiD6zV2CAX1hM1lWcnNH1j4KjJ6OzfncSyo3p08A
         mpm+D0McM+6BKG5vC5iY2Mnq3h33ppFYRdrnrnloxJWCpTgASzBzH3xFUXpplKZEVvOc
         OqDyujkrvl57P3vUIzQ1EvNT52mIJlmjmcot2CRdTnMnRFK3JrTxu1rsgl5eaejkOYGb
         Z/WOAJzx7LNpceHmiD+I+9XK+elsI0ONl0d+UR6FU8FRCw8nUoKqefEDD+80ZPcyoETU
         IRCA==
X-Gm-Message-State: APjAAAXnWW+IaQP/lEdMdaNrZWuwwRC6N8+SG74zrbFr93QeVv6HVE9R
        xSpbm6B1PmzV4la+w5x1YGOJsw==
X-Google-Smtp-Source: APXvYqwVLtPb9Y66MfjtEJ3pY/cbVHyEpaqcazb0NNI5OZUjqIM/ZX4qjxPKhkH9KEDMjRA0yO877Q==
X-Received: by 2002:a17:90a:a4e:: with SMTP id o72mr29191875pjo.66.1574562900160;
        Sat, 23 Nov 2019 18:35:00 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j7sm3191767pjz.12.2019.11.23.18.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:35:00 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:34:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Nishad Kamdar <nishadkamdar@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Use the correct style for SPDX License
 Identifier
Message-ID: <20191123183455.6266e9a8@cakuba.netronome.com>
In-Reply-To: <20191123130815.GA3288@nishad>
References: <20191123130815.GA3288@nishad>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 18:38:19 +0530, Nishad Kamdar wrote:
> diff --git a/drivers/net/phy/aquantia.h b/drivers/net/phy/aquantia.h
> index 5a16caab7b2f..40e0be0f4e1c 100644
> --- a/drivers/net/phy/aquantia.h
> +++ b/drivers/net/phy/aquantia.h
> @@ -1,5 +1,5 @@
> -/* SPDX-License-Identifier: GPL-2.0
> - * HWMON driver for Aquantia PHY
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*  HWMON driver for Aquantia PHY

You're adding an extra space here. Is this intentional?

>   *
>   * Author: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
>   * Author: Andrew Lunn <andrew@lunn.ch>
