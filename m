Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2176C6989CE
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjBPBXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPBXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:23:07 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3839838EA4;
        Wed, 15 Feb 2023 17:23:06 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PHHJ45MqWz4f3jMP;
        Thu, 16 Feb 2023 09:23:00 +0800 (CST)
Received: from [10.67.109.184] (unknown [10.67.109.184])
        by APP3 (Coremail) with SMTP id _Ch0CgA3LRt2he1jx4OFDQ--.43193S2;
        Thu, 16 Feb 2023 09:23:02 +0800 (CST)
Message-ID: <f4f01d2a-666b-58a1-cf76-84541643bdc3@huaweicloud.com>
Date:   Thu, 16 Feb 2023 09:23:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH bpf-next v1 0/4] Support bpf trampoline for RV64
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Pu Lehui <pulehui@huawei.com>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
 <87mt5ft2bx.fsf@all.your.base.are.belong.to.us>
From:   Pu Lehui <pulehui@huaweicloud.com>
In-Reply-To: <87mt5ft2bx.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgA3LRt2he1jx4OFDQ--.43193S2
X-Coremail-Antispam: 1UD129KBjvdXoWruryrtFy5AFyDKry8KryUJrb_yoWkCFg_ur
        93tF1xZwnxJanrta1Y9r4a9rZFgr47Xry0y3yxZrWIv34kZFn8Jr4FvF9avryfXa4SvFn8
        GrZxuFyxAa42vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbI8YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
        07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
        WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AK
        xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
        xUo0eHDUUUU
X-CM-SenderInfo: psxovxtxl6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/15 22:45, Björn Töpel wrote:
> Hi Lehui,
> 
> Pu Lehui <pulehui@huaweicloud.com> writes:
> 
>> BPF trampoline is the critical infrastructure of the bpf
>> subsystem, acting as a mediator between kernel functions
>> and BPF programs. Numerous important features, such as
>> using ebpf program for zero overhead kernel introspection,
>> rely on this key component. We can't wait to support bpf
>> trampoline on RV64. Since RV64 does not support ftrace
>> direct call yet, the current RV64 bpf trampoline is only
>> used in bpf context.
> 
> Thanks a lot for continuing this work. I agree with you that it's
> valuable to have BPF trampoline support, even without proper direct call
> support (we'll get there soon). The trampoline enables kfunc calls. On
> that note; I don't see that you enable "bpf_jit_supports_kfunc_call()"
> anywhere in the series.  With BPF trampoline support, the RISC-V BPF
> finally can support kfunc calls!
> 
> I'd add the following to bpf_jit_comp64.c:
> 

happy to hear that，let's make it more completeable.

> bool bpf_jit_supports_kfunc_call(void)
> {
>          return true;
> }
> 
> :-)
> 
> I'll do a review ASAP.
> 
> 
> Björn

