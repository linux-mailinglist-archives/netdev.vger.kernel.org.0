Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8D95DB1
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHTLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:47:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbfHTLrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:06 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EE6B24BCADEC9E5725BD;
        Tue, 20 Aug 2019 19:47:01 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Tue, 20 Aug 2019
 19:46:57 +0800
Subject: Re: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
References: <20190820013652.147041-1-yuehaibing@huawei.com>
 <93fafdab-8fb3-0f2b-8f36-0cf297db3cd9@intel.com>
 <20190820085547.GE4451@kadam>
 <CAJ+HfNhRf+=yN6eOOZ1zp8=VicT-k6nHLO6r+f__O5X3M+N=ug@mail.gmail.com>
 <20190820094444.GA3964@kadam>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <e98df2e2-6b57-6c1c-e80e-732434b177ad@huawei.com>
Date:   Tue, 20 Aug 2019 19:46:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190820094444.GA3964@kadam>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/8/20 17:44, Dan Carpenter wrote:
> On Tue, Aug 20, 2019 at 11:25:29AM +0200, Björn Töpel wrote:
>> On Tue, 20 Aug 2019 at 10:59, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>
>>> On Tue, Aug 20, 2019 at 09:28:26AM +0200, Björn Töpel wrote:
>>>> For future patches: Prefix AF_XDP socket work with "xsk:" and use "PATCH
>>>> bpf-next" to let the developers know what tree you're aiming for.
>>>
>>> There are over 300 trees in linux-next.  It impossible to try remember
>>> everyone's trees.  No one else has this requirement.
>>>
>>
>> Net/bpf are different, and I wanted to point that out to lessen the
>> burden for the maintainers. It's documented in:
>>
>> Documentation/bpf/bpf_devel_QA.rst.
>> Documentation/networking/netdev-FAQ.rst
> 
> Ah...  I hadn't realized that BPF patches were confusing to Dave.
> 
> I actually do keep track of net and net-next.  I do quite a bit of extra
> stuff for netdev patches.  So what about if we used [PATCH] for bpf and
> [PATCH net] and [PATCH net-next] for networking?
> 
> I will do that.

bpf-next is a good choice.

> 
> regards,
> dan carpenter
> 
> .
> 

