Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15E0A07F8
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfH1RAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:00:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33550 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfH1RAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 13:00:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so71076pgn.0;
        Wed, 28 Aug 2019 10:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=decKtc/g5mKDxnU3M4CnjbopGl5p5ls3xyrkhWq75Ck=;
        b=bv6EplGvmRQzBpcYi+Vkq1yWLxlv2X7wue/xacuLKnEcSpUmOSv+ilHDanoSiOArW9
         HzGijZK4WFbjrozxmTNL7COm4r5P5+Td9DazTuZ/zkWavR9kDU0K1cUX6yMsjXLEF+MN
         O0p0l5dsStPx/IRPj63FY44LY+SHHZFmxNsSBSbLMPKHOPtpGesSW0AqbTxbKYt1AQIs
         G7dcRUo1qYf4Ud9jorSVV4D+o49pMfSnhwC8W4VyAPP2gf4T87RrBMnLWodc/Ae0NyUP
         fcg6xoWni3WXj+MD8WaO3G0l/HFo+lgo8taCBtfpvtYByY1kp2ofTFxAzpC32YrudLWq
         mZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=decKtc/g5mKDxnU3M4CnjbopGl5p5ls3xyrkhWq75Ck=;
        b=i49Ryg9d93TE0OASPiV5JBk9MkkKt/UUubBkfVgp90WdNvmbpe0FpHpvnu1ScDCs1r
         ILtIT4YcU1SQBa2pI7H4+/5QrDhxqYMAOPq3S/+pMGUIgrB8mr0iPAQDpaV5Og2XXGL1
         DboqvLjVWTpd8B/0b5AdntFOhFSmIw346ilhBEu8BS8OhW2ubsIlX8ubx6WuXaAryik/
         m5Oagk2vvGkdA3kXIvxS8dlG4yoa8Ed02eeDjMVuUOXnz0LPP90H7c5mOs7ElGO7L7aY
         j4WMGK+EDt1kKnN2tmqIad4+a+qzP+FA/8o0L255lN8NfUHgbZB98iLf260Qbadi7fek
         ERgw==
X-Gm-Message-State: APjAAAXl7BzV6VCvvv/rrUjARtpBsvXj61AboiOenV+CbPE/yGYKrtlD
        uKTZ+68542dd67p8zmgVfSs=
X-Google-Smtp-Source: APXvYqyypedWBTazjZm8LOnMG0UBTWAl3VL5LhTz9b+j3K/ULPyjgSiTd5IqpJN9jMrUwVmn7chlNA==
X-Received: by 2002:a17:90a:fa82:: with SMTP id cu2mr5384513pjb.85.1567011606288;
        Wed, 28 Aug 2019 10:00:06 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n24sm3139642pjq.21.2019.08.28.10.00.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 10:00:05 -0700 (PDT)
Subject: Re: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
 <20190827154918.GO2168@lunn.ch>
 <AF233D1473C1364ABD51D28909A1B1B75C22CD3C@pgsmsx114.gar.corp.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <ef6aa10e-d3eb-e154-0168-d7f012858a2c@gmail.com>
Date:   Wed, 28 Aug 2019 10:00:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C22CD3C@pgsmsx114.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/19 8:41 AM, Ong, Boon Leong wrote:
>> On Tue, Aug 27, 2019 at 03:23:34PM +0000, Voon, Weifeng wrote:
>>>>>> Make mdiobus_scan() to try harder to look for any PHY that only
>>>> talks C45.
>>>>> If you are not using Device Tree or ACPI, and you are letting the MDIO
>>>>> bus be scanned, it sounds like there should be a way for you to
>>>>> provide a hint as to which addresses should be scanned (that's
>>>>> mii_bus::phy_mask) and possibly enhance that with a mask of possible
>>>>> C45 devices?
>>>>
>>>> Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
>>>> drivers don't look for the MII_ADDR_C45. They are going to do a C22
>>>> transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
>>>> invalid register write. Bad things can then happen.
>>>>
>>>> With DT and ACPI, we have an explicit indication that C45 should be used,
>>>> so we know on this platform C45 is safe to use. We need something
>>>> similar when not using DT or ACPI.
>>>>
>>>> 	  Andrew
>>>
>>> Florian and Andrew,
>>> The mdio c22 is using the start-of-frame ST=01 while mdio c45 is using ST=00
>>> as identifier. So mdio c22 device will not response to mdio c45 protocol.
>>> As in IEEE 802.1ae-2002 Annex 45A.3 mention that:
>>> " Even though the Clause 45 MDIO frames using the ST=00 frame code
>>> will also be driven on to the Clause 22 MII Management interface,
>>> the Clause 22 PHYs will ignore the frames. "
>>>
>>> Hence, I am not seeing any concern that the c45 scanning will mess up with
>>> c22 devices.
>>
>> Hi Voon
>>
>> Take for example mdio-hisi-femac.c
>>
>> static int hisi_femac_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>> {
>>        struct hisi_femac_mdio_data *data = bus->priv;
>>        int ret;
>>
>>        ret = hisi_femac_mdio_wait_ready(data);
>>        if (ret)
>>                return ret;
>>
>>        writel((mii_id << BIT_PHY_ADDR_OFFSET) | regnum,
>>               data->membase + MDIO_RWCTRL);
>>
>>
>> There is no check here for MII_ADDR_C45. So it will perform a C22
>> transfer. And regnum will still have MII_ADDR_C45 in it, so the
>> writel() is going to set bit 30, since #define MII_ADDR_C45
>> (1<<30). What happens on this hardware under these conditions?
>>
>> You cannot unconditionally ask an MDIO driver to do a C45
>> transfer. Some drivers are going to do bad things.
> 
> Andrew & Florian, thanks for your review on this patch and insights on it.
> We will look into the implementation as suggested as follow. 
> 
> - for each bit clear in mii_bus::phy_mask, scan it as C22
> - for each bit clear in mii_bus::phy_c45_mask, scan it as C45
> 
> We will work on this and resubmit soonest. 

Sounds good. If you do not need to scan the MDIO bus, another approach
is to call get_phy_device() by passing the is_c45 boolean to true in
order to connect directly to a C45 device for which you already know the
address.

Assuming this is done for the stmmac PCI changes that you have
submitted, and that those cards have a fixed set of addresses for their
PHYs, maybe scanning the bus is overkill?
-- 
Florian
