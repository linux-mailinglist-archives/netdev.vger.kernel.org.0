Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21483924C6
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 04:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhE0CY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 22:24:26 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:4020 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhE0CYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 22:24:25 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FrBPB2L9kzmZM7;
        Thu, 27 May 2021 10:20:30 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 10:22:51 +0800
Received: from [10.67.100.138] (10.67.100.138) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 10:22:51 +0800
Subject: Re: [PATCH net-next 01/10] net: wan: remove redundant blank lines
To:     Jakub Kicinski <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
CC:     <davem@davemloft.net>, <xie.he.0141@gmail.com>, <ms@dev.tdt.de>,
        <willemb@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tanhuazhong@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
 <1622029495-30357-2-git-send-email-huangguangbin2@huawei.com>
 <20210526175702.5aecd246@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <d3fb35fb-01a1-0d3a-03af-e8e083520901@huawei.com>
Date:   Thu, 27 May 2021 10:22:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20210526175702.5aecd246@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/27 8:57, Jakub Kicinski Ð´µÀ:
> On Wed, 26 May 2021 19:44:46 +0800 Guangbin Huang wrote:
>> From: Peng Li <lipeng321@huawei.com>
>>
>> This patch removes some redundant blank lines.
> We already have 4 commits with this exact subject and message in
> the tree:
>
> 98d728232c98 net: wan: remove redundant blank lines
> 8890d0a1891a net: wan: remove redundant blank lines
> 145efe6c279b net: wan: remove redundant blank lines
> 78524c01edb2 net: wan: remove redundant blank lines
>
> Please use appropriate commit prefix, for example for this series
> "net: hdlc_fr:".
> .

Ok, will fix it next version.

Thanks.


