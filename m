Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD31630DBF
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 10:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiKSJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 04:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 04:20:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBDC74602;
        Sat, 19 Nov 2022 01:20:24 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NDp5S53hXzmVt9;
        Sat, 19 Nov 2022 17:19:56 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 19 Nov 2022 17:20:22 +0800
Subject: Re: [PATCH net] wifi: plfxlc: fix potential memory leak in
 __lf_x_usb_enable_rx()
To:     Kalle Valo <kvalo@kernel.org>
CC:     <srini.raju@purelifi.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221119051900.1192401-1-william.xuanziyang@huawei.com>
 <87v8nbphrr.fsf@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <215ec3cc-88ad-3f68-6dc3-c1aed2a17c76@huawei.com>
Date:   Sat, 19 Nov 2022 17:20:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87v8nbphrr.fsf@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ziyang Xuan <william.xuanziyang@huawei.com> writes:
> 
>> urbs does not be freed in exception paths in __lf_x_usb_enable_rx().
>> That will trigger memory leak. To fix it, add kfree() for urbs within
>> "error" label. Compile tested only.
>>
>> Fixes: 68d57a07bfe5 ("wireless: add plfxlc driver for pureLiFi X, XL, XC devices")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/wireless/purelifi/plfxlc/usb.c | 1 +
>>  1 file changed, 1 insertion(+)
> 
> plfxlc patches go to wireless tree, not net. But I think I'll take this
> to wireless-next actually.

OK, thanks.

> 
