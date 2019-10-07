Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1446CEAF0
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfJGRrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:47:32 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33380 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfJGRrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:47:32 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so20513747qtd.0;
        Mon, 07 Oct 2019 10:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9brArzmow4+S+OwMgabAOaG8vYuIy/Dm4KOaavrwI6U=;
        b=UcdJWd0RqmL1QOmxP3viGNDCUcWOcoJFSlVkkd6SeFWNyu/c09ziUkd0PLYin1hpux
         lp3xlvoEOrhKBAUKGdt2szozYPZ4JWhU4wbP05YPn5OMBdIV2L8Bw6zDglLedwFmJjik
         1A4ckaK5EdTfWPuzem2pmqdy33Uxpr9TiLkqbhLRqZGdBcfLPqZx4gZLqcE4yyW4hChd
         LqGXno2EkN+5XDZfILuesYwKxdH7oy/g35wNlwRXKAcP6wpYmnBhnVYOCm0LHVkT2dLP
         KK7EoS20FdPapeW0gDk6p/KqLrUVShtcWXBs/xNJxtEKDnlBA+YL0hnWTKFAttnX+D+K
         Ieag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9brArzmow4+S+OwMgabAOaG8vYuIy/Dm4KOaavrwI6U=;
        b=IpUNOy20Q1z1r3isZDDdRELKypacwi41XEJcXmFDkoK2ms1kl4BD1AJdxkvzFLjUh5
         VMA+//FJc+BczAo+CiFvSNaqwwl24dyq80q9+9qgIgxar6C+tDdXmlHo4QnimgKDoL4t
         5zv1fE9tBeGisUcO0xzlSZRcCQzuQWRDxiW4qzGb9djdprpiYibpgA4Wq+q+qmvWIluj
         6qdyy+Cmk0qbbtn+UXbbAO4kIMZRUiIvFN3eT6Y5nYH24KN8+tuBwfRafEuFG6TUIwwJ
         nmh+UZkKEUzJ5X+vEmOi45si6rir4FgBopvx37mx9hk7xbXNAV/JQ84EmSIz603dpbEh
         r/Ug==
X-Gm-Message-State: APjAAAUJ6hgDyGoFKH7og2AvpDVczXOp2FccTDc9SNpf0VETaPtNZVDp
        Tap7qFMmOdj2zRhGLzzjn/2Xhpp4d6OpHXkKb98=
X-Google-Smtp-Source: APXvYqx0HFGdoWbC5TIi5pACtp17u38tW2uDl6YUL2NdDJ/U4oQM7iFpHNGjq+kdlzryWPkzSnxst+xAudVMHV893qQ=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr30597139qti.59.1570470450780;
 Mon, 07 Oct 2019 10:47:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191007030738.2627420-1-andriin@fb.com> <20191007030738.2627420-2-andriin@fb.com>
 <20191007094346.GC27307@pc-66.home>
In-Reply-To: <20191007094346.GC27307@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 10:47:19 -0700
Message-ID: <CAEf4BzZDKkxtMGwnn+Zam58sYwS33EDuw3hrUTexmC9o7Xnj1w@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/3] uapi/bpf: fix helper docs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 2:43 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Sun, Oct 06, 2019 at 08:07:36PM -0700, Andrii Nakryiko wrote:
> > Various small fixes to BPF helper documentation comments, enabling
> > automatic header generation with a list of BPF helpers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/uapi/linux/bpf.h       | 32 ++++++++++++++++----------------
> >  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++----------------
> >  2 files changed, 32 insertions(+), 32 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 77c6be96d676..a65c3b0c6935 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -794,7 +794,7 @@ union bpf_attr {
> >   *           A 64-bit integer containing the current GID and UID, and
> >   *           created as such: *current_gid* **<< 32 \|** *current_uid*.
>
> Overall, I do like the approach that we keep generating the BPF helpers header
> file from this documentation as it really enforces that the signatures here
> must be 100% correct, and given this also lands in the man page it is /always/
> in sync.
>
> > - * int bpf_get_current_comm(char *buf, u32 size_of_buf)
> > + * int bpf_get_current_comm(void *buf, u32 size_of_buf)
>
> You did not elaborate why this needs to change from char * to void *. What is
> the reason? Those rules should probably be documented somewhere, otherwise
> people might keep adding them.

So here and below for __u8*, compiler is much more strict about
**exact** type of pointer passed by program into helpers. E.g, in one
selftest, we had struct like this

struct s {
    char a[16];
};

struct s = {};
bpf_get_current_comm(&s.a);

and compiler was complaining that program passes char (*)[16] (pointer
to an array) instead of char *. So instead of forcing all the correct
program to do extra casts, I think it's better to stick to void * for
all the "pointer to a chunk of memory" use cases. With void *,
usability is much better.

>
> >   *   Description
> >   *           Copy the **comm** attribute of the current task into *buf* of
> >   *           *size_of_buf*. The **comm** attribute contains the name of
> > @@ -1023,7 +1023,7 @@ union bpf_attr {
> >   *           The realm of the route for the packet associated to *skb*, or 0
> >   *           if none was found.
> >   *
> > - * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
> > + * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
>
> This one here is because we have multiple program types with different input context.

Yes.

>
> >   *   Description
> >   *           Write raw *data* blob into a special BPF perf event held by
> >   *           *map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
> > @@ -1068,7 +1068,7 @@ union bpf_attr {
> >   *   Return
> >   *           0 on success, or a negative error in case of failure.
> >   *
> > - * int bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
> > + * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len)
>
> Changing from struct sk_buff * to void * here, again due to struct sk_reuseport_kern *?

Yep.

>
> I'm wondering whether it would simply be much better to always just use 'void *ctx'
> for everything that is BPF context as it may be just confusing to people why different
> types are chosen sometimes leading to buggy drive-by attempts to 'fix' them back into
> struct sk_buff * et al.

I'm impartial on this issue. In some cases it might be helpful to
specify what is the expected type of the context, if it's only ever
one type, but there are lots of helpers that accept various contexts,
so for consistency its better to just have "void *context".

>
> >   *   Description
> >   *           This helper was provided as an easy way to load data from a
> >   *           packet. It can be used to load *len* bytes from *offset* from
> > @@ -1085,7 +1085,7 @@ union bpf_attr {
> >   *   Return
> >   *           0 on success, or a negative error in case of failure.
> >   *
> > - * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
> > + * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
> >   *   Description
> >   *           Walk a user or a kernel stack and return its id. To achieve
> >   *           this, the helper needs *ctx*, which is a pointer to the context
> > @@ -1154,7 +1154,7 @@ union bpf_attr {
> >   *           The checksum result, or a negative error code in case of
> >   *           failure.
> >   *
> > - * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
> > + * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)
>
> Same here and in more places in this patch, why u8 * -> void * and the like?

See above, making compiler less picky about pointer to a memory buffer.

>
> >   *   Description
> >   *           Retrieve tunnel options metadata for the packet associated to
> >   *           *skb*, and store the raw tunnel option data to the buffer *opt*
> [...]
