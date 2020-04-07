Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62B21A04B3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 04:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDGCB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 22:01:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50208 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgDGCB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 22:01:59 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C2E117F2EAD5A19040C1;
        Tue,  7 Apr 2020 10:01:51 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.234) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Apr 2020
 10:01:48 +0800
Subject: Re: [PATCH] ath11k: thermal: Fix build error without CONFIG_THERMAL
To:     Kalle Valo <kvalo@codeaurora.org>
References: <20200403083414.31392-1-yuehaibing@huawei.com>
 <87mu7ozs1c.fsf@kamboji.qca.qualcomm.com>
CC:     <davem@davemloft.net>, <pradeepc@codeaurora.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <2c636eaf-7672-353c-80b2-1649b3a94e60@huawei.com>
Date:   Tue, 7 Apr 2020 10:01:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <87mu7ozs1c.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/6 21:02, Kalle Valo wrote:
> YueHaibing <yuehaibing@huawei.com> writes:
> 
>> drivers/net/wireless/ath/ath11k/thermal.h:45:1:
>>  warning: no return statement in function returning non-void [-Wreturn-type]
>> drivers/net/wireless/ath/ath11k/core.c:416:28: error:
>>  passing argument 1 of ‘ath11k_thermal_unregister’ from incompatible pointer type [-Werror=incompatible-pointer-types]
>>
>> Add missing return 0 in ath11k_thermal_set_throttling,
>> and fix ath11k_thermal_unregister param type.
> 
> These are warnings, no? "build error" and "compiler warning" are
> different things, the former breaks the whole build which is super
> critical, but I'll queue this to v5.7 nevertheless. And I'll change the
> title to:
> 
> ath11k: fix compiler warning without CONFIG_THERMAL

Ok , thanks!

> 

