Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C224B32BC
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiBLCkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:40:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLCkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:40:39 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68E522DABD;
        Fri, 11 Feb 2022 18:40:34 -0800 (PST)
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9CxDuEaHgdi9rwAAA--.3561S3;
        Sat, 12 Feb 2022 10:40:27 +0800 (CST)
Subject: Re: [PATCH bpf-next 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable in
 Kconfig
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <1644569851-20859-1-git-send-email-yangtiezhu@loongson.cn>
 <1644569851-20859-3-git-send-email-yangtiezhu@loongson.cn>
 <af2b415a-874d-0524-c5bb-b50c419a1559@iogearbox.net>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <65323db1-5fcb-21b3-2197-9bd6935bd96c@loongson.cn>
Date:   Sat, 12 Feb 2022 10:40:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <af2b415a-874d-0524-c5bb-b50c419a1559@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9CxDuEaHgdi9rwAAA--.3561S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ury3Wr1fAF4xZr43KrWkCrg_yoW8GFyUpw
        4Yq34Syrs7Krs3KFs7u3W7JF48Ww48Wr1UXFs8GrWUZas7CF92kr18K3Wqqa47Z34kX3Wj
        yFZ5ZFyDXa1Uu37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
        n2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
        Y4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO_MaUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2022 06:23 PM, Daniel Borkmann wrote:
> On 2/11/22 9:57 AM, Tiezhu Yang wrote:
>> Currently, it is not possible to set bpf_jit_enable to 1 by default
>> and the users can change it to 0 or 2, it seems bad for some users,
>> make BPF_JIT_DEFAULT_ON selectable to give them a chance.
>
> I'm not fully sure I follow the above, so you are saying that a kconfig of
> !BPF_JIT_ALWAYS_ON and ARCH_WANT_DEFAULT_BPF_JIT, enables
> BPF_JIT_DEFAULT_ON
> however in such setting you are not able to reset bpf_jit_enable back to
> 0 at
> runtime?

Oh, no. Sorry for the unclear description.

currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
the users can not change it to 0 or 2, it seems bad for some users, we
can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
a chance.

Additionaly, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when
make menuconfig, it seems flexible for some developers.

If you are OK, I will update the commit message and then send v2.

Thanks,
Tiezhu

>
> Thanks,
> Daniel

