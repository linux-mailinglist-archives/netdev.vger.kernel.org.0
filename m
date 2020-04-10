Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D87181A4B9C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 23:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDJVdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 17:33:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46037 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgDJVdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 17:33:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id t17so3198849ljc.12;
        Fri, 10 Apr 2020 14:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eVMKHOcwOHc1uDsK1KuN40ZRj/NsNM/2M7tDl8sBx14=;
        b=gKiIOy65yLjnpP+RsK9noHVbNlazZeQ1fYSNS/FLI33iB7ZJr2vrMOX4db/rpqKEb7
         E6SUqiFS2qwV+KJJMTffV7OFykjiYBHKx7FtwN+cbxUzY6tQTBZv/ZMozpnqeJ/onE/k
         NwuHmw3CNWFDoc3w12Y5dBGlfeuY/0MWRwuvAn2QbXawYDxPgoELjXblobAzIdrxaO0n
         fg45AmwrkRo+iiG9rCoBmi0fj4ZgVc4C0u3WsgpTWRVvWxgzq4UmnBQOUDEKZWFGsMFW
         1YdRHYb6lRUsq15f3OT/QMLMmo3qUilRiSNG9dSDIjjJfi8zDds/7azWjgc1Tv9lrv5Z
         KbSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eVMKHOcwOHc1uDsK1KuN40ZRj/NsNM/2M7tDl8sBx14=;
        b=KY2dYsTGgObPvVH18p/bu6sPzLBTwIVx7VSCPaa5GOY2Rai/7og+VmXndk5ktWcYHd
         w/yLORoHmjo4gyXwKiSJcrba4jL16CEwFFFp+lbeBB7t6r1mdc2dvikuGPNvEkrWEPAW
         qlWRkGxvtQThUSs6BBt33EClBar6h+ngvvcjYEUtRghYiaILhd6SvOomElylRL0RQ0cN
         bDQVET9o96nYVkdPcaEB7OZ5q/N0j1GS8Srdp2seCFGSf+iPWr71LqatjWioTEyMuK4l
         SgiX4tONf1r8N7YA9OlqP5QrsTSqrCmkdE3SsB1kxXsH7oHMofQRku0p0treP4YBKUkF
         J11A==
X-Gm-Message-State: AGi0PuaVDlJLdD3DwWGXX8sn4A50shV0gEzvUdORF974EPQqlgvc4sNq
        9Q0YyNL4wV9X462Tyrgz7J2mkO7UiC/LOPUw3ls=
X-Google-Smtp-Source: APiQypKKEJY3TWdYNUYfN3bMGP2tPq8LtsMuVggJ7yTdGFxA/noP65lt/2GchulQeLPjNM/At7A0hP0Xk4qxLFfVbbo=
X-Received: by 2002:a2e:9247:: with SMTP id v7mr3844056ljg.215.1586554425130;
 Fri, 10 Apr 2020 14:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232529.2676060-1-yhs@fb.com>
 <20200410032223.esp46oxtpegextxn@ast-mbp.dhcp.thefacebook.com>
 <d40f0a39-093f-2ed2-d5d0-b97947f0093f@fb.com> <20200410213138.xwn2b7t6np44v5ls@ast-mbp>
In-Reply-To: <20200410213138.xwn2b7t6np44v5ls@ast-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Apr 2020 14:33:33 -0700
Message-ID: <CAADnVQ+kmd0-9Q0XjNwLHEuYb60mnKYTQgy=RPsstdOZwtgixg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 08/16] bpf: add task and task/file targets
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 2:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Apr 09, 2020 at 11:19:10PM -0700, Yonghong Song wrote:
> >
> >
> > On 4/9/20 8:22 PM, Alexei Starovoitov wrote:
> > > On Wed, Apr 08, 2020 at 04:25:29PM -0700, Yonghong Song wrote:
> > > > +
> > > > + spin_lock(&files->file_lock);
> > > > + for (; sfd < files_fdtable(files)->max_fds; sfd++) {
> > > > +         struct file *f;
> > > > +
> > > > +         f = fcheck_files(files, sfd);
> > > > +         if (!f)
> > > > +                 continue;
> > > > +
> > > > +         *fd = sfd;
> > > > +         get_file(f);
> > > > +         spin_unlock(&files->file_lock);
> > > > +         return f;
> > > > + }
> > > > +
> > > > + /* the current task is done, go to the next task */
> > > > + spin_unlock(&files->file_lock);
> > > > + put_files_struct(files);
> > >
> > > I think spin_lock is unnecessary.
> > > It's similarly unnecessary in bpf_task_fd_query().
> > > Take a look at proc_readfd_common() in fs/proc/fd.c.
> > > It only needs rcu_read_lock() to iterate fd array.
> >
> > I see. I was looking at function seq_show() at fs/proc/fd.c,
> >
> > ...
> >                 spin_lock(&files->file_lock);
> >                 file = fcheck_files(files, fd);
> >                 if (file) {
> >                         struct fdtable *fdt = files_fdtable(files);
> >
> >                         f_flags = file->f_flags;
> >                         if (close_on_exec(fd, fdt))
> >                                 f_flags |= O_CLOEXEC;
> >
> >                         get_file(file);
> >                         ret = 0;
> >                 }
> >                 spin_unlock(&files->file_lock);
> >                 put_files_struct(files);
> > ...
> >
> > I guess here spin_lock is needed due to close_on_exec().
>
> Right. fdr->close_on_exec array is not rcu protected and needs that spin_lock.

Actually. I'll take it back. fdt is rcu protected and that member is part of it.
So imo seq_show() is doing that spin_lock unnecessary.
