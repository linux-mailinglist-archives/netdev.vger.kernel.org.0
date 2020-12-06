Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478C72D003A
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 02:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgLFBrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 20:47:36 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9384 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLFBrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 20:47:35 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CpTnC3slhz70sq;
        Sun,  6 Dec 2020 09:46:23 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sun, 6 Dec 2020
 09:46:44 +0800
Subject: Re: [PATCH net-next 2/3] net: hns3: add priv flags support to switch
 limit promisc mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <huangdaode@huawei.com>, Jian Shen <shenjian15@huawei.com>
References: <1606997936-22166-1-git-send-email-tanhuazhong@huawei.com>
 <1606997936-22166-3-git-send-email-tanhuazhong@huawei.com>
 <20201204182411.1d2d73f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <0429b9ad-f8c8-b42f-ebcb-643ef06f54ee@huawei.com>
Date:   Sun, 6 Dec 2020 09:46:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201204182411.1d2d73f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/12/5 10:24, Jakub Kicinski wrote:
> On Thu, 3 Dec 2020 20:18:55 +0800 Huazhong Tan wrote:
>> @@ -224,6 +224,7 @@ static int hclge_map_unmap_ring_to_vf_vector(struct hclge_vport *vport, bool en,
>>   static int hclge_set_vf_promisc_mode(struct hclge_vport *vport,
>>   				     struct hclge_mbx_vf_to_pf_cmd *req)
>>   {
>> +	struct hnae3_handle *handle = &vport->nic;
>>   	bool en_bc = req->msg.en_bc ? true : false;
>>   	bool en_uc = req->msg.en_uc ? true : false;
>>   	bool en_mc = req->msg.en_mc ? true : false;
> 
> Please order variable lines longest to shortest.

will fix it, thanks.

> 
>> @@ -1154,6 +1158,8 @@ static int hclgevf_cmd_set_promisc_mode(struct hclgevf_dev *hdev,
>>   	send_msg.en_bc = en_bc_pmc ? 1 : 0;
>>   	send_msg.en_uc = en_uc_pmc ? 1 : 0;
>>   	send_msg.en_mc = en_mc_pmc ? 1 : 0;
>> +	send_msg.en_limit_promisc =
>> +	test_bit(HNAE3_PFLAG_LIMIT_PROMISC_ENABLE, &handle->priv_flags) ? 1 : 0;
> 
> The continuation line should be indented more than the first line.

yes, will fix it.

> 
> I suggest you rename HNAE3_PFLAG_LIMIT_PROMISC_ENABLE to
> HNAE3_PFLAG_LIMIT_PROMISC, the _ENABLE doesn't add much
> to the meaning. That way the lines will get shorter.
> 

ok, thanks.

> .
> 

