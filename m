Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE771CBC5F
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 04:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEICNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 22:13:51 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2125 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728158AbgEICNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 22:13:50 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 1B3B4814A7F49E9CC799;
        Sat,  9 May 2020 10:13:49 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 9 May 2020 10:13:48 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 9 May 2020 10:13:48 +0800
Subject: Re: [PATCH net-next v1] hinic: add three net_device_ops of vf
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200507182119.20494-1-luobin9@huawei.com>
 <20200508143606.65767cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <5ecdc59b-54b0-ba94-94c4-5340b55927c9@huawei.com>
Date:   Sat, 9 May 2020 10:13:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200508143606.65767cc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will fix. Thanks for your review.

On 2020/5/9 5:36, Jakub Kicinski wrote:
> On Thu, 7 May 2020 18:21:19 +0000 Luo bin wrote:
>> +	return hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
>> +				 HINIC_COMM_CMD_HWCTXT_SET,
>> +				 &hw_ioctxt, sizeof(hw_ioctxt), NULL,
>> +				 NULL, HINIC_MGMT_MSG_SYNC);
>> +
>> +	return 0;
> Oh, well, I think there will be a v2 :)
> .
