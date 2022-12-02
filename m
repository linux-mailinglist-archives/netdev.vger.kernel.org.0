Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FF0640786
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiLBNM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLBNM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:12:58 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B201054B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 05:12:54 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NNtZH1gQjzpW4p;
        Fri,  2 Dec 2022 21:09:27 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 21:12:52 +0800
Subject: Re: [PATCH] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
To:     Andrew Lunn <andrew@lunn.ch>, Zeng Heng <zengheng4@huawei.com>
CC:     <f.fainelli@gmail.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <liwei391@huawei.com>
References: <20221201092202.3394119-1-zengheng4@huawei.com>
 <Y4jH1Z8UdA/h+WlE@lunn.ch> <d7f2266a-12c0-7369-952b-fbaa787de125@huawei.com>
 <Y4n2C1A78YgxZTyG@lunn.ch>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <7d2d8aa8-cef0-da2c-7459-c799564a3ad8@huawei.com>
Date:   Fri, 2 Dec 2022 21:12:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y4n2C1A78YgxZTyG@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/2 20:56, Andrew Lunn wrote:
>> No, they don't interact with each other, because they fix different issues
>> respectively.
> I'm wanted to ensure you know about each others work and that the
> fixes don't clash. I could not see a Cc: between you, nor a
> reviewed-by: etc to indicate you are working together on this.
Yeah, we know each others work, he run test with both patches merged.
>
> The patches can go separately, but maybe you can review v3 of his
> patch? Ask him to review yours.
I can review his patch.

Thanks,
Yang
>
>         Andrew
> .
