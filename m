Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7DC27AFC7
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgI1ONQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:13:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1ONQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:13:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SE9Vn5065420;
        Mon, 28 Sep 2020 14:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=iQLxmJxSvSJscFRlyFmzx7cDJf4NvJfEUoYeUUEmSq0=;
 b=0Q8eHlmTxUZwNR4uBoJ/jRA6CQrm4V75pLJYhNynu/mQZ7SGs4IhFb5URe85IyR6NQmn
 35FuToHscKSC/Wrpy+Cjtfn2qErrGK9aS1tGZVFCxgz1kIuI/URfiCdcjziZDMx4cPvs
 bWtFzR8OACZIAELD+dvm8zwZv8E9Tae6R6gW9qPgrI7GZetbXgt7R/ZsudIm+WJov0e3
 d1+bfs4LXwuaDTCuRpu8JqHUFdKPhp3spBQSdKHT3vLSn03QLYzTG63fLL8D1+pGITz5
 64PayZfxn+8mvMsFXTW8ihexhiU35xJ9/oixDix5TdSPsI8KCeRydXcqiGFt+LXwBPqd lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkn9pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 14:12:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SEAOmu181612;
        Mon, 28 Sep 2020 14:12:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33tfhwax0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 14:12:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08SECIhV022371;
        Mon, 28 Sep 2020 14:12:18 GMT
Received: from dhcp-10-175-172-184.vpn.oracle.com (/10.175.172.184)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 07:12:18 -0700
Date:   Mon, 28 Sep 2020 15:12:04 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org
Subject: Re: [PATCH v6 bpf-next 6/6] selftests/bpf: add test for bpf_seq_printf_btf
 helper
In-Reply-To: <20200925012611.jebtlvcttusk3hbx@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.LRH.2.21.2009281500220.13299@localhost>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com> <1600883188-4831-7-git-send-email-alan.maguire@oracle.com> <20200925012611.jebtlvcttusk3hbx@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=3 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 24 Sep 2020, Alexei Starovoitov wrote:

> to whatever number, but printing single task_struct needs ~800 lines and
> ~18kbytes. Humans can scroll through that much spam, but can we make it less
> verbose by default somehow?
> May be not in this patch set, but in the follow up?
>

One approach that might work would be to devote 4 bits or so of
flag space to a "maximum depth" specifier; i.e. at depth 1,
only base types are displayed, no aggregate types like arrays,
structs and unions.  We've already got depth processing in the
code to figure out if possibly zeroed nested data needs to be
displayed, so it should hopefully be a simple follow-up.

One way to express it would be to use "..." to denote field(s)
were omitted. We could even use the number of "."s to denote
cases where multiple fields were omitted, giving a visual sense
of how much data was omitted.  So for example with 
BTF_F_MAX_DEPTH(1), task_struct looks like this:

(struct task_struct){
 .state = ()1,
 .stack = ( *)0x00000000029d1e6f,
 ...
 .flags = (unsigned int)4194560,
 ...
 .cpu = (unsigned int)36,
 .wakee_flips = (unsigned int)11,
 .wakee_flip_decay_ts = (long unsigned int)4294914874,
 .last_wakee = (struct task_struct *)0x000000006c7dfe6d,
 .recent_used_cpu = (int)19,
 .wake_cpu = (int)36,
 .prio = (int)120,
 .static_prio = (int)120,
 .normal_prio = (int)120,
 .sched_class = (struct sched_class *)0x00000000ad1561e6,
 ...
 .exec_start = (u64)674402577156,
 .sum_exec_runtime = (u64)5009664110,
 .vruntime = (u64)167038057,
 .prev_sum_exec_runtime = (u64)5009578167,
 .nr_migrations = (u64)54,
 .depth = (int)1,
 .parent = (struct sched_entity *)0x00000000cba60e7d,
 .cfs_rq = (struct cfs_rq *)0x0000000014f353ed,
 ...
 
...etc. What do you think?

> > +SEC("iter/task")
> > +int dump_task_fs_struct(struct bpf_iter__task *ctx)
> > +{
> > +	static const char fs_type[] = "struct fs_struct";
> > +	struct seq_file *seq = ctx->meta->seq;
> > +	struct task_struct *task = ctx->task;
> > +	struct fs_struct *fs = (void *)0;
> > +	static struct btf_ptr ptr = { };
> > +	long ret;
> > +
> > +	if (task)
> > +		fs = task->fs;
> > +
> > +	ptr.type = fs_type;
> > +	ptr.ptr = fs;
> 
> imo the following is better:
>        ptr.type_id = __builtin_btf_type_id(*fs, 1);
>        ptr.ptr = fs;
> 

I'm still seeing lookup failures using __builtin_btf_type_id(,1) -
whereas both __builtin_btf_type_id(,0) and Andrii's
suggestion of bpf_core_type_id_kernel() work. Not sure what's
going on - pahole is v1.17, clang is

clang version 12.0.0 (/mnt/src/llvm-project/clang 
7ab7b979d29e1e43701cf690f5cf1903740f50e3)

> > +
> > +	if (ctx->meta->seq_num == 0)
> > +		BPF_SEQ_PRINTF(seq, "Raw BTF fs_struct per task\n");
> > +
> > +	ret = bpf_seq_printf_btf(seq, &ptr, sizeof(ptr), 0);
> > +	switch (ret) {
> > +	case 0:
> > +		tasks++;
> > +		break;
> > +	case -ERANGE:
> > +		/* NULL task or task->fs, don't count it as an error. */
> > +		break;
> > +	default:
> > +		seq_err = ret;
> > +		break;
> > +	}
> 
> Please add handling of E2BIG to this switch. Otherwise
> printing large amount of tiny structs will overflow PAGE_SIZE and E2BIG
> will be send to user space.
> Like this:
> @@ -40,6 +40,8 @@ int dump_task_fs_struct(struct bpf_iter__task *ctx)
>         case -ERANGE:
>                 /* NULL task or task->fs, don't count it as an error. */
>                 break;
> +       case -E2BIG:
> +               return 1;
> 

Done.

> Also please change bpf_seq_read() like this:
> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
> index 30833bbf3019..8f10e30ea0b0 100644
> --- a/kernel/bpf/bpf_iter.c
> +++ b/kernel/bpf/bpf_iter.c
> @@ -88,8 +88,8 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>         mutex_lock(&seq->lock);
> 
>         if (!seq->buf) {
> -               seq->size = PAGE_SIZE;
> -               seq->buf = kmalloc(seq->size, GFP_KERNEL);
> +               seq->size = PAGE_SIZE << 3;
> +               seq->buf = kvmalloc(seq->size, GFP_KERNEL);
> 
> So users can print task_struct by default.
> Hopefully we will figure out how to deal with spam later.
> 

Thanks for all the help and suggestions! I didn't want to
attribute the patch bumping seq size in v7 to you without your 
permission, but it's all your work so if I need to respin let me
know if you'd like me to fix that. Thanks again!

Alan
