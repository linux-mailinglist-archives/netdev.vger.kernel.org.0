Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAABE11F3
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 08:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbfJWGM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 02:12:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37140 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJWGM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 02:12:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id g50so16522645qtb.4;
        Tue, 22 Oct 2019 23:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hQskDhbKXFRJJrl8Iyiwwev9vkusM5amuQGHYUX5UvI=;
        b=dkuX3JsLhAWaAplPzNHLtRJ2RLDHukZYEuM4P+yuH4xOIf07Z13TcAP7Jhj/t3WW4q
         alK9h3ZKpUpiEKt6w0Xi1U/1zBiCDpGeW8eb3rUE+MIyy92Qycoq6WtuCDFoXyeGOjBk
         KDM7ZOcrK/f3eyqIGykItEmCl4juJnZSh6hNGmyZVroikZftVrnwgQ4LmNYjZGgw6RWN
         cFdCm7tt6ww4CqWCtglAtoXO/4HbXlJN1qXRweshx0tKNHEpQ/cpFnftrkXc+1ta3dQD
         9Zxl5LGJiIX9vo7C3e0Qjm0/VYjwXqjpxO58trjVKT+2zBPsOITlsO7CbAucN645RsPa
         OHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hQskDhbKXFRJJrl8Iyiwwev9vkusM5amuQGHYUX5UvI=;
        b=UdHTzi2Ufb4Je9h2FXm3Z9eJ092pZS+nrNOceu7DoBjkO4wUQVKoM8PM4j4RRbCgpN
         yjMdi8dqnIsymeax5uO2XsgOuDXuixK8NdrFvOHAeKyMZoCi5gSMbvhkR/fLAfV3GMNY
         Gd9V6yDwJK7w0NJHhJnc+JJKXCIF0MqGGrZ8YC4ttHT5I73LkgRySULNmaIGaWq4Old3
         59J5YSqIBKf3nad/B7nUMgmwobXMPzWq2J6YD3I55X5sfIsooSPQz2SPmxqpO6r1NzeY
         kxUH2lIa8eae+QivWssxBi02ZISuPYIw8McUhDUnH8pwEPGlzSv+ojfaw6CBURJtWJVG
         ChHQ==
X-Gm-Message-State: APjAAAWGVpfI69w0SPv34FAJfG9YTmhsWrn9JreMFGeV4iNfF8Wzo2dg
        1bZRgso4mHqcLiR+X7KnBDz4I2DYPg0g5vz7MlM=
X-Google-Smtp-Source: APXvYqx7Ov3L6IRaoLoggQZeAoHYdb3C46rrIzbElP1auVoYyGOXdX05Ekib01sdjrKNJJfMpgdY9nx7U/hx5VxUXok=
X-Received: by 2002:a05:6214:1042:: with SMTP id l2mr7103874qvr.224.1571811146255;
 Tue, 22 Oct 2019 23:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191021033902.3856966-5-andriin@fb.com> <20191023042444.GJ12647@shao2-debian>
In-Reply-To: <20191023042444.GJ12647@shao2-debian>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Oct 2019 23:12:15 -0700
Message-ID: <CAEf4Bza1yefy6W86F3mkpwnVSEYMon6ncVr3FH5WqiHVnLBW_w@mail.gmail.com>
Subject: Re: [libbpf] 651b775f02: kernel_selftests.bpf.test_section_names.fail
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 9:25 PM kernel test robot <rong.a.chen@intel.com> w=
rote:
>
> FYI, we noticed the following commit (built with gcc-7):
>
> commit: 651b775f027f9758740d748cc08c5a0661f13bb7 ("[PATCH bpf-next 4/7] l=
ibbpf: teach bpf_object__open to guess program types")
> url: https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/Auto-guess-=
program-type-on-bpf_object__open/20191021-214022
> base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf-next.git maste=
r
>
> in testcase: kernel_selftests
> with following parameters:
>
>         group: kselftests-00
>
> test-description: The kernel contains a set of "self tests" under the too=
ls/testing/selftests/ directory. These are intended to be small unit tests =
to exercise individual code paths in the kernel.
> test-url: https://www.kernel.org/doc/Documentation/kselftest.txt
>
>
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -=
m 8G
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/=
backtrace):
>
>
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>

Thanks, fixed in https://patchwork.ozlabs.org/patch/1181840/

>
>
> # selftests: bpf: test_section_names
> # libbpf: failed to guess program type based on ELF section name 'InvAliD=
'
> # libbpf: supported section(type) names are: socket kprobe/ uprobe/ kretp=
robe/ uretprobe/ classifier action tracepoint/ tp/ raw_tracepoint/ raw_tp/ =
tp_btf/ xdp perf_event lwt_in lwt_out lwt_xmit lwt_seg6local cgroup_skb/ing=
ress cgroup_skb/egress cgroup/skb cgroup/sock cgroup/post_bind4 cgroup/post=
_bind6 cgroup/dev sockops sk_skb/stream_parser sk_skb/stream_verdict sk_skb=
 sk_msg lirc_mode2 flow_dissector cgroup/bind4 cgroup/bind6 cgroup/connect4=
 cgroup/connect6 cgroup/sendmsg4 cgroup/sendmsg6 cgroup/recvmsg4 cgroup/rec=
vmsg6 cgroup/sysctl cgroup/getsockopt cgroup/setsockopt
> # test_section_names: prog: unexpected rc=3D-3 for InvAliD
> # libbpf: failed to guess program type based on ELF section name 'cgroup'
> # libbpf: supported section(type) names are: socket kprobe/ uprobe/ kretp=
robe/ uretprobe/ classifier action tracepoint/ tp/ raw_tracepoint/ raw_tp/ =
tp_btf/ xdp perf_event lwt_in lwt_out lwt_xmit lwt_seg6local cgroup_skb/ing=
ress cgroup_skb/egress cgroup/skb cgroup/sock cgroup/post_bind4 cgroup/post=
_bind6 cgroup/dev sockops sk_skb/stream_parser sk_skb/stream_verdict sk_skb=
 sk_msg lirc_mode2 flow_dissector cgroup/bind4 cgroup/bind6 cgroup/connect4=
 cgroup/connect6 cgroup/sendmsg4 cgroup/sendmsg6 cgroup/recvmsg4 cgroup/rec=
vmsg6 cgroup/sysctl cgroup/getsockopt cgroup/setsockopt
> # test_section_names: prog: unexpected rc=3D-3 for cgroup
> # Summary: 38 PASSED, 2 FAILED
> not ok 18 selftests: bpf: test_section_names
>
>
> To reproduce:
>
>         # build kernel
>         cd linux
>         cp config-5.4.0-rc1-00593-g651b775f027f9 .config
>         make HOSTCC=3Dgcc-7 CC=3Dgcc-7 ARCH=3Dx86_64 olddefconfig prepare=
 modules_prepare bzImage
>
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in =
this email
>
>
>
> Thanks,
> Rong Chen
>
