Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A912D5CB
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 03:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfLaC3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 21:29:15 -0500
Received: from mail1.windriver.com ([147.11.146.13]:41800 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfLaC3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 21:29:15 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id xBV2T0As012150
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 30 Dec 2019 18:29:00 -0800 (PST)
Received: from [128.224.162.195] (128.224.162.195) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.468.0; Mon, 30 Dec 2019
 18:28:59 -0800
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
To:     Randy Dunlap <rdunlap@infradead.org>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>
CC:     <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
References: <20191231020302.71792-1-jiping.ma2@windriver.com>
 <5b10a5ff-8428-48c7-a60d-69dd62009716@infradead.org>
 <719d8dd3-0119-0c93-b299-d2b3d66b1e06@windriver.com>
 <adc6d2bc-a92c-703f-2e27-d905c6322c17@infradead.org>
From:   Jiping Ma <Jiping.Ma2@windriver.com>
Message-ID: <93bebc7e-3a47-55f9-f48c-a4c1de6d62bc@windriver.com>
Date:   Tue, 31 Dec 2019 10:28:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <adc6d2bc-a92c-703f-2e27-d905c6322c17@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/31/2019 10:22 AM, Randy Dunlap wrote:
> On 12/30/19 6:16 PM, Jiping Ma wrote:
>>
>> On 12/31/2019 10:11 AM, Randy Dunlap wrote:
>>> Hi,
>>>
>>> On 12/30/19 6:03 PM, Jiping Ma wrote:
>>>> Add one notifier for udev changes net device name.
>>>>
>>>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>>>> ---
>>>>    .../net/ethernet/stmicro/stmmac/stmmac_main.c | 38 ++++++++++++++++++-
>>>>    1 file changed, 37 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> index b14f46a57154..c1c877bb4421 100644
>>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>>>> @@ -4038,6 +4038,40 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
>>>>    }
>>>>    DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
>>>>    +/**
>>> Just use /* here since this is not a kernel-doc comment.
>>> /** is reserved for kernel-doc comments/notation.
>> I use checkpatch.pl to check my patch, it show one warning, then I change * to **.   I will change it back to *.
> It should be more like:
>
> /* Use network device events to create/remove/rename
>   * debugfs file entries.
>   */
>
Got it.  Thanks.
>> WARNING: networking block comments don't use an empty /* line, use /* Comment...
>> #23: FILE: drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:4042:
>> +/*
>> + * Use network device events to create/remove/rename
>>>> + * Use network device events to create/remove/rename
>>>> + * debugfs file entries
>>>> + */
>>>> +static int stmmac_device_event(struct notifier_block *unused,
>>>> +                   unsigned long event, void *ptr)
>>>> +{
>

