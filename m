Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC65B69E9C0
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 22:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjBUVwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 16:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBUVwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 16:52:50 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01E5E9;
        Tue, 21 Feb 2023 13:52:48 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id l15so7759245pls.1;
        Tue, 21 Feb 2023 13:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=53AdyNVXlHP7RjvnY1hA1Yfhgk81+nfodODupP0lcr4=;
        b=QMgGIkOzlNq5HPbeX4KcMqD50SPOGDjybDNChfPYwb5xD9QL44429OaJLnFyvGd9Bt
         aMdFeDFpvSAoeHozhEcBuZESaGKOG1zyBexeQQX0yfICAxn4ukJNNagkRuXP5KJV9jWS
         z5Z03OkGIu2KJXM7stQiFO1UPUsEyKGz8Mynmo2AkCP4CEV9Hmtkq+tEgep2MN4U44tf
         Rd5BNQV8PJDr3Z0+3ii01c7P8ZtuaDc2wyMFvaANKAplMhVUcY7TfCeW+BC+BWuDGY5u
         D22L0pKEHQzkpE0o4AU3Z2vP55mC8yzkm7Zx4VtoadDq8rlOviseNOFuGsYowyjb0Jqz
         axeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53AdyNVXlHP7RjvnY1hA1Yfhgk81+nfodODupP0lcr4=;
        b=QgI0YPELT1pWqcOQp8okpm0pHHpYmvRLufBeX3ZNlJApytpHlHXu3hw2LP/elEhYCv
         qnjDr+0szss4I50JIfzJApsGJNz9RlRxLcPLguKUjjrgQYmCvomdq4P8aFfsVOZO2oTE
         8PiLnkDHO6CIJ1HQzvFwIGvt2FaLO2QE+CPuslGgWI1nbSEnJ9jRfgV66KBEEizrkZYE
         IEGUuCFhAxw8/8gdd1Zxig5d13xImcbt/VKvrtdANrqMRvGcqff0FUKPpidGbbfDSj5J
         he/HIh+UiqfQKTmB2TMThGQXakhSCW1jHWD/aVpudfnIOxKLhg9vEsmWikdLwmpA3n2w
         CDiA==
X-Gm-Message-State: AO0yUKU1vdfhxDrKW94ZUseYd/HFZyD4rPDrczEi7fB4t89tAqAXrOJ8
        lPQwFdcdK2aBcinETy5ROVs=
X-Google-Smtp-Source: AK7set/YwJVw+NshoUc6KGAagiLsWirf7I2eOdPnPG/8DlZB2K3fW6EdA0D5TpK5gNqfUEw8a61c5w==
X-Received: by 2002:a17:903:1111:b0:196:8d48:8744 with SMTP id n17-20020a170903111100b001968d488744mr9780139plh.40.1677016368241;
        Tue, 21 Feb 2023 13:52:48 -0800 (PST)
Received: from [10.69.33.24] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p15-20020a170903248f00b0019a7f427b79sm4030137plw.119.2023.02.21.13.52.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 13:52:47 -0800 (PST)
Message-ID: <af2a622f-033c-739a-858d-18c65f7afd17@gmail.com>
Date:   Tue, 21 Feb 2023 13:51:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: BCM54220: After the BCM54220 closes the auto-negotiation, the
 configuration forces the 1000M network port to be linked down all the time.
Content-Language: en-US
From:   Doug Berger <opendmb@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Wang, Xiaolei" <Xiaolei.Wang@windriver.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <MW5PR11MB5764F9734ACFED2EF390DFF795A19@MW5PR11MB5764.namprd11.prod.outlook.com>
 <ae617cad-63dc-333f-c4c4-5266de88e4f8@gmail.com> <Y/UehVXRNHuRprAv@lunn.ch>
 <33198e39-8c86-85db-76c2-c5ce18dee290@gmail.com>
In-Reply-To: <33198e39-8c86-85db-76c2-c5ce18dee290@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/2023 11:53 AM, Doug Berger wrote:
> On 2/21/2023 11:41 AM, Andrew Lunn wrote:
>> On Tue, Feb 21, 2023 at 10:44:44AM -0800, Doug Berger wrote:
>>> On 2/17/2023 12:06 AM, Wang, Xiaolei wrote:
>>>> hi
>>>>
>>>>       When I use the nxp-imx7 board, eth0 is connected to the PC, 
>>>> eth0 is turned off the auto-negotiation mode, and the configuration 
>>>> is forced to 10M, 100M, 1000M. When configured to force 1000M，
>>>>       The link status of phy status reg(0x1) is always 0, and the 
>>>> chip of phy is BCM54220, but I did not find the relevant datasheet 
>>>> on BCM official website, does anyone have any suggestions or the 
>>>> datasheet of BCM54220?
>>>>
>>>> thanks
>>>> xiaolei
>>>>
>>> It is my understanding that the 1000BASE-T PHY requires peers to take on
>>> asymmetric roles and that establishment of these roles requires 
>>> negotiation
>>> which occurs during auto-negotiation. Some PHYs may allow manual 
>>> programming
>>> of these roles, but it is not standardized and tools like ethtool do not
>>> support manual specification of such details.
>>
>> Are you talking about ethtool -s 
>> [master-slave|preferred-master|preferred-slave|forced-master|forced-slave]
>>
> I am, though I was not aware of their addition to ethtool and I avoided 
> referencing them by name out of an overabundance of political 
> correctness ;).
> 
> Thanks for bringing this to my attention.
> 
>> The broadcom PHYs call genphy_config_aneg() -> __genphy_config_aneg()
>> -> genphy_setup_master_slave() which should configure this, even when
>> auto-neg is off.
> Yes, this sounds good. Perhaps Xiaolei is not setting these properly 
> when forcing 1000.
> 
Hmmm. I just revisited 802.3-2018 40.5.2 MASTER-SLAVE configuration 
resolution and I see it contains this statement:
The MASTER-SLAVE relationship shall be determined
during Auto-Negotiation using Table 40–5 with the 1000BASE-T Technology 
Ability Next Page bit
values specified in Table 40–4 and information received from the link 
partner.

So it appears that the only normative behavior requires Auto-Negotiation 
to be enabled. It seems reasonable that an implementation might allow 
the forced-master and forced-slave configurations to be applied when 
Auto-Negotiation is not enabled, but this case is outside of the 
standard so an implementation could also fail to establish a link.

>>
>>      Andrew
> Thanks again!
>      Doug

