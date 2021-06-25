Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE993B3D03
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhFYHK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:10:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5425 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhFYHK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:10:27 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GB7Kp1wf8z7410;
        Fri, 25 Jun 2021 15:04:46 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 15:08:03 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 25
 Jun 2021 15:08:02 +0800
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
 <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
 <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <ce1e61d6-546e-2856-17cc-04419e30eaca@huawei.com>
Date:   Fri, 25 Jun 2021 15:08:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/25 3:25, Jakub Kicinski wrote:
> On Thu, 24 Jun 2021 22:36:45 +0800 Guangbin Huang wrote:
>> In order to know reason why link down, add a debugfs file
>> "link_diagnosis_info" to get link faults from firmware, and each bit
>> represents one kind of fault.
>>
>> usage example:
>> $ cat link_diagnosis_info
>> Reference clock lost
> 
> Please use ethtool->get_link_ext_state instead.
> .
> 
Ok, thanks.
