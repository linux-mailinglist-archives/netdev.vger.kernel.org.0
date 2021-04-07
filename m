Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2519A35725A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347732AbhDGQrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245696AbhDGQrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 12:47:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E79BC061756;
        Wed,  7 Apr 2021 09:47:37 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i4so1179278pjk.1;
        Wed, 07 Apr 2021 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oGh9bkiyj6+EkWkOQAdYaOgpqM5cW8idh8bXV6aXyO0=;
        b=FTFoS+IIVQZVCzbPWJKNuk9ooiaUnHASKGfJzfKbfXQMAecp/A3EwHonJ8kHmqDegt
         13uQx3ef/b3aPrKx1T7TdEV4qKRljsmP7r5Xd2C6B9GUGzvQNmDjLWq2gb8/Zgf6k0dR
         1nz/LWlz8h2dH4g71S9RzTSmdSWWGYuDQyO6SPpU8yGyP/UBSpxSN1ANvBWgxMqNqkmD
         DZ8VAKWtpA1SSCajpphfxLzVBsUp9y/W+D+nBMBn/S6sMO3masT3leI5yXvdUOHM3jb4
         rxEdmEchgi0/yhm26XU4jYGxrFVDSSZoqb3s2PfHwP/etqIy2atta7FC6rE5jbSfG6Ir
         KMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oGh9bkiyj6+EkWkOQAdYaOgpqM5cW8idh8bXV6aXyO0=;
        b=VYDeMkV6VUfjUHyWvUnXuc8XaL0xSMVK/UbFUT2NxkkrwM4ve+iL9AWwWb1kKGFpww
         kFWcN2dD45abbJG2wffGFtwG6lLLRysl35ToqcEVRp4ipJRf3j+8mHcP+tF7am6cPR9O
         nWf+ej0j1wnGmRdHUI+2ytGOgD2QWcherKMR4YDw/aP6kfFS+7AG+9/hXc8JsSpja/RN
         MMtGo18reC8OkXKLVIubNKaKm1erp1nN89ShLVgfT+25uib4S41zTtYEZjA0+wW+GXF3
         7o7S4TuZXJLMiC58AEM/Tlj8m7scfFQTjsHJVtr2sPRJrOF40RWUIkNJSx+WIPyz7Vf5
         gG3A==
X-Gm-Message-State: AOAM531NpMTEmjSe6YSETRWIB+Jr6fQTIdIbUyMmL/GnIbp+z6476UMT
        wcRqQ1eSuY85s8laV2tQFCd53C6T9kw=
X-Google-Smtp-Source: ABdhPJy9yq4HYZgj7+0LjaaaE7HmIOIeHCQulpqZzEk/JyIm2fgHsu7LnIP5ESNi7bwQG/5ncclsHQ==
X-Received: by 2002:a17:90b:3909:: with SMTP id ob9mr4233859pjb.181.1617814056539;
        Wed, 07 Apr 2021 09:47:36 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w7sm17762242pff.208.2021.04.07.09.47.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 09:47:35 -0700 (PDT)
Subject: Re: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
To:     Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
 <YGz9hMcgZ1sUkgLO@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <98ef4831-27eb-48d4-1421-c6496b174659@gmail.com>
Date:   Wed, 7 Apr 2021 09:47:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGz9hMcgZ1sUkgLO@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2021 5:32 PM, Andrew Lunn wrote:
>>  	case PHY_INTERFACE_MODE_RGMII:
>>  	case PHY_INTERFACE_MODE_RGMII_ID:
>>  	case PHY_INTERFACE_MODE_RGMII_RXID:
>>  	case PHY_INTERFACE_MODE_RGMII_TXID:
>>  		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
>> +
>> +		if (phylink_autoneg_inband(mode))
>> +			miicfg |= GSWIP_MII_CFG_RGMII_IBS;
> 
> Is there any other MAC driver doing this? Are there any boards
> actually enabling it? Since it is so odd, if there is nothing using
> it, i would be tempted to leave this out.

Some PHYs (Broadcom namely) support suppressing the RGMII in-band
signaling towards the MAC, so if the MAC relies on that signaling to
configure itself based on what the PHY reports this may not work.
-- 
Florian
