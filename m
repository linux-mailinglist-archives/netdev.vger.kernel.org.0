Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4153C382299
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 03:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbhEQBwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 21:52:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3772 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhEQBwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 21:52:24 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fk27t4BP9zmj6N;
        Mon, 17 May 2021 09:47:38 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 09:51:05 +0800
Received: from [10.69.38.207] (10.69.38.207) by dggema704-chm.china.huawei.com
 (10.3.20.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 17
 May 2021 09:51:05 +0800
Subject: Re: [PATCH 24/34] net: ath: ath5k: Fix wrong function name in
 comments
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-25-git-send-email-shenyang39@huawei.com>
 <87h7j4i5zy.fsf@codeaurora.org> <87cztsi5xm.fsf@codeaurora.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        "Nick Kossifidis" <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>
From:   Yang Shen <shenyang39@huawei.com>
Message-ID: <11fe9762-e54e-04b2-872c-222d62c21d8b@huawei.com>
Date:   Mon, 17 May 2021 09:51:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <87cztsi5xm.fsf@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.38.207]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema704-chm.china.huawei.com (10.3.20.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/5/15 19:37, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Yang Shen <shenyang39@huawei.com> writes:
>>
>>> Fixes the following W=1 kernel build warning(s):
>>>
>>>  drivers/net/wireless/ath/ath5k/pcu.c:865: warning: expecting
>>> prototype for at5k_hw_stop_rx_pcu(). Prototype was for
>>> ath5k_hw_stop_rx_pcu() instead
>>>
>>> Cc: Jiri Slaby <jirislaby@kernel.org>
>>> Cc: Nick Kossifidis <mickflemm@gmail.com>
>>> Cc: Luis Chamberlain <mcgrof@kernel.org>
>>> Cc: Kalle Valo <kvalo@codeaurora.org>
>>> Signed-off-by: Yang Shen <shenyang39@huawei.com>
>>> ---
>>>  drivers/net/wireless/ath/ath5k/pcu.c | 2 +-
>>
>> Patches for drivers/net/wireless should be sent to linux-wireless, I
>> recommend submitting those patches separately from rest of the series.
>> (Patches 24, 25, 29, 30 and 34)
>
> Oh, and patch 33 should be also sent to linux-wireless.
>

Thanks! I'll fix this in the next version.

Regards,
     Yang
