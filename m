Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753554EFF88
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 10:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239076AbiDBIL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 04:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiDBIL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 04:11:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E13C65160
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 01:09:35 -0700 (PDT)
Received: from kwepemi100016.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KVqQG0d0wzDqCh;
        Sat,  2 Apr 2022 16:07:18 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100016.china.huawei.com (7.221.188.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 2 Apr 2022 16:09:33 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 2 Apr
 2022 16:09:33 +0800
Subject: Re: [RFCv4 PATCH net-next 1/3] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220331084342.27043-1-wangjie125@huawei.com>
 <20220331084342.27043-2-wangjie125@huawei.com>
 <20220331202250.01f53929@kernel.org>
CC:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <6b0cf200-c946-ff7d-e80a-920ab0770b67@huawei.com>
Date:   Sat, 2 Apr 2022 16:09:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220331202250.01f53929@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/1 11:22, Jakub Kicinski wrote:
> On Thu, 31 Mar 2022 16:43:40 +0800 Jie Wang wrote:
>> +``ETHTOOL_A_RINGS_TX_PUSH`` controls flag to choose the fast path or the
>> +normal path to send packets. Setting tx push attribute "on" will enable tx
>> +push mode and send packets in fast path. For those not supported hardwares,
>> +this attributes is "off" by default settings.
>
> You need to be more specific what a "fast path" is, that term is
> too general.
>
> I presume you want to say something about the descriptor being written
> directly into device address space... and that it lowers the latency
> but increases the cost...
>
OK, I will add tx push description in detail in next version.
> .
>

