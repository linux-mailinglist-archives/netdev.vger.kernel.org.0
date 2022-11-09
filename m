Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4845622294
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKID2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKID2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:28:38 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5074322BD6;
        Tue,  8 Nov 2022 19:28:37 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N6VmT0xhhzRp5v;
        Wed,  9 Nov 2022 11:28:25 +0800 (CST)
Received: from [10.174.179.211] (10.174.179.211) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 11:28:33 +0800
Message-ID: <3c99ca30-dd89-03e9-481c-95310b562702@huawei.com>
Date:   Wed, 9 Nov 2022 11:28:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>
References: <20221108093447.3588889-1-liwei391@huawei.com>
 <cc8f8393ab5e45f895fda98e6b42d1d3@realtek.com>
From:   "liwei (GF)" <liwei391@huawei.com>
In-Reply-To: <cc8f8393ab5e45f895fda98e6b42d1d3@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.211]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/9 8:32, Ping-Ke Shih wrote:
> 
> 
>> -----Original Message-----
>> From: Wei Li <liwei391@huawei.com>
>> Sent: Tuesday, November 8, 2022 5:35 PM
>> To: Ping-Ke Shih <pkshih@realtek.com>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
>> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; huawei.libin@huawei.com
>> Subject: [PATCH v1 0/3] rtlwifi: Correct inconsistent header guard
> 
> Subject prefix should be "wifi: rtlwifi: ..."
>>
>> This patch set fixes some inconsistent header guards in module
>> rtl8188ee/rtl8723ae/rtl8192de, that may be copied but missing update.
>>
>> Wei Li (3):
>>   rtlwifi: rtl8188ee: Correct the header guard of rtl8188ee/*.h
>>   rtlwifi: rtl8723ae: Correct the header guard of
>>     rtl8723ae/{fw,led,phy}.h
>>   rtlwifi: rtl8192de: Correct the header guard of rtl8192de/{dm,led}.h
>>
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h  | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h     | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h    | 4 ++--
>>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h    | 4 ++--
>>  16 files changed, 32 insertions(+), 32 deletions(-)
> 
> The changes aren't too much and commit contents/messages are very similar,
> so I would like to squash 3 patches into single one.

OK, I will combine this series in one patch, and fix the prefix in v2,
thanks for your suggestion.

Thanks,
Wei
