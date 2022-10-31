Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E28613867
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiJaNvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJaNvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:51:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EE31007D
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 06:51:03 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N1Dxj1rqQzJnPf;
        Mon, 31 Oct 2022 21:48:09 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 21:50:55 +0800
Subject: Re: [PATCH] net: mdio: fix undefined behavior in bit shift for
 __mdiobus_register
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <afleming@freescale.com>,
        <buytenh@wantstofly.org>, <netdev@vger.kernel.org>
References: <20221031060116.3967513-1-cuigaosheng1@huawei.com>
 <Y1/BBbXOo2Ii68Z/@lunn.ch>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <9a456619-40de-44f1-f216-6ca338aadba3@huawei.com>
Date:   Mon, 31 Oct 2022 21:50:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y1/BBbXOo2Ii68Z/@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please use the BIT() macro.

Thanks for taking time to review this patch, I have made patch v2 and submit it.

On 2022/10/31 20:35, Andrew Lunn wrote:
>>   	for (i = 0; i < PHY_MAX_ADDR; i++) {
>> -		if ((bus->phy_mask & (1 << i)) == 0) {
>> +		if ((bus->phy_mask & (1U << i)) == 0) {
> Please use the BIT() macro.
>
>         Andrew
> .
