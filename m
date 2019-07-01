Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B925C57F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGAWIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:08:37 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36970 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfGAWIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:08:36 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so12360349qkl.4;
        Mon, 01 Jul 2019 15:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fXU/F8/uUMptSiFpWC1OrkKjHnJVaWfZ8i30i4bfdpo=;
        b=feTq7f1/XIGXRzUuW8O3K4rUapfkx303gzYcFV+x0eun3ijd8+iD0Ha302tepWZN65
         LYSiUkfyACBXZDC++BRko3pEFw9JLLnq6uTtFdiEiVRvZaqHFM0qWb795HUGKFbY5rRz
         gbuKjG6W0lzOWRVITr0ix5jk//uW9/fMTNtnSLjvR2OSqbbyBuWxH+jMgkSacYYlsu3T
         xMlj5RB8MyUjl+yYnUQ51v0/i9DjTNn9VHCtcddMxRGlvYLhFQnuFlFXMHT3T43WAUKW
         G4qlfZh8hdNjsGcmUuSB2JgfemiGQTp0I1NeHPpXZvZWlhiNDdxrMunnI4cjdk1TfSp9
         WPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXU/F8/uUMptSiFpWC1OrkKjHnJVaWfZ8i30i4bfdpo=;
        b=WX6BPC2BKZNQ5HrEHoscwrzRyjM/61TEOj1hfqdpfSEqG3Hz4UC6/bmU14w6piNS/7
         Z0M85voZCbtnCRdSKpEOUfxMtmIArLIRqqDG1WK1ygCsPCZA47l0riXzhgbM7Dsuhxwa
         rcD9/JrOxdELQY/1IaFiiptkKAFpzP9+RdbC3H+sXty/cIkHS4npmmYKqxylluV3Fqha
         H7RlOGjiGydYhxsccC3H6Nh7r1NGC6X+EIf02k1TpNWc+bkrljSWbZG5jpJkb+RDFCka
         QjFNuFLTM7WprsF+x4yjsZpwSsRrj/LYVJNhirDSNSm3plFEIutCmYjim+Ho4bN/5yuu
         6z7w==
X-Gm-Message-State: APjAAAWBfJujA2RFe/Seu2T9C8W/X4XHsL3kSnVdzyMOI1jv27TP9MPm
        ji/F/Fz51VEg9UfNWeNMx4n39mGA5nhWhFvVELE7aA0VnQ4=
X-Google-Smtp-Source: APXvYqzplE739zeHz9dPZ7XcXvGhrzgm0GgJJQc7+3g+qyOtdlefvbRwkNN1ynpaDW7JeFENRh3UsgAiGk46lEzCoec=
X-Received: by 2002:a37:a095:: with SMTP id j143mr23620515qke.449.1562018915297;
 Mon, 01 Jul 2019 15:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-5-andriin@fb.com>
 <fbc744f2-74c9-7fca-b9bc-76353b1cf7b5@fb.com>
In-Reply-To: <fbc744f2-74c9-7fca-b9bc-76353b1cf7b5@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jul 2019 15:08:24 -0700
Message-ID: <CAEf4BzbjnMfuJPiHsoiz5+zKbPyCXyg3FcjEZ--CUvYtG99=ow@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 10:09 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/28/19 8:49 PM, Andrii Nakryiko wrote:
> > Add ability to attach to kernel and user probes and retprobes.
> > Implementation depends on perf event support for kprobes/uprobes.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/libbpf.c   | 165 +++++++++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/libbpf.h   |   7 ++
> >   tools/lib/bpf/libbpf.map |   2 +
> >   3 files changed, 174 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 98c155ec3bfa..2f79e9563db9 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4019,6 +4019,171 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
> >       return (struct bpf_link *)link;
> >   }
> >
> > +static int parse_value_from_file(const char *file, const char *fmt)
>
> Here, the value from the file must be positive int values to avoid
> confusion between valid value vs. error code.
> Could you add a comment to state this fact for the current
> uprobe/kprobe/tracepoint support?

You are right. I'll name it parse_uint_from_file to make it more
obvious (though even that is not strictly true, we expect value in the
range of [0, 2^32-1]. I'll leave a comment.

>
> > +{
> > +     char buf[STRERR_BUFSIZE];
> > +     int err, ret;
> > +     FILE *f;
> > +
> > +     f = fopen(file, "r");
> > +     if (!f) {
> > +             err = -errno;
> > +             pr_debug("failed to open '%s': %s\n", file,
> > +                      libbpf_strerror_r(err, buf, sizeof(buf)));
> > +             fclose(f);
>
> fclose(f) is not needed. fopen has failed.

*facepalm*, of course, thanks!

>
> > +             return err;
> > +     }
> > +     err = fscanf(f, fmt, &ret);
> > +     if (err != 1) {
> > +             err = err == EOF ? -EIO : -errno;
> > +             pr_debug("failed to parse '%s': %s\n", file,
> > +                     libbpf_strerror_r(err, buf, sizeof(buf)));
> > +             fclose(f);
> > +             return err;
> > +     }
> > +     fclose(f);
> > +     return ret;
> > +}
> > +
> > +static int determine_kprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/kprobe/type";
> > +
> > +     return parse_value_from_file(file, "%d\n");
> > +}
> > +
> > +static int determine_uprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/uprobe/type";
> > +
> > +     return parse_value_from_file(file, "%d\n");
> > +}
> > +
> > +static int determine_kprobe_retprobe_bit(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> > +
> > +     return parse_value_from_file(file, "config:%d\n");
> > +}
> > +
> > +static int determine_uprobe_retprobe_bit(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> > +
> > +     return parse_value_from_file(file, "config:%d\n");
> > +}
> > +
> > +static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> > +                              uint64_t offset, int pid)
> > +{
> > +     struct perf_event_attr attr = {};
> > +     char errmsg[STRERR_BUFSIZE];
> > +     int type, pfd, err;
> > +
> > +     type = uprobe ? determine_uprobe_perf_type()
> > +                   : determine_kprobe_perf_type();
> > +     if (type < 0) {
> > +             pr_warning("failed to determine %s perf type: %s\n",
> > +                        uprobe ? "uprobe" : "kprobe",
> > +                        libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > +             return type;
> > +     }
> > +     if (retprobe) {
> > +             int bit = uprobe ? determine_uprobe_retprobe_bit()
> > +                              : determine_kprobe_retprobe_bit();
> > +
> > +             if (bit < 0) {
> > +                     pr_warning("failed to determine %s retprobe bit: %s\n",
> > +                                uprobe ? "uprobe" : "kprobe",
> > +                                libbpf_strerror_r(bit, errmsg,
> > +                                                  sizeof(errmsg)));
> > +                     return bit;
> > +             }
> > +             attr.config |= 1 << bit;
> > +     }
> > +     attr.size = sizeof(attr);
> > +     attr.type = type;
> > +     attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> > +     attr.config2 = offset;                 /* kprobe_addr or probe_offset */
> > +
> > +     /* pid filter is meaningful only for uprobes */
> > +     pfd = syscall(__NR_perf_event_open, &attr,
> > +                   pid < 0 ? -1 : pid /* pid */,
> > +                   pid == -1 ? 0 : -1 /* cpu */,
> > +                   -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> > +     if (pfd < 0) {
> > +             err = -errno;
> > +             pr_warning("%s perf_event_open() failed: %s\n",
> > +                        uprobe ? "uprobe" : "kprobe",
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return err;
> > +     }
> > +     return pfd;
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> > +                                         bool retprobe,
> > +                                         const char *func_name)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link *link;
> > +     int pfd, err;
> > +
> > +     pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> > +                                 0 /* offset */, -1 /* pid */);
> > +     if (pfd < 0) {
> > +             pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "kretprobe" : "kprobe", func_name,
> > +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(pfd);
> > +     }
> > +     link = bpf_program__attach_perf_event(prog, pfd);
> > +     if (IS_ERR(link)) {
> > +             close(pfd);
> > +             err = PTR_ERR(link);
> > +             pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "kretprobe" : "kprobe", func_name,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return link;
> > +     }
> > +     return link;
> > +}
> > +
> > +struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
> > +                                         bool retprobe, pid_t pid,
> > +                                         const char *binary_path,
> > +                                         size_t func_offset)
> > +{
> > +     char errmsg[STRERR_BUFSIZE];
> > +     struct bpf_link *link;
> > +     int pfd, err;
> > +
> > +     pfd = perf_event_open_probe(true /* uprobe */, retprobe,
> > +                                 binary_path, func_offset, pid);
> > +     if (pfd < 0) {
> > +             pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "uretprobe" : "uprobe",
> > +                        binary_path, func_offset,
> > +                        libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> > +             return ERR_PTR(pfd);
> > +     }
> > +     link = bpf_program__attach_perf_event(prog, pfd);
> > +     if (IS_ERR(link)) {
> > +             close(pfd);
> > +             err = PTR_ERR(link);
> > +             pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
> > +                        bpf_program__title(prog, false),
> > +                        retprobe ? "uretprobe" : "uprobe",
> > +                        binary_path, func_offset,
> > +                        libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +             return link;
> > +     }
> > +     return link;
> > +}
> > +
> >   enum bpf_perf_event_ret
> >   bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> >                          void **copy_mem, size_t *copy_size,
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 1bf66c4a9330..bd767cc11967 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> >
> >   LIBBPF_API struct bpf_link *
> >   bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> > +                        const char *func_name);
> > +LIBBPF_API struct bpf_link *
> > +bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> > +                        pid_t pid, const char *binary_path,
> > +                        size_t func_offset);
> >
> >   struct bpf_insn;
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 756f5aa802e9..57a40fb60718 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
> >       global:
> >               bpf_link__destroy;
> >               bpf_object__load_xattr;
> > +             bpf_program__attach_kprobe;
> >               bpf_program__attach_perf_event;
> > +             bpf_program__attach_uprobe;
> >               btf_dump__dump_type;
> >               btf_dump__free;
> >               btf_dump__new;
> >
