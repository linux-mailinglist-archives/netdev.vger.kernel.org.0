Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F8738928B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354766AbhESP2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:28:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3606 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbhESP2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 11:28:17 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Flc9f3KLGzmWWJ;
        Wed, 19 May 2021 23:24:38 +0800 (CST)
Received: from dggeml759-chm.china.huawei.com (10.1.199.138) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 23:26:54 +0800
Received: from [10.174.178.165] (10.174.178.165) by
 dggeml759-chm.china.huawei.com (10.1.199.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 23:26:54 +0800
Subject: Re: [PATCH net-next] net: qrtr: ns: Fix error return code in
 qrtr_ns_init()
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
References: <20210519141621.3044684-1-weiyongjun1@huawei.com>
 <20210519141801.GB119648@thinkpad>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <090d74f3-348c-43d1-a598-e54a852da7d5@huawei.com>
Date:   Wed, 19 May 2021 23:26:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210519141801.GB119648@thinkpad>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml759-chm.china.huawei.com (10.1.199.138)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Wed, May 19, 2021 at 02:16:21PM +0000, Wei Yongjun wrote:
>> Fix to return a negative error code -ENOMEM from the error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> You might want to add Fixes tag:
>
> Fixes: c6e08d6251f3 ("net: qrtr: Allocate workqueue before kernel_bind")
>

Thanks, I will add fixes tag and send v2.

Regards,

Wei Yongjun


