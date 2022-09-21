Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17DE5BF2F4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 03:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiIUBcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 21:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiIUBcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 21:32:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A93967465
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 18:32:29 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXLQm3lhrzmW41;
        Wed, 21 Sep 2022 09:28:32 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 09:32:27 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 09:32:27 +0800
Subject: Re: [PATCH -next 1/3] net: dsa: microchip: remove unnecessary
 spi_set_drvdata()
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>
References: <20220913144406.2002409-1-yangyingliang@huawei.com>
 <20220920234535.foehn5ugotbschfi@skbuf>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <facfc855-d082-cc1c-a0bc-027f562a2f45@huawei.com>
Date:   Wed, 21 Sep 2022 09:32:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20220920234535.foehn5ugotbschfi@skbuf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 2022/9/21 7:45, Vladimir Oltean wrote:
> On Tue, Sep 13, 2022 at 10:44:04PM +0800, Yang Yingliang wrote:
>> Remove unnecessary spi_set_drvdata() in ksz_spi_remove(), the
>> driver_data will be set to NULL in device_unbind_cleanup() after
>> calling ->remove().
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
> I would like all drivers in drivers/net/dsa/ to follow the same
> convention, which they currently do. They all call .*_set_drvdata.*NULL
> from ->remove(), why just patch the spi_set_drvdata() calls?
Yes, it's right, all the set_drvdata functions in ->remove() can be 
removed. I will
send a v2 to remove all this calling.

Thanks,
Yang
> .
