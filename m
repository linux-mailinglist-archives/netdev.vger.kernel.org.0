Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA434E1AA
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhC3HAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:00:37 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14193 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhC3HAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:00:30 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F8gHx72DDzmc9b;
        Tue, 30 Mar 2021 14:57:49 +0800 (CST)
Received: from [10.67.110.73] (10.67.110.73) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Tue, 30 Mar 2021
 15:00:18 +0800
Subject: Re: [PATCH -next] drivers: net: CONFIG_ATH9K select LEDS_CLASS
To:     Pavel Machek <pavel@ucw.cz>
CC:     "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chenyi (Johnny)" <johnny.chenyi@huawei.com>
References: <20210326081351.172048-1-zhangjianhua18@huawei.com>
 <20210327223811.GB2875@duo.ucw.cz>
From:   "zhangjianhua (E)" <zhangjianhua18@huawei.com>
Message-ID: <9c6989a1-614e-23af-dc90-58663aa7d9a1@huawei.com>
Date:   Tue, 30 Mar 2021 15:00:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210327223811.GB2875@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.73]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Pavel，thanks for your reply.

for  the a point, I don't know the led lists and cannot find it.

for the b point, I look other configs who select LEDS_CLASS, almost all 
of them select NEW_LEDS，maybe you are right, CONFIG_ATH9K also need 
select NEW_LEDS too.


Best regards,

Zhang Jianhua

在 2021/3/28 6:38, Pavel Machek 写道:
> On Fri 2021-03-26 16:13:51, Zhang Jianhua wrote:
>> If CONFIG_ATH9K=y, the following errors will be seen while compiling
>> gpio.c
>>
>> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_deinit_leds':
>> gpio.c:(.text+0x604): undefined reference to `led_classdev_unregister'
>> gpio.c:(.text+0x604): relocation truncated to fit: R_AARCH64_CALL26
>> against undefined symbol `led_classdev_unregister'
>> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_init_leds':
>> gpio.c:(.text+0x708): undefined reference to `led_classdev_register_ext'
>> gpio.c:(.text+0x708): relocation truncated to fit: R_AARCH64_CALL26
>> against undefined symbol `led_classdev_register_ext'
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhang Jianhua <zhangjianhua18@huawei.com>
> a) please cc led lists with led issue.
>
> b) probably does not work as LED_CLASS depends on NEW_LEDS...?
>
> Best regards,
> 									Pavel
> 									
