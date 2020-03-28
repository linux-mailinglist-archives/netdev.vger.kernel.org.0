Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E26B19625F
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgC1ARw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:17:52 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34150 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgC1ARv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:17:51 -0400
Received: by mail-qt1-f194.google.com with SMTP id 10so10207549qtp.1;
        Fri, 27 Mar 2020 17:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rd/kZuwDUbwtE932LuCUfDihCMXQyPB1DkgyzbaO5Yc=;
        b=n2XL+HtH3bcfupmNgd7gkjwsEm/CNr2hug9QzB3oeoH1s2qIP2Nj4z4TO2zzHpXECf
         0sYXi31ON/Wsb3Eb7TF1PK//WoSF9/DGJm1/bA8iHoFZEahP32OI3QVX2k7A3RKETNSf
         OpQZEF23A28A50zCkc6vWzeNzeaW2hC9x4rSBVL545iBbY//PtcZd/z2hZtyb2eWOQPN
         Qh0WhOAn4zxIWz30kMi8UNaio5COQ4f/6LgfK9YeolfgC2VHdWfrmEjcljwllMT2YYct
         X0CJleU+FejLwRt1pjZyObZdy68D0ST4uFy+m9OgJ72xuYQHuU+ScnxHMwT6eRI/Sgw2
         hqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rd/kZuwDUbwtE932LuCUfDihCMXQyPB1DkgyzbaO5Yc=;
        b=hv04SG3OwQnFKXApavE3c+jk0qKFYZ+IYoYdlusrvr/XXrW9uKOXwJ3NcCAsKziUDW
         dAWlfLYKbtpHNBabUlxu5gGIcASNbFYgb+2+AeXTIoYGBVxW2hl9mH/g6VV5ekuGPJmk
         3dHzNlUuquoIcb5hyStEwV9Fpz1bL9tGWyjmmvYwOXXuEYs3jo3OB6v1lt8QWywtybzj
         r5laSJ2jUCG2HhRz3vyv90UzhysJsMT7zbTjdIKU/q7CILzNFFcnLWaJE1T82mcy5+L1
         jRcmotcPByX67yTR6SDna2b7bN/vw5yT3LxCcSD6vfC+zq/cFHT1RbKl6T306D8cWD7G
         NKgQ==
X-Gm-Message-State: ANhLgQ3wYaoeJe5SY5kePRxhMlv5zvhTRqSl10SNk1ANx1C5e9X+0tDm
        BVpIQ1fFxxv5jBnKOoluUYpEtu+d9FVaQScJABI=
X-Google-Smtp-Source: ADFU+vvxfHvWJhtQbLX9VhZBRB8W6yRBV79Ysr/MtfHtnPW89mUVWq1yCpjXDetm4aYmYHHMxtXMGbwzWR3gUTqa00g=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr1849063qtk.93.1585354670512;
 Fri, 27 Mar 2020 17:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com> <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp> <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
In-Reply-To: <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 17:17:38 -0700
Message-ID: <CAEf4BzZZfsW-xw8AtmwA4gSBusrBW8M6D4RLqO3SWV_0DQxW8w@mail.gmail.com>
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:07 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Thu, Mar 26, 2020 at 2:07 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > The second concern was pruning, but iirc the experiments were inconclusive.
> > selftests/bpf only has old fb progs. Hence, I think, the step zero is for
> > everyone to contribute their bpf programs written in C. If we have both
> > cilium and cloudflare progs as selftests it will help a lot to guide such long
> > lasting verifier decisions.
>
> How would you like to handle program changes over time for this?
>
> In Cilium community we periodically rebuild bpf-next VM images for
> testing, and run every pull request against those images[0]. We also
> test against specific older kernels, currently 4.9 and 4.19. This
> allows us to get some sense for the impact of upstream changes while
> developing Cilium features, but unfortunately doesn't allow everyone
> using kernel selftests to get that feedback at least from the kernel
> tree. We also have a verifier complexity test script where we compile
> with the maximum number of features (to ideally generate the most
> complex programs possible) then attempt to load all of the various
> programs, and output the complexity count that the kernel reports[1,2]
> which we can track over time.
>
> However Cilium BPF programs are actively developing and even if we
> merge these programs into the kernel tree, they will get out-of-date
> quickly. Up until recently everything was verifying fine compiling
> with LLVM7 and loading into bpf-next. Over the past month we started
> noticing new issues not with the existing implementation, but in *new*
> BPF features. As we increased complexity, our CI started failing
> against bpf-next[3] while they loaded fine on older kernels. We ended
> up mitigating by upgrading to LLVM-10. Long story short, there's
> several moving parts; changing BPF program implementations, changing
> the compiler toolchain, changing the kernel verifier. So my question
> is basically, where's the line of responsibility for what the kernel
> selftests are responsible for vs integration tests? How do we maintain
> those over time as the BPF programs and compiler changes?

Just wanted to point out that libbpf's Github CI has multi-kernel
testing, so we'll be able to capture regressions on old kernels that
are caused by libbpf and/or nightly clang (we are currently pulling
clang-11 from nightly packages). We are also testing against latest
kernel as well, so if they break, we'll need to fix them. Which is why
I'd like those programs to be manageable in size and complexity and a
simple part of test_progs, not in some Docker container :)

>
> Do we just parachute the ~11K LoC of Cilium datapath into the kernel
> tree once per cycle? Or should Cilium autobuild a verifier-test docker
> image that kernel testing scripts can pull & run? Or would it be
> helpful to have a separate GitHub project similar to libbpf that pulls
> out kernel selftests, Cilium progs, fb progs, cloudflare progs, etc
> automatically and centralizes a generic suite of BPF verifier
> integration tests? Some other option?
>
> [0] https://github.com/cilium/packer-ci-build
> [1] https://github.com/cilium/cilium/blob/master/test/bpf/check-complexity.sh
> [2] https://github.com/cilium/cilium/blob/master/test/bpf/verifier-test.sh
> [3] https://github.com/cilium/cilium/issues/10517
