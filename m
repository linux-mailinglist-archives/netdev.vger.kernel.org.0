Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6796D0F84
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfJINCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:02:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730901AbfJINCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 09:02:38 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0A99F554228B2C48068D;
        Wed,  9 Oct 2019 21:02:32 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 21:02:30 +0800
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used
 variable 'err'
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
 <8736g2rs86.fsf@codeaurora.org>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <0135c3c7-a827-941a-1bad-90129c49d0ac@huawei.com>
Date:   Wed, 9 Oct 2019 21:01:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <8736g2rs86.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/9 20:58, Kalle Valo wrote:
> zhengbin <zhengbin13@huawei.com> writes:
>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> There's no changelog, why did you resend? Document clearly the changes
> so that maintainers don't need to guess what has changed:

Failed to apply:

fatal: corrupt patch at line 13
error: could not build fake ancestor
Applying: rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Patch failed at 0001 rtlwifi: rtl8192ee: Remove set but not used variable 'err'
The copy of the patch that failed is found in: .git/rebase-apply/patch

So I resend this. 

>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing
>

