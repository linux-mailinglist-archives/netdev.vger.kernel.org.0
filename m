Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F6F4B95DF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiBQCZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:25:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiBQCZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:25:51 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D423929B9C1;
        Wed, 16 Feb 2022 18:25:36 -0800 (PST)
Received: from kwepemi100011.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JzdqC6nzKzZfdP;
        Thu, 17 Feb 2022 10:21:11 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100011.china.huawei.com (7.221.188.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 10:25:34 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 10:25:34 +0800
Subject: Re: [PATCH net-next] net: hns3: Remove unused inline function
 hclge_is_reset_pending()
To:     YueHaibing <yuehaibing@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
References: <20220216113507.22368-1-yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <171c12cc-5b05-a567-59cf-66e211aba941@huawei.com>
Date:   Thu, 17 Feb 2022 10:25:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220216113507.22368-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

Reviewed-by: Jie Wang <wangjie125@huawei.com>

On 2022/2/16 19:35, YueHaibing wrote:
> This is unused since commit 8e2288cad6cb ("net: hns3: refactor PF
> cmdq init and uninit APIs with new common APIs").
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index adfb26e79262..3c5e76eaf90b 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -1060,11 +1060,6 @@ static inline int hclge_get_queue_id(struct hnae3_queue *queue)
>  	return tqp->index;
>  }
>
> -static inline bool hclge_is_reset_pending(struct hclge_dev *hdev)
> -{
> -	return !!hdev->reset_pending;
> -}
> -
>  int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport);
>  int hclge_cfg_mac_speed_dup(struct hclge_dev *hdev, int speed, u8 duplex);
>  int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
>

