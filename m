Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D46710F1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjARCOH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Jan 2023 21:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjARCOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:14:04 -0500
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D999D2C646;
        Tue, 17 Jan 2023 18:14:02 -0800 (PST)
X-QQ-mid: bizesmtp63t1674007995t7ilarhe
Received: from smtpclient.apple ( [1.202.165.115])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 18 Jan 2023 10:13:12 +0800 (CST)
X-QQ-SSF: 00000000000000809000000A0000000
X-QQ-FEAT: znfcQSa1hKYt2IoUPBjev0xJiHXY9/1L91X5VNAqb/e5yZ9oi32VUsokqo2nJ
        +wPh7qedOpf/tsd3HzSONUeqf1pOD8MPxuZr0e8HJYW8yc9nStr3qH/UMCs7uC97bBIoauC
        46fR5fcZOGBhfbnbvnndoVjlwYD2qlmAiNd3g85zOD6ybo+JHkDJ3YFv8gZnfdK624jb5L0
        3NpTCtRd7BPUQQ1oMUmzarTm8J9gSabU6CkDDw5Lbcuxyg02RDuJDKqY2Y632j6Vq7rTuFa
        9P1D7m16VwFZTPebxFJpM0XMMvQf3jvYtbqAw/ST3zovg30ZxZruPNqLj1J99TB8FXiCDQs
        VGQcZ15w70JL0IH4ZUAQo2ndqJtFyqEEz+MovJW
X-QQ-GoodBg: 0
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
From:   Tonghao Zhang <tong@infragraf.org>
In-Reply-To: <d91bbb9e-484b-d43d-e62d-0474ff21cf91@iogearbox.net>
Date:   Wed, 18 Jan 2023 10:13:11 +0800
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.or" 
        <linux-arm-kernel@lists.infradead.or>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Content-Transfer-Encoding: 8BIT
Message-Id: <7159E8F8-AE66-4563-8A29-D10D66EFAF3D@infragraf.org>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <4380D454-3ED0-43F4-9A79-102BB0E3577A@infragraf.org>
 <d91bbb9e-484b-d43d-e62d-0474ff21cf91@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:infragraf.org:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 17, 2023, at 11:59 PM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> On 1/17/23 3:22 PM, Tonghao Zhang wrote:
>>> On Jan 17, 2023, at 3:30 PM, Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>>> 
>>> 
>>> 
>>> Le 17/01/2023 à 06:30, Tonghao Zhang a écrit :
>>>> 
>>>> 
>>>>> On Jan 9, 2023, at 4:15 PM, Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>>>>> 
>>>>> 
>>>>> 
>>>>> Le 06/01/2023 à 16:37, Daniel Borkmann a écrit :
>>>>>> On 1/5/23 6:53 PM, Christophe Leroy wrote:
>>>>>>> Le 05/01/2023 à 04:06, tong@infragraf.org a écrit :
>>>>>>>> From: Tonghao Zhang <tong@infragraf.org>
>>>>>>>> 
>>>>>>>> The x86_64 can't dump the valid insn in this way. A test BPF prog
>>>>>>>> which include subprog:
>>>>>>>> 
>>>>>>>> $ llvm-objdump -d subprog.o
>>>>>>>> Disassembly of section .text:
>>>>>>>> 0000000000000000 <subprog>:
>>>>>>>>          0:       18 01 00 00 73 75 62 70 00 00 00 00 72 6f 67 00 r1
>>>>>>>> = 29114459903653235 ll
>>>>>>>>          2:       7b 1a f8 ff 00 00 00 00 *(u64 *)(r10 - 8) = r1
>>>>>>>>          3:       bf a1 00 00 00 00 00 00 r1 = r10
>>>>>>>>          4:       07 01 00 00 f8 ff ff ff r1 += -8
>>>>>>>>          5:       b7 02 00 00 08 00 00 00 r2 = 8
>>>>>>>>          6:       85 00 00 00 06 00 00 00 call 6
>>>>>>>>          7:       95 00 00 00 00 00 00 00 exit
>>>>>>>> Disassembly of section raw_tp/sys_enter:
>>>>>>>> 0000000000000000 <entry>:
>>>>>>>>          0:       85 10 00 00 ff ff ff ff call -1
>>>>>>>>          1:       b7 00 00 00 00 00 00 00 r0 = 0
>>>>>>>>          2:       95 00 00 00 00 00 00 00 exit
>>>>>>>> 
>>>>>>>> kernel print message:
>>>>>>>> [  580.775387] flen=8 proglen=51 pass=3 image=ffffffffa000c20c
>>>>>>>> from=kprobe-load pid=1643
>>>>>>>> [  580.777236] JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc cc
>>>>>>>> cc cc cc cc cc
>>>>>>>> [  580.779037] JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc cc
>>>>>>>> cc cc cc cc cc
>>>>>>>> [  580.780767] JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc cc
>>>>>>>> cc cc cc cc cc
>>>>>>>> [  580.782568] JIT code: 00000030: cc cc cc
>>>>>>>> 
>>>>>>>> $ bpf_jit_disasm
>>>>>>>> 51 bytes emitted from JIT compiler (pass:3, flen:8)
>>>>>>>> ffffffffa000c20c + <x>:
>>>>>>>>      0:   int3
>>>>>>>>      1:   int3
>>>>>>>>      2:   int3
>>>>>>>>      3:   int3
>>>>>>>>      4:   int3
>>>>>>>>      5:   int3
>>>>>>>>      ...
>>>>>>>> 
>>>>>>>> Until bpf_jit_binary_pack_finalize is invoked, we copy rw_header to
>>>>>>>> header
>>>>>>>> and then image/insn is valid. BTW, we can use the "bpftool prog dump"
>>>>>>>> JITed instructions.
>>>>>>> 
>>>>>>> NACK.
>>>>>>> 
>>>>>>> Because the feature is buggy on x86_64, you remove it for all
>>>>>>> architectures ?
>>>>>>> 
>>>>>>> On powerpc bpf_jit_enable == 2 works and is very usefull.
>>>>>>> 
>>>>>>> Last time I tried to use bpftool on powerpc/32 it didn't work. I don't
>>>>>>> remember the details, I think it was an issue with endianess. Maybe it
>>>>>>> is fixed now, but it needs to be verified.
>>>>>>> 
>>>>>>> So please, before removing a working and usefull feature, make sure
>>>>>>> there is an alternative available to it for all architectures in all
>>>>>>> configurations.
>>>>>>> 
>>>>>>> Also, I don't think bpftool is usable to dump kernel BPF selftests.
>>>>>>> That's vital when a selftest fails if you want to have a chance to
>>>>>>> understand why it fails.
>>>>>> 
>>>>>> If this is actively used by JIT developers and considered useful, I'd be
>>>>>> ok to leave it for the time being. Overall goal is to reach feature parity
>>>>>> among (at least major arch) JITs and not just have most functionality only
>>>>>> available on x86-64 JIT. Could you however check what is not working with
>>>>>> bpftool on powerpc/32? Perhaps it's not too much effort to just fix it,
>>>>>> but details would be useful otherwise 'it didn't work' is too fuzzy.
>>>>> 
>>>>> Sure I will try to test bpftool again in the coming days.
>>>>> 
>>>>> Previous discussion about that subject is here:
>>>>> https://patchwork.kernel.org/project/linux-riscv/patch/20210415093250.3391257-1-Jianlin.Lv@arm.com/#24176847=
>>>> Hi Christophe
>>>> Any progress? We discuss to deprecate the bpf_jit_enable == 2 in 2021, but bpftool can not run on powerpc.
>>>> Now can we fix this issue?
>>> 
>>> Hi Tong,
>>> 
>>> I have started to look at it but I don't have any fruitfull feedback yet.
>>> 
>>> In the meantime, were you able to confirm that bpftool can also be used
>>> to dump jitted tests from test_bpf.ko module on x86_64 ? In that can you
>>> tell me how to proceed ?
>> Now I do not test, but we can dump the insn after bpf_prog_select_runtime in test_bpf.ko. bpf_map_get_info_by_fd can copy the insn to userspace, but we can
>> dump them in test_bpf.ko in the same way.
> 
> Issue is that these progs are not consumable from userspace (and therefore not bpftool).
> it's just simple bpf_prog_alloc + copy of test insns + bpf_prog_select_runtime() to test
> JITs (see generate_filter()). Some of them could be converted over to test_verifier, but
> not all might actually pass verifier, iirc. Don't think it's a good idea to allow exposing
> them via fd tbh.
Hi
I mean that, can we invoke the bpf_jit_dump in test_bpf.ko directly ?. bpf_prog_get_info_by_fd copy the insn to userspace, but we only dump insn in test_bpf.ko

                if (bpf_dump_raw_ok(file->f_cred)) {// code copied from bpf_prog_get_info_by_fd, not tested

                        /* for multi-function programs, copy the JITed
                         * instructions for all the functions
                         */
                        if (prog->aux->func_cnt) {
                                for (i = 0; i < prog->aux->func_cnt; i++) {
                                        len = prog->aux->func[i]->jited_len;
                                        img = (u8 *) prog->aux->func[i]->bpf_func;
                                        bpf_jit_dump(1, len, 1, img);
                                }
                        } else {
                                bpf_jit_dump(1, ulen, 1, prog->bpf_func);
                        }
                }


 

