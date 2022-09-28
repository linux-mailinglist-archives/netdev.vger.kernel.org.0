Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5912F5EDBE9
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiI1Li4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiI1Liz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:38:55 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEA5D4
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:38:53 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mcvb65XPbzHqLr;
        Wed, 28 Sep 2022 19:36:34 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:38:51 +0800
Message-ID: <e8349423-25ee-65c8-a630-07f9a9dc5931@huawei.com>
Date:   Wed, 28 Sep 2022 19:38:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [net-next] net: bonding: Convert to use sysfs_emit() APIs
To:     Nikolay Aleksandrov <razor@blackwall.org>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
References: <1664365222-30004-1-git-send-email-wangyufen@huawei.com>
 <599636e0-ebf2-c954-ef2b-80a642771bb7@blackwall.org>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <599636e0-ebf2-c954-ef2b-80a642771bb7@blackwall.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/9/28 19:27, Nikolay Aleksandrov 写道:
> On 28/09/2022 14:40, Wang Yufen wrote:
>> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
>> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
>> to be returned to user space.
>>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   drivers/net/bonding/bond_sysfs_slave.c | 24 ++++++++++++------------
>>   1 file changed, 12 insertions(+), 12 deletions(-)
>>
> This converts only the bonding partially (bond_sysfs_slave.c).
> Why not do it all in one go?
>
Sorry, my mistake, I missed a place and bond_sysfs.c will send v2 together.


>
