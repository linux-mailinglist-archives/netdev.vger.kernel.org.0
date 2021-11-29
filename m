Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4336D462243
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhK2UhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:37:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhK2UfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:35:07 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F38C0698E2;
        Mon, 29 Nov 2021 09:07:19 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l16so38346279wrp.11;
        Mon, 29 Nov 2021 09:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=RPtVND5JA3DspUC9hemnui7PsT/i5Eny1DeZFxA/D1E=;
        b=BXt7NSteFF6ww4RIpt1GN79fVDK0Fc9uNtwzV5JR+has54q5WXMqUqmBxUy7SPuFbX
         H7W9f6ul9Z9h2c6e2NOuSk3ACC02jOeITBxrM+aD6sh0cy/9zWlsIueY43HhaVdX0vxI
         yZjlC6ULD5/j6v/jxjVgAt6x8MWwEG6sMekJ1huSWwTaPSppzcfXWhXxFYYCiUbdcwv3
         cdyCOWFVpc+wd0XOBVWB1cQfYIZKyjjIe8dT+HN9Oi/elhh/tf9yTH8RL81fXKhtHUc+
         ysHtzt5OjSX7freWaTrvALNKNvMlfpESTYwiPch5Fr0V2WVgAtBXfE76wwbclbmxIDJw
         VTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=RPtVND5JA3DspUC9hemnui7PsT/i5Eny1DeZFxA/D1E=;
        b=pyjjsIAFsinPTY9wf+nxKDSzYHKrjwdwt3txCde7HTqfPBMxxGn4PO76MUHbpvyOvj
         7dicOL/Ej9QsDPJ0yB2ELqiocg49nqrdgdqi4t/9q2enic1khviaIuwpf20jmCcon+Di
         gpsruwZk56ODcpmHWuXU+JASK4K3RWR8exdfRXczguWDeWOkIZw9z6KrMFFozlxyO1GA
         QMIn0+gTpKnqOYJ5DFwvl0MocLDN0meWIKlf7X2T7b5cpw80AZMKRsna2MTmaKPgj44T
         +V6Gqzj3drvXUI/O3hXskdfpDrgHpY3Igir+trNy4gAuvkfU/BUnZ0YsjnhU85WET3yB
         u9rQ==
X-Gm-Message-State: AOAM531MTUFOdwcpr3DmQwTLbCJP8rvrP8QnhWPCER/DUdM0seGuye7a
        m0UGKP/AwoJoe2l5HkEzdYw=
X-Google-Smtp-Source: ABdhPJy+RxjU0PPq6nKzgD3jLQOdx2NoHa6HB+7pF/Xa3JAISuXjsJzl5m8TwPmw561HyXLEmIKO+w==
X-Received: by 2002:a05:6000:92:: with SMTP id m18mr35149120wrx.617.1638205638066;
        Mon, 29 Nov 2021 09:07:18 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:e474:c9cc:78a6:961d? (p200300ea8f1a0f00e474c9cc78a6961d.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:e474:c9cc:78a6:961d])
        by smtp.googlemail.com with ESMTPSA id x1sm14382786wru.40.2021.11.29.09.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 09:07:17 -0800 (PST)
Message-ID: <a85b5463-7742-af34-2f51-8a828d6fe866@gmail.com>
Date:   Mon, 29 Nov 2021 18:07:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211126103833.3609945-1-horatiu.vultur@microchip.com>
 <402780af-9d12-45dd-e435-e7279f1b9263@gmail.com>
 <20211129082958.ap6xtsb6jad3os4x@soft-dev3-1.localhost>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Add config_init for LAN8814
In-Reply-To: <20211129082958.ap6xtsb6jad3os4x@soft-dev3-1.localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2021 09:29, Horatiu Vultur wrote:
> The 11/26/2021 12:57, Heiner Kallweit wrote:
> 
> Hi Heiner,
> 
>>
>> On 26.11.2021 11:38, Horatiu Vultur wrote:
>>>
>>> +static int lan8814_config_init(struct phy_device *phydev)
>>> +{
>>> +     int val;
>>> +
>>> +     /* Reset the PHY */
>>> +     val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
>>> +     val |= LAN8814_QSGMII_SOFT_RESET_BIT;
>>> +     lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
>>> +
>>> +     /* Disable ANEG with QSGMII PCS Host side */
>>> +     val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
>>> +     val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
>>> +     lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
>>> +
>>> +     /* MDI-X setting for swap A,B transmit */
>>> +     val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
>>> +     val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
>>> +     val |= LAN8814_ALIGN_TX_A_B_SWAP;
>>> +     lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
>>> +
>>
>> Not directly related to just this patch:
>> Did you consider implementing the read_page and write_page PHY driver
>> callbacks? Then you could use phylib functions like phy_modify_paged et al
>> and you wouldn't have to open-code the paged register operations.
>>
>> I think write_page would just be
>> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
>> phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
>> phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
>>
>> and read_page
>> phy_read(phydev, LAN_EXT_PAGE_ACCESS_CONTROL);
> 
> Thanks for the suggestion, but unfortunately it would not work.
> The reason is that in the callback 'write_page' I don't actually get
> also the address in the page that is needed to be read/write.
> 
> If this issue would be fixed, then there is another problem.
> To read/write the data in the extended page is required to access the
> register LAN_EXT_PAGE_ACCESS_ADDRESS_DATA. But that would not happen
> when using the phy_read_paged, it would read actually the register in
> page 0.
> 
> If I have missed something, please let me know.
> 

Right, after reading the sequence in lanphy_read_page_reg() more
carefully I agree. This PHY re-uses the more complex MMD access
mechanism for paged access.

>>
>>> +     return 0;
>>> +}
>>> +
>>>  static int lan8804_config_init(struct phy_device *phydev)
>>>  {
>>>       int val;
>>> @@ -1793,6 +1824,7 @@ static struct phy_driver ksphy_driver[] = {
>>>       .phy_id         = PHY_ID_LAN8814,
>>>       .phy_id_mask    = MICREL_PHY_ID_MASK,
>>>       .name           = "Microchip INDY Gigabit Quad PHY",
>>> +     .config_init    = lan8814_config_init,
>>>       .driver_data    = &ksz9021_type,
>>>       .probe          = kszphy_probe,
>>>       .soft_reset     = genphy_soft_reset,
>>>
>>
> 

