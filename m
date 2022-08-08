Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C1158CF95
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244328AbiHHVTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244331AbiHHVTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:19:06 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492DE1AF3A;
        Mon,  8 Aug 2022 14:19:05 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id d8so2824332qkk.1;
        Mon, 08 Aug 2022 14:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=/W1hvzubxBYod9WsPFOgXwUrgoJJswMrDqkBVXc072g=;
        b=FENZYDZxfSrZ/W9bPWYmJ9IxImCcPgXH03zT61wWyaExT7g47K128TNBD/j1EiH/e3
         EVe15jy6yAUr21eHVeYNJ4Sxuj2RJlq3vf7FrjrJDgqmcHuD/ihucOlodZeEUxt1U9Ns
         9aQpU70x3BmhBJhAkWZAz52hasUvuEsTdSI198g/ugRYaI+OshvQ9+Wi+9e6bdPxzsLt
         r3dIbR8SfPVvCkkVBWX1bamwBgVP6Xtn0e6T4EbBCaMjai3FjeYrkAnDv7LLkGn6axc5
         QN7gNv20cKP1oC3+jY/JFALo+miBPbS+wtnqQfQF7CnE5mnqn76a5yRbHN8zT6Pv79YY
         tWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/W1hvzubxBYod9WsPFOgXwUrgoJJswMrDqkBVXc072g=;
        b=Y9WnqTwk3PkJf8rXTTWRq5UHvS+i/kEGZ1B0Xljzzvc1AxT3ZXZW5nN2oLY3iZ0H9n
         k5eWHO6h7FJ2QYG67+SF5frijHqxSMCMEcp5Q6ZPx7eb1K9MN7+YAF2Vd06CwZmG0Q3j
         lHTAbfYN+eHKxlh123IIGyoSC8X3D6QCp9km6a4f7dF+4N608VXAuMzgpaDhwtt1oThc
         TWnxHGk9OTyMzsODIb3eA6mjWSdrFSktui0femsbaEaiBINVP5puCxknpO9O+/Dxo77l
         c1zxV4X25ObYv3M1+vlrwPMJRyw8EOgoi/gouCEbJqJ9dre4EiQiI2NX9SlkFwBxA+72
         ughw==
X-Gm-Message-State: ACgBeo0Y/R7NDseiCaD7sHxs2Swpqc6jhb0XmqFFhGttrQVoqSRSBYG7
        A42HrvTxE6lMFUb5b5UyNXP2PGdargI=
X-Google-Smtp-Source: AA6agR621GkRGKPuo9ioDU6PQL+1i7B7oA4YsZ7ftrS1qoz/roQmyKEzABLGtxpTppOroXBEFu/WKg==
X-Received: by 2002:a05:620a:2b8b:b0:6b9:43ca:4a6 with SMTP id dz11-20020a05620a2b8b00b006b943ca04a6mr5838418qkb.346.1659993544170;
        Mon, 08 Aug 2022 14:19:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u33-20020a05622a19a100b00342e86b3bdasm7103406qtc.12.2022.08.08.14.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 14:19:03 -0700 (PDT)
Message-ID: <4edd83d8-e6d9-ad11-c1b1-078f556ea4f3@gmail.com>
Date:   Mon, 8 Aug 2022 14:18:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 12:57, Sean Anderson wrote:
> Hi Tim,
> 
> On 8/8/22 3:18 PM, Tim Harvey wrote:
>> Greetings,
>>
>> I'm trying to understand if there is any implication of 'ethernet<n>'
>> aliases in Linux such as:
>>          aliases {
>>                  ethernet0 = &eqos;
>>                  ethernet1 = &fec;
>>                  ethernet2 = &lan1;
>>                  ethernet3 = &lan2;
>>                  ethernet4 = &lan3;
>>                  ethernet5 = &lan4;
>>                  ethernet6 = &lan5;
>>          };
>>
>> I know U-Boot boards that use device-tree will use these aliases to
>> name the devices in U-Boot such that the device with alias 'ethernet0'
>> becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
>> appears that the naming of network devices that are embedded (ie SoC)
>> vs enumerated (ie pci/usb) are always based on device registration
>> order which for static drivers depends on Makefile linking order and
>> has nothing to do with device-tree.
>>
>> Is there currently any way to control network device naming in Linux
>> other than udev?
> 
> You can also use systemd-networkd et al. (but that is the same kind of mechanism)
> 
>> Does Linux use the ethernet<n> aliases for anything at all?
> 
> No :l

It is actually used, but by individual drivers, not by the networking 
stack AFAICT:

git grep -E "of_alias_get_id\((.*), \"(eth|ethernet)\"\)" *
drivers/net/ethernet/broadcom/genet/bcmmii.c:           id = 
of_alias_get_id(dn, "eth");
drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c:    plat->bus_id = 
of_alias_get_id(np, "ethernet");
drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c:   plat->bus_id = 
of_alias_get_id(np, "ethernet");
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:  plat->bus_id = 
of_alias_get_id(np, "ethernet");

There were discussions about using that alias to name ethernet network 
devices in the past (cannot quite point to the thread), the current 
consensus appears to be that if you use the "label" property (which was 
primed by DSA) then your network device will follow that name, still not 
something the networking stack does for you within the guts of 
register_netdev().
-- 
Florian
