Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86A641FB32
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 13:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhJBLsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 07:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbhJBLsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 07:48:04 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2739EC061570;
        Sat,  2 Oct 2021 04:46:18 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id g41so49106149lfv.1;
        Sat, 02 Oct 2021 04:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4DJIItM2FWrgGH0UiE2IkSW9OJMaI+AG2VdPxfUUR5I=;
        b=IIPTgavOUo90wwODdx+/CN9IrSwM+20hM8eZbuyl23QKA6e5pPbL/+e8iy+q1KL2p6
         DbGol0FzQQ9ZSaptH/3qC/sdiP0mKUQg08t56zJJY73YluPwyfJEkMcv1u96QWm65QCG
         8HSKn+qDZ72qPg9wLb3kD6pcrrpaFcYai13tLJe65YLcpsXAHKfMvmmH24/1aFZAIMp3
         si8bipmfGphoADxgO0Rs3/bXvZYr2xAmTJT6kWvJZAvjjSAnZKciVBtXNekdQZb/21fa
         ml7cClnSrKGt9MZTSMyjjNWNziRU/uEA9xIYzl47iudzz0RrW3nj7iI1r32R43dQpJ9v
         hw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4DJIItM2FWrgGH0UiE2IkSW9OJMaI+AG2VdPxfUUR5I=;
        b=vubiVDLdHw1CuL/udJwdj7sVoNCFQSdNoezBBIbqFehYNnG6gqgr085eQsJcbGOGLv
         YVPeyLyTyWHU42xrPnvXR913ihLeKzZ3k0GAeifCf8xxe1+NFioZsvpr6VMzdpDbaDff
         ZkrNxQc3ltTnSpYaTZrnPjw32rVKtJEeW4R1UOGGOUahnO5AlVF6Guk9AmCDYba//8vL
         1JP+nsGy/QPiLfaBRiONBYDjiOXfVeeNRwZdZ49M9u6uq/EcKkQMDMGuI0DnDi9LPS/c
         wURtduhqPRPX/JCXT0I0tDL8TcdRxBELbYH/PCz1iBlwU9wwi2vsaJLf5qMk99Z6UxL0
         W0Ng==
X-Gm-Message-State: AOAM531c0J1P7fRN10wG73uHeZ/3NE9Q1BBTR8NSsbsxTjAwJfGEoNNs
        baIebigEHcv00UtNlm3k0hk=
X-Google-Smtp-Source: ABdhPJxgufrLx9SHL6JLhQoZbIE498UDDZer3ETrvG+uXjCBFO2/jb+pRWiBPwe91n8WxE1I2j8xUw==
X-Received: by 2002:a2e:a367:: with SMTP id i7mr3466046ljn.435.1633175176498;
        Sat, 02 Oct 2021 04:46:16 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id j23sm43970lfm.139.2021.10.02.04.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 04:46:15 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bgmac: support MDIO described in DT
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210920123441.9088-1-zajec5@gmail.com>
 <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
 <79c91b0e-7f6a-ef40-9ab2-ee8212bf5791@gmail.com>
 <780a6e7f-655a-6d79-d086-2eefd7e9ccb6@gmail.com>
 <c687a7b4-24eb-f088-d6d0-f167a8f9da1f@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <3b468d96-8c36-ec04-8993-97f1de12c34f@gmail.com>
Date:   Sat, 2 Oct 2021 13:46:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c687a7b4-24eb-f088-d6d0-f167a8f9da1f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.2021 01:04, Florian Fainelli wrote:
> On 9/30/21 7:29 AM, Rafał Miłecki wrote:
>> On 20.09.2021 19:57, Rafał Miłecki wrote:
>>> On 20.09.2021 18:11, Florian Fainelli wrote:
>>>> I believe this leaks np and the use case is not exactly clear to me
>>>> here. AFAICT the Northstar SoCs have two MDIO controllers: one for
>>>> internal PHYs and one for external PHYs which how you would attach a
>>>> switch to the chip (in chipcommonA). Is 53573 somewhat different here?
>>>> What is the MDIO bus driver that is being used?
>>>
>>> of_get_child_by_name() doesn't seem to increase refcount or anything and
>>> I think it's how most drivers handle it. I don't think it should leak.
>>>
>>> BCM53573 is a built with some older blocks. Please check:
>>>
>>> 4ebd50472899 ("ARM: BCM53573: Initial support for Broadcom BCM53573
>>> SoCs")
>>>       BCM53573 series is a new family with embedded wireless. By marketing
>>>       people it's sometimes called Northstar but it uses different CPU
>>> and has
>>>       different architecture so we need a new symbol for it.
>>>       Fortunately it shares some peripherals with other iProc based
>>> SoCs so we
>>>       will be able to reuse some drivers/bindings.
>>>
>>> e90d2d51c412 ("ARM: BCM5301X: Add basic dts for BCM53573 based Tenda
>>> AC9")
>>>       BCM53573 seems to be low priced alternative for Northstar
>>> chipsts. It
>>>       uses single core Cortex-A7 and doesn't have SDU or local (TWD)
>>> timer. It
>>>       was also stripped out of independent SPI controller and 2 GMACs.
>>>
>>> Northstar uses SRAB which is some memory based (0x18007000) access to
>>> switch register space.
>>> BCM53573 uses different blocks & mappings and it doesn't include SRAB at
>>> 0x18007000. Accessing switch registers is handled over MDIO.
>>
>> Florian: did my explanations help reviewing this patch? Would you ack it
>> now?
> 
> Thanks for providing the background.
> 
> You still appear to be needing an of_node_put() after
> of_mdiobus_register() because that function does increase the reference
> count.

I really can't find code increasing refcount.

I even attempted to runtime test it and I still can't see a leaking ref. See:

[    1.168863] bgmac_bcma bcma0:5: [bcma_mdio_mii_register] BEFORE count:2
[    1.176235] libphy: bcma_mdio mii bus: probed
[    1.181513] bcm53xx bcma_mdio-0-0:1e: found switch: BCM53125, rev 4
[    1.187936] bcm53xx bcma_mdio-0-0:1e: failed to register switch: -517
[    1.194610] bgmac_bcma bcma0:5: [bcma_mdio_mii_register]  AFTER count:2


diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
index 086739e4f..e52a3d8b7 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
@@ -233,11 +233,14 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)

         np = of_get_child_by_name(core->dev.of_node, "mdio");

+
+       dev_info(&core->dev, "[%s] BEFORE count:%d\n", __func__, refcount_read(&np->kobj.kref.refcount));
         err = of_mdiobus_register(mii_bus, np);
         if (err) {
                 dev_err(&core->dev, "Registration of mii bus failed\n");
                 goto err_free_bus;
         }
+       dev_info(&core->dev, "[%s]  AFTER count:%d\n", __func__, refcount_read(&np->kobj.kref.refcount));

         return mii_bus;

