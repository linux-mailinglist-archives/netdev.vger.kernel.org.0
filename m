Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C552B7590
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgKRFE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgKRFE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:04:57 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC0CC0613D4;
        Tue, 17 Nov 2020 21:04:57 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id q28so113675oof.1;
        Tue, 17 Nov 2020 21:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Cq3QabuEzYpm2XyXyix1VEkOKFBIiM8zYtz8XGYhJc=;
        b=ocKPm9AEoPT5sWhohvZbbAuMiKYs3UsQt7XPJM7I6teqfAIVxZkTn9Qsui5y5pjFeZ
         CY7uSuaQOq48RihkTenj1SqhyC0hcXcoOjJNOpoF4cDz+DpTlT0BYjRajoXS5DLx5Gf9
         dlifBVFpUc2k9QzzMFAmmU4NGkIQLl0fP4O6Bn3nbfhcOm7vlVNbxeRiAQepnQ8mZ4+d
         AMPzrQm8ae4n6YJM2q9k0VpMVylgniGdXuEZIFSaih2DDE4EkpdgTc3O1yyK11SrOUKd
         XJ8d7QQ7WVtT7XLvonuI/ZdIO6n8OUBMvAMGR7RNysnyOcu1VeoS51WdEVbc5HurUFtT
         A4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Cq3QabuEzYpm2XyXyix1VEkOKFBIiM8zYtz8XGYhJc=;
        b=Oh5id95IQhaxe1GH90ckyJxzhNzZIHll+3OV0NTS923PTZZ62GrgTAXgF/jvQDGk1B
         ncOycwsL984JtN1s9TTy2M3iJ9Yvb0JjvP6503l/pc30ZhPjyIeq/g4SqOvzzz2WkTZi
         luqTTFBxqUAHCZgPyP3wPuI2xIK2E9oklHM+MyibxIdqb6YEIHJUeiTpfsr+p59KLhR1
         jMbkugTM0f39v2jjtwL7rqduNClnOkF6QvevzLBiIhjC6uAIqEDUN46B4Aj+1wRHYT+D
         +kCI/mONJQafehEZ4F9MES7iexwmhLKTvZyHDZLqXh+ic9H34WzDJH6hlt+GYXIQvSWU
         CVmg==
X-Gm-Message-State: AOAM531CBAhZ55cqEV014B1ZeVLvb3FEIFTT6/P2t/aSwx3+RnSEkGZO
        pC4MBdQse2oWOpE4IBnBBQGErqsNPNIaDKrq7Q==
X-Google-Smtp-Source: ABdhPJxOBfZy76f30nNUPLt1LBwMUMP+CIau8efonpAOtddwQ0DCjNk+P93Kxfj8EjBQZbuDdcudtBe9Nepq+cqxf+k=
X-Received: by 2002:a4a:928a:: with SMTP id i10mr5332895ooh.47.1605675896969;
 Tue, 17 Nov 2020 21:04:56 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-6-danieltimlee@gmail.com> <CAEf4BzZBjVw4ptGZE8V9SM4htW_Nf_TjXkUKEHjF9bxgO43DQA@mail.gmail.com>
 <CAEKGpzisb+6nZ8AQ6nOu6tdPPZzjqAox1AzvYYd5-J3c7N9joQ@mail.gmail.com> <CAEf4BzbOLqX-xXjjbzc_5pDKZzKH+X74oAsXgs_1PtWod=3TAA@mail.gmail.com>
In-Reply-To: <CAEf4BzbOLqX-xXjjbzc_5pDKZzKH+X74oAsXgs_1PtWod=3TAA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 14:04:40 +0900
Message-ID: <CAEKGpzg+VJZ6cPVdE7-2q7+Vz9+nciezuszY3XzDc9=8GMLBKA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] samples: bpf: refactor ibumad program with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:10 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 7:05 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > On Wed, Nov 18, 2020 at 11:52 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > >
> > > > This commit refactors the existing ibumad program with libbpf bpf
> > > > loader. Attach/detach of Tracepoint bpf programs has been managed
> > > > with the generic bpf_program__attach() and bpf_link__destroy() from
> > > > the libbpf.
> > > >
> > > > Also, instead of using the previous BPF MAP definition, this commit
> > > > refactors ibumad MAP definition with the new BTF-defined MAP format.
> > > >
> > > > To verify that this bpf program works without an infiniband device,
> > > > try loading ib_umad kernel module and test the program as follows:
> > > >
> > > >     # modprobe ib_umad
> > > >     # ./ibumad
> > > >
> > > > Moreover, TRACE_HELPERS has been removed from the Makefile since it is
> > > > not used on this program.
> > > >
> > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > ---
> > > >  samples/bpf/Makefile      |  2 +-
> > > >  samples/bpf/ibumad_kern.c | 26 +++++++--------
> > > >  samples/bpf/ibumad_user.c | 66 ++++++++++++++++++++++++++++++---------
> > > >  3 files changed, 65 insertions(+), 29 deletions(-)
> > > >
> > > > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > > > index 36b261c7afc7..bfa595379493 100644
> > > > --- a/samples/bpf/Makefile
> > > > +++ b/samples/bpf/Makefile
> > > > @@ -109,7 +109,7 @@ xsk_fwd-objs := xsk_fwd.o
> > > >  xdp_fwd-objs := xdp_fwd_user.o
> > > >  task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
> > > >  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
> > > > -ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> > > > +ibumad-objs := ibumad_user.o
> > > >  hbm-objs := hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
> > > >
> > > >  # Tell kbuild to always build the programs
> > > > diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
> > > > index 3a91b4c1989a..26dcd4dde946 100644
> > > > --- a/samples/bpf/ibumad_kern.c
> > > > +++ b/samples/bpf/ibumad_kern.c
> > > > @@ -16,19 +16,19 @@
> > > >  #include <bpf/bpf_helpers.h>
> > > >
> > > >
> > > > -struct bpf_map_def SEC("maps") read_count = {
> > > > -       .type        = BPF_MAP_TYPE_ARRAY,
> > > > -       .key_size    = sizeof(u32), /* class; u32 required */
> > > > -       .value_size  = sizeof(u64), /* count of mads read */
> > > > -       .max_entries = 256, /* Room for all Classes */
> > > > -};
> > > > -
> > > > -struct bpf_map_def SEC("maps") write_count = {
> > > > -       .type        = BPF_MAP_TYPE_ARRAY,
> > > > -       .key_size    = sizeof(u32), /* class; u32 required */
> > > > -       .value_size  = sizeof(u64), /* count of mads written */
> > > > -       .max_entries = 256, /* Room for all Classes */
> > > > -};
> > > > +struct {
> > > > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > > > +       __type(key, u32); /* class; u32 required */
> > > > +       __type(value, u64); /* count of mads read */
> > > > +       __uint(max_entries, 256); /* Room for all Classes */
> > > > +} read_count SEC(".maps");
> > > > +
> > > > +struct {
> > > > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > > > +       __type(key, u32); /* class; u32 required */
> > > > +       __type(value, u64); /* count of mads written */
> > > > +       __uint(max_entries, 256); /* Room for all Classes */
> > > > +} write_count SEC(".maps");
> > > >
> > > >  #undef DEBUG
> > > >  #ifndef DEBUG
> > > > diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
> > > > index fa06eef31a84..66a06272f242 100644
> > > > --- a/samples/bpf/ibumad_user.c
> > > > +++ b/samples/bpf/ibumad_user.c
> > > > @@ -23,10 +23,15 @@
> > > >  #include <getopt.h>
> > > >  #include <net/if.h>
> > > >
> > > > -#include "bpf_load.h"
> > > > +#include <bpf/bpf.h>
> > > >  #include "bpf_util.h"
> > > >  #include <bpf/libbpf.h>
> > > >
> > > > +struct bpf_link *tp_links[3] = {};
> > > > +struct bpf_object *obj;
> > >
> > > statics and you can drop = {} part.
> > >
> > > > +static int map_fd[2];
> > > > +static int tp_cnt;
> > > > +
> > > >  static void dump_counts(int fd)
> > > >  {
> > > >         __u32 key;
> > > > @@ -53,6 +58,11 @@ static void dump_all_counts(void)
> > > >  static void dump_exit(int sig)
> > > >  {
> > > >         dump_all_counts();
> > > > +       /* Detach tracepoints */
> > > > +       while (tp_cnt)
> > > > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > > > +
> > > > +       bpf_object__close(obj);
> > > >         exit(0);
> > > >  }
> > > >
> > > > @@ -73,19 +83,11 @@ static void usage(char *cmd)
> > > >
> > > >  int main(int argc, char **argv)
> > > >  {
> > > > +       struct bpf_program *prog;
> > > >         unsigned long delay = 5;
> > > > +       char filename[256];
> > > >         int longindex = 0;
> > > >         int opt;
> > > > -       char bpf_file[256];
> > > > -
> > > > -       /* Create the eBPF kernel code path name.
> > > > -        * This follows the pattern of all of the other bpf samples
> > > > -        */
> > > > -       snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
> > > > -
> > > > -       /* Do one final dump when exiting */
> > > > -       signal(SIGINT, dump_exit);
> > > > -       signal(SIGTERM, dump_exit);
> > > >
> > > >         while ((opt = getopt_long(argc, argv, "hd:rSw",
> > > >                                   long_options, &longindex)) != -1) {
> > > > @@ -107,10 +109,38 @@ int main(int argc, char **argv)
> > > >                 }
> > > >         }
> > > >
> > > > -       if (load_bpf_file(bpf_file)) {
> > > > -               fprintf(stderr, "ERROR: failed to load eBPF from file : %s\n",
> > > > -                       bpf_file);
> > > > -               return 1;
> > > > +       /* Do one final dump when exiting */
> > > > +       signal(SIGINT, dump_exit);
> > > > +       signal(SIGTERM, dump_exit);
> > > > +
> > > > +       snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > > > +       obj = bpf_object__open_file(filename, NULL);
> > > > +       if (libbpf_get_error(obj)) {
> > > > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > > > +               return 0;
> > >
> > > not really a success, no?
> > >
> > > > +       }
> > > > +
> > > > +       /* load BPF program */
> > > > +       if (bpf_object__load(obj)) {
> > > > +               fprintf(stderr, "ERROR: loading BPF object file failed\n");
> > > > +               goto cleanup;
> > > > +       }
> > > > +
> > > > +       map_fd[0] = bpf_object__find_map_fd_by_name(obj, "read_count");
> > > > +       map_fd[1] = bpf_object__find_map_fd_by_name(obj, "write_count");
> > > > +       if (map_fd[0] < 0 || map_fd[1] < 0) {
> > > > +               fprintf(stderr, "ERROR: finding a map in obj file failed\n");
> > > > +               goto cleanup;
> > > > +       }
> > > > +
> > > > +       bpf_object__for_each_program(prog, obj) {
> > > > +               tp_links[tp_cnt] = bpf_program__attach(prog);
> > > > +               if (libbpf_get_error(tp_links[tp_cnt])) {
> > > > +                       fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> > > > +                       tp_links[tp_cnt] = NULL;
> > > > +                       goto cleanup;
> > > > +               }
> > > > +               tp_cnt++;
> > > >         }
> > >
> > > This cries for the BPF skeleton... But one step at a time :)
> > >
> >
> > I will make sure it'll be updated by using skeleton next time. :D
> >
> > > >
> > > >         while (1) {
> > > > @@ -118,5 +148,11 @@ int main(int argc, char **argv)
> > > >                 dump_all_counts();
> > > >         }
> > > >
> > > > +cleanup:
> > > > +       /* Detach tracepoints */
> > > > +       while (tp_cnt)
> > > > +               bpf_link__destroy(tp_links[--tp_cnt]);
> > > > +
> > > > +       bpf_object__close(obj);
> > > >         return 0;
> > >
> > > same, in a lot of cases it's not a success, probably need int err
> > > variable somewhere.
> > >
> >
> > I will correct the return code and send the next version of patch.
> >
> > Thanks for your time and effort for the review.
>
> You don't have to write that every time :) It's an implicit contract:
> you contribute your time to prepare, test, and submit a patch.
> Maintainers and reviewers contribute theirs to review, maybe improve,
> and eventually apply it. Together as a community we move the needle.
>

Thank you for your kindness, and the tip!

-- 
Best,
Daniel T. Lee
