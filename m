Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9B12BB5A5
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgKTTfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbgKTTfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 14:35:03 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4D9C0613CF;
        Fri, 20 Nov 2020 11:35:03 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id 10so9586169ybx.9;
        Fri, 20 Nov 2020 11:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gz1739iBwCHgCBSlGtAiZOrgVZxBWr1CGt1BZBmpYLc=;
        b=RzB+vNPhSCrctwjVn+9T6hR6Yb4xLi2sRuLX5y1dyGHE7S8qBKJTP60ZFndycLLjWR
         cfZ+4EeKHWR71BqEEFTdnENFAxgmfIon80UfZY5zzs1BMIRtrNZnKpjAQZ2jfwAaXwGE
         jIg/wU69lERt1QJmrwiZwBKz+VKPrZ84qCz09yBB4/r1tJ+AQAjppUqBzoTAMzpyXj2f
         3AXR+EkVhJq9cCM41bfk6ku3vfZOHOhskQX7KJSl+jlDlndy8ihR8rfBKvXxJpFZbt1G
         z7JrXTeaCMs8evhudiSzZVJOMGJNsPn91wKBD6buBKCemHjbaww+P/VmG3PVi0jU+YPo
         iuEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gz1739iBwCHgCBSlGtAiZOrgVZxBWr1CGt1BZBmpYLc=;
        b=c64RCKBjyJD2N0j+EMO2CtRNAG5sGkx1ty64uDgxAjh6WGSUZ5NKTbHF40whbg4Y5i
         PKcx8R4zWIkxlrvu63pEoSj179Z5qExblzza2arThZ9dIb9IGEgVhcnXiNU/l0CPK5Zo
         DrZAvA2K1zzPnERDz2HoRyDUFkkNGD/uNb7Z0mkB4+y6d43k0Wj+yPgCAQdpxmB+QGOj
         ckkaKkHULOlZBEcvXaYu2nacp/CtJU0Llc6yCkGoTfJFhubpOAedmvQwMVlrO1UxVFkl
         Oo7lzQrp4a8daSeBbedo078VwyPSecECC3VnKefW+1DcXpACFWj5ewlKR2EsN2eWhUDa
         S2ng==
X-Gm-Message-State: AOAM533oJjhSLh7Cus2abLtgPUT3am4ZUIQIJG2k5Ki0qM0ulxZ+GFPx
        hMV49fYNceJ5unQO4wmQSSRFjQFT6YxZFjNaY8U=
X-Google-Smtp-Source: ABdhPJwkW17RSiw+obd1e5Nm9Hj38vu7NKehRzeU4T+FN+Gb8602HMGA3LC/1ktxDY/miOWB9z+AA91gQ2RHOGaaUf4=
X-Received: by 2002:a25:254a:: with SMTP id l71mr30667864ybl.439.1605900902740;
 Fri, 20 Nov 2020 11:35:02 -0800 (PST)
MIME-Version: 1.0
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-3-weqaar.a.janjua@intel.com> <c73ca08d-4eae-c56f-f5fe-b4dd1440773b@fb.com>
In-Reply-To: <c73ca08d-4eae-c56f-f5fe-b4dd1440773b@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Fri, 20 Nov 2020 19:34:36 +0000
Message-ID: <CAPLEeBaq5yu5Be4dd1KxRxk5JX24PynuA-xreBm9qm-3uMrS0A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] selftests/bpf: xsk selftests - SKB POLL, NOPOLL
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 at 18:54, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> > Adds following tests:
> >
> > 1. AF_XDP SKB mode
> >     Generic mode XDP is driver independent, used when the driver does
> >     not have support for XDP. Works on any netdevice using sockets and
> >     generic XDP path. XDP hook from netif_receive_skb().
> >     a. nopoll - soft-irq processing
> >     b. poll - using poll() syscall
> >
> > Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   5 +-
> >   .../selftests/bpf/test_xsk_prerequisites.sh   |  15 +-
> >   .../selftests/bpf/test_xsk_skb_nopoll.sh      |  20 +
> >   ..._xsk_framework.sh => test_xsk_skb_poll.sh} |  12 +-
> >   tools/testing/selftests/bpf/xdpxceiver.c      | 961 ++++++++++++++++++
> >   tools/testing/selftests/bpf/xdpxceiver.h      | 151 +++
> >   tools/testing/selftests/bpf/xsk_env.sh        |  17 +
> >   7 files changed, 1174 insertions(+), 7 deletions(-)
> >   create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
> >   rename tools/testing/selftests/bpf/{test_xsk_framework.sh => test_xsk_skb_poll.sh} (61%)
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
> >   create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 51436db24f32..17af570a32d7 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -73,7 +73,8 @@ TEST_PROGS := test_kmod.sh \
> >       test_bpftool.sh \
> >       test_bpftool_metadata.sh \
> >       test_xsk_prerequisites.sh \
> > -     test_xsk_framework.sh
> > +     test_xsk_skb_nopoll.sh \
> > +     test_xsk_skb_poll.sh
> >
> >   TEST_PROGS_EXTENDED := with_addr.sh \
> >       with_tunnels.sh \
> > @@ -84,7 +85,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
> >   # Compile but not part of 'make run_tests'
> >   TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
> >       flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
> > -     test_lirc_mode2_user xdping test_cpp runqslower bench
> > +     test_lirc_mode2_user xdping test_cpp runqslower bench xdpxceiver
> >
> >   TEST_CUSTOM_PROGS = urandom_read
> >
> > diff --git a/tools/testing/selftests/bpf/test_xsk_prerequisites.sh b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> > index 00bfcf53127c..a9ce8887dffc 100755
> > --- a/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk_prerequisites.sh
> > @@ -8,8 +8,17 @@
> >   #
> >   # Topology:
> >   # ---------
> > -#      -----------           -----------
> > -#      |  xskX   | --------- |  xskY   |
> > +#                 -----------
> > +#               _ | Process | _
> > +#              /  -----------  \
> > +#             /        |        \
> > +#            /         |         \
> > +#      -----------     |     -----------
> > +#      | Thread1 |     |     | Thread2 |
> > +#      -----------     |     -----------
> > +#           |          |          |
> > +#      -----------     |     -----------
> > +#      |  xskX   |     |     |  xskY   |
> >   #      -----------     |     -----------
> >   #           |          |          |
> >   #      -----------     |     ----------
> > @@ -40,6 +49,8 @@
> >   #       conflict with any existing interface
> >   #   * tests the veth and xsk layers of the topology
> >   #
> > +# See the source xdpxceiver.c for information on each test
> > +#
> >   # Kernel configuration:
> >   # ---------------------
> >   # See "config" file for recommended kernel config options.
> > diff --git a/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh b/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
> > new file mode 100755
> > index 000000000000..96600b0f5136
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_xsk_skb_nopoll.sh
> > @@ -0,0 +1,20 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright(c) 2020 Intel Corporation.
> > +
> > +# See test_xsk_prerequisites.sh for detailed information on tests
> > +
> > +. xsk_prereqs.sh
> > +. xsk_env.sh
> > +
> > +TEST_NAME="SKB NOPOLL"
> > +
> > +vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
> > +
> > +params=("-S")
> > +execxdpxceiver params
> > +
> > +retval=$?
> > +test_status $retval "${TEST_NAME}"
> > +
> > +test_exit $retval 0
> > diff --git a/tools/testing/selftests/bpf/test_xsk_framework.sh b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> > similarity index 61%
> > rename from tools/testing/selftests/bpf/test_xsk_framework.sh
> > rename to tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> > index 2e3f099d001c..d152c8a24251 100755
> > --- a/tools/testing/selftests/bpf/test_xsk_framework.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
> > @@ -7,11 +7,17 @@
> >   . xsk_prereqs.sh
> >   . xsk_env.sh
>
> Here both xsk_prereqs.sh and xsk_env.sh are executed.
> But xsk_env.sh also calls xsk_prereqs.sh. This double
> execution of xsk_prereqs.sh is required or is an
> oversight?
>
Oversight, will fix as v3 - in all 5/5 test_xsk_*.sh, thanks

> >
> > -TEST_NAME="XSK FRAMEWORK"
> > +TEST_NAME="SKB POLL"
> >
> > -test_status $ksft_pass "${TEST_NAME}"
> > +vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
> > +
> > +params=("-S" "-p")
> > +execxdpxceiver params
> > +
> > +retval=$?
> > +test_status $retval "${TEST_NAME}"
> >
> >   # Must be called in the last test to execute
> >   cleanup_exit ${VETH0} ${VETH1} ${NS1}
> >
> > -test_exit $ksft_pass 0
> > +test_exit $retval 0
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> [...]
