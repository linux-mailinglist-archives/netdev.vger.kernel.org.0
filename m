Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0AD23292C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 02:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgG3Awn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 20:52:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:48672 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbgG3Awn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 20:52:43 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 79EC1DE18D7FD5DBC91C;
        Thu, 30 Jul 2020 08:52:41 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 30 Jul 2020 08:52:41 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 30 Jul 2020 08:52:40 +0800
Subject: Re: [PATCH net-next] hinic: add generating mailbox random index
 support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200729005919.11293-1-luobin9@huawei.com>
 <20200729150303.0cbe7948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <9ecea2b0-cf06-570c-f695-6b8076d63630@huawei.com>
Date:   Thu, 30 Jul 2020 08:52:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200729150303.0cbe7948@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/30 6:03, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 08:59:19 +0800 Luo bin wrote:
>> add support to generate mailbox random id for VF to ensure that
>> the mailbox message from VF is valid and PF should check whether
>> the cmd from VF is supported before passing it to hw.
> 
> This is hard to review. I don't see how the addition of
> hinic_mbox_check_cmd_valid() correlates to the random id 
> thing. Please split this into two or more patches making
> one logical change each.
> 
> .
> 
I'll split it into two patches. Thank you!
