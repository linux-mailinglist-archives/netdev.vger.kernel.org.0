Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF680594
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388200AbfHCJje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 05:39:34 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34847 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388191AbfHCJje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 05:39:34 -0400
Received: by mail-yw1-f66.google.com with SMTP id g19so27408910ywe.2
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 02:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c97+1Qszvuqdx0YffAC3U77mPIb8pL/pcutu6fEhjZ4=;
        b=swJ5giB2jnEgQWVg+vIjF4Fvq0609p2jgs2Sf9wEQmTX9MAjrVzEtED358ObI7E0g1
         urVWt8VPEd49A1RZfEh4ZD4+A0dE3jbYJPZMJBDGs2dlh3oKh3VbK6lKQXgKXCpdY6PF
         +WGqfHQrl6eetRkVrECfAy0PzL/1V2t7DPBUttVjh/XBOyDQcy6KRf4Ck3DviY+h90E9
         N7jJ1ixlOTb6WbsYjGi/Y1+B9IZEgulEB2tIuKPgZN4vBtfsy4NJQZYrxXXdlqNJDOOC
         mxfgE8GDsCBu9XmoPOJ48gGKISsdLX9IPrkpMid/dhibXllgS5s9hsmqx5IYPKQ/BbfD
         Lfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c97+1Qszvuqdx0YffAC3U77mPIb8pL/pcutu6fEhjZ4=;
        b=YdLLp/s3G0+ZBhdaVmT26zDWPFCq0CT/qfExOc52I7/9+k5pmvSXyxFxwvuFJGgPTE
         Y1f/ZWtxZvA8fBHfOBca9IT+v5k5rf1TUKVX8mdhSVqSIzlaksviDAQ2upADxyi6o6g0
         1/qnBMOKH71aK6aGRnz6VIXL4U8sqZXUcjZShBJoFJuy0cyRaObs/lZlHtxWNjFw6lEA
         oJo8H1KHifceXWDZeYYjQwoVcaxCaZpXErc9U5ty9A83Fy88KqMt2n2FH7okQl+uo2oO
         ZOMF4dcOdh7fjcIa7WVnXQYLgAlLjFUHAeeTpkHF4Qz9G1NFIuMhuxiikuga4wgquzzW
         iAqA==
X-Gm-Message-State: APjAAAWtZhkwHB6kRgOEyaecPpKDFgy9cmqv0ik7fIs+bSYPtlyUru8+
        zsbOdekeOrc+JKJfcUpWviV0oNEx+WmTMpAi9A==
X-Google-Smtp-Source: APXvYqyT79fgliNOKOvhv9Q4B3Rb1f3E7QHHvuoo8/PVpZbgVqkYTnsdymaWLCy+eNm/rsSVpXitsvlCSnL7eAt1Vnk=
X-Received: by 2002:a0d:e6c6:: with SMTP id p189mr80773897ywe.69.1564825172955;
 Sat, 03 Aug 2019 02:39:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190801081133.13200-1-danieltimlee@gmail.com>
 <20190801081133.13200-2-danieltimlee@gmail.com> <20190801163638.71700f6d@cakuba.netronome.com>
 <CAEKGpzhsjMuf+DtN3pDVYMxJa5o2e=-3AeWbHFiFoMoXCkgsNg@mail.gmail.com> <20190802113935.63be803a@cakuba.netronome.com>
In-Reply-To: <20190802113935.63be803a@cakuba.netronome.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 3 Aug 2019 18:39:21 +0900
Message-ID: <CAEKGpzg91CMvq5FnYhAxX7XoA+Sr-+AY3t34q5Q2meG93Ydq9Q@mail.gmail.com>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP on interface
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 3, 2019 at 3:39 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 2 Aug 2019 14:02:29 +0900, Daniel T. Lee wrote:
> > On Fri, Aug 2, 2019 at 8:36 AM Jakub Kicinski  wrote:
> > > On Thu,  1 Aug 2019 17:11:32 +0900, Daniel T. Lee wrote:
> > > > By this commit, using `bpftool net attach`, user can attach XDP prog on
> > > > interface. New type of enum 'net_attach_type' has been made, as stated at
> > > > cover-letter, the meaning of 'attach' is, prog will be attached on interface.
> > > >
> > > > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> > > >
> > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > ---
> > > > Changes in v2:
> > > >   - command 'load' changed to 'attach' for the consistency
> > > >   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVER'
> > > >
> > > >  tools/bpf/bpftool/net.c | 107 +++++++++++++++++++++++++++++++++++++++-
> > > >  1 file changed, 106 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > > index 67e99c56bc88..f3b57660b303 100644
> > > > --- a/tools/bpf/bpftool/net.c
> > > > +++ b/tools/bpf/bpftool/net.c
> > > > @@ -55,6 +55,35 @@ struct bpf_attach_info {
> > > >       __u32 flow_dissector_id;
> > > >  };
> > > >
> > > > +enum net_attach_type {
> > > > +     NET_ATTACH_TYPE_XDP,
> > > > +     NET_ATTACH_TYPE_XDP_GENERIC,
> > > > +     NET_ATTACH_TYPE_XDP_DRIVER,
> > > > +     NET_ATTACH_TYPE_XDP_OFFLOAD,
> > > > +     __MAX_NET_ATTACH_TYPE
> > > > +};
> > > > +
> > > > +static const char * const attach_type_strings[] = {
> > > > +     [NET_ATTACH_TYPE_XDP] = "xdp",
> > > > +     [NET_ATTACH_TYPE_XDP_GENERIC] = "xdpgeneric",
> > > > +     [NET_ATTACH_TYPE_XDP_DRIVER] = "xdpdrv",
> > > > +     [NET_ATTACH_TYPE_XDP_OFFLOAD] = "xdpoffload",
> > > > +     [__MAX_NET_ATTACH_TYPE] = NULL,
> > >
> > > Not sure if the terminator is necessary,
> > > ARRAY_SIZE(attach_type_strings) should suffice?
> >
> > Yes, ARRAY_SIZE is fine though. But I was just trying to make below
> > 'parse_attach_type' consistent with 'parse_attach_type' from the 'prog.c'.
> > At 'prog.c', It has same terminator at 'attach_type_strings'.
> >
> > Should I change it or keep it?
>
> Oh well, I guess there is some precedent for that :S
>
> Quick grep for const char * const reveals we have around 7 non-NULL
> terminated arrays, and 2 NULL terminated. Plus the NULL-terminated
> don't align the '=' sign, while most do.
>
> it's not a big deal, my preference is for not NULL terminating here,
> and aligning '='.
>

I think following the majority, is better for this case.

Like you mentioned, those 2 NULL-terminated arrays are at 'cgroup.c'
and 'prog.c'
and the strings they are defining are 'bpf_attach_type' which is from
uapi 'bpf.h'.

And, in my guess, the reason for those 2 arrays uses NULL-terminator
is because enum from 'bpf_attach_type' has '__MAX_BPF_ATTACH_TYPE' at
the end.

Actually I was kind of uncomfortable with adding an enum since it's
not used globally and *only* used in 'net.c' context. Instead of using
hacky enum entry, stick to the majority, ARRAY_SIZE, is better to keep
consistency.

I'll update this to next version with '=' alignment.

>
> > > > +     NEXT_ARG();
> > > > +     if (!REQ_ARGS(1))
> > > > +             return -EINVAL;
> > >
> > > Error message needed here.
> > >
> >
> > Actually it provides error message like:
> > Error: 'xdp' needs at least 1 arguments, 0 found
> >
> > are you suggesting that any additional error message is necessary?
>
> Ah, sorry, I missed REQ_ARGS() there!
>
> > > > +             return -EINVAL;
> > > > +     }
> > >
> > > Please require the dev keyword before the interface name.
> > > That'll make it feel closer to prog load syntax.
> >
> > If adding the dev keyword before interface name, will it be too long to type in?
>
> I think it's probably muscle memory for most. Plus we have excellent
> bash completions.
>
> > and also `bpftool prog` use extra keyword (such as dev) when it is
> > optional keyword.
> >
> >        bpftool prog dump jited  PROG [{ file FILE | opcodes | linum }]
> >        bpftool prog pin   PROG FILE
> >        bpftool prog { load | loadall } OBJ  PATH \
> >
> > as you can see here, FILE uses optional keyword 'file' when the
> > argument is optional.
>
> Not sure I follow
>

command 'dump' has optional argument '[ file FILE ]',
and command 'pin' has required argument with 'FILE'.

I thought the preceding optional keyword 'file' with lower-case is
intended for the optional argument since it isn't preceded when the
argument is required.

> >        bpftool prog { load | loadall } OBJ  PATH \
> >                          [type TYPE] [dev NAME] \
> >                          [map { idx IDX | name NAME } MAP]\
> >                          [pinmaps MAP_DIR]
> >
> > Yes, bpftool prog load has dev keyword with it,
> >
> > but first, like previous, the argument is optional so i think it is
> > unnecessary to use optional keyword 'dev'.
>
> The keyword should not be optional if device name is specified.
> Maybe lack of coffee on my side..
>
> > and secondly, 'bpftool net attach' isn't really related to 'bpftool prog load'.
> >
> > At previous version patch, I was using word 'load' instead of
> > 'attach', since XDP program is not
> > considered as 'BPF_PROG_ATTACH', so it might give a confusion. However
> > by the last patch discussion,
> > word 'load' has been replaced to 'attach'.
> >
> > Keeping the consistency is very important, but I was just wandering
> > about making command
> > similar to 'bpftool prog load' syntax.
>
> In case of TC the device argument is optional. You may specify it, or
> you can refer to TC blocks instead. So for that reason alone I think
> it'll be much cleaner to require dev before the interface name.
>

Previously I didn't really considered TC.

Considering the extensibility, since device argument could be optional,
requiring dev before the interface name seems necessary.

Thank you for letting me know! :)

> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
> > > > +                             int *ifindex)
> > > > +{
> > > > +     __u32 flags;
> > > > +     int err;
> > > > +
> > > > +     flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> > >
> > > Please add this as an option so that user can decide whether overwrite
> > > is allowed or not.
> >
> > Adding force flag to bpftool seems necessary.
> > I will add an optional argument for this.
>
> Right, I was wondering if we want to call it force, though? force is
> sort of a reuse of iproute2 concept. But it's kind of hard to come up
> with names.
>
> Just to be sure - I mean something like:
>
> bpftool net attach xdp id xyz dev ethN noreplace
>
> Rather than:
>
> bpftool -f net attach xdp id xyz dev ethN
>

How about a word 'immutable'? 'noreplace' seems good though.
Just suggesting an option.

> > > > +     if (*attach_type == NET_ATTACH_TYPE_XDP_GENERIC)
> > > > +             flags |= XDP_FLAGS_SKB_MODE;
> > > > +     if (*attach_type == NET_ATTACH_TYPE_XDP_DRIVER)
> > > > +             flags |= XDP_FLAGS_DRV_MODE;
> > > > +     if (*attach_type == NET_ATTACH_TYPE_XDP_OFFLOAD)
> > > > +             flags |= XDP_FLAGS_HW_MODE;
> > > > +
> > > > +     err = bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> > > > +
> > > > +     return err;
> > >
> > > no need for the err variable here.
> >
> > My apologies, but I'm not sure why err variable isn't needed at here.
> > AFAIK, 'bpf_set_link_xdp_fd' from libbpf returns the netlink_recv result,
> > and in order to propagate error, err variable is necessary, I guess?
>
>         return bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
>
> Is what I meant.
>

Oops. I've got it wrong.
I'll update to next patch.

> > > > +}
> > > > +
> > > > +static int do_attach(int argc, char **argv)
> > > > +{
> > > > +     enum net_attach_type attach_type;
> > > > +     int err, progfd, ifindex;
> > > > +
> > > > +     err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> > > > +     if (err)
> > > > +             return err;
> > >
> > > Probably not the best idea to move this out into a helper.
> >
> > Again, just trying to make consistent with 'prog.c'.
> >
> > But clearly it has differences with do_attach/detach from 'prog.c'.
> > From it, it uses the same parse logic 'parse_attach_detach_args' since
> > the two command 'bpftool prog attach/detach' uses the same argument format.
> >
> > However, in here, 'bpftool net' attach and detach requires different number of
> > argument, so function for parse argument has been defined separately.
> > The situation is little bit different, but keeping argument parse logic as an
> > helper, I think it's better in terms of consistency.
>
> Well they won't share the same arguments if you add the keyword for
> controlling IF_NOEXIST :(
>

My apologies, but I think I'm not following with you.

Currently detach/attach isn't sharing same arguments.
And even after adding the argument for IF_NOEXIST such as  [ noreplace ],
it'll stays the same for not sharing same arguments.

I'm not sure why it is not the best idea to move arg parse logic into a helper.

> > About the moving parse logic to a helper, I was trying to keep command
> > entry (do_attach)
> > as simple as possible. Parse all the argument in command entry will
> > make function longer
> > and might make harder to understand what it does.
> >
> > And I'm not pretty sure that argument parse logic will stays the same
> > after other attachment
> > type comes in. What I mean is, the argument count or type might be
> > added and to fulfill
> > all that specific cases, the code might grow larger.
> >
> > So for the consistency, simplicity and extensibility, I prefer to keep
> > it as a helper.
> >
> > > > +     if (is_prefix("xdp", attach_type_strings[attach_type]))
> > > > +             err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
> > >
> > > Hm. We either need an error to be reported if it's not xdp or since we
> > > only accept XDP now perhaps the if() is superfluous?
> >
> > Well, if the attach_type isn't xdp, the error will be occurred from
> > the argument parse,
> > Will it be necessary to reinforce with error logic to make it more secure?
>
> Hm. it should already be fine, no? For non-xdp parse_attach_type() will
> return __MAX_NET_ATTACH_TYPE, then parsing returns EINVAL and we exit.
> Not sure I follow.

Yes. That was what i meant.

Thank you for taking your time for the review.
