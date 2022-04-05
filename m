Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E921F4F538E
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2360867AbiDFEZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835840AbiDFAdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 20:33:43 -0400
Received: from sonic312-30.consmr.mail.ne1.yahoo.com (sonic312-30.consmr.mail.ne1.yahoo.com [66.163.191.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B7B104A54
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 15:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649198856; bh=kuHtMKHl/c2qIGNhAGVZoANBI56QWLO5me7QncFB0/4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=lw/b5SvbMVXuoNhOkN60MTNvRK0sDPou7k8Sm8/fDot5jNIhKwRd3eHlRDH4X++09rQEJw1wr+aKES2kF0F5dOMKeDQUZQ6F4HZOWGED0RDC4zr9xcZY9Qk6H8JLGIQho7PvJeTl8oKy7KnIOIiPnQQ7B7oSZHdV7nV34QwwpPvCV1hoQGTxbT/4rS1hlwLxnfvKtak1zmDmffa+AUzFsTThb4ap/GSRNi9jovUUtR5yK7ddvNvJrvphSyDebb/pwGdWdzuXAqm2VSIbgKe10iBQx3wYqNt0U7V+Z2fvGSGZwR7tJu3GBEoFohyivhXzK9FuIP48+lJCqFVNv9I8hQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1649198856; bh=VbxZHvRlQ3ApM+hvxQitthNUVXoy1RKh/KVchJBGZGS=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=oGp9qOO4oZpK+WQMwTyI6AQctVQpLckSVRDCMM9EY4+URlBQmX+gpK78IfGzEbJ1WQOoAgSAqaV7gbPSvkBrQmDEU+odSwN0Z7UaU315n38j5LFqVI6pfJGjwXZEkE0sJ20imT5mnbnidmwOGI5FZKeajBcL6gMT9w9tZ6VAPJSnOE5tnZANcnkdMh7dqLfFizhLODK+mnLGixLVyp1AgVBsFojT0K3uAfCKlTIeoM31WO7VJJKdaVbU1W5+cjem8eiUyG/ev9ipDWUvQK/goHUd0yZOMuHWRMtTMakOWirSW07wdwQdxNy89lTohXsPGu8sAAXcWlEgAmiEApvXZw==
X-YMail-OSG: KM__rusVM1mvT51zYphGFvuxV3vMoEUz.64XbPOnJeUfM3Q02p8tjzbCHPbxK90
 xEbDliiZmXka7VwlPeFd9D1DD5e1OCiK71seGddNJdacxGYZBFqNL38S22jUAAh2NKwCZgZ3a1qm
 b68mSbOJTcl892WIwb.mTv9vYc9nK6H9jOBvffECkgbEOIuJ2OTT0OCGlYe38K9gXdoiudYOOpHl
 2fh_s6WdkypLC5Nfeyk4z1adY.Se94Xlv.8WW64_g.Q6gsD7htFWlmyKKuIjT7IOL6GjWm9Szqd1
 R3UV59okWBjij2lkAmEvm1OGVvxhNPUS.liSAj2FU0qfbfjIyuTRodjmQ44ijXaF_l.ncSA6E7D2
 52uqJTjoWIGYu33gu7Y9smglgLO03sxROpSKDJjLYSmqq5TZV191mqxNk6qpvwyo1.It_zg1CqAM
 _I4TYKmrHvNzptK8N1w3ksNztLX_e0N5gHbhAJlQPW5Bw6ykmInAWc_WUaCDq_nMTrMNQ0.BQLAW
 WCRbo_nap91myK7S6jaZMMJbCJQlKQ0d19nAP0GXwM.U0k4qdC3wPw9KG8_ejbIeSpZDDcf8IzrJ
 4bQvcIjmYkKtr30WANdICKGFIG6qoNp9Fg95.2kjpGHvmwHPuO6qR9YqjocDnUP97EQvkTGUoZTC
 fmWLce.3nw8OaynFbR2KRNYiUriJl8uXIATVYpJyjRTwAIa8rjrwbAhxUP5NVN_nxvbt9B0qD1vL
 iF5dcCV7zA.vqsgkTlPIKvL7geTOs3C_5Q.EkNfAn5PlCJi3y1zODah_iTZ4ecECSgQVOQRR_lvQ
 5sUCI4wSaPH5EOmTNV6q7bTyu3MxHVIaMUAIVoLi_8k4EtldfkqaEeKispwKxjk.YDkONtPJE0Cc
 pE8iFJVkuJaeEnENzECZy3vMXBzWkyWrlOzxhd.x5VcN.LvY_kezvJ9przKkPd24eoo3B9kOZUKP
 NS_jcRoQPrm.gnozfYxNufkt9qbgJaWqXnPjXRpcK_nHwdGqJ9SrZII7p1ZaQmL_NGh5eShl5Ak0
 oCDgnLQHlke0.mPoBs.DXXK7r8bayP2uWHxez.cMKyi2mCozH06SzzozGsmV2DV4wRVeNnQ5NnD7
 duFgvP9y0siotq8UHHEY2GCd5kkjmdaAUd1iyLgVlxPeMAd89ho9zCouqCHg9YuIHw3L_NEVlpyt
 6bEP0KxoUYtsVKOeWmn1lqMZxOkdMux8JF.jzEan8uwwC2iFVX62Zh.3mtBLMy4wCtI2ydJ7NwVg
 kIvCoToLc5RDNWmOhaNfzcZ9SpG03jdgluv5cLh1oyTvjJti37BVGbQVSuFKambK6zz6fPT3JpqQ
 Td7uMTzGQLDd3aM3r4lpQwkkq6ZgvfZuI74TGG1Qz72OiRGT6ElyxmqgTz9DPI0QPCS8zFtBd5wN
 g7GXxswBII_DtM6v2a2SqBZlQJnDZCEbYwvF6Rsb7KLhj9nTdtNLv40B05j5uX6eOcjh6.gjicjh
 4n2hzMomOHjxFoL26zmw2HZQXDRB9WrXRegbN6o9ZS7S56GISCNn0e.GVx1_ANGl1Y9ITLgc3mkj
 aeGxLxguvgu5LBpKKyxuQl92.GCrYlYGg9HBZk_gNpX.esY3Yg6VvCP7BctyRlX5CWY0a9REhZJK
 YiZHe20QUET91dvI8o.O7mlwNgp2u8k7LNi3gGdWWoDQLdXbXVKDqqN8p.OkQ_PT6MQFWhvWD6Hq
 lQi_UcfdeW3nTE0YTi7wBXLRaPZq2rA6YO6mbYysziXrkHmx9aCMWS1.7xLOO2J43QzBZ7VjWuOp
 mr2bspwwUWdOji.Vpcv8AgMMWnL2l9RHnGmuIXsm.HAAsC.rmVV9vmPHZtotu0A2DOfy6b8a.kDo
 88dY442gAarDTf8zkzmeXacI80hqCh0bPv.qB_AqAuDz8UFgHzXk6kRu6lMfytQN56jEeBNu5Xav
 WAcMHhj._SoyiuB1CBQ_SLZ1CY5EpL3Iyd3J9TY3sxDmLjffnDicxHqypaiKCVj_kLP6XvZDVPDC
 iyDxzHS.Msc7c3OGGTk6..15qsMeGybeAzJrJPCL1fE309eHGaV_S4Jk04LwlcKG_q0pxqPS7NCO
 lvKrLp6NdUSkWJWPqisJBlzCNx0nElmqBXE2hAc2_hYCT_zwuwkjKJLWpKiy5Q8p8ZXptLMQaK_n
 h7bPvT_uLr4.6T.jmGFpAcr.PEWhdDEqORzK1ytMR5S1ocjyiSITC5gOz0z6sv3U1VufvspTMC_V
 OyGNoO0g8_WnT_BFdlHO7W5vCSMmUK1kEBFdnH8P0oNSTwlTNikou0acFupkLZ0z2
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Apr 2022 22:47:36 +0000
Received: by hermes--canary-production-bf1-665cdb9985-4zttc (VZM Hermes SMTP Server) with ESMTPA ID eaa50fa1da4b68d1bc9a73fb183248ea;
          Tue, 05 Apr 2022 22:47:33 +0000 (UTC)
Message-ID: <5ce85845-824c-32fb-3807-6f9ab95ad6fe@schaufler-ca.com>
Date:   Tue, 5 Apr 2022 15:47:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [POC][USER SPACE][PATCH] Introduce LSM to protect pinned objects
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>, corbet@lwn.net,
        viro@zeniv.linux.org.uk, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kpsingh@kernel.org, tixxdz@gmail.com,
        shuah@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, zohar@linux.ibm.com
Cc:     linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <CACYkzJ7ZVbL2MG7ugmDEfogSPAHkYYMCHxRO_eBCJJmBZyn6Rw@mail.gmail.com>
 <20220405131116.3810418-1-roberto.sassu@huawei.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220405131116.3810418-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20001 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/2022 6:11 AM, Roberto Sassu wrote:
> Introduce a new LSM to protect pinned objects in a bpf filesystem

This is *not an LSM*. Do not call it an LSM. It is a set of
eBPF programs. We have all the opportunities for confusion
that we need. I suggested that you call this a BPF security
module (BSM) earlier today. You have any number of things
you can call this that won't be objectionable.

> instance. This is useful for example to ensure that an LSM will always
> enforce its policy, even despite root tries to unload the corresponding
> eBPF program.

How is this going to ensure that SELinux enforces its policy?
AppArmor has no eBPF program that corresponds to its policy,
neither does any other existing LSM, save BPF. Your claim is
nonsensical in the face of LSM behavior.

> Achieve the protection by denying inode unlink and unmount of the
> protected bpf filesystem instance. Since protected inodes hold a
> reference of the link of loaded programs (e.g. LSM hooks), denying
> operations on them will prevent the ref count of the links from reaching
> zero, ensuring that the programs remain always active.
>
> Enable the protection only for the instance created by the user space
> counterpart of the LSM, and don't interfere with other instances, so
> that their behavior remains unchanged.
>
> Suggested-by: Djalal Harouni <tixxdz@gmail.com>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>   .gitignore       |  4 +++
>   Makefile         | 18 ++++++++++++++
>   bpffs_lsm_kern.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++
>   bpffs_lsm_user.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 145 insertions(+)
>   create mode 100644 .gitignore
>   create mode 100644 Makefile
>   create mode 100644 bpffs_lsm_kern.c
>   create mode 100644 bpffs_lsm_user.c
>
> diff --git a/.gitignore b/.gitignore
> new file mode 100644
> index 000000000000..7fa02964f1dc
> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,4 @@
> +*.o
> +vmlinux.h
> +bpffs_lsm_kern.skel.h
> +bpffs_lsm_user
> diff --git a/Makefile b/Makefile
> new file mode 100644
> index 000000000000..c3d805759db3
> --- /dev/null
> +++ b/Makefile
> @@ -0,0 +1,18 @@
> +# SPDX-License-Identifier: GPL-2.0
> +all: bpffs_lsm_user
> +
> +clean:
> +	rm -rf bpffs_lsm.skel.h vmlinux.h bpffs_lsm_kern.o bpffs_lsm_user
> +
> +vmlinux.h:
> +	/usr/sbin/bpftool btf dump file /sys/kernel/btf/vmlinux format c > \
> +			  vmlinux.h
> +
> +bpffs_lsm_kern.skel.h: bpffs_lsm_kern.o
> +	bpftool gen skeleton $< > $@
> +
> +bpffs_lsm_kern.o: bpffs_lsm_kern.c vmlinux.h
> +	clang -Wall -Werror -g -O2 -target bpf -c $< -o $@
> +
> +bpffs_lsm_user: bpffs_lsm_user.c bpffs_lsm_kern.skel.h bpffs_lsm_kern.o
> +	cc -Wall -Werror -g -o $@ $< -lbpf
> diff --git a/bpffs_lsm_kern.c b/bpffs_lsm_kern.c
> new file mode 100644
> index 000000000000..b3ccb2a75c95
> --- /dev/null
> +++ b/bpffs_lsm_kern.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
> + *
> + * Authors:
> + * Roberto Sassu <roberto.sassu@huawei.com>
> + *
> + * Implement an LSM to protect a bpf filesystem instance.
> + */
> +
> +#include "vmlinux.h"
> +#include <errno.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_core_read.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +uint32_t monitored_pid = 0;
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_INODE_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, int);
> +	__type(value, sizeof(uint8_t));
> +} inode_storage_map SEC(".maps");
> +
> +SEC("lsm/sb_set_mnt_opts")
> +int BPF_PROG(sb_set_mnt_opts, struct super_block *sb, void *mnt_opts,
> +	     unsigned long kern_flags, unsigned long *set_kern_flags)
> +{
> +	u32 pid;
> +
> +	pid = bpf_get_current_pid_tgid() >> 32;
> +	if (pid != monitored_pid)
> +		return 0;
> +
> +	if (!bpf_inode_storage_get(&inode_storage_map, sb->s_root->d_inode, 0,
> +				   BPF_LOCAL_STORAGE_GET_F_CREATE))
> +		return -EPERM;
> +
> +	return 0;
> +}
> +
> +SEC("lsm/inode_unlink")
> +int BPF_PROG(inode_unlink, struct inode *dir, struct dentry *dentry)
> +{
> +	if (bpf_inode_storage_get(&inode_storage_map,
> +				  dir->i_sb->s_root->d_inode, 0, 0))
> +		return -EPERM;
> +
> +	return 0;
> +}
> +
> +SEC("lsm/sb_umount")
> +int BPF_PROG(sb_umount, struct vfsmount *mnt, int flags)
> +{
> +	if (bpf_inode_storage_get(&inode_storage_map,
> +				  mnt->mnt_sb->s_root->d_inode, 0, 0))
> +		return -EPERM;
> +
> +	return 0;
> +}
> diff --git a/bpffs_lsm_user.c b/bpffs_lsm_user.c
> new file mode 100644
> index 000000000000..e20180cc5db9
> --- /dev/null
> +++ b/bpffs_lsm_user.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
> + *
> + * Author: Roberto Sassu <roberto.sassu@huawei.com>
> + *
> + * Implement the user space side of the LSM for bpffs.
> + */
> +
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <sys/mount.h>
> +#include <sys/stat.h>
> +
> +#include "bpffs_lsm_kern.skel.h"
> +
> +#define MOUNT_FLAGS (MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_RELATIME)
> +
> +int main(int argc, char *argv[])
> +{
> +	char mntpoint[] = "/tmp/bpf_private_mountXXXXXX";
> +	char path[PATH_MAX];
> +	struct bpffs_lsm_kern *skel;
> +	int ret, i;
> +
> +	skel = bpffs_lsm_kern__open_and_load();
> +	if (!skel)
> +		return -EINVAL;
> +
> +	ret = bpffs_lsm_kern__attach(skel);
> +	if (ret < 0)
> +		goto out_destroy;
> +
> +	mkdtemp(mntpoint);
> +
> +	skel->bss->monitored_pid = getpid();
> +	ret = mount(mntpoint, mntpoint, "bpf", MOUNT_FLAGS, NULL);
> +	skel->bss->monitored_pid = 0;
> +
> +	if (ret < 0)
> +		goto out_destroy;
> +
> +	for (i = 0; i < skel->skeleton->prog_cnt; i++) {
> +		snprintf(path, sizeof(path), "%s/%s", mntpoint,
> +			 skel->skeleton->progs[i].name);
> +		ret = bpf_link__pin(*skel->skeleton->progs[i].link, path);
> +		if (ret < 0)
> +			goto out_destroy;
> +	}
> +
> +	ret = 0;
> +out_destroy:
> +	bpffs_lsm_kern__destroy(skel);
> +	return ret;
> +}
