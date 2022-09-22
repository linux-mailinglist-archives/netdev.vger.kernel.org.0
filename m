Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7395E5E6601
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiIVOlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiIVOlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:41:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C2AF6850
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:40:49 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MYHss651SzWgqP;
        Thu, 22 Sep 2022 22:36:49 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 22:40:47 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 22:40:46 +0800
Subject: Re: [PATCH 7/18] net: dsa: microchip: remove unnecessary
 set_drvdata()
To:     <Arun.Ramadoss@microchip.com>, <netdev@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>,
        <george.mccollister@gmail.com>, <vivien.didelot@gmail.com>,
        <linus.walleij@linaro.org>, <f.fainelli@gmail.com>,
        <hauke@hauke-m.de>, <clement.leger@bootlin.com>,
        <sean.wang@mediatek.com>, <kurt@linutronix.de>,
        <Woojung.Huh@microchip.com>
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
 <20220921140524.3831101-8-yangyingliang@huawei.com>
 <291e1e20d479629e82bbca984c15e9e87dbe1197.camel@microchip.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <b9c7d729-677f-8274-d5b2-339bf4462b46@huawei.com>
Date:   Thu, 22 Sep 2022 22:40:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <291e1e20d479629e82bbca984c15e9e87dbe1197.camel@microchip.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/9/22 22:12, Arun.Ramadoss@microchip.com wrote:
> On Wed, 2022-09-21 at 22:05 +0800, Yang Yingliang wrote:
>> Remove unnecessary set_drvdata(NULL) function in ->remove(),
>> the driver_data will be set to NULL in device_unbind_cleanup()
>> after calling ->remove().
> Do we need to remove i2c_set_clientdata(i2c, NULL) in ksz9477_i2c.c or
> is it applicable only spi and mdio bus.
Yes, it calls the dev_set_drvdata(), I think it should be remove too.

Thanks,
Yang
