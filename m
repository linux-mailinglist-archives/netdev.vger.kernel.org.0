Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A81949BF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCZVHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:07:25 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46615 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbgCZVHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:07:25 -0400
Received: by mail-pf1-f182.google.com with SMTP id q3so3390186pff.13;
        Thu, 26 Mar 2020 14:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+tGik48XZgz8ps2HJplog6RVFfzRdU9r7sWa9GBVpDg=;
        b=j4l9iGAWl3nqBGrMk84KvHRv3q+2xpkJqMedVk4ipxOn6ME/dXl0mtHC07FpgmANWz
         2fSt/5hW28CbLIayGq3OI6wLjG/LTiC0ECNu0rfxfung7pxFoSYUythNgNWBd3MaK406
         5pczX2daQ68tDQojvpoEdcLCys2xP7UTpXujo/4H0KHUmRwMXxV1w6duhaSSMCs8hK12
         hZjApkNv69ebzAmNmPYiCTprNaGStBGWAiK/hsJ8r66n8LldylGI8fMcocJziJCmTE33
         /EXjuw1AjifXh0AUEa6ylC3XdlKDPl+ruhb4c2a5MfmyDjJRM7ocGYQSm5WtXLRHlrwr
         BpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+tGik48XZgz8ps2HJplog6RVFfzRdU9r7sWa9GBVpDg=;
        b=Ve+pI2/N5ZGG5BRVYq/EUtcp3yMO+/zrzUEOBQ6dymfvhPKG5s0RADMieR/n6/84DM
         zkQjBEiBbPfpGgZozhELSyPidGKYE3qi5IXKGf9waLo5zUhawDpYL8tACU/L2yX+hdwm
         t7Ak7O5EduBDsfijAEF6qB3aTrpYXetqSr2/ZhlmMJ4NgSey2Xjc+toTVKuV1TQCa91X
         K/Na/ICtn1eOLmhkMwlIt9q/H0JUzhjdV5sfTyn9Y+MkLJIYOADed05KIQi6j3jiaomp
         u9ijhhFkxFlDfRSIm3HE0Wid35+MuW2j2D6zT+zr2jDwny3fx4xJSWkJmdC7kj6ip5/G
         mXWg==
X-Gm-Message-State: ANhLgQ1wA81NG9M6NEgay4VU9ZgAGQL4XFPBCIztvIQOTkKFPcqBuxb6
        OvhykVg712ZygeYoZgacsZM=
X-Google-Smtp-Source: ADFU+vszgdzg87/wCeTmP9PZeV0FWkM21K+bLx008dar21E2qOzw++aaag44tuS7g19qm+HINZ3FvA==
X-Received: by 2002:a62:1a90:: with SMTP id a138mr11334325pfa.320.1585256843638;
        Thu, 26 Mar 2020 14:07:23 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id p4sm2407112pfg.163.2020.03.26.14.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:07:22 -0700 (PDT)
Date:   Thu, 26 Mar 2020 14:07:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Yonghong Song <yhs@fb.com>, Joe Stringer <joe@wand.net.nz>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Subject: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add
 test for sk_assign
Message-ID: <20200326210719.den5isqxntnoqhmv@ast-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
 <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:13:31AM +0000, Lorenz Bauer wrote:
> > > +
> > > +     if (ipv4) {
> > > +             if (tuple->ipv4.dport != bpf_htons(4321))
> > > +                     return TC_ACT_OK;
> > > +
> > > +             ln.ipv4.daddr = bpf_htonl(0x7f000001);
> > > +             ln.ipv4.dport = bpf_htons(1234);
> > > +
> > > +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
> > > +                                     BPF_F_CURRENT_NETNS, 0);
> > > +     } else {
> > > +             if (tuple->ipv6.dport != bpf_htons(4321))
> > > +                     return TC_ACT_OK;
> > > +
> > > +             /* Upper parts of daddr are already zero. */
> > > +             ln.ipv6.daddr[3] = bpf_htonl(0x1);
> > > +             ln.ipv6.dport = bpf_htons(1234);
> > > +
> > > +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
> > > +                                     BPF_F_CURRENT_NETNS, 0);
> > > +     }
> > > +
> > > +     /* We can't do a single skc_lookup_tcp here, because then the compiler
> > > +      * will likely spill tuple_len to the stack. This makes it lose all
> > > +      * bounds information in the verifier, which then rejects the call as
> > > +      * unsafe.
> > > +      */
> >
> > This is a known issue. For scalars, only constant is restored properly
> > in verifier at this moment. I did some hacking before to enable any
> > scalars. The fear is this will make pruning performs worse. More
> > study is needed here.
> 
> Of topic, but: this is actually one of the most challenging issues for
> us when writing
> BPF. It forces us to have very deep call graphs to hopefully avoid clang
> spilling the constants. Please let me know if I can help in any way.

Thanks for bringing this up.
Yonghong, please correct me if I'm wrong.
I think you've experimented with tracking spilled constants. The first issue
came with spilling of 4 byte constant. The verifier tracks 8 byte slots and
lots of places assume that slot granularity. It's not clear yet how to refactor
the verifier. Ideas, help are greatly appreciated.
The second concern was pruning, but iirc the experiments were inconclusive.
selftests/bpf only has old fb progs. Hence, I think, the step zero is for
everyone to contribute their bpf programs written in C. If we have both
cilium and cloudflare progs as selftests it will help a lot to guide such long
lasting verifier decisions.
