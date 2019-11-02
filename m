Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40206ECDD4
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfKBJA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 05:00:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40480 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726999AbfKBJA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 05:00:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 677F7A0B1EA4340F04BC;
        Sat,  2 Nov 2019 17:00:26 +0800 (CST)
Received: from [127.0.0.1] (10.133.219.218) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Sat, 2 Nov 2019
 17:00:25 +0800
Message-ID: <5DBD45A8.3000701@huawei.com>
Date:   Sat, 2 Nov 2019 17:00:24 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Simon Horman <simon.horman@netronome.com>
CC:     <kvalo@codeaurora.org>, <stas.yakovlev@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] wireless: remove unneeded variable and return
 0
References: <1572611621-13280-1-git-send-email-zhongjiang@huawei.com> <20191101134456.GA5859@netronome.com>
In-Reply-To: <20191101134456.GA5859@netronome.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.219.218]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/11/1 21:44, Simon Horman wrote:
> On Fri, Nov 01, 2019 at 08:33:38PM +0800, zhong jiang wrote:
>> The issue is detected with help of coccinelle.
>>
>> v1 -> v2:
>>    libipw_qos_convert_ac_to_parameters() make it void.
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
I am sorry for that.  [PATCH 3/3] is not correct.  its local variable will be used by
fappend.  hence just remove the patch in v3.

Thanks,
zhong jiang
> .
>


