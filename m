Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0272C0F40
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 03:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfI1BnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 21:43:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41382 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfI1BnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 21:43:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id p10so3512210qkg.8;
        Fri, 27 Sep 2019 18:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=K5mFZ8ZW9xOI1UQMWK7PjgDnXrBKjboW28wsNbRcWmE=;
        b=SiOb/42E4i/NZ0ZBE3lcP+McD+hrcwGfgXpY4tN8hpDGQV+yFe/epXL2jR4IU6/D7J
         ngxIVvXOrrHrnM8B79ti5QsMsTrDl/6VXYtzvLGjRfWQUMyVRJ+Dx6wpE3V1C54Tan9f
         TQdB9zggHfx/5cleX9A82CkOhkCNG2J6ujB33GGcuonTMieoy/iqeMgQbrboeXGEK+FJ
         GOp7+E8pVIjA4DWbJSGMfGzL6+yaGi9d5YFscvQ5cYllydGET0EBmfWdj9xaTFaktRue
         4y8Aty/jYJ+NcWgRLARbDGQnIqnZFP3zz/+NOmb0Ef3f3xOHo+mqh5FZL1qjOrwAWDcy
         XRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=K5mFZ8ZW9xOI1UQMWK7PjgDnXrBKjboW28wsNbRcWmE=;
        b=uiR86DX3ZlkVcSI2qKAx4vkv8EFrJHbVPn9Erp2IJ3Zs0wkXqYYZZNA3AKv7bwA3Py
         fdmQbzT+lCsznhkTNXe0KGnzXBXjpG4yhDzgBAvPIkjPXi83dJmgvlp1DMDJ05Lkjfbb
         wAOc4zmh6Vw8k+HD1UPD0/asi/DFKZjVLcmKTl+ZORw6qHbSxsora+xmJt1bBiDmCZ23
         7618fE/16PY/5OYugx/oFgSlC/ulUfO2azxJKnDNlrwIgWAcJ0sNXAF2mFr+6/RFITqu
         Ox3hiV8udf+Ovcx0ryoE7H6CvHl2SOLX99UQyldVxCW6L19nnQlEAfTc611lWO1TCyNJ
         zYAQ==
X-Gm-Message-State: APjAAAUkfYZB5UlnzF+6eqZoYQYYdv9FYxdIbdOiA+N9AUi6YQAAC5I7
        EaB4+zwddmioykyhxn85KPM=
X-Google-Smtp-Source: APXvYqz2ig4TXerI5H5B7nuvAFYXfdDzqqK9yg3BMH2qpJKfW7jPWd85akRSLqTt34b327Czp4YYBQ==
X-Received: by 2002:a37:916:: with SMTP id 22mr8005703qkj.45.1569634979407;
        Fri, 27 Sep 2019 18:42:59 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id z46sm2846281qth.62.2019.09.27.18.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 18:42:58 -0700 (PDT)
Date:   Fri, 27 Sep 2019 22:42:54 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v11 2/4] bpf: added new helper
 bpf_get_ns_current_pid_tgid
Message-ID: <20190928014254.GA26129@frodo.byteswizards.com>
References: <20190924152005.4659-1-cneirabustos@gmail.com>
 <20190924152005.4659-3-cneirabustos@gmail.com>
 <CAEf4BzZeO3cZJWVG0min98gnFs3E8D1m67E+3A_9-rTjHA_Ybg@mail.gmail.com>
 <12db0313-668e-3825-d5fa-28d0f675808c@fb.com>
 <CAEf4BzYZGh774nS1EaCP4od9gzWqPtePPAGX6J7O+pEosnuYrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYZGh774nS1EaCP4od9gzWqPtePPAGX6J7O+pEosnuYrQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 10:24:46AM -0700, Andrii Nakryiko wrote:
> On Fri, Sep 27, 2019 at 9:59 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 9/27/19 9:15 AM, Andrii Nakryiko wrote:
> > > On Thu, Sep 26, 2019 at 1:15 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> > >>
> > >> New bpf helper bpf_get_ns_current_pid_tgid,
> > >> This helper will return pid and tgid from current task
> > >> which namespace matches dev_t and inode number provided,
> > >> this will allows us to instrument a process inside a container.
> > >>
> > >> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > >> ---
> > >>   include/linux/bpf.h      |  1 +
> > >>   include/uapi/linux/bpf.h | 18 +++++++++++++++++-
> > >>   kernel/bpf/core.c        |  1 +
> > >>   kernel/bpf/helpers.c     | 32 ++++++++++++++++++++++++++++++++
> > >>   kernel/trace/bpf_trace.c |  2 ++
> > >>   5 files changed, 53 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > >> index 5b9d22338606..231001475504 100644
> > >> --- a/include/linux/bpf.h
> > >> +++ b/include/linux/bpf.h
> > >> @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> > >>   extern const struct bpf_func_proto bpf_strtol_proto;
> > >>   extern const struct bpf_func_proto bpf_strtoul_proto;
> > >>   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> > >> +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
> > >>
> > >>   /* Shared helpers among cBPF and eBPF. */
> > >>   void bpf_user_rnd_init_once(void);
> > >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > >> index 77c6be96d676..9272dc8fb08c 100644
> > >> --- a/include/uapi/linux/bpf.h
> > >> +++ b/include/uapi/linux/bpf.h
> > >> @@ -2750,6 +2750,21 @@ union bpf_attr {
> > >>    *             **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> > >>    *
> > >>    *             **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> > >> + *
> > >> + * int bpf_get_ns_current_pid_tgid(u32 dev, u64 inum)
> > >> + *     Return
> > >> + *             A 64-bit integer containing the current tgid and pid from current task
> > >
> > > Function signature doesn't correspond to the actual return type (int vs u64).
> > >
> > >> + *              which namespace inode and dev_t matches , and is create as such:
> > >> + *             *current_task*\ **->tgid << 32 \|**
> > >> + *             *current_task*\ **->pid**.
> > >> + *
> > >> + *             On failure, the returned value is one of the following:
> > >> + *
> > >> + *             **-EINVAL** if dev and inum supplied don't match dev_t and inode number
> > >> + *              with nsfs of current task.
> > >> + *
> > >> + *             **-ENOENT** if /proc/self/ns does not exists.
> > >> + *
> > >>    */
> > >
> > > [...]
> > >
> > >>   #include "../../lib/kstrtox.h"
> > >>
> > >> @@ -487,3 +489,33 @@ const struct bpf_func_proto bpf_strtoul_proto = {
> > >>          .arg4_type      = ARG_PTR_TO_LONG,
> > >>   };
> > >>   #endif
> > >> +
> > >> +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u32, dev, u64, inum)
> > >
> > > Just curious, is dev_t officially specified as u32 and is never
> > > supposed to grow bigger? I wonder if accepting u64 might be more
> > > future-proof API here?
> >
> > This is what we have now in kernel (include/linux/types.h)
> > typedef u32 __kernel_dev_t;
> > typedef __kernel_dev_t          dev_t;
> >
> > But userspace dev_t (defined at /usr/include/sys/types.h) have
> > 8 bytes.
> >
> > Agree. Let us just use u64. It won't hurt and also will be fine
> > if kernel internal dev_t becomes 64bit.
> 
> Sounds good. Let's not forget to check that conversion to dev_t
> doesn't loose high bits, something like:
> 
> if ((u64)(dev_t)dev != dev)
>     return -E<something>;
> 
> >
> > >
> > >> +{
> > >> +       struct task_struct *task = current;
> > >> +       struct pid_namespace *pidns;
> > >
> > > [...]
> > >

Thanks Yonghong and Andrii,

I'll include these fixes on V12, I'll work on this over the weekend.

Bests
