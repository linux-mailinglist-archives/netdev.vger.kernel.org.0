Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B97C48588F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243105AbiAEShj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243101AbiAEShe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:37:34 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DE5C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:37:34 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t187so118688pfb.11
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aFf2D6+qU6oJQF9ewXkTxdtotIZSYvo+/xR4KIFvNmM=;
        b=j6dLjK1+wdOVSpJ4Iq38A/NETFiMy2F6LkFEwrSHC6iQM7r60k3g7H7ugvP810iqfH
         zA8ZFCOkp7oXC7mQpz1BBycINqYN65Xvbj0rdzt9MSTYCWzd5r0FglL/x83ZgGtaqE9o
         7Ms2IxxKA4gwSyb0icvZj/OvruQceYKMbViVG7pOfkd+HyUu2+EpQtUtoLUKsUr+JMpL
         H5AmSlGjZve3YzkZ6Pb3+YON8kog0vgtIz0QRRF/KfXUQ4P4R3PJSfLB4DrSvcqXvkuX
         RbldXB1c82OG+nXyK1XqPPp+1LnqLNvpfsrHg2Apz43tNypYEte+VMMADo7FSrxpXGtA
         C23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aFf2D6+qU6oJQF9ewXkTxdtotIZSYvo+/xR4KIFvNmM=;
        b=CIkjYyhjLvGXbfgglxvA5PCXnhEK/w1MZizchATYcbgTlEL7hS7nr3YJfD2keZpYv6
         6A9CJObtTE1hxDTknzK/4G3iTHi34mfygPY0bt0Jh9bqttTIpP3hJUvM5yebo7KffVry
         /XeoAoKRYZTh2/9v3IPzFp7GIUE40aKUkL67z2bT8LeRkA7Fs2TGZSdH0wtRyT2fxUHW
         502Z4sF1d785MPuCTAHroflzVdbZ2CqqFBQZ+8/2PUkZiOsAxYTzHMUIyf4+HQZ2beRq
         J2/grz5i4iJvP1K95OKvJ8i9dbVGSTQTmNo4H0ThQkDBKEEshKlBE8DqlbWLPoc7zrGQ
         FZPg==
X-Gm-Message-State: AOAM5314ebfMFOs7ZzQkLLhBhDi6yL1n6CGgULhQuCMueSbfWyhPQjXk
        AVSeygCcIrJgld03UaDq6O0=
X-Google-Smtp-Source: ABdhPJxTXTfZYsy1DX6z63PYjmx5YfNdgGHTnWxS/rXr7BVamYeVoDuoOgBHeSOoX5d4H0w0A55Hgg==
X-Received: by 2002:a62:4e4a:0:b0:4ba:8079:c463 with SMTP id c71-20020a624e4a000000b004ba8079c463mr56611680pfb.9.1641407853564;
        Wed, 05 Jan 2022 10:37:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b27sm3886756pfp.51.2022.01.05.10.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:37:33 -0800 (PST)
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <20220105142838.uzanzmozesap63om@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <feb17bce-256f-b667-1d38-578ac4ef8cfd@gmail.com>
Date:   Wed, 5 Jan 2022 10:37:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105142838.uzanzmozesap63om@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 6:28 AM, Vladimir Oltean wrote:
> On Wed, Jan 05, 2022 at 03:21:34PM +0200, Vladimir Oltean wrote:
>> This series contains changes that do the following:
>>
>> - struct dsa_port reduced from 576 to 544 bytes, and first cache line a
>>   bit better organized
>> - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
>>   better organized
>> - struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
>>   bit better organized
>>
>> No changes compared to v1, just split into a separate patch set.
>>
>> Vladimir Oltean (7):
>>   net: dsa: move dsa_port :: stp_state near dsa_port :: mac
>>   net: dsa: merge all bools of struct dsa_port into a single u8
>>   net: dsa: move dsa_port :: type near dsa_port :: index
>>   net: dsa: merge all bools of struct dsa_switch into a single u32
>>   net: dsa: make dsa_switch :: num_ports an unsigned int
>>   net: dsa: move dsa_switch_tree :: ports and lags to first cache line
>>   net: dsa: combine two holes in struct dsa_switch_tree
>>
>>  include/net/dsa.h | 146 +++++++++++++++++++++++++---------------------
>>  net/dsa/dsa2.c    |   2 +-
>>  2 files changed, 81 insertions(+), 67 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> 
> Let's keep this version for review only (RFC). For the final version I
> just figured that I can use this syntax:
> 
> 	u8			vlan_filtering:1;
> 
> 	/* Managed by DSA on user ports and by drivers on CPU and DSA ports */
> 	u8			learning:1;
> 
> 	u8			lag_tx_enabled:1;
> 
> 	u8			devlink_port_setup:1;
> 
> 	u8			setup:1;
> 
> instead of this syntax:
> 
> 	u8			vlan_filtering:1,
> 				/* Managed by DSA on user ports and by
> 				 * drivers on CPU and DSA ports
> 				 */
> 				learning:1,
> 				lag_tx_enabled:1,
> 				devlink_port_setup:1,
> 				setup:1;
> 
> which is what I'm going to prefer.

Yes this is indeed more readable. Thanks!
-- 
Florian
