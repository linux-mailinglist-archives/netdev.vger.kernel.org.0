Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045325B1FF1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiIHOAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbiIHOAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:00:08 -0400
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B93F5BA;
        Thu,  8 Sep 2022 06:59:34 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.228])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4MNgcW0HfGz9y62N;
        Thu,  8 Sep 2022 21:55:23 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwDn3pIh9RljLSYwAA--.49581S2;
        Thu, 08 Sep 2022 14:59:10 +0100 (CET)
Message-ID: <8d7a713e500b5e3fce93e4c5c7b8841eb6dd28e4.camel@huaweicloud.com>
Subject: Re: [PATCH 1/7] bpf: Add missing fd modes check for map iterators
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable <stable@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        LSM List <linux-security-module@vger.kernel.org>
Date:   Thu, 08 Sep 2022 15:58:53 +0200
In-Reply-To: <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
         <20220906170301.256206-2-roberto.sassu@huaweicloud.com>
         <CAADnVQ+o8zyi_Z+XqCQynmvj04AtEtF9AoOTSeyUx9dvKTXOqg@mail.gmail.com>
         <02309cfbc1ce47f7de6be8addc2caa315b1fee1b.camel@huaweicloud.com>
         <CAADnVQ+cEM5Sb7d9yPA72Mp2zimx7VZ5Si3SPVdAZgsdFGpP1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwDn3pIh9RljLSYwAA--.49581S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWr4rJw17tF18ZF47Xr15twb_yoWrAFy3pF
        Z3tryxtr1kZFW7Za9Y9F48WFWFy3srAasrAF1DJryUAFWkXr1vkr1xta1fXasIyFyrX3WS
        y3yYk348Xa4UXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAkuxUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAJBF1jj37gqQAAsJ
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-07 at 09:02 -0700, Alexei Starovoitov wrote:
> 

[...]

> > Well, if you write a security module to prevent writes on a map,
> > and
> > user space is able to do it anyway with an iterator, what is the
> > purpose of the security module then?
> 
> sounds like a broken "security module" and nothing else.

Ok, if a custom security module does not convince you, let me make a
small example with SELinux.

I created a small map iterator that sets every value of a map to 5:

SEC("iter/bpf_map_elem")
int write_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
{
	u32 *key = ctx->key;
	u8 *val = ctx->value;

	if (key == NULL || val == NULL)
		return 0;

	*val = 5;
	return 0;
}

I create and pin a map:

# bpftool map create /sys/fs/bpf/map type array key 4 value 1 entries 1
name test

Initially, the content of the map looks like:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element

I then created a new SELinux type bpftool_test_t, which has only read
permission on maps:

# sesearch -A -s bpftool_test_t -t unconfined_t -c bpf
allow bpftool_test_t unconfined_t:bpf map_read;

So, what I expect is that this type is not able to write to the map.

Indeed, the current bpftool is not able to do it:

# strace -f -etrace=bpf runcon -t bpftool_test_t bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0, file_flags=0},
144) = -1 EACCES (Permission denied)
Error: bpf obj get (/sys/fs/bpf): Permission denied

This happens because the current bpftool requests to access the map
with read-write permission, and SELinux denies it:

# cat /var/log/audit/audit.log|audit2allow


#============= bpftool_test_t ==============
allow bpftool_test_t unconfined_t:bpf map_write;


The command failed, and the content of the map is still:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element


Now, what I will do is to use a slightly modified version of bpftool
which requests read-only access to the map instead:

# strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
file_flags=BPF_F_RDONLY}, 16) = 3
libbpf: elf: skipping unrecognized data section(5) .eh_frame
libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
.eh_frame

...

bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = 5
bpf(BPF_OBJ_PIN, {pathname="/sys/fs/bpf/iter", bpf_fd=5, file_flags=0},
16) = 0

That worked, because SELinux grants read-only permission to
bpftool_test_t. However, the map iterator does not check how the fd was
obtained, and thus allows the iterator to be created.

At this point, we have write access, despite not having the right to do
it:

# cat /sys/fs/bpf/iter
# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 05
Found 1 element

The iterator updated the map value.


The patch I'm proposing checks how the map fd was obtained, and if its
modes are compatible with the operations an attached program is allowed
to do. If the fd does not have the required modes, eBPF denies the
creation of the map iterator.

After patching the kernel, I try to run the modified bpftool again:

# strace -f -etrace=bpf runcon -t bpftool_test_t ./bpftool iter pin
writer.o /sys/fs/bpf/iter map pinned /sys/fs/bpf/map
bpf(BPF_OBJ_GET, {pathname="/sys/fs/bpf/map", bpf_fd=0,
file_flags=BPF_F_RDONLY}, 16) = 3
libbpf: elf: skipping unrecognized data section(5) .eh_frame
libbpf: elf: skipping relo section(6) .rel.eh_frame for section(5)
.eh_frame

...

bpf(BPF_LINK_CREATE, {link_create={prog_fd=4, target_fd=0,
attach_type=BPF_TRACE_ITER, flags=0}, ...}, 48) = -1 EPERM (Operation
not permitted)
libbpf: prog 'write_bpf_hash_map': failed to attach to iterator:
Operation not permitted
Error: attach_iter failed for program write_bpf_hash_map

The map iterator cannot be created and the map is not updated:

# bpftool map dump pinned /sys/fs/bpf/map 
key: 00 00 00 00  value: 00
Found 1 element

Roberto

