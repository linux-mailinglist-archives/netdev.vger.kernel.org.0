Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF90E143956
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAUJTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:19:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9227 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729017AbgAUJTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 04:19:01 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C4CAB24DD88B7E0210E3;
        Tue, 21 Jan 2020 17:18:57 +0800 (CST)
Received: from [127.0.0.1] (10.177.131.64) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 17:18:51 +0800
Subject: Re: [PATCH -next] drivers: net: declance: fix comparing pointer to 0
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <davem@davemloft.net>, <mhabets@solarflare.com>, <kuba@kernel.org>
References: <20200121013553.15252-1-chenzhou10@huawei.com>
 <40eb3815-f677-c2fd-3e67-4b39bb332f48@cogentembedded.com>
 <86f4d4a0-627d-84aa-c785-4dac426b7cc6@huawei.com>
 <c223c347-4c19-176f-4626-b096c12c0558@cogentembedded.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Chen Zhou <chenzhou10@huawei.com>
Message-ID: <63bef062-6a5a-c919-c805-798f19be5632@huawei.com>
Date:   Tue, 21 Jan 2020 17:18:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <c223c347-4c19-176f-4626-b096c12c0558@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.131.64]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/1/21 17:01, Sergei Shtylyov wrote:
> On 21.01.2020 11:54, Chen Zhou wrote:
> 
>>>> Fixes coccicheck warning:
>>>>
>>>> ./drivers/net/ethernet/amd/declance.c:611:14-15:
>>>>      WARNING comparing pointer to 0
>>>>
>>>> Compare pointer-typed values to NULL rather than 0.
>>>
>>>     I don't see NULL in the patch -- you used ! instead.
>>
>> Yeah, i used ! here.
> 
>    Make the patch description match the diff, please.

ok, i will fix this in next version.

Thanks,
Chen Zhou

> 
>> Thanks,
>> Chen Zhou
> 
> MBR, Sergei
> 
> 

