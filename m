Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2297F5E9BA4
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbiIZIHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiIZIH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:07:28 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958C432BA8;
        Mon, 26 Sep 2022 01:06:05 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MbZwF64KQzlXVQ;
        Mon, 26 Sep 2022 16:01:49 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 16:06:02 +0800
Message-ID: <521bf990-e6aa-ee95-fcfa-1a03d08ee766@huawei.com>
Date:   Mon, 26 Sep 2022 16:06:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH -next] wifi: brcmfmac: pcie: add missing
 pci_disable_device() in brcmf_pcie_get_resource()
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
CC:     Franky Lin <franky.lin@broadcom.com>, <aspriel@gmail.com>,
        <hante.meuleman@broadcom.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <marcan@marcan.st>, <linus.walleij@linaro.org>,
        <rmk+kernel@armlinux.org.uk>, <soontak.lee@cypress.com>,
        <linux-wireless@vger.kernel.org>,
        <SHA-cyfmac-dev-list@infineon.com>,
        <brcm80211-dev-list.pdl@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220923093806.3108119-1-ruanjinjie@huawei.com>
 <CA+8PC_eCwv321DxoCMOrWNLw7NWkT9F0sD-=8GzygEXPJHFWWA@mail.gmail.com>
 <b5e39818-2961-ba3d-8552-f618c19f8fe6@huawei.com> <878rm64le2.fsf@kernel.org>
From:   Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <878rm64le2.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/26 15:58, Kalle Valo wrote:
> Ruan Jinjie <ruanjinjie@huawei.com> writes:
> 
>> On 2022/9/24 0:50, Franky Lin wrote:
>>> On Fri, Sep 23, 2022 at 2:42 AM ruanjinjie <ruanjinjie@huawei.com> wrote:
>>>>
>>>> Add missing pci_disable_device() if brcmf_pcie_get_resource() fails.
>>>
>>> Did you encounter any issue because of the absensent
>>> pci_disable_device? A bit more context will be very helpful.
>>>
>>
>> We use static analysis via coccinelle to find the above issue. The
>> command we use is below:
>>
>> spatch -I include -timeout 60 -very_quiet -sp_file
>> pci_disable_device_missing.cocci
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> 
> Please include this information to the commit log, it helps to
> understand the background of the fix.

 Thank you for your suggestion! I'll include this information in the
future commit log.

> 
