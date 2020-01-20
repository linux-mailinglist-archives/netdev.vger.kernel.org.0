Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FB8142173
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 02:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgATB22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 20:28:28 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbgATB22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 20:28:28 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8860E21A705949EA223D;
        Mon, 20 Jan 2020 09:28:26 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Mon, 20 Jan 2020
 09:28:19 +0800
Subject: Re: [PATCH -next] net: hns3: replace snprintf with scnprintf in
 hns3_dbg_cmd_read
To:     Chen Zhou <chenzhou10@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200119124147.30394-1-chenzhou10@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <2e1ab30a-af35-6bc6-f880-a3051375a6a8@huawei.com>
Date:   Mon, 20 Jan 2020 09:28:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200119124147.30394-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/19 20:41, Chen Zhou wrote:
> The return value of snprintf may be greater than the size of
> HNS3_DBG_READ_LEN, use scnprintf instead in hns3_dbg_cmd_read.
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index 6b328a2..8fad699 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -297,7 +297,7 @@ static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
>   	if (!buf)
>   		return -ENOMEM;
>   
> -	len = snprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
> +	len = scnprintf(buf, HNS3_DBG_READ_LEN, "%s\n",
>   		       "Please echo help to cmd to get help information");

not align?

>   	uncopy_bytes = copy_to_user(buffer, buf, len);
>   
> 

