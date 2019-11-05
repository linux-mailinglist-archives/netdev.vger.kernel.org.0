Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04D5EFD2A
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbfKEMcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:32:15 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5726 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387744AbfKEMcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 07:32:15 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 88790C2C4894996D8FD4;
        Tue,  5 Nov 2019 20:32:10 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.218) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 5 Nov 2019
 20:32:07 +0800
Message-ID: <5DC16BC6.3090700@huawei.com>
Date:   Tue, 5 Nov 2019 20:32:06 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <stas.yakovlev@gmail.com>, <simon.horman@netronome.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] wireless: remove unneeded variable and return
 0
References: <1572684922-61805-1-git-send-email-zhongjiang@huawei.com> <87a79b7guv.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a79b7guv.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.218]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/5 0:20, Kalle Valo wrote:
> zhong jiang <zhongjiang@huawei.com> writes:
>
>> The issue is detected with help of coccinelle.
>>
>> v2 -> v3:
>>     Remove [PATCH 3/3] of series. Because fappend will use the
>>     local variable.  
> You really need to test your patches. If you submit patches without
> build testing I'm not going to take such patches.
>
I am sorry for that. :-[

Thanks,
zhong jiang

