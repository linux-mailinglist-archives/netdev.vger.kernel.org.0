Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7CC808E5
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 04:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbfHDCOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 22:14:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45037 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHDCOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 22:14:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so35071310plr.11
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 19:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2UDZ3sufJe2El1eObSREvTdAFmClPqPoVDvcheNoK6s=;
        b=mULZg2knYgid/DyRN6LUL1n/n2bO51JGXDy6Zd0etGe41Q4VHCFCugbGPw7eI+UZqa
         CYaI3lBkjzub2Leq4VBWi0Bici2tqEv6hJWnBi98ZHIn77LqOBx34oY6DqGiy7GdiozI
         KKMjc4zODxR1k61/QvwvNWzUex/PCh3BZVDFfZkq1l/eUJIkUHWp/mGb616wNR3r580V
         kedmw1s32A76nKKpbP/sDIDW4oDOajMa6+yvcDmHlQBI4HwQc4Sap4ld8UokJy9Xas1o
         mKQahdwzkgPfuiGh1SleFFVMkiqkqs5GJPHY9d22X1r0gSkw56VYZRY07k69pETplPwx
         WnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2UDZ3sufJe2El1eObSREvTdAFmClPqPoVDvcheNoK6s=;
        b=EetvAexDRPm7q0s9iiHj18Qut8p3zTzwYbk0+iC3nsapjBeLBXMRJQL8UFDlpaALxd
         AvM60AQqa3tVArlbmRQsSxfNNqYHYc4kaje/zDMQSOaa/vt63Zmwp1DQo5WTFT30DzOd
         2pApP3jDmo/SlEa91G0XYbIJjQWbMndfaRsSNJfI3OKBQRtKRsG1Y5gtf94Qw0XNxYbA
         V0D325aS0pdtGyCCmM6IYZSW7BnIk6OPd/0I57kpnWKYzDtTY1u//GYeO2weh/vsyj1K
         rZDt+CDQDW8foYOsWENquZYGmA0sLXpruua1lWK+yYVrwTx2u631Jnf2L3UEDqEh84ZE
         R/tg==
X-Gm-Message-State: APjAAAVaxqcfpIhVyQHhCUgTHy9xcvJuD/GdEuYWbTJu5jJxX1BQnn2N
        JxiU80eM/o62+ZeLqvAtQLsO8Q==
X-Google-Smtp-Source: APXvYqxtMPNARe37wAAVEY/9ebt1EP6WNgIebJDlZsfp1+nvXZmlN9cjXV+5FRhZygsEuC6+MT5XBQ==
X-Received: by 2002:a17:902:42d:: with SMTP id 42mr132038172ple.228.1564884842250;
        Sat, 03 Aug 2019 19:14:02 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id s66sm84164775pfs.8.2019.08.03.19.14.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 03 Aug 2019 19:14:02 -0700 (PDT)
Date:   Sat, 3 Aug 2019 19:13:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP
 on interface
Message-ID: <20190803191341.0a7bb258@cakuba.netronome.com>
In-Reply-To: <CAEKGpzg91CMvq5FnYhAxX7XoA+Sr-+AY3t34q5Q2meG93Ydq9Q@mail.gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
        <20190801081133.13200-2-danieltimlee@gmail.com>
        <20190801163638.71700f6d@cakuba.netronome.com>
        <CAEKGpzhsjMuf+DtN3pDVYMxJa5o2e=-3AeWbHFiFoMoXCkgsNg@mail.gmail.com>
        <20190802113935.63be803a@cakuba.netronome.com>
        <CAEKGpzg91CMvq5FnYhAxX7XoA+Sr-+AY3t34q5Q2meG93Ydq9Q@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 3 Aug 2019 18:39:21 +0900, Daniel T. Lee wrote:
> On Sat, Aug 3, 2019 at 3:39 AM Jakub Kicinski wrote:
> > Right, I was wondering if we want to call it force, though? force is
> > sort of a reuse of iproute2 concept. But it's kind of hard to come up
> > with names.
> >
> > Just to be sure - I mean something like:
> >
> > bpftool net attach xdp id xyz dev ethN noreplace
> >
> > Rather than:
> >
> > bpftool -f net attach xdp id xyz dev ethN
> >  
> 
> How about a word 'immutable'? 'noreplace' seems good though.
> Just suggesting an option.

Hm. Immutable kind of has a meaning in Linux (check out immutable in
extended file attributes, and CAP_LINUX_IMMUTABLE) which is different
than here.. so I'd avoid that one.

Another option I was thinking about was using the same keywords as maps
do: "noexist" - although we don't have a way of doing "exist"
currently, which is kind of breaking the equivalence.

Or maye we should go the same route as iproute2 after all, and set
noreplace by default?  That way we don't need the negation in the 
name. We could use "overwrite", "replace"?

Naming things... :)

> > > > > +}
> > > > > +
> > > > > +static int do_attach(int argc, char **argv)
> > > > > +{
> > > > > +     enum net_attach_type attach_type;
> > > > > +     int err, progfd, ifindex;
> > > > > +
> > > > > +     err = parse_attach_args(argc, argv, &progfd, &attach_type, &ifindex);
> > > > > +     if (err)
> > > > > +             return err;  
> > > >
> > > > Probably not the best idea to move this out into a helper.  
> > >
> > > Again, just trying to make consistent with 'prog.c'.
> > >
> > > But clearly it has differences with do_attach/detach from 'prog.c'.
> > > From it, it uses the same parse logic 'parse_attach_detach_args' since
> > > the two command 'bpftool prog attach/detach' uses the same argument format.
> > >
> > > However, in here, 'bpftool net' attach and detach requires different number of
> > > argument, so function for parse argument has been defined separately.
> > > The situation is little bit different, but keeping argument parse logic as an
> > > helper, I think it's better in terms of consistency.  
> >
> > Well they won't share the same arguments if you add the keyword for
> > controlling IF_NOEXIST :(
> 
> My apologies, but I think I'm not following with you.
> 
> Currently detach/attach isn't sharing same arguments.
> And even after adding the argument for IF_NOEXIST such as  [ noreplace ],
> it'll stays the same for not sharing same arguments.

Ah, my apologies I misread your message.

> I'm not sure why it is not the best idea to move arg parse logic into a helper.

Output args are kind of ugly, and having to pass each parameter through
output arg seems like something that could get out of hand as the
number grows. 

Usually command handling functions are relatively small and
straightforward in bpftool so it's quite nice to have it all in one
simple procedure.

But I'm not feeling too strongly about it. Feel free to leave the
parsing in separate functions if you prefer!
