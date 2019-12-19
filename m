Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3DD127049
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfLSWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:04:52 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40619 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfLSWEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:04:52 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so2677018pjb.5;
        Thu, 19 Dec 2019 14:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vU/yG9rhO+wLaHPfrGrvYue5a5qDi7/QvRZIZCkUrKc=;
        b=NmROeqkXwSag0ft7FrXfWUzQaYbBLf3RmWRtxmIKAfuXgQzHP3VXyJ02K12DZd1zOa
         BZuflCXV+k1NU/v1oduF1m5lu0nLzY49q0q0fU0PTjcEzj/dif076TqG0nl/vg68ta66
         v8l06fJCnc6xUNMeT7UdGgY1oZ8i5vggHk44SYJUv9tm7MmWC0TZ44E3w5fFBWd+FJA6
         6+wttmlNxu3LiQxp8f6XqKY/lTiB3NrmxiMLYPLXjLcRUHGsZ736cOro3Juogv44CYQO
         8c1vpqiayhyL2I+Q68SrTax94EcF2MtI8nnOUCVp3AZYtmrE8kTiHdPu8WwFZfEhKSsa
         DGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vU/yG9rhO+wLaHPfrGrvYue5a5qDi7/QvRZIZCkUrKc=;
        b=K7HbaltKhwlicHLAdyITAZBouGeQ+riWnewOv/i9s1P6t/GEKjS4oIFCi8rsc5GsN5
         CDKe80mH3lOgAr+3bttHaQhxjUtqd4bbrYTkEeLIg7VGazMTjb3oX8BBzuwagYY0vVal
         6wv4OQRPgcOqKChKrXhwxWUT5UhbFuoAKqUgXGV5N5tzMC+lBM3L4xun1zZrNafJ5phT
         riViFYzWr836Og0S/Ja+vvs6oO9NcjuMH0ONHHZi3zjDR7z1FcQkOO7T/mYqCg/cOHIg
         3RvSsdkX8qmElRiBNlQF2LaqNk7ySm9EGiQxiLethi2rbLRDGTqywT+/+7sw0pcfDq4F
         xyqQ==
X-Gm-Message-State: APjAAAWFiLCax9tY8/8gR8uMUgldmL07J3hNQbfXilE0tQh1MyHzyKdt
        lPVy37tY9FHRG0mZA5I0jZgVW/vy
X-Google-Smtp-Source: APXvYqxg/LNLoQVc+TzC0CzrEJnakddK68JTkSxu0UD6aDE1Q1iZo351/R3mLyUb5e6Wml9Giu4ZDA==
X-Received: by 2002:a17:90a:2729:: with SMTP id o38mr10945891pje.45.1576793091396;
        Thu, 19 Dec 2019 14:04:51 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::b180])
        by smtp.gmail.com with ESMTPSA id m71sm11020865pje.0.2019.12.19.14.04.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 14:04:49 -0800 (PST)
Date:   Thu, 19 Dec 2019 14:04:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf/tools: add runqslower tool to libbpf
Message-ID: <20191219220446.fhtn4i7w5wczuahq@ast-mbp.dhcp.thefacebook.com>
References: <20191219070659.424273-1-andriin@fb.com>
 <20191219070659.424273-3-andriin@fb.com>
 <20191219154137.GB4198@linux-9.fritz.box>
 <CAEf4BzZ8+_GYecvgGUXdOFj4Oca=U3_23PLWBJSAi0A8=gwReg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ8+_GYecvgGUXdOFj4Oca=U3_23PLWBJSAi0A8=gwReg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 01:14:46PM -0800, Andrii Nakryiko wrote:
> On Thu, Dec 19, 2019 at 7:41 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On Wed, Dec 18, 2019 at 11:06:57PM -0800, Andrii Nakryiko wrote:
> > > Convert one of BCC tools (runqslower [0]) to BPF CO-RE + libbpf. It matches
> > > its BCC-based counterpart 1-to-1, supporting all the same parameters and
> > > functionality.
> > >
> > > runqslower tool utilizes BPF skeleton, auto-generated from BPF object file,
> > > as well as memory-mapped interface to global (read-only, in this case) data.
> > > Its makefile also ensures auto-generation of "relocatable" vmlinux.h, which is
> > > necessary for BTF-typed raw tracepoints with direct memory access.
> > >
> > >   [0] https://github.com/iovisor/bcc/blob/11bf5d02c895df9646c117c713082eb192825293/tools/runqslower.py
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/tools/runqslower/.gitignore     |   2 +
> > >  tools/lib/bpf/tools/runqslower/Makefile       |  60 ++++++
> > >  .../lib/bpf/tools/runqslower/runqslower.bpf.c | 101 ++++++++++
> > >  tools/lib/bpf/tools/runqslower/runqslower.c   | 187 ++++++++++++++++++
> > >  tools/lib/bpf/tools/runqslower/runqslower.h   |  13 ++
> >
> > tools/lib/bpf/tools/ is rather weird, please add to tools/bpf/ which is the
> > more appropriate place we have for small tools. Could also live directly in
> > there, e.g. tools/bpf/runqslower.{c,h,bpf.c} and then built/run from selftests,
> > but under libbpf directly is too odd.
> 
> runqslower is as much as a showcase of how to build a stand-alone tool
> with libbpf and CO-RE, as a separate tool, which is why I put it under
> libbpf directory. It's also not really BPF-specific tool, wouldn't
> that make it weird to put it under tools/bpf along the bpftool? If we
> added few more such tools using BPF CO-RE + libbpf, would you feel
> it's still a good idea to put them under tools/bpf?

I agree with Daniel tools/bpf/ seems like better location.

