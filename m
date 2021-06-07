Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCCD39D317
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbhFGCqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:46:24 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4326 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGCqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:46:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FyyJG59W1z1BJkL;
        Mon,  7 Jun 2021 10:39:42 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:44:31 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 7 Jun
 2021 10:44:30 +0800
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603132237.GC6216@hoboy.vegasvil.org>
 <a60de68c-ca2e-05e9-2770-a4d3ecb589ae@huawei.com>
 <20210605155330.GB10328@localhost>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <47805689-2c52-ea26-49a6-3fbe3aa22a88@huawei.com>
Date:   Mon, 7 Jun 2021 10:44:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210605155330.GB10328@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/5 23:53, Richard Cochran wrote:
> On Sat, Jun 05, 2021 at 06:37:19PM +0800, huangguangbin (A) wrote:
>>> Need mutex or spinlock to protest against concurrent access.
>>>
>> Ok, thank you. Is it better to add mutex or spinlock in the public place, like ptp_clock_adjtime()?
>> Then there's no need to add mutex or spinlock in all the drives.
> 
> No, that is a terrible idea.  The class layer has no idea about the
> hardware implementation.  Only the driver knows that.
> 
> Thanks,
> Richard
> .
> 
Ok, thanks. We will add mutex or spinlock as your idea, and repost a new version after we test ok.
