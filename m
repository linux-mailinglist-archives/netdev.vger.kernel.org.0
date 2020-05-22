Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C641A1DE331
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgEVJfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:35:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35900 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728424AbgEVJfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 05:35:17 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6EEB8BA3EB6C87F79A13;
        Fri, 22 May 2020 17:35:14 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 May 2020
 17:35:06 +0800
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
To:     David Miller <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
 <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200521.143726.481524442371246082.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <cb427604-05ee-504c-03d0-fcce16b3cfcc@huawei.com>
Date:   Fri, 22 May 2020 17:35:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200521.143726.481524442371246082.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/22 5:37, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Thu, 21 May 2020 12:17:07 -0700
> 
>> On Thu, 21 May 2020 19:38:23 +0800 Huazhong Tan wrote:
>>> This patchset adds two new VLAN feature.
>>>
>>> [patch 1] adds a new dynamic VLAN mode.
>>> [patch 2] adds support for 'QoS' field to PVID.
>>>
>>> Change log:
>>> V1->V2: modifies [patch 1]'s commit log, suggested by Jakub Kicinski.
>>
>> I don't like the idea that FW is choosing the driver behavior in a way
>> that's not observable via standard Linux APIs. This is the second time
>> a feature like that posted for a driver this week, and we should
>> discourage it.
> 
> Agreed, this is an unacceptable approach to driver features.
> 

Hi, Jakub & David.

As decribed in patch #1, there is a scenario which needs the dynamic
mode(port VLAN filter is always disabled, andVF VLAN filter is keep
disable until a non-zero VLAN ID being used for the function).

Is this mode selection provided through "ethtool --set-priv-flags"
more acceptable? Or is there any other better suggestion for this?

Thanks.

> .
> 

