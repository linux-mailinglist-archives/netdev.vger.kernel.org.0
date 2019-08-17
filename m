Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDDA90C0F
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 04:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfHQCRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 22:17:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60592 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfHQCRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 22:17:35 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 9612836245C86E63AB5F;
        Sat, 17 Aug 2019 10:17:30 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 17 Aug 2019 10:17:29 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Sat, 17
 Aug 2019 10:17:30 +0800
Subject: Re: [PATCH net] net: hns: add phy_attached_info() to the hns driver
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
References: <1566006967-1509-1-git-send-email-liuyonglong@huawei.com>
Message-ID: <879150c3-b376-872d-f5c8-3ebddeaa173c@huawei.com>
Date:   Sat, 17 Aug 2019 10:17:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1566006967-1509-1-git-send-email-liuyonglong@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch, it is not bugfix, should send to net-next.
Sorry for the noise.

On 2019/8/17 9:56, Yonglong Liu wrote:
> This patch add the call to phy_attached_info() to the hns driver
> to identify which exact PHY drivers is in use.
> 
> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> index 2235dd5..ab5118d 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> @@ -1182,6 +1182,8 @@ int hns_nic_init_phy(struct net_device *ndev, struct hnae_handle *h)
>  	if (unlikely(ret))
>  		return -ENODEV;
>  
> +	phy_attached_info(phy_dev);
> +
>  	return 0;
>  }
>  
> 

