Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9471F358CE7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhDHSth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHStg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:49:36 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A6BC061760;
        Thu,  8 Apr 2021 11:49:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id g10so1510135plt.8;
        Thu, 08 Apr 2021 11:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iaZA9uccUhevRcQXh1gy8pD/RdVdtZQych5CAmgXTRw=;
        b=piIlDdMykZWRNqBj+SejOLbpkS//URH6CnbJ87LsCyZG15F2iCsmANew1vP9Xyd/ts
         2vAld14Jflhbah7+bgN5Kw1MefEAr73Z6/bQTjVWNYv4B1GNoL2J/KH/uK4fbIS7H2uv
         8n68AIc7mWbfp6XmZX3o2vrxKm4QqNBVIyUHFqKf4AtqUkH2Vv6XNHKZi7cpMJmDGsXk
         fm5V0Rf+J91w1LFABu5PIKEs1AfFdwFJqGVvrG6RsrRCZssvJhAN+xJ9OUes5lxuvPLP
         7IykOUOWIVPPGZbfvRsKe3mzgc+OYwjzR4vOkQSD92l+Wi4BkjqM4SbE6omsrWzzoaRk
         88bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iaZA9uccUhevRcQXh1gy8pD/RdVdtZQych5CAmgXTRw=;
        b=DQ5YDp3y9vCWIP3I0Sbv3t/gWzZbvxU1lTukxeeZCu34ASoOU1zXd1abMpmUKvsDHI
         S98fGghBy7T+cR6+yof6mJLq0tqqkjxH9EVh4ZJeBlNyOGzSMpsfvrQhEu9auT8VFyE3
         qs/3vch9NZU7rzlfoB4dZYg0Z6rqEpWVQutdkVGClamDJ3SlveNicZYHbeAtbshHOsoX
         excwJA7Z8qXj3C/B/oyoCxhSFUsqQnMQuGUAw4iMtRpXNYbeVqitU2YsWIpgE9UaXXOK
         ZilsaAE/2VS8xSuxQMlvgCDgCZ4nyohx/kf+qIkzNj/Zgg7Ir+uKukLBxnROXmKkTKEq
         AEmA==
X-Gm-Message-State: AOAM530XdHiavwUV7xnqOIJNasKnIpyhsoEK8R+rijXkAKl1q9Q4F3UF
        tBdhdfAdc3CFGE/52YVVli2Fi1JIEoA=
X-Google-Smtp-Source: ABdhPJz3VROIBwGEDOUQzf0UiQQ1EdfYV2EMhPwucdJKLC8iIMeYog8glMZikMgkbmoeCG/h3cGNhA==
X-Received: by 2002:a17:90a:df15:: with SMTP id gp21mr10013340pjb.127.1617907764302;
        Thu, 08 Apr 2021 11:49:24 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g12sm133641pjd.57.2021.04.08.11.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 11:49:23 -0700 (PDT)
Subject: Re: [PATCH net v2 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
 <20210408183828.1907807-3-martin.blumenstingl@googlemail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <19b78806-ff51-567c-5121-674db706682f@gmail.com>
Date:   Thu, 8 Apr 2021 11:49:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408183828.1907807-3-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/8/2021 11:38 AM, Martin Blumenstingl wrote:
> There are a few more bits in the GSWIP_MII_CFG register for which we
> did rely on the boot-loader (or the hardware defaults) to set them up
> properly.
> 
> For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
> bit and also we should un-set it for non-RMII PHYs. The
> GSWIP_MII_CFG_RMII_CLK bit is ignored for other PHY connection modes.
> 
> The GSWIP IP also supports in-band auto-negotiation for RGMII PHYs when
> the GSWIP_MII_CFG_RGMII_IBS bit is set. Clear this bit always as there's
> no known hardware which uses this (so it is not tested yet).
> 
> Clear the xMII isolation bit when set at initialization time if it was
> previously set by the bootloader. Not doing so could lead to no traffic
> (neither RX nor TX) on a port with this bit set.
> 
> While here, also add the GSWIP_MII_CFG_RESET bit. We don't need to
> manage it because this bit is self-clearning when set. We still add it
> here to get a better overview of the GSWIP_MII_CFG register.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Cc: stable@vger.kernel.org
> Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
