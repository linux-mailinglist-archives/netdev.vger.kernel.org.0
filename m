Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720EEE0953
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388897AbfJVQkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:40:36 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44949 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388775AbfJVQkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:40:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id u22so16829594qkk.11;
        Tue, 22 Oct 2019 09:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hCr4P8fdccYJ7+hmKz+EXE//tI9JMVTOlYBXjmoDwPw=;
        b=mxFJJJWXWrZvt8MFhh5CGm9cs1URIoegnaZ31LSmyXYgeCjNLmG8EdpuqXs4et8yvV
         sQcWVEcJkZ/AR0IULqzM3EKeEhjJn1UmjNldDfNeUIHFzKlHkeCzSoIgvPSFODinMZrJ
         usMP0P2sEx63h55Lw9isWfRAKG/OMWqlnjlaiF5wV8nTa7mBgWClbT9sYEYdQsWSQdc2
         LN4JXxwwQbnZ7pFDErUOs4d0RwZcBcqlAVuS9fv5FIGC2IXVciXoxxzjmRl0/pFooaxJ
         T2Yb7Jn6OUsNGKoT9v8df3gqPZsHV8y98k5sdD5AWJ08frpg2cKM9IQAO+VgIrHJLNr6
         5udw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hCr4P8fdccYJ7+hmKz+EXE//tI9JMVTOlYBXjmoDwPw=;
        b=YK8Vv4W86saY4DYI5gLWICkDmuFtqEniJccCCX5U3i4a5awLCMucAk1NzFLj88MRyD
         7CLNS3ukILPEAjxhsmmVpQjD2S1PpD3rE2D8NynNTztYjNee9P4xQrD39UmLMRAYGrD5
         6/CbFuFyUVnGifGH1pByz75b4bhbwZ522AWi9fNQYtw6bd1Zl/8S+M/RfNbftSpX7NUv
         XCBH4tJiWYBOaPYIgQs926nNTVLlL80J7YoUqUC4SADlYLSBJVWNEckIiVIhOUlSnlp0
         aLiAXigioUzCyNxrfdTdIghaEGYa8RmMXimUNTaA84E7qNSvSsYxSMl/CBuq3210+wvD
         jjVg==
X-Gm-Message-State: APjAAAXUIH/Yd0eUS5iFFBJMzYmSqb/LAxsZ76N7wR06E6bfkF48dNcL
        wBYailg0I/4WtLBGMM7dQRyU+YGNtYMaYlES5nySxzath9Q=
X-Google-Smtp-Source: APXvYqwKFr0f/jiAB9x6EdWI3D/i6V38jDi7K2JAu6mMtnCc9psHmBvg30mafuTVwkI234dD1FrjVdJCx8AbXd8f3mY=
X-Received: by 2002:a37:b447:: with SMTP id d68mr3928437qkf.437.1571762433412;
 Tue, 22 Oct 2019 09:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com> <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
In-Reply-To: <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 09:40:22 -0700
Message-ID: <CAEf4Bza7Sz-Rk=9fD70bKvUY=_BtbTUoyobkHB=pLqQijgVkbA@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:08 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > kprobes programs on older kernels.
> > >
> >
> > My main concern with this is that this code is born bit-rotten,
> > because selftests are never testing the legacy code path. How did you
> > think about testing this and ensuring that this keeps working going
> > forward?
> >
>
> Well we use it, but I see your point and actually I even broke the retprobe
> piece hastily fixing merge conflicts in this patch. When I ran tests on it
> I missed running retprobe tests on the set of kernels that would hit that
> code.
>
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 73 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index fcea6988f962..12b3105d112c 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
> > >         return parse_uint_from_file(file, "config:%d\n");
> > >  }
> > >
> > > +static int use_kprobe_debugfs(const char *name,
> > > +                             uint64_t offset, int pid, bool retprobe)
> > > +{
> > > +       const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> > > +       int fd = open(file, O_WRONLY | O_APPEND, 0);
> > > +       char buf[PATH_MAX];
> > > +       int err;
> > > +
> > > +       if (fd < 0) {
> > > +               pr_warning("failed open kprobe_events: %s\n",
> > > +                          strerror(errno));
> > > +               return -errno;
> >
> > errno after pr_warning() call might be clobbered, you need to save it
> > locally first
>
> Seems so thanks.
>
> >
> > > +       }
> > > +
> > > +       snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
> > > +                retprobe ? 'r' : 'p', name, name);
> >
> > remember result, check it to detect overflow, and use it in write below?
>
> sure seems more robust. If someone has names longer than PATH_MAX though
> it seems a bit much.
>
> >
> > > +
> > > +       err = write(fd, buf, strlen(buf));
> > > +       close(fd);
> > > +       if (err < 0)
> > > +               return -errno;
> > > +       return 0;
> > > +}
> > > +
> > >  static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> > >                                  uint64_t offset, int pid)
> > >  {
> > >         struct perf_event_attr attr = {};
> > >         char errmsg[STRERR_BUFSIZE];
> > > +       uint64_t config1 = 0;
> > >         int type, pfd, err;
> > >
> > >         type = uprobe ? determine_uprobe_perf_type()
> > >                       : determine_kprobe_perf_type();
> > >         if (type < 0) {
> > > -               pr_warning("failed to determine %s perf type: %s\n",
> > > -                          uprobe ? "uprobe" : "kprobe",
> > > -                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > > -               return type;
> > > +               if (uprobe) {
> > > +                       pr_warning("failed to determine uprobe perf type %s: %s\n",
> > > +                                  name,
> > > +                                  libbpf_strerror_r(type,
> > > +                                                    errmsg, sizeof(errmsg)));
> > > +               } else {
> >
> > I think this legacy kprobe setup deserves its own function (maybe even
> > combine it with use_kprobe_debugfs to do entire attribute setup from A
> > to Z?)
> >
> > These 2 levels of nestedness is also unfortunate, how about having two
> > functions that are filling out perf_event_attr? Something like:
> >
> > err = determine_perf_probe_attr(...)
> > if (err)
> >     err = determine_legacy_probe_attr(...)
> > if (!err)
> >     <bail out>
> > do perf call here
> >
>
> Perhaps it makes sense to even uplevel this into the API? Something like
> bpf_program__attach_legacy_kprobe() then we could test it easer?

Having this as a separate API is bad from usability standpoint,
because we force user to either know which kernel versions support new
vs old ways, or have to write a "try this, if fails - try that" logic,
which is ugly. So I think we should hide this from user.

I'm still thinking what's the least intrusive way to cause new way to
fail on modern kernels, so that we can guarantee that legacy code path
is executed. Some way of forcing determine_kprobe_perf_type() to fail
would be easiest.

>
> >
> > > +                       /* If we do not have an event_source/../kprobes then we
> > > +                        * can try to use kprobe-base event tracing, for details
> > > +                        * see ./Documentation/trace/kprobetrace.rst
> > > +                        */
> > > +                       const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
> > > +                       char c[PATH_MAX];
> >
> > what does c stand for?
>
> Can name it file and push the path into snprintf() below.

sounds good

>
> >
> > > +                       int fd, n;
> > > +
> > > +                       snprintf(c, sizeof(c), "%s/%s/id", file, name);
> >
> > check result? also, is there a reason to not use
> > "/sys/kernel/debug/tracing/events/kprobes/" directly in format string?
> >
>
> I believe when I wrote that I just like the it as a const char better.
> But no reason if you like it inline better.
>
> > > +
> > > +                       err = use_kprobe_debugfs(name, offset, pid, retprobe);
> > > +                       if (err)
> > > +                               return err;
> > > +
> > > +                       type = PERF_TYPE_TRACEPOINT;
> > > +                       fd = open(c, O_RDONLY, 0);
> > > +                       if (fd < 0) {
> > > +                               pr_warning("failed to open tracepoint %s: %s\n",
> > > +                                          c, strerror(errno));
> > > +                               return -errno;
> > > +                       }
> > > +                       n = read(fd, c, sizeof(c));
> > > +                       close(fd);
> > > +                       if (n < 0) {
> > > +                               pr_warning("failed to read %s: %s\n",
> > > +                                          c, strerror(errno));
> >
> > It's a bit fishy that you are reading into c and then print out c on
> > error. Its contents might be corrupted at this point.
> >
> > And same thing about errno as above.
>
> Sure just didn't see much point in using yet another buffer. We can
> just make the pr_warning general enough that the buffer isn't needed.

just use parse_uint_from_file(), as long as we don't expect to read
negative numbers, it will do what you want (and that's what we already
use for new-style kprobe/uprobe).

>
> >
> > > +                               return -errno;
> > > +                       }
> > > +                       c[n] = '\0';
> > > +                       config1 = strtol(c, NULL, 0);
> >
> > no need for config1 variable, just attr.config = strtol(...)?
>
> yes, fallout from some code churn. But no reason for it.
>
> >
> > > +                       attr.size = sizeof(attr);
> > > +                       attr.type = type;
> > > +                       attr.config = config1;
> > > +                       attr.sample_period = 1;
> > > +                       attr.wakeup_events = 1;
> > > +               }
> > > +       } else {
> > > +               config1 = ptr_to_u64(name);
> >
> > same, just straight attr.config1 = ... ?
>
> yes.
>
> >
> > > +               attr.size = sizeof(attr);
> > > +               attr.type = type;
> > > +               attr.config1 = config1; /* kprobe_func or uprobe_path */
> > > +               attr.config2 = offset;  /* kprobe_addr or probe_offset */
> > >         }
> > >         if (retprobe) {
> > >                 int bit = uprobe ? determine_uprobe_retprobe_bit()
> > > @@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
> > >                 }
> > >                 attr.config |= 1 << bit;
> > >         }
> > > -       attr.size = sizeof(attr);
> > > -       attr.type = type;
> > > -       attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
> > > -       attr.config2 = offset;           /* kprobe_addr or probe_offset */
> > >
> > >         /* pid filter is meaningful only for uprobes */
> > >         pfd = syscall(__NR_perf_event_open, &attr,
> > >
> >
> > What about the detaching? Would closing perf event FD be enough?
> > Wouldn't we need to clear a probe with -:<event>?
>
> It seems to be enough to close the fd. From an API standpoint might
> make sense to have a detach() though if adding an attach().

we do have detach, it's bpf_link__destroy()

BCC certainly deletes kprobe:
https://github.com/iovisor/bcc/blob/master/src/cc/libbpf.c#L1142

BTW, if we are adding legacy stuff, we should probably also add uprobe
support, no? See BCC for inspiration:
https://github.com/iovisor/bcc/blob/master/src/cc/libbpf.c#L975

One thing that's not clear, and maybe Yonghong can clarify, is why do
we need to enter mount_ns. I vaguely remember this has problems for
multi-threaded applications. This aspect libbpf can't and shouldn't
control, so I wonder if we can avoid mount_ns?..
