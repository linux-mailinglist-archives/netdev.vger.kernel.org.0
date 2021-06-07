Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5681B39D2E1
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhFGCWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:22:45 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4372 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGCWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:22:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fyxp80lBTz69HH;
        Mon,  7 Jun 2021 10:17:04 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:20:49 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 7 Jun
 2021 10:20:49 +0800
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603131452.GA6216@hoboy.vegasvil.org>
 <4b2247bc-605e-3aca-3bcb-c06477cd2f2e@huawei.com>
 <20210605155143.GA10328@localhost>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <de04cc07-5c69-f4f6-b140-d2505da5e1ff@huawei.com>
Date:   Mon, 7 Jun 2021 10:20:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210605155143.GA10328@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/5 23:51, Richard Cochran wrote:
> On Sat, Jun 05, 2021 at 05:54:45PM +0800, huangguangbin (A) wrote:
>>> This won't work.  After all, the ISR thread might already be running.
>>> Use a proper spinlock instead.
>>>
>> Thanks for review. Using spinlock in irq_handler looks heavy, what about
>> adding a new flag HCLGE_STATE_PTP_CLEANING_TX_HWTS for hclge_ptp_clean_tx_hwts()?
>> Function hclge_ptp_clean_tx_hwts() test and set this flag at the beginning
>> and clean it in the end. Do you think it is Ok?
> 
> No, I don't.  Use a proper lock.  Don't make vague arguments about how
> it "looks heavy".
> 
> Thanks,
> Richard
> .
> 
Ok, thanks. We will modify this according to your idea, and repost a new version after we test ok.
