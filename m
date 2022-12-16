Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E3564F281
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 21:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiLPUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 15:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiLPUlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 15:41:05 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B7C64DD;
        Fri, 16 Dec 2022 12:41:03 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m18so8859022eji.5;
        Fri, 16 Dec 2022 12:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FGvyMITTi9oXyIUnasPEhVJqtyXv6Y6ZzePRftZhGnA=;
        b=W0V7by09TM3s4cRnh35968yxctyIfGjE/cCRibvsu2bm/46MP7rin+KSTflQzQKadY
         rEhxD62uDF4OtoSmtHWSXxjSW39LnBLIdPIfn0oNAaY4Xn6Z5mjtg+KLIUjlSjVLA1YN
         WnFw7nqrHwYPDpSC6Zr5MtmonMEJTt2kRP5Mc2q2nzvdc1/B4irhSlQV8v9ZVF7z7aLR
         8P7jkFJtcZXLGHDXOOaozD9KgNFS+VQhio/Iqpfvu8kcmN6VEPYkvk+JD5o2COope2MW
         Ywur2jORt6myml1Zpqqg6i6Md2JSWB/OAD3gmXSvlW7XbMoQVSD1oRkJvCU5ZeUKKSTp
         Ex8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FGvyMITTi9oXyIUnasPEhVJqtyXv6Y6ZzePRftZhGnA=;
        b=iSYoEh0vu6KX//PAW9anyldixdQSurvJQeKyss29A+IXK9JjcDIwZ0KPVMvT9hOMMb
         RMCjbDiGdNZhxHwBMWTsSNXXgKA6thT6zKqfEgB2CiYG2Ta4WGLKEh5dLAnPD4GyxpzN
         YxNVKzCMpWc53V3qeOg2kxMXTQD3+ObTm/rY5x6zgDOPPJj2MnDs6AFpJe1M6nRa8sF7
         rR4/jHUsPN95/h8M/iPAWi9EULNM1KCaWoPnp1NE/9M/5SU3S9FefWAsuQaGuZkYlUUi
         FuKeDiFyqu6HkJ/JWcs5Wz92Ju4cUxW225VEYdhy0RC5XTSBj+XumYL3qvIT5f/HJe/X
         aZMg==
X-Gm-Message-State: ANoB5pko3ZUTCgDfCGZnA4ZioT64WWxjsX8/Ydex0WROWaf+EdwqGt73
        5jVJwkM8VceGx2Myzw9JktE=
X-Google-Smtp-Source: AA0mqf5+bwekE2Ck/RwL71cqJjClxSLICfq5IEg1sgbFYw1RK6V3aTOQKEC9pglUSfZAcAdPZeVJcg==
X-Received: by 2002:a17:907:cbc8:b0:7c1:6e08:4c20 with SMTP id vk8-20020a170907cbc800b007c16e084c20mr23312414ejc.7.1671223261471;
        Fri, 16 Dec 2022 12:41:01 -0800 (PST)
Received: from [192.168.1.101] ([141.136.89.211])
        by smtp.gmail.com with ESMTPSA id dm4-20020a05640222c400b004589da5e5cesm1258695edb.41.2022.12.16.12.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:41:01 -0800 (PST)
Message-ID: <7d44c9ed-cf9d-64e1-df85-726a97859e06@gmail.com>
Date:   Sat, 17 Dec 2022 00:40:56 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next v1 01/13] net: wwan: tmi: Add PCIe core
Content-Language: en-US
To:     =?UTF-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
Cc:     =?UTF-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        =?UTF-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "linuxwwan@mediatek.com" <linuxwwan@mediatek.com>,
        =?UTF-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?UTF-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        =?UTF-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        =?UTF-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?UTF-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?UTF-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?UTF-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
 <20221122111152.160377-2-yanchao.yang@mediatek.com>
 <64aada78-8029-1b05-b802-a005549503c9@gmail.com>
 <8878ed64fadfda9b3d3c8cd8b4564dd9019349b6.camel@mediatek.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
In-Reply-To: <8878ed64fadfda9b3d3c8cd8b4564dd9019349b6.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Yanchao,

On 07.12.2022 06:33, Yanchao Yang (杨彦超) wrote:
> On Sun, 2022-12-04 at 22:52 +0400, Sergey Ryazanov wrote:
>> On 22.11.2022 15:11, Yanchao Yang wrote:
>>> Registers the TMI device driver with the kernel. Set up all the
>>> fundamental
>>> configurations for the device: PCIe layer, Modem Host Cross Core
>>> Interface
>>> (MHCCIF), Reset Generation Unit (RGU), modem common control
>>> operations and
>>> build infrastructure.
>>>
>>> * PCIe layer code implements driver probe and removal, MSI-X
>>> interrupt
>>> initialization and de-initialization, and the way of resetting the
>>> device.
>>> * MHCCIF provides interrupt channels to communicate events such as
>>> handshake,
>>> PM and port enumeration.
>>> * RGU provides interrupt channels to generate notifications from
>>> the device
>>> so that the TMI driver could get the device reset.
>>> * Modem common control operations provide the basic read/write
>>> functions of
>>> the device's hardware registers, mask/unmask/get/clear functions of
>>> the
>>> device's interrupt registers and inquiry functions of the device's
>>> status.
>>>
>>> Signed-off-by: Ting Wang <ting.wang@mediatek.com>
>>> Signed-off-by: MediaTek Corporation <linuxwwan@mediatek.com>
>>> ---
>>>    drivers/net/wwan/Kconfig                 |   11 +
>>>    drivers/net/wwan/Makefile                |    1 +
>>>    drivers/net/wwan/mediatek/Makefile       |   12 +
>>>    drivers/net/wwan/mediatek/mtk_common.h   |   30 +
>>>    drivers/net/wwan/mediatek/mtk_dev.c      |   50 +
>>>    drivers/net/wwan/mediatek/mtk_dev.h      |  503 ++++++++++
>>>    drivers/net/wwan/mediatek/pcie/mtk_pci.c | 1164
>>> ++++++++++++++++++++++
>>>    drivers/net/wwan/mediatek/pcie/mtk_pci.h |  150 +++
>>>    drivers/net/wwan/mediatek/pcie/mtk_reg.h |   69 ++
>>>    9 files changed, 1990 insertions(+)
>>>    create mode 100644 drivers/net/wwan/mediatek/Makefile
>>>    create mode 100644 drivers/net/wwan/mediatek/mtk_common.h
>>>    create mode 100644 drivers/net/wwan/mediatek/mtk_dev.c
>>>    create mode 100644 drivers/net/wwan/mediatek/mtk_dev.h
>>>    create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.c
>>>    create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_pci.h
>>>    create mode 100644 drivers/net/wwan/mediatek/pcie/mtk_reg.h
>>>
>>> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
>>> index 3486ffe94ac4..a93a0c511d50 100644
>>> --- a/drivers/net/wwan/Kconfig
>>> +++ b/drivers/net/wwan/Kconfig
>>> @@ -119,6 +119,17 @@ config MTK_T7XX
>>>    
>>>    	  If unsure, say N.
>>>    
>>> +config MTK_TMI
>>> +	tristate "TMI Driver for Mediatek T-series Device"
>>> +	depends on PCI
>>> +	help
>>> +	  This driver enables Mediatek T-series WWAN Device
>>> communication.
>>> +
>>> +	  If you have one of those Mediatek T-series WWAN Modules and
>>> wish to
>>> +	  use it in Linux say Y/M here.
>>
>> From this and the series descriptions, it is unclear which modem
>> chips this driver is intended for and how does it correlate with the
>> T7xx driver? Is the TMI driver a drop-in replacement for the t7xx driver,
>> or does the TMI driver support any T-series chips except t7xx?
> > The driver is intended for t8xx or later T-series modem chips in the
> future. Currently, t7xx is not support.

Can you add this information to the option description to make it easier 
for users to choose?

BTW, just curious, do you have any plans to add T7xx support to the TMI 
driver, or maybe merge them or factor out the common code into a common 
library? I am asking because I noticed some common code and modem 
components, but that is not addressed in the cover letter. Or is this 
feeling misleading and these two series are very different?

>>> +
>>> +	  If unsure, say N.
>>> +
>>>    endif # WWAN
>>>    
>>>    endmenu
>>> diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
>>> index 3960c0ae2445..198d8074851f 100644
>>> --- a/drivers/net/wwan/Makefile
>>> +++ b/drivers/net/wwan/Makefile
>>> @@ -14,3 +14,4 @@ obj-$(CONFIG_QCOM_BAM_DMUX) += qcom_bam_dmux.o
>>>    obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
>>>    obj-$(CONFIG_IOSM) += iosm/
>>>    obj-$(CONFIG_MTK_T7XX) += t7xx/
>>> +obj-$(CONFIG_MTK_TMI) += mediatek/
>>
>> The driver is called mtk_tmi, but its code is placed to the
>> directory
>> with too generic name 'mediatek'. Do you plan too keep all possible
>> future drivers in this directory? >
> Yes, we plan to put all mediatek's wwan driver into the same directory.
> Currently, there is only T-series modem driver. So we don't create
> 'tmi' folder under 'mediatek' directory explicitly.

Thank you for the clarification.

--
Sergey
