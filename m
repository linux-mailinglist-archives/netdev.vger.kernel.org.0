Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B3B2DA5A4
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgLOBf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:35:29 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2333 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgLOBf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:35:29 -0500
Received: from dggeme765-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Cw14S0V7Gz13TqC;
        Tue, 15 Dec 2020 09:33:44 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme765-chm.china.huawei.com
 (10.3.19.111) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Tue, 15
 Dec 2020 09:34:45 +0800
Subject: Re: [PATCH][next] net: hns3: fix expression that is currently always
 true
To:     Colin King <colin.king@canonical.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jian Shen <shenjian15@huawei.com>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201215000033.85383-1-colin.king@canonical.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <0b0cca1c-1208-c5b3-914b-314dcb484209@huawei.com>
Date:   Tue, 15 Dec 2020 09:34:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201215000033.85383-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme765-chm.china.huawei.com (10.3.19.111)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/15 8:00, Colin King wrote:
> From: Colin Ian King<colin.king@canonical.com>
>
> The ||  condition in hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE ||
> hdev->fd_active_type != HCLGE_FD_RULE_NONE will always be true because
> hdev->fd_active_type cannot be equal to two different values at the same
> time. The expression is always true which is not correct. Fix this by
> replacing || with && to correct the logic in the expression.
>
> Addresses-Coverity: ("Constant expression result")
> Fixes: 0205ec041ec6 ("net: hns3: add support for hw tc offload of tc flower")
> Signed-off-by: Colin Ian King<colin.king@canonical.com>

Reviewed-by: Huazhong Tan <tanhuazhong@huawei.com>

Thanks.



