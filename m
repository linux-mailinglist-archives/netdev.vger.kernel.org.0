Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CCD56A8AA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbiGGQxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiGGQxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:53:08 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1185857251;
        Thu,  7 Jul 2022 09:53:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id z14so19620262pgh.0;
        Thu, 07 Jul 2022 09:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yEdFXCGLYP6p24mUEYpfuF8XGgV1c9l+qum9gTsv/MM=;
        b=QCmDCcdxcPTv1Kk3qNPtKQIJrsSTwKodwYFoA4Uio6sThCwT3Wxz4yQ3gxfMoGLcOG
         FQRviSTYBWKdcXTP+2OVH0cUzSMnBBjv0AHcMNMfiDGHcqZ7sjuD1yjJ5Ha044OJli5a
         8FqV3Wou5/TJXt9YBSAW4j7qT/J3Y0pVP3cnScUwfENHl/nUPCN/QgyCb87CzobKbrVb
         u1/srX+dBqKtkOe/AtP1AFQQjuisYTmg2G/auZ35b41q4f6slCzwkVzuH7Wffb8Hi1vs
         y95RnWg0XEkaJgF7lPWLDiQ4wgC8E16gysBeHUPBh1ULMZf1W/7lybHNp9rS9hhu/WqE
         bPpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yEdFXCGLYP6p24mUEYpfuF8XGgV1c9l+qum9gTsv/MM=;
        b=hfu3k14s9d4Zoi0RSEsbs2IZ+Jw5jQhjym2zRHxGNQ+nhkgvDMIXERX7aGF8+kymPy
         1c/2xbtfDfZXB9x3AvBsYSD/n+ZXBhYOF9Ak61jTFyEDMSsJlSi6pNOUKnAMI2w3C0w6
         EznLpeoB8WNWuEYrDIMs7hQcTlmmOqnWbBK7r8Sfyk/+5jQAdWzYlPTJOImapkhFuRjU
         q9d623T4Pe+Pb2M6blsF/oOoMqmPxhtNSIoGB2o4/7DzpepEf/A+jpaPP9/IHCAUWlml
         o9iLV8646sHZ3AjW40T+uUF3tan3wUOrtkGwHrvLoQTqhr6OcCBmPXAAwSS5+r5FrAih
         1CyA==
X-Gm-Message-State: AJIora+LeRxwq6+Z1IomUxZcY6TbmgocxJqMLelCCcJTu+xFNkwywmk6
        O6upgjVMr2aUKmtJeNTD7po=
X-Google-Smtp-Source: AGRyM1vNrGgDokvfbc7rb0oMlFem0P2zbQrWEvUolVG47kpLqWLypzxZNbNO2vmRuPg6YzH9VQ+N7g==
X-Received: by 2002:a17:90b:2bd3:b0:1ef:9ac7:d90c with SMTP id ru19-20020a17090b2bd300b001ef9ac7d90cmr6235074pjb.53.1657212787423;
        Thu, 07 Jul 2022 09:53:07 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o13-20020a17090a5b0d00b001ea629a431bsm19753476pji.8.2022.07.07.09.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 09:53:07 -0700 (PDT)
Message-ID: <b503199e-61d2-4d60-99dc-0f71616f7ec9@gmail.com>
Date:   Thu, 7 Jul 2022 09:53:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH stable 4.9 v2] net: dsa: bcm_sf2: force pause link
 settings
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
References: <20220706192455.56001-1-f.fainelli@gmail.com>
 <20220706203102.6pd5fac7tkyi4idz@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220706203102.6pd5fac7tkyi4idz@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 13:31, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Wed, Jul 06, 2022 at 12:24:54PM -0700, Florian Fainelli wrote:
>> From: Doug Berger <opendmb@gmail.com>
>>
>> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
>>
>> The pause settings reported by the PHY should also be applied to the
>> GMII port status override otherwise the switch will not generate pause
>> frames towards the link partner despite the advertisement saying
>> otherwise.
>>
>> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> Changes in v2:
>>
>> - use both local and remote advertisement to determine when to apply
>>    flow control settings
>>
>>   drivers/net/dsa/bcm_sf2.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>> index 40b3adf7ad99..562b5eb23d90 100644
>> --- a/drivers/net/dsa/bcm_sf2.c
>> +++ b/drivers/net/dsa/bcm_sf2.c
>> @@ -600,7 +600,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>>   	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
>>   	struct ethtool_eee *p = &priv->port_sts[port].eee;
>>   	u32 id_mode_dis = 0, port_mode;
>> +	u16 lcl_adv = 0, rmt_adv = 0;
>>   	const char *str = NULL;
>> +	u8 flowctrl = 0;
>>   	u32 reg;
>>   
>>   	switch (phydev->interface) {
>> @@ -667,10 +669,24 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>>   		break;
>>   	}
>>   
>> +	if (phydev->pause)
>> +		rmt_adv = LPA_PAUSE_CAP;
>> +	if (phydev->asym_pause)
>> +		rmt_adv |= LPA_PAUSE_ASYM;
>> +	if (phydev->advertising & ADVERTISED_Pause)
>> +		lcl_adv = ADVERTISE_PAUSE_CAP;
>> +	if (phydev->advertising & ADVERTISED_Asym_Pause)
>> +		lcl_adv |= ADVERTISE_PAUSE_ASYM;
>> +	flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
> 
> IEEE 802.3 says "The PAUSE function shall be enabled according to Table
> 28B–3 only if the highest common denominator is a full duplex technology."

Indeed, sorry about that, so I suppose the incremental patch would do, 
since we do not support changing pause frame auto-negotiation settings 
in 4.9:

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 562b5eb23d90..f3d61f2bb0f7 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -669,15 +669,18 @@ static void bcm_sf2_sw_adjust_link(struct 
dsa_switch *ds, int port,
                 break;
         }

-       if (phydev->pause)
-               rmt_adv = LPA_PAUSE_CAP;
-       if (phydev->asym_pause)
-               rmt_adv |= LPA_PAUSE_ASYM;
-       if (phydev->advertising & ADVERTISED_Pause)
-               lcl_adv = ADVERTISE_PAUSE_CAP;
-       if (phydev->advertising & ADVERTISED_Asym_Pause)
-               lcl_adv |= ADVERTISE_PAUSE_ASYM;
-       flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+       if (phydev->duplex == DUPLEX_FULL &&
+           phydev->autoneg == AUTONEG_ENABLE) {
+               if (phydev->pause)
+                       rmt_adv = LPA_PAUSE_CAP;
+               if (phydev->asym_pause)
+                       rmt_adv |= LPA_PAUSE_ASYM;
+               if (phydev->advertising & ADVERTISED_Pause)
+                       lcl_adv = ADVERTISE_PAUSE_CAP;
+               if (phydev->advertising & ADVERTISED_Asym_Pause)
+                       lcl_adv |= ADVERTISE_PAUSE_ASYM;
+               flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+       }

         if (phydev->link)
                 reg |= LINK_STS;
-- 
Florian
