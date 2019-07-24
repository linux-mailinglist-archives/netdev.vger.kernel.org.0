Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85B6732DC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbfGXPgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:36:12 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:51856 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXPgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 11:36:12 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x6OFa4V8068342;
        Wed, 24 Jul 2019 10:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1563982564;
        bh=NQLqsA8/Ngn3H2FxerfsPD+JWi46FHhUiIHy8lZl8T4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=NQ/R8B08ViyuzyN821PPohdthMRBob1GdULACYpn1vsb8AH161z7/imKmM7mBkadk
         cm64dSjK3DCIytuF14WIiQDBR0PupfcAYVGlHjnFctnXK8TvLHAgvPcP+F7B2WFQCd
         OyR9GygLAl1JjmIfrbESDEv64r+wAJNKYXgmxhHc=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x6OFa3tX106644
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jul 2019 10:36:04 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 24
 Jul 2019 10:36:03 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 24 Jul 2019 10:36:03 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x6OFa2vp066515;
        Wed, 24 Jul 2019 10:36:02 -0500
Subject: Re: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <dbb7bdef-820d-5dcc-d7b5-a82bc1b076fb@ti.com>
 <a8e3f2d3-18c3-3bdb-1318-8964afc7e032@ti.com>
 <93530d94-ec65-de82-448e-f2460dd39fb9@ti.com>
 <0f6c41c8-0071-ed3a-9e65-caf02a0fbefe@ti.com>
 <6fa79302-ad32-7f43-f9d5-af70aa789284@ti.com>
 <f236a88a-485c-9002-1e4a-9a5ad0e1c81f@ti.com>
 <437b6371-8488-a0ff-fa68-d1fb5a81bb8b@ti.com>
 <20190724064754.GC22447@kroah.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <443fe5e5-5e5c-f669-1f4b-565d9f3dd6c8@ti.com>
Date:   Wed, 24 Jul 2019 10:36:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190724064754.GC22447@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On 7/24/19 1:47 AM, Greg KH wrote:
> On Tue, Jul 23, 2019 at 10:14:14AM -0500, Dan Murphy wrote:
>> Hello
>>
>> On 7/10/19 7:08 AM, Dan Murphy wrote:
>>> Hello
>>>
>>> On 6/17/19 10:09 AM, Dan Murphy wrote:
>>>> Marc
>>>>
>>>> On 6/10/19 11:35 AM, Dan Murphy wrote:
>>>>> Bump
>>>>>
>>>>> On 6/6/19 8:16 AM, Dan Murphy wrote:
>>>>>> Marc
>>>>>>
>>>>>> Bump
>>>>>>
>>>>>> On 5/31/19 6:51 AM, Dan Murphy wrote:
>>>>>>> Marc
>>>>>>>
>>>>>>> On 5/15/19 3:54 PM, Dan Murphy wrote:
>>>>>>>> Marc
>>>>>>>>
>>>>>>>> On 5/9/19 11:11 AM, Dan Murphy wrote:
>>>>>>>>> Create a m_can platform framework that peripheral
>>>>>>>>> devices can register to and use common code and register sets.
>>>>>>>>> The peripheral devices may provide read/write and configuration
>>>>>>>>> support of the IP.
>>>>>>>>>
>>>>>>>>> Acked-by: Wolfgang Grandegger <wg@grandegger.com>
>>>>>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>>>>>> ---
>>>>>>>>>
>>>>>>>>> v12 - Update the m_can_read/write functions to
>>>>>>>>> create a backtrace if the callback
>>>>>>>>> pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/
>>>>>>>>>
>>>>>>>> Is this able to be merged now?
>>>>>>> ping
>>>> Wondering if there is anything else we need to do?
>>>>
>>>> The part has officially shipped and we had hoped to have driver
>>>> support in Linux as part of the announcement.
>>>>
>>> Is this being sent in a PR for 5.3?
>>>
>>> Dan
>>>
>> Adding Greg to this thread as I have no idea what is going on with this.
> Why me?  What am I supposed to do here?  I see no patches at all to do
> anything with :(

I am not sure who to email. The maintainer seems to be on hiatus or 
super busy with other work.

So I added you to see if you know how to handle this.  Wolfgang Acked it 
but he said Marc needs to pull

it in.  We have quite a few users of this patchset. I have been hosting 
the patchset in a different tree.

These users keep pinging us for upstream status and all we can do is 
point them to the

LKML to show we are continuing to pursue inclusion.

https://lore.kernel.org/patchwork/project/lkml/list/?series=393454

Thanks
Dan


>
> thanks,
>
> greg "not a miracle worker" k-h
