Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D924858EDE0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiHJOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 10:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiHJOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 10:07:03 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5648C59261
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:07:01 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M2sCd0pTzzGpJx;
        Wed, 10 Aug 2022 22:05:33 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 10 Aug
 2022 22:06:58 +0800
Subject: Re: [RFCv7 PATCH net-next 17/36] treewide: adjust features
 initialization
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-18-shenjian15@huawei.com>
 <20220810105831.1307150-1-alexandr.lobakin@intel.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <e4c6e1f7-5957-1501-de89-76c904351f1d@huawei.com>
Date:   Wed, 10 Aug 2022 22:06:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220810105831.1307150-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



ÔÚ 2022/8/10 18:58, Alexander Lobakin Ð´µÀ:
> From: Jian Shen <shenjian15@huawei.com>
> Date: Wed, 10 Aug 2022 11:06:05 +0800
>
>> There are many direclty single bit assignment to netdev features.
>> Adjust these expressions, so can use netdev features helpers later.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> ---
>>   arch/um/drivers/vector_kern.c                       | 5 ++++-
>>   drivers/firewire/net.c                              | 4 +++-
>>   drivers/infiniband/hw/hfi1/vnic_main.c              | 4 +++-
>>   drivers/misc/sgi-xp/xpnet.c                         | 3 ++-
>>   drivers/net/can/dev/dev.c                           | 4 +++-
>>   drivers/net/ethernet/alacritech/slicoss.c           | 4 +++-
>>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c            | 4 +++-
>>   drivers/net/ethernet/aquantia/atlantic/aq_nic.c     | 3 ++-
>>   drivers/net/ethernet/atheros/atlx/atl2.c            | 4 +++-
>>   drivers/net/ethernet/cadence/macb_main.c            | 4 +++-
>>   drivers/net/ethernet/davicom/dm9000.c               | 4 +++-
>>   drivers/net/ethernet/engleder/tsnep_main.c          | 4 +++-
>>   drivers/net/ethernet/ibm/ibmveth.c                  | 3 ++-
>>   drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
>>   drivers/net/ethernet/mellanox/mlx4/en_netdev.c      | 3 ++-
>>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 +++-
>>   drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++++--
>>   drivers/net/ethernet/netronome/nfp/nfp_net_repr.c   | 3 ++-
>>   drivers/net/ethernet/ni/nixge.c                     | 4 +++-
>>   drivers/net/ethernet/renesas/sh_eth.c               | 6 ++++--
>>   drivers/net/ethernet/sun/sunhme.c                   | 7 +++++--
>>   drivers/net/ethernet/toshiba/ps3_gelic_net.c        | 6 ++++--
>>   drivers/net/ethernet/toshiba/spider_net.c           | 3 ++-
>>   drivers/net/ethernet/tundra/tsi108_eth.c            | 3 ++-
>>   drivers/net/ethernet/xilinx/ll_temac_main.c         | 4 +++-
>>   drivers/net/ethernet/xilinx/xilinx_axienet_main.c   | 4 +++-
>>   drivers/net/hamradio/bpqether.c                     | 4 +++-
>>   drivers/net/hyperv/netvsc_drv.c                     | 3 ++-
>>   drivers/net/ipa/ipa_modem.c                         | 4 +++-
>>   drivers/net/ntb_netdev.c                            | 4 +++-
>>   drivers/net/rionet.c                                | 4 +++-
>>   drivers/net/tap.c                                   | 2 +-
>>   drivers/net/thunderbolt.c                           | 3 ++-
>>   drivers/net/usb/smsc95xx.c                          | 4 +++-
>>   drivers/net/virtio_net.c                            | 4 +++-
>>   drivers/net/wireless/ath/ath10k/mac.c               | 7 +++++--
>>   drivers/net/wireless/ath/ath11k/mac.c               | 4 +++-
>>   drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c   | 4 +++-
>>   drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 4 +++-
>>   drivers/net/wireless/mediatek/mt76/mt7615/init.c    | 4 +++-
>>   drivers/net/wireless/mediatek/mt76/mt7915/init.c    | 4 +++-
>>   drivers/net/wireless/mediatek/mt76/mt7921/init.c    | 4 +++-
>>   drivers/net/wwan/t7xx/t7xx_netdev.c                 | 4 +++-
>>   drivers/s390/net/qeth_core_main.c                   | 7 +++++--
>>   include/net/udp.h                                   | 4 +++-
>>   net/phonet/pep-gprs.c                               | 4 +++-
>>   46 files changed, 138 insertions(+), 52 deletions(-)
>>
>> diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
>> index 1d59522a50d8..d797758850e1 100644
>> --- a/arch/um/drivers/vector_kern.c
>> +++ b/arch/um/drivers/vector_kern.c
>> @@ -1628,7 +1628,10 @@ static void vector_eth_configure(
>>   		.bpf			= NULL
>>   	});
>>   
>> -	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
>> +	netdev_active_features_zero(dev);
>> +	dev->features |= NETIF_F_SG;
>> +	dev->features |= NETIF_F_FRAGLIST;
>> +	dev->features = dev->hw_features;
> I think a new helper can be useful there and in a couple other
> places, which would set or clear an array of bits taking them as
> varargs:
>
> #define __netdev_features_set_set(feat, uniq, ...) ({	\
> 	DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
> 	netdev_features_set_array(feat, &(uniq));	\
> })
> #define netdev_features_set_set(feat, ...)		\
> 	__smth(feat, __UNIQUE_ID(feat_set), __VA_ARGS__)
>
> (name is a placeholder)
>
> so that you can do
>
> 	netdev_active_features_zero(dev);
> 	netdev_features_set_set(dev->features, NETIF_F_SG, NETIF_F_FRAGLIST);
>
> in one take. I think it looks elegant, doesn't it?
good idea. I will try it, thanks!


>>   	INIT_WORK(&vp->reset_tx, vector_reset_tx);
>>   
>>   	timer_setup(&vp->tl, vector_timer_expire, 0);
> [...]
>
>> -- 
>> 2.33.0
> Thanks,
> Olek
>
> .
>

