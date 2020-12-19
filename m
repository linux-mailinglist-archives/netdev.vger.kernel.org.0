Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDCB2DF09C
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgLSRH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgLSRH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 12:07:57 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345EDC0613CF
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 09:07:17 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id f14so3114363pju.4
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 09:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zcPwcPXMVpnY+3eclfJ/8aqJ3GoVY62IrGy7/V75q7k=;
        b=fD3UkN+hE3I4EXEN4uJ0V0s6uTHGW/RZwKYBi91VPLSZhW+LnT2hIId8K/QN5m7gz6
         oBnPA3JSId0M8/3sBGWKCnjsL17SNeuIGUo1ez/PjV1yQ637srrNsgnwpG76UcAfioFt
         HYQPMCQbCcZjQrDuSintyvhWhdIEyZMTqv0XsPXCjOVLaRAgBw+bPOXpC90m8WWpi+7p
         P9Ybk5He7MZbXl+7nWrifu+3ugwomWAY0Pd+m8j5M53zhgA4uR9tZzSjOKlc4869wGuU
         Kwd8vX/La5S9EcM+Ugtxn6NhHdzHdAkXez5rhraQhmeeeIEck+mfwuVnLklt3ktP2MNQ
         OvLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zcPwcPXMVpnY+3eclfJ/8aqJ3GoVY62IrGy7/V75q7k=;
        b=WUb0vrkpPQA8NnRJjYJuOMjxc9MQ/o/+4yK5WnlDacHld/cuRfVu7uZH4+vzbrSFA2
         EqwsQ5p9cizy9S/0pokXv7NIw40ItRII+YKwpz/7tvyVGi99vrfgc8v6b+sESXTKjIFB
         l9ch9vw2oh45VYlPsY4MjpSwFnyPid6qMPlz0mMATLdU/FURZ7IRcH0BHLb4MCR3rYh5
         vTl9yiC37qpKKw6I7NyiFR7rqQUhi3UfEtZlThQ7weKQ+rJCqjSUZpmGniofrPjrB//S
         lveP3TuaW1mdJencYWyuXXdqyanRqYgJBjW9+0ZAHeNaZcWmJTIexX5hdNbU5tGJykA2
         zLSw==
X-Gm-Message-State: AOAM533KoD4s0X6s3mNMcqYc4ucdoVJXFPRWJ22QsPpu2xOyZRJbbx7T
        mADTL2xOQxe2bGFejyK7LA8=
X-Google-Smtp-Source: ABdhPJzCNJAHHMGz9gyVfixo1zoozcw1G2uxKs1g3WPUZvjZcf5GHk4cal7zZ5ovqjJxxy/A2Yc14Q==
X-Received: by 2002:a17:90b:24c:: with SMTP id fz12mr9719452pjb.138.1608397636641;
        Sat, 19 Dec 2020 09:07:16 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v3sm11452583pjn.7.2020.12.19.09.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 09:07:15 -0800 (PST)
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
To:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
References: <20201219162153.23126-1-dqfext@gmail.com>
 <20201219162601.GE3008889@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
Date:   Sat, 19 Dec 2020 09:07:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201219162601.GE3008889@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/2020 8:26 AM, Andrew Lunn wrote:
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
>>  };
>>  
>>  static const struct of_device_id mt7530_of_match[] = {
>> -	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
>> +	{ .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
>>  	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
>>  	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
>>  	{ /* sentinel */ },
> 
> This will break backwards compatibility with existing DT blobs. You
> need to keep the old "mediatek,mt7621", but please add a comment that
> it is deprecated.

Besides, adding -gsw would make it inconsistent with the existing
matching compatible strings. While it's not ideal to have the same
top-level SoC compatible and having another sub-node within that SoC's
DTS have the same compatible, given this would be break backwards
compatibility, cannot you stay with what is defined today?
-- 
Florian
