Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C402CE29D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgLCXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgLCXZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:25:50 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD21C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 15:25:04 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id 4so2050349plk.5
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXx+Lih2scuYckE4hy+8J0ICMfHxNRyw+S8h7E+Hq9U=;
        b=XhbOxZiQF+cRKPHUV71+DqeiRGv8hBcqHje+KfoKbtBDYLtebu5g1xaP4yutFzkonv
         ZSdo1bBpD282Jz7D1cQu3bes8yV8q7IV8Vjfu5p4h+z+moOot5stYTTJvPFWxFj5lFX7
         3fE7OhtZv3OADEBGv/Lo4zD/ubMAhuOS+JZ8KO1aBdLd5sETjRlvqGhEL7Cp6mbuZV/F
         P4yJF8P4fPeVoFOgqzzPo9/i56NNrG3fMELRRzuUe2hO/k4XISwwCXWUJVbV9CEYeuN0
         +g/vapokbAA4qsX5lmmM2ootwWvn86WtcJJA0oGkrw4ugcseLKgXcL3EyJfPT7anBBsv
         hVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXx+Lih2scuYckE4hy+8J0ICMfHxNRyw+S8h7E+Hq9U=;
        b=ftZ/UXoigjbv93OVKgkFdE4nig9VOVvvxPJo3P9NSYPNU2hOWdYvYlauzewT+RWEYa
         kM+R7oqOvKhYVBb6uLvbtw3D31lZopDiRmkiKgW3qxu+Fw5zpfGKUic9Rk8vtQBgRFSV
         41BHIBfaLq1F/PoHZU3qne3cC6NrGBmiT7fcT2G1RjBMuUkfYm5jxwN889dXpBK+UXMr
         3I4/Fg0LhGIMKFfwJZZbDs0YVdx7XddGfwP99e0XnY4ADlQS/P4dOYQAkur4ri0tJOeU
         Crm9kvCJ4XUaFDvFbXHD0NcJnQ2OE9e2CUm2o/qBhwB8dujoyZWLKkDLgmB+mvvSLTaV
         dPpA==
X-Gm-Message-State: AOAM531Uoxi8QG1m8o3JLo2GvqMbzOIddb75CrXhj4cax1ggc2gg+hRy
        xE9lJCpsJLq+HI9NsIkVYgJnSF/ElCrIQkADarBgJQ==
X-Google-Smtp-Source: ABdhPJxf08aE5Y0xDzY/iPzo8ygFVlTNXZa6q4QdEiEbigEyQNLgg6MLkTvyYDWbLkZMTqh1jK0IY8P2VkRlZLCPc2c=
X-Received: by 2002:a17:90b:338d:: with SMTP id ke13mr1365642pjb.48.1607037903949;
 Thu, 03 Dec 2020 15:25:03 -0800 (PST)
MIME-Version: 1.0
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com> <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com> <CAOFY-A07C=TEfob3S3-Dqm8tFTavFfEGqQwbisnNd+yKgDEGFA@mail.gmail.com>
In-Reply-To: <CAOFY-A07C=TEfob3S3-Dqm8tFTavFfEGqQwbisnNd+yKgDEGFA@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 3 Dec 2020 15:24:53 -0800
Message-ID: <CAOFY-A2vTwyA_45oUQR-91CMZya5i1y-4yzDboL+CnKceLzXPw@mail.gmail.com>
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
To:     David Laight <David.Laight@aculab.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 3:19 PM Arjun Roy <arjunroy@google.com> wrote:
>
> On Thu, Dec 3, 2020 at 3:01 PM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Stephen Hemminger
> > > Sent: 03 December 2020 00:15
> > >
> > > On Wed,  2 Dec 2020 14:09:38 -0800
> > > Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> > >
> > > > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > > > index cfcb10b75483..62db78b9c1a0 100644
> > > > --- a/include/uapi/linux/tcp.h
> > > > +++ b/include/uapi/linux/tcp.h
> > > > @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
> > > >     __u32 recv_skip_hint;   /* out: amount of bytes to skip */
> > > >     __u32 inq; /* out: amount of bytes in read queue */
> > > >     __s32 err; /* out: socket error */
> > > > +   __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > > > +   __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
> >
> > You need to swap the order of the above fields to avoid padding
> > and differing alignments for 32bit and 64bit apps.
> >
>
> Just to double check, are you referring to the order of
> copybuf_address and copybuf_len?
> If so, it seems that the current ordering is not creating any
> alignment holes, but flipping it would: https://godbolt.org/z/bdxP6b
>
>
> > > >  };
> > > >  #endif /* _UAPI_LINUX_TCP_H */
> > >
> > > You can't safely grow the size of a userspace API without handling the
> > > case of older applications.  Logic in setsockopt() would have to handle
> > > both old and new sizes of the structure.
> >
> > You also have to allow for old (working) applications being recompiled
> > with the new headers.
> > So you cannot rely on the fields being zero even if you are passed
> > the size of the structure.
> >
>
> I think this should already be taken care of in the current code; the
> full-sized struct with new fields is being zero-initialized, then
> we're getting the user-provided optlen, then copying from userspace
> only that much data. So the newer fields would be zero in that case,
> so this should handle the case of new kernels but old applications.
> Does this address the concern, or am I misunderstanding?
>

Actually, on closer read, perhaps the following is what you have in
mind for the old application?

struct zerocopy_args args;
args.address = ...;
args.length = ...;
args.recv_skip_hint = ...;
args.inq = ...;
args.err = ...;
getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE, &args, sizeof(args));
// sizeof(args) is now bigger when recompiled with new headers, but we
did not explicitly set the new fields to 0, therefore issues

-Arjun

> Thanks,
> -Arjun
>
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
