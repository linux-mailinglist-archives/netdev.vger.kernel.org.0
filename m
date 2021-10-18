Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC488431978
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhJRMmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:42:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29904 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhJRMmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:42:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HXxF2368gzbnG8;
        Mon, 18 Oct 2021 20:36:06 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 20:40:38 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 20:40:37 +0800
Subject: Re: [PATCH net-next] rtw89: fix return value check in
 rtw89_cam_send_sec_key_cmd()
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <pkshih@realtek.com>,
        <kuba@kernel.org>, <davem@davemloft.net>
References: <20211018033102.1813058-1-yangyingliang@huawei.com>
 <163455936283.19217.11931035159424062771.kvalo@codeaurora.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <671df474-be18-4fdb-bfd6-c8cef0536d00@huawei.com>
Date:   Mon, 18 Oct 2021 20:40:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <163455936283.19217.11931035159424062771.kvalo@codeaurora.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021/10/18 20:16, Kalle Valo wrote:
> Yang Yingliang <yangyingliang@huawei.com> wrote:
>
>> Fix the return value check which testing the wrong variable
>> in rtw89_cam_send_sec_key_cmd().
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> rtw89 patches are applied wireless-drivers-next, not net-next. rtw89 is not
> even in net-next yet.
It should be -next.

Thanks,
Yang
>
