Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657DBE6D86
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 08:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733057AbfJ1Htc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 03:49:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48006 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729695AbfJ1Htc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 03:49:32 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A5B60C32BAC2A7398FB4;
        Mon, 28 Oct 2019 15:49:26 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 15:49:25 +0800
Subject: Re: [EXT] Re: [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Simon Horman <simon.horman@netronome.com>
References: <20191025133726.31796-1-yuehaibing@huawei.com>
 <20191026080929.GD31244@netronome.com>
 <4edcf4c4-b8fc-00a1-5f13-6c41a27eb4a5@huawei.com>
 <379afbe8-adb8-5209-ac65-8bb9fb92966a@aquantia.com>
CC:     Egor Pomozov <epomozov@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "Sergey Samoilenko" <Sergey.Samoilenko@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <49a629ba-c143-896a-d24d-32e04c430b77@huawei.com>
Date:   Mon, 28 Oct 2019 15:49:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <379afbe8-adb8-5209-ac65-8bb9fb92966a@aquantia.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/26 19:09, Igor Russkikh wrote:
> 
>>> Hi YueHaibing,
>>>
>>> thanks for your patch.
>>>
>>> What is the motivation for not using the existing copy of this function?
>>
>> I'm not sure if PTP_1588_CLOCK is needed at this config,
>> using the existing function need to PTP_1588_CLOCK is selected.
> 
> Hi YueHaibing,
> 
> Please checkout this patch: https://patchwork.ozlabs.org/patch/1184620/
> 
> It fixes the problem without duplicating the function.

Yes, this fix the issue.

> 
> Regards,
>   Igor
> 
> 

