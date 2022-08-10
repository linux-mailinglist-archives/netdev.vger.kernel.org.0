Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A258EBEE
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiHJMZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiHJMZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:25:42 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52BB5D0F7
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:25:40 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M2pyj4GFhzGpLT;
        Wed, 10 Aug 2022 20:24:13 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 10 Aug
 2022 20:25:38 +0800
Subject: Re: [RFCv7 PATCH net-next 16/36] treewide: use replace features '0'
 by netdev_empty_features
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-17-shenjian15@huawei.com>
 <20220810104841.1306583-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <7b6eb064-a649-8a26-8eff-2ad2b2457c22@huawei.com>
Date:   Wed, 10 Aug 2022 20:25:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220810104841.1306583-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/8/10 18:48, Alexander Lobakin Ð´µÀ:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Wed, 10 Aug 2022 11:06:04 +0800
>
>> For the prototype of netdev_features_t will be changed from
>> u64 to bitmap, so it's unable to assignment with 0 directly.
>> Replace it with netdev_empty_features.
> Hmm, why not just netdev_features_zero() instead?
> There's a couple places where empty netdev_features are needed, but
> they're not probably worth a separate and rather pointless empty
> variable, you could create one on the stack there.
As replied before, the new netdev_features_t supports being
assigned directly, so use netdev_emtpy_features looks
more simple.

>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>   drivers/hsi/clients/ssi_protocol.c             | 2 +-
>>   drivers/net/caif/caif_serial.c                 | 2 +-
>>   drivers/net/ethernet/amazon/ena/ena_netdev.c   | 2 +-
>>   drivers/net/ethernet/broadcom/b44.c            | 2 +-
>>   drivers/net/ethernet/broadcom/tg3.c            | 2 +-
>>   drivers/net/ethernet/dnet.c                    | 2 +-
>>   drivers/net/ethernet/ec_bhf.c                  | 2 +-
>>   drivers/net/ethernet/emulex/benet/be_main.c    | 2 +-
>>   drivers/net/ethernet/ethoc.c                   | 2 +-
>>   drivers/net/ethernet/huawei/hinic/hinic_main.c | 5 +++--
>>   drivers/net/ethernet/ibm/ibmvnic.c             | 6 +++---
>>   drivers/net/ethernet/intel/iavf/iavf_main.c    | 9 +++++----
>>   drivers/net/ethernet/microsoft/mana/mana_en.c  | 2 +-
>>   drivers/net/ethernet/sfc/ef10.c                | 2 +-
>>   drivers/net/tap.c                              | 2 +-
>>   drivers/net/tun.c                              | 2 +-
>>   drivers/net/usb/cdc-phonet.c                   | 3 ++-
>>   drivers/net/usb/lan78xx.c                      | 2 +-
>>   drivers/s390/net/qeth_core_main.c              | 2 +-
>>   drivers/usb/gadget/function/f_phonet.c         | 3 ++-
>>   net/dccp/ipv4.c                                | 2 +-
>>   net/dccp/ipv6.c                                | 2 +-
>>   net/ethtool/features.c                         | 2 +-
>>   net/ethtool/ioctl.c                            | 6 ++++--
>>   net/ipv4/af_inet.c                             | 2 +-
>>   net/ipv4/tcp.c                                 | 2 +-
>>   net/ipv4/tcp_ipv4.c                            | 2 +-
>>   net/ipv6/af_inet6.c                            | 2 +-
>>   net/ipv6/inet6_connection_sock.c               | 2 +-
>>   net/ipv6/tcp_ipv6.c                            | 2 +-
>>   net/openvswitch/datapath.c                     | 2 +-
>>   31 files changed, 44 insertions(+), 38 deletions(-)
> [...]
>
>> -- 
>> 2.33.0
> Thanks,
> Olek
> .
>
Thanks,
Jian
