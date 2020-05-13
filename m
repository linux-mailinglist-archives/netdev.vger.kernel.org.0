Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398941D0420
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgEMBBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:01:08 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4397 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728131AbgEMBBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:01:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9D910F579F4695007B0E;
        Wed, 13 May 2020 09:01:03 +0800 (CST)
Received: from [10.166.212.221] (10.166.212.221) by smtp.huawei.com
 (10.3.19.204) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 13 May
 2020 09:00:58 +0800
Subject: Re: [PATCH -next] net/wireless/rtl8225: Remove unused variable
 rtl8225z2_tx_power_ofdm
To:     Larry Finger <Larry.Finger@lwfinger.net>, <herton@canonical.com>,
        <htl10@users.sourceforge.net>, <kvalo@codeaurora.org>
CC:     <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200512111408.157738-1-chentao107@huawei.com>
 <377df527-267a-2405-5519-8ae956636248@lwfinger.net>
From:   "chentao (AS)" <chentao107@huawei.com>
Message-ID: <b7fbd9f9-9d78-0c86-1890-367dc55e8345@huawei.com>
Date:   Wed, 13 May 2020 09:00:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <377df527-267a-2405-5519-8ae956636248@lwfinger.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.212.221]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, i will change it in v2.

On 2020/5/12 23:24, Larry Finger wrote:
> On 5/12/20 6:14 AM, ChenTao wrote:
>> Fix the following warning:
>>
>> drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c:609:17: warning:
>> ‘rtl8225z2_tx_power_ofdm’ defined but not used
>>   static const u8 rtl8225z2_tx_power_ofdm[] = {
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: ChenTao <chentao107@huawei.com>
>
> The patch is OK, but the subject is wrong. It should be "[PATCH-next] 
> rtl8187: Remove ...."
>
> With that change, ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Larry
