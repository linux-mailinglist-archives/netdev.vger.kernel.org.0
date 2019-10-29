Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBEAE8C87
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390237AbfJ2QQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:16:36 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35422 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389902AbfJ2QQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 12:16:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so10486660qtp.2;
        Tue, 29 Oct 2019 09:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TTlfYRCpg135DhMROmOFDqOshy8nA4VrPEygQSyIN0w=;
        b=XieAxBD6jhGtyt2lZ3YvnlrJCgX20KDLHd/479bTJrAgwFXLM6hxGqHnqW3w1eeI96
         wmNtLIUZDojnpf4losxFWYQGV4mm4s213f1lCFPI7a1G4A3sL+k51BfBSPlVwdIYGAR8
         Gv2zWWF2a2jvR/NzkJofNM+Br/4iCH0pMCnfdya5Xr1FRj97V8XBsIuGnXAu/DKi1ncm
         O9GLaonyhAyjz7KkuxjDfU9RuSgcDqPv0F/3x4jz1GkFvfQ7WZwVBh913efdIGb9xzYJ
         gKH41pUXCZPDe7adLW5esUoG7F8EU37ajzIqy/V6sXPd5mNRpUHzkrmxvI12tUvNzJGL
         bcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TTlfYRCpg135DhMROmOFDqOshy8nA4VrPEygQSyIN0w=;
        b=Q8XrY1A/sMNHzN5oeD5rtJRaRbRNRQZWHu1Ilvdvk3oxlzWo3u4f3CN5YFyRX1FPLg
         GAx154rpld6MuxkzUFwyquphwiJ0Fwii79KgwLn9hjmU0fMIL8JBClSZH3fSLdpsq6SL
         JEFdHE+rTbmlhFZ3E4n6OoCO+Id97Xlm6qPU0r+Yy7CnlZ6MiJ+Z7AJ75SjNshY/inPj
         cHoFztQfwQzYZAQfLsPrRkPLov70MIxpkYB8zttopKzaseBku2Co3w4lLED5UNIK/+hG
         d3Y/za72ikzafLGuzjupYo3MTW+RDVQtgowbiCDLPL1f1OC4TMaqqe+2HiAC0/ClhDfw
         ZVGQ==
X-Gm-Message-State: APjAAAW9oPlv1rGIQLN6PQICm7004BLSDo9C4abKON69VH1z5w+n9a9x
        d2hLHsW3sgIed+NGwD+VU9V8247Zn1iuaFoxLWg=
X-Google-Smtp-Source: APXvYqydjzzlGdhmb3jIi3/gDcM5OoqEyPS4ksvg6TngRvujjXZzUivR9OlAeka+nty0E0hU8L4pMJcR7O7lQsWg3cM=
X-Received: by 2002:ac8:6f27:: with SMTP id i7mr5255963qtv.359.1572365795225;
 Tue, 29 Oct 2019 09:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191029154307.23053-1-bjorn.topel@gmail.com> <20191029091210.0a7f0b37@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191029091210.0a7f0b37@cakuba.hsd1.ca.comcast.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 29 Oct 2019 17:16:24 +0100
Message-ID: <CAJ+HfNgENGHSC-BCgOpDiWrNGJD0uSgK-2qeiaOHxbO9JXJySg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: change size to u64 for bpf_map_{area_alloc,charge_init}()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Oct 2019 at 17:12, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 29 Oct 2019 16:43:07 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The functions bpf_map_area_alloc() and bpf_map_charge_init() prior
> > this commit passed the size parameter as size_t. In this commit this
> > is changed to u64.
> >
> > All users of these functions avoid size_t overflows on 32-bit systems,
> > by explicitly using u64 when calculating the allocation size and
> > memory charge cost. However, since the result was narrowed by the
> > size_t when passing size and cost to the functions, the overflow
> > handling was in vain.
> >
> > Instead of changing all call sites to size_t and handle overflow at
> > the call site, the parameter is changed to u64 and checked in the
> > functions above.
> >
> > Fixes: d407bd25a204 ("bpf: don't trigger OOM killer under pressure with=
 map alloc")
> > Fixes: c85d69135a91 ("bpf: move memory size checks to bpf_map_charge_in=
it()")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> Okay, I guess that's the smallest change we can make here.
>
> I'd prefer we went the way of using the standard overflow handling the
> kernel has, rather than proliferating this u64 + U32_MAX comparison
> stuff. But it's hard to argue with the patch length in light of the
> necessary backports..
>

I agree with you, but this is a start, and then maps can gradually
move over to standard overflow handling.

> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
