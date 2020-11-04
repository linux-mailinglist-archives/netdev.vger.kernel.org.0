Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F52A6A30
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbgKDQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:46:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730987AbgKDQqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604508362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1cW8DZx44Ft/UJKyMxnwWKu5EBpXA6JwZoQX8qWDLTE=;
        b=FHbImQZ1Ywb0LLFfA9fBhjAhUaQp89l/VbJIBgc4o9lKjGfvz9y04z0eTHaElprYT+u4Ci
        ifIXsSUHU9BV87PnaSftKF3GNc17sSXAQq67gjd821E4dpj2PnVp63tSBtmjoMDPm3GXk6
        5LDdns/2TzFos8G66w5jsHN8R+Xw0qI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-4dMxcShON1yrcemzc-s_bg-1; Wed, 04 Nov 2020 11:45:58 -0500
X-MC-Unique: 4dMxcShON1yrcemzc-s_bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 120106D243;
        Wed,  4 Nov 2020 16:45:57 +0000 (UTC)
Received: from krava (unknown [10.40.192.118])
        by smtp.corp.redhat.com (Postfix) with SMTP id 58FF955784;
        Wed,  4 Nov 2020 16:45:54 +0000 (UTC)
Date:   Wed, 4 Nov 2020 17:45:53 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
Message-ID: <20201104164215.GH3861143@krava>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com>
 <20201013195622.GB1305928@krava>
 <CAADnVQLYSk0YgK7_dUSF-5Rau10vOdDgosVhE9xmEr1dp+=2vg@mail.gmail.com>
 <CAEf4BzbWO3fgWxAWQw4Pee=F7=UqU+N6LtKYV7V9ZZrfkPZ3gw@mail.gmail.com>
 <561A9F0C-BDAE-406A-8B93-011ECAB22B1C@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561A9F0C-BDAE-406A-8B93-011ECAB22B1C@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 06:09:14AM +0000, Song Liu wrote:
> 
> 
> > On Oct 13, 2020, at 2:56 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> 
> [...]
> 
> > 
> > I'd go with Kconfig + bpf_core_enum_value(), as it's shorter and
> > nicer. This compiles and works with my Kconfig, but I haven't checked
> > with CONFIG_CGROUP_PIDS defined.
> 
> Tested with CONFIG_CGROUP_PIDS, it looks good. 
> 
> Tested-by: Song Liu <songliubraving@fb.com>

hi,
I still need to apply my workaround to compile tests,
so I wonder this fell through cracks

thanks,
jirka

> 
> > 
> > 
> > diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > index 00578311a423..79b8d2860a5c 100644
> > --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > @@ -243,7 +243,11 @@ static ino_t get_inode_from_kernfs(struct
> > kernfs_node* node)
> >        }
> > }
> > 
> > -int pids_cgrp_id = 1;
> > +extern bool CONFIG_CGROUP_PIDS __kconfig __weak;
> > +
> > +enum cgroup_subsys_id___local {
> > +       pids_cgrp_id___local = 1, /* anything but zero */
> > +};
> > 
> > static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_data,
> >                                         struct task_struct* task,
> > @@ -253,7 +257,9 @@ static INLINE void* populate_cgroup_info(struct
> > cgroup_data_t* cgroup_data,
> >                BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset,
> > dfl_cgrp, kn);
> >        struct kernfs_node* proc_kernfs = BPF_CORE_READ(task, cgroups,
> > dfl_cgrp, kn);
> > 
> > -       if (ENABLE_CGROUP_V1_RESOLVER) {
> > +       if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
> > +               int cgrp_id = bpf_core_enum_value(enum
> > cgroup_subsys_id___local, pids_cgrp_id___local);
> > +
> > #ifdef UNROLL
> > #pragma unroll
> > #endif
> > @@ -262,7 +268,7 @@ static INLINE void* populate_cgroup_info(struct
> > cgroup_data_t* cgroup_data,
> >                                BPF_CORE_READ(task, cgroups, subsys[i]);
> >                        if (subsys != NULL) {
> >                                int subsys_id = BPF_CORE_READ(subsys, ss, id);
> > -                               if (subsys_id == pids_cgrp_id) {
> > +                               if (subsys_id == cgrp_id) {
> >                                        proc_kernfs =
> > BPF_CORE_READ(subsys, cgroup, kn);
> >                                        root_kernfs =
> > BPF_CORE_READ(subsys, ss, root, kf_root, kn);
> >                                        break;
> 

