Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9BD2B5614
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731790AbgKQBMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:12:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7254 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgKQBMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:12:37 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CZnwd24nXzkYWX;
        Tue, 17 Nov 2020 09:12:17 +0800 (CST)
Received: from [10.67.76.251] (10.67.76.251) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Nov 2020
 09:12:28 +0800
Subject: Re: [PATCH v6] lib: optimize cpumask_local_spread()
To:     Dave Hansen <dave.hansen@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Yuqi Jin <jinyuqi@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        Michal Hocko <mhocko@suse.com>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Anshuman Khandual" <anshuman.khandual@arm.com>
References: <1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com>
 <3e2e760d-e4b9-8bd0-a279-b23bd7841ae7@intel.com>
 <eec4c1b6-8dad-9d07-7ef4-f0fbdcff1785@hisilicon.com>
 <5e8b0304-4de1-4bdc-41d2-79fa5464fbc7@intel.com>
 <1ca0d77f-7cf3-57d8-af23-169975b63b32@hisilicon.com>
 <11889127-21f0-bba9-7beb-5a07f263923e@intel.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <9b69f841-7b4a-5ff7-817f-523ccdb9cb67@hisilicon.com>
Date:   Tue, 17 Nov 2020 09:12:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <11889127-21f0-bba9-7beb-5a07f263923e@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.76.251]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

在 2020/11/16 22:48, Dave Hansen 写道:
> On 11/15/20 11:59 PM, Shaokun Zhang wrote:
>>> Do you want to take another pass at submitting this patch?
>> 'Another pass'? Sorry for my bad understading, I don't follow it correctly.
> 
> Could you please incorporate the feedback that I've given about this
> version of the patch and write a new version?

Yeah, I will do it soon addressed your comments.

Cheers,
Shaokun.

> 
