Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347CC240116
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 05:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJDBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 23:01:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55312 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbgHJDBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 23:01:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BB7E56A952D883030327;
        Mon, 10 Aug 2020 11:01:13 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 10 Aug 2020
 11:01:08 +0800
Subject: Re: [PATCH net] net: qcom/emac: Fix missing clk_disable_unprepare()
 in error path of emac_probe
To:     Timur Tabi <timur@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200806140647.43099-1-wanghai38@huawei.com>
 <87f41175-689e-f198-aaf6-9b9f04449ed8@kernel.org>
 <df1bad2e-2a6a-ff70-9b91-f18df20aaec8@huawei.com>
 <9ec9b9ab-48d9-9d38-8f58-27e2556c141a@kernel.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <8e2e50eb-d747-8c11-7067-9042a0b59aaf@huawei.com>
Date:   Mon, 10 Aug 2020 11:01:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <9ec9b9ab-48d9-9d38-8f58-27e2556c141a@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/8/7 21:38, Timur Tabi 写道:
> On 8/6/20 8:54 PM, wanghai (M) wrote:
>> Thanks for your suggestion. May I fix it like this?
>>
> Yes, this is what I had in mind.  Thanks.
>
> Acked-by: Timur Tabi <timur@kernel.org>
>
> .

Thanks for your ack. I just sent a new patch.

"[PATCH net] net: qcom/emac: add missed clk_disable_unprepare in error 
path of emac_clks_phase1_init"


