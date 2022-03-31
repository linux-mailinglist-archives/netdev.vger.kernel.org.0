Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF84ED58D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiCaI1e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 31 Mar 2022 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiCaI1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:27:21 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9C41C391A;
        Thu, 31 Mar 2022 01:25:25 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KTbtK51ctz67KsG;
        Thu, 31 Mar 2022 16:23:53 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 31 Mar 2022 10:25:23 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Thu, 31 Mar 2022 10:25:23 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "corbet@lwn.net" <corbet@lwn.net>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Topic: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF
 programs
Thread-Index: AQHYQsxoL5kXhl8+JE6PJPNWV+NOTqzYppqAgABrSsA=
Date:   Thu, 31 Mar 2022 08:25:22 +0000
Message-ID: <b9f5995f96da447c851f7c9db8232a9b@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220331022727.ybj4rui4raxmsdpu@MBP-98dd607d3435.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.200.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> Sent: Thursday, March 31, 2022 4:27 AM
> On Mon, Mar 28, 2022 at 07:50:15PM +0200, Roberto Sassu wrote:
> > eBPF already allows programs to be preloaded and kept running without
> > intervention from user space. There is a dedicated kernel module called
> > bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
> > program. If this module is enabled in the kernel configuration, its loading
> > will be triggered when the bpf filesystem is mounted (unless the module is
> > built-in), and the links of iterators_bpf are pinned in that filesystem
> > (they will appear as the progs.debug and maps.debug files).
> >
> > However, the current mechanism, if used to preload an LSM, would not
> offer
> > the same security guarantees of LSMs integrated in the security
> subsystem.
> > Also, it is not generic enough to be used for preloading arbitrary eBPF
> > programs, unless the bpf_preload code is heavily modified.
> >
> > More specifically, the security problems are:
> > - any program can be pinned to the bpf filesystem without limitations
> >   (unless a MAC mechanism enforces some restrictions);
> > - programs being executed can be terminated at any time by deleting the
> >   pinned objects or unmounting the bpf filesystem.
> 
> So many things to untangle here.

Hi Alexei

thanks for taking the time to provide such detailed
explanation.

> The above paragraphs are misleading and incorrect.
> The commit log sounds like there are security issues that this
> patch set is fixing.
> This is not true.

I reiterate the goal: enforce a mandatory policy with
an out-of-tree LSM (a kernel module is fine), with the
same guarantees of LSMs integrated in the security
subsystem.

The root user is not part of the TCB (i.e. is untrusted),
all the changes that user wants to make must be subject
of decision by the LSM enforcing the mandatory policy.

I thought about adding support for LSMs from kernel
modules via a new built-in LSM (called LoadLSM), but
to me it looks that the bpf LSM is closer to achieve the
same goal. And in addition, eBPF significantly simplifies
with its helpers writing an LSM.

> Looks like there is a massive misunderstanding on what bpffs is.
> It's a file system to pin and get bpf objects with normal
> file access permissions. Nothing else.
> Do NOT use it to pin LSM or any other security sensitive bpf programs
> and then complain that root can unpin them.
> Yes. Root can and should be able to 'rm -rf' anything in bpffs instance.
> 
> > The usability problems are:
> > - only a fixed amount of links can be pinned;
> 
> where do you see this limit?

static int populate_bpffs(struct dentry *parent)
{
        struct bpf_preload_info objs[BPF_PRELOAD_LINKS] = {};

#define BPF_PRELOAD_LINKS 2

> > - only links can be pinned, other object types are not supported;
> 
> really? progs, maps can be pinned as well.

struct bpf_preload_info {
        char link_name[16];
        struct bpf_link *link;
};

> > - code to pin objects has to be written manually;
> 
> huh?

I meant if you want to extend the bpf_preload kernel
module.

> > Solve the security problems by mounting the bpf filesystem from the
> kernel,
> > by preloading authenticated kernel modules (e.g. with
> module.sig_enforce)
> > and by pinning objects to that filesystem. This particular filesystem
> > instance guarantees that desired eBPF programs run until the very end of
> > the kernel lifecycle, since even root cannot interfere with it.
> 
> No.

Ok. How can the goal I stated above be achieved properly?

> I suspect there is huge confusion on what these two "progs.debug"
> and "maps.debug" files are in a bpffs instance.
> They are debug files to pretty pring loaded maps and progs for folks who
> like to use 'cat' to examine the state of the system instead of 'bpftool'.
> The root can remove these files from bpffs.
> 
> There is no reason for kernel module to pin its bpf progs.
> If you want to develop DIGLIM as a kernel module that uses light skeleton
> just do:
> #include <linux/init.h>
> #include <linux/module.h>
> #include "diglim.lskel.h"
> 
> static struct diglim_bpf *skel;
> 
> static int __init load(void)
> {
>         skel = diglim_bpf__open_and_load();
>         err = diglim_bpf__attach(skel);
> }
> /* detach skel in __fini */
> 
> It's really that short.
> 
> Then you will be able to
> - insmod diglim.ko -> will load and attach bpf progs.
> - rmmod diglim -> will detach them.

root can stop the LSM without consulting the security
policy. The goal of having root untrusted is not achieved.

Maybe there is another way to prevent unloading
the kernel module. I didn't find it yet. If there was an
LSM hook called when kernel modules are unloaded,
that would be sufficient, I guess.

My point was that pinning progs seems to be the
recommended way of keeping them running. Pinning
them to unreachable inodes intuitively looked the
way to go for achieving the stated goal. Or maybe I
should just increment the reference count of links
and don't decrement during an rmmod?

If there is something I'm missing, please let me know.

Thanks

Roberto

HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Li Peng, Zhong Ronghua
