Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9546F07E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhLIRIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242222AbhLIRG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:06:59 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C2C061746;
        Thu,  9 Dec 2021 09:03:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u17so4329019plg.9;
        Thu, 09 Dec 2021 09:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Op+42mbDhglNyviIkOZHonr4IeaA+i4s2xT7SfqcJB8=;
        b=L6sTzlddpyukALP/eLZJGVymU8I6sqeHHWxwCtW3j8t4ITN1+tmfBp2128TGzPPMSx
         iLx1Fc4n5aa4T1/LpZ3COj5hHFKKwIRFWRUOfssPpZhVprerAZIk/aYSnrvfejAZ5tDf
         lMM0c+jivpvLb9JPa7tU7Yr66vLaRHYBN8kc3o+PaiOZyLBRl1cZKXs42NiBmbSmfqNm
         59BuKWlsjCuL+vxTlyUT+3ynFbSbgQLJzTeBfBRQVSbD8f55N7mieuTgH/feqZxqdKm1
         vALZSpDa5IWBhp7lj1B1Pm5MzE0gJ+LMP5YkYAXfu4ARRkNdYRQX2P5EUSVO6M7ROmIq
         rKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Op+42mbDhglNyviIkOZHonr4IeaA+i4s2xT7SfqcJB8=;
        b=HtAlXkfAbkLlW7qzP2r0mYW3fQ5p4CWdnm9ZcNIJHICqYGT0Y6k6yaCwaHGBsC22oJ
         jVLIHwtUdGfLCeZwR2RpOWSBVOnAMlFKb6N0FcwTK5Z60+le2bf+0hjNEJG13sGwkwvA
         gtw2jvpbgT88XyPZjZhgvP/AQshB5CqrMjXCpQjjwqvckbm5HLtNTO1umfJjRigTQHLo
         evn5dZOLkoyfkiSSWtFL9cS3CnFOHiCOGpzFBZlPGkgHOWLlskCTc3HGuqp/PeYrx9Cv
         zJRZdbAzPZTRRhyL6o2cFbD821vKdjDhm0rYjD/tADW5q1uTWvFRjyQ+A9VtSvZTn7FS
         HBRg==
X-Gm-Message-State: AOAM532rp9Hq195ndFfES82b3nMazM1gPCv+BCCPtmnq2AuxsQm1WPGQ
        AX8LDA+nqI55ZdzTbsw6r4I=
X-Google-Smtp-Source: ABdhPJxXtm1k+sBFHHygrBG/44c1yDsQTafG7aspDubKC1Q08FQQEdprTc82px39jxTK/7wtr0yaBQ==
X-Received: by 2002:a17:902:ba84:b0:142:5514:8dd7 with SMTP id k4-20020a170902ba8400b0014255148dd7mr69407569pls.87.1639069405897;
        Thu, 09 Dec 2021 09:03:25 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16sm269627pfu.72.2021.12.09.09.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:03:25 -0800 (PST)
Subject: Re: [PATCH v2 net-next] net: ocelot: fix missed include in the
 vsc7514_regs.h file
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
References: <20211209074010.1813010-1-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <115ae71d-f0ad-c64f-5b0f-f58bc6615fb4@gmail.com>
Date:   Thu, 9 Dec 2021 09:02:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211209074010.1813010-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 11:40 PM, Colin Foster wrote:
> commit 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a
> separate file") left out an include for <soc/mscc/ocelot_vcap.h>. It was
> missed because the only consumer was ocelot_vsc7514.h, which already
> included ocelot_vcap.
> 
> Fixes: 32ecd22ba60b ("net: mscc: ocelot: split register definitions to a separate file")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
