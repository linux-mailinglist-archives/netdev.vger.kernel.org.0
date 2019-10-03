Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222E4CA0A2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfJCOwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:52:18 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39618 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfJCOwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 10:52:18 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so3970406qtb.6;
        Thu, 03 Oct 2019 07:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N3/hgHIgFHAEc4D3l90bst0MRiCB8lnQXRGxCdOTQXE=;
        b=CqyYB+I8rwq2r8tJ5+HkW2YP1Cy3Ey4GEQNqvaDj2a78UMRWRFxqNn4THrgAmdx74D
         rV5gwRAxVkGP3K7QlL8THB9PQIcpsKf6vjxhCC3LvHGvQES6gizayQo9VLNvKBRq2UTJ
         3eXhqo4R8wqmFp2UR0F8rlvWMIIp2LK8rzd4wGODj+LE1JvpQgZosjKVuQ5XggoM1L8c
         58sC/7nAyhyuL/+yD1bORS0bkilcpeHtkFHjsl2fll7iDxfrPlMSEXURXmchoyiKlKjh
         Z5lWe8J8jglMFM+wANa5eSAgRT5JdIhRpgSGgglPLEg5vr+P2jaYZO1vHBgZXumMwWf/
         L8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N3/hgHIgFHAEc4D3l90bst0MRiCB8lnQXRGxCdOTQXE=;
        b=ltAtnU281EXMqhsZmNASXpX+yyAegTS/umGxLXGUg5COhuTQuJlGPi/DLwaumyqw7l
         /dJzSdJX5wXE7MgEUnKlKKOSldx+SrnI0Lhh7hHzmVbRfIetSlXvM/yOfHEsgLBV9YV9
         tBj63qDzmlbwbEJ1vnVSKL9lSGrHpPaTB25CJfj9pRXdF30yBvFUjC3xUPY6rXMZzSnJ
         1vnaPoFIbAYTzYnxUg7euvOCJ0zMW8XRVH4Ns2+cXuZ55DV44Zuv3nTS0o2C6qdK+Tdf
         8KdodM7qHWLkyYx8wJqPIkU4LxN5EmoPiO/HQeC+yExupelhKXKRmSvMved+1fOQP62J
         Uhew==
X-Gm-Message-State: APjAAAWy8jMWNIwv9LJ2oCaEd29lFzP/aMQkEOR92/PL3a8GyeZmuCY0
        LautXdxk93mEpqWWDK7R3hA=
X-Google-Smtp-Source: APXvYqxcq5nAS58NLFhfHzXTFHmuEigLFFtUs6Cgu1R+pT9Nyo/Xsm2Dl7s4d4GwIg9ubSyO9OW1Pg==
X-Received: by 2002:ac8:3f96:: with SMTP id d22mr10570499qtk.36.1570114336300;
        Thu, 03 Oct 2019 07:52:16 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id p77sm1801981qke.6.2019.10.03.07.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 07:52:15 -0700 (PDT)
Date:   Thu, 3 Oct 2019 11:52:11 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH V12 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
Message-ID: <20191003145211.GA3657@frodo.byteswizards.com>
References: <20191001214141.6294-1-cneirabustos@gmail.com>
 <20191001214141.6294-3-cneirabustos@gmail.com>
 <79645731-da32-6071-e05f-6345cf47bcd1@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79645731-da32-6071-e05f-6345cf47bcd1@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 12:52:29PM +0200, Daniel Borkmann wrote:
> On 10/1/19 11:41 PM, Carlos Neira wrote:
> > New bpf helper bpf_get_ns_current_pid_tgid,
> > This helper will return pid and tgid from current task
> > which namespace matches dev_t and inode number provided,
> > this will allows us to instrument a process inside a container.
> > 
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >   include/linux/bpf.h      |  1 +
> >   include/uapi/linux/bpf.h | 18 +++++++++++++++++-
> >   kernel/bpf/core.c        |  1 +
> >   kernel/bpf/helpers.c     | 36 ++++++++++++++++++++++++++++++++++++
> >   kernel/trace/bpf_trace.c |  2 ++
> >   5 files changed, 57 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 5b9d22338606..231001475504 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> >   extern const struct bpf_func_proto bpf_strtol_proto;
> >   extern const struct bpf_func_proto bpf_strtoul_proto;
> >   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
> >   /* Shared helpers among cBPF and eBPF. */
> >   void bpf_user_rnd_init_once(void);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 77c6be96d676..ea8145d7f897 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2750,6 +2750,21 @@ union bpf_attr {
> >    *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> >    *
> >    *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
> > + *
> > + * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 inum)
> > + *	Return
> > + *		A 64-bit integer containing the current tgid and pid from current task
> > + *              which namespace inode and dev_t matches , and is create as such:
> > + *		*current_task*\ **->tgid << 32 \|**
> > + *		*current_task*\ **->pid**.
> > + *
> > + *		On failure, the returned value is one of the following:
> > + *
> > + *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
> > + *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
> > + *
> > + *		**-ENOENT** if /proc/self/ns does not exists.
> > + *
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -2862,7 +2877,8 @@ union bpf_attr {
> >   	FN(sk_storage_get),		\
> >   	FN(sk_storage_delete),		\
> >   	FN(send_signal),		\
> > -	FN(tcp_gen_syncookie),
> > +	FN(tcp_gen_syncookie),          \
> > +	FN(get_ns_current_pid_tgid),
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >    * function eBPF program intends to call
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 66088a9e9b9e..b2fd5358f472 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
> >   const struct bpf_func_proto bpf_get_current_comm_proto __weak;
> >   const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
> >   const struct bpf_func_proto bpf_get_local_storage_proto __weak;
> > +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
> >   const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
> >   {
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index 5e28718928ca..8777181d1717 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -11,6 +11,8 @@
> >   #include <linux/uidgid.h>
> >   #include <linux/filter.h>
> >   #include <linux/ctype.h>
> > +#include <linux/pid_namespace.h>
> > +#include <linux/proc_ns.h>
> >   #include "../../lib/kstrtox.h"
> > @@ -487,3 +489,37 @@ const struct bpf_func_proto bpf_strtoul_proto = {
> >   	.arg4_type	= ARG_PTR_TO_LONG,
> >   };
> >   #endif
> > +
> > +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u64, dev, u64, inum)
> > +{
> > +	struct task_struct *task = current;
> > +	struct pid_namespace *pidns;
> > +	pid_t pid, tgid;
> > +
> > +	if ((u64)(dev_t)dev != dev)
> > +		return -EINVAL;
> > +
> > +	if (unlikely(!task))
> > +		return -EINVAL;
> > +
> > +	pidns = task_active_pid_ns(task);
> > +	if (unlikely(!pidns))
> > +		return -ENOENT;
> > +
> > +
> > +	if (!ns_match(&pidns->ns, (dev_t)dev, inum))
> > +		return -EINVAL;
> > +
> > +	pid = task_pid_nr_ns(task, pidns);
> > +	tgid = task_tgid_nr_ns(task, pidns);
> > +
> > +	return (u64) tgid << 32 | pid;
> 
> Basically here you are overlapping the 64-bit return value for the valid
> outcome with the error codes above for the invalid case. If you look at
> bpf_perf_event_read() we already had such broken occasion that bit us in
> the past, and needed to introduce bpf_perf_event_read_value() instead.
> Lets not go there again and design it similarly to the latter.
> 
> > +}
> > +
> > +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
> > +	.func		= bpf_get_ns_current_pid_tgid,
> > +	.gpl_only	= false,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_ANYTHING,
> > +	.arg2_type	= ARG_ANYTHING,
> > +};
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 44bd08f2443b..32331a1dcb6d 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   #endif
> >   	case BPF_FUNC_send_signal:
> >   		return &bpf_send_signal_proto;
> > +	case BPF_FUNC_get_ns_current_pid_tgid:
> > +		return &bpf_get_ns_current_pid_tgid_proto;
> >   	default:
> >   		return NULL;
> >   	}
> > 
> 
Daniel,
If I understand correctly, to avoid problems I need to change the helper's function signature to something like the following:

struct bpf_ns_current_pid_tgid_storage {
	__u64 dev;
	__u64 inum;
	__u64 pidtgid;
};

BPF_CALL_2(bpf_get_ns_current_pid_tgid,
	   struct bpf_ns_current_pid_tgid_storage *, buf, u32, size);  

then use dev and inum provided by the user and return the requested
value into pidtgid of the struct. Would that work?

Thanks for your help. 
 



