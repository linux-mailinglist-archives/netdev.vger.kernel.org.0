Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309EF2BC202
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 21:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgKUUPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 15:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728439AbgKUUPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 15:15:20 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3651EC0613CF;
        Sat, 21 Nov 2020 12:15:20 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id t33so12071481ybd.0;
        Sat, 21 Nov 2020 12:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbw2Y23oAuZzwEvVM0pA0thCp3SZyb/YnzSJ41FnCLM=;
        b=J5SvMFJ1YRlnd+pAiPvZG/9oSqVoUmC69dGwJmfFqeIFim4DRvpIk6QcDPHGz9yyqm
         qSPxUv8xkfC6gWuGlM7jwK4NzS839cz24lIgadVB2APJS4+/puoLDUGTnVYScghUqzu0
         0LIO9up3r3XF8CxHNPkUJvQKqnsZ0Gwz5dGGpq6TVLz17UEsD240nSq5ykFx1JdYGtkp
         Pn7BqpbuJKcHhLuwtAB0OE5kMrZNb/mEjp9PlhckbH/vSeu2sxuaNYgHwAAWTRDVI8G4
         C6szmZmxgHXcERQB1dDsq5X2hin9q+hLcGtzT+npJ2ZLD2kMwJvTk2b4Tska505qsEHM
         mVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbw2Y23oAuZzwEvVM0pA0thCp3SZyb/YnzSJ41FnCLM=;
        b=qIiJu33zAWiveTqltQ9mx7MqTBKPTjKDRC/Uq8QoFatGuXvQ2wttUUzpRzWuqqE4yN
         e3VW6UZ1UlnxxseUlWFd/+hegwaibQ3suhd2oILE8/QlDE1a/Mn8mT/da7FemsRaNwOH
         ngjuNxtbxAu7XnOFqPUWTLjGeQzeDBBBHFr4jiLsp9Qy1kcDoJwxSSpuL+Uttk1GGR1x
         VHZsZXRWJY6mVJ5FVXBfGbLgBaQ4r2Laxqgl6bLCfjljISAwkpGXOWloEOVAEipq0bBv
         EYH76uk2EO5RHGCPJ5fDBnvChXMEZjbxMNAdqPpo2AuqDui47U+3QCmZ6xQ0dz+Ng7dM
         0YZQ==
X-Gm-Message-State: AOAM531evKnthR1Sga5izVA3FmAIXs1SgQ2W5WZOVGk3hlfVG39C9xI2
        RIqzw/cYBnBvyQPmgKSZU2aRtCw5tG9e3q5Pxmg=
X-Google-Smtp-Source: ABdhPJzBsk5B8w2UWPoktp6JDdeVbPg3jreUuCgAemoxFbElp24DD8JOmhdwVcYWgz9v/LS55UQoSG2wxvAy01L1yDw=
X-Received: by 2002:a25:493:: with SMTP id 141mr31799448ybe.104.1605989719314;
 Sat, 21 Nov 2020 12:15:19 -0800 (PST)
MIME-Version: 1.0
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-6-weqaar.a.janjua@intel.com> <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
In-Reply-To: <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
Date:   Sat, 21 Nov 2020 20:14:53 +0000
Message-ID: <CAPLEeBY_p_0QsZeqvrr0P+uf1jkL_eFGgawc=KD6Rkuh_177NA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: xsk selftests -
 Bi-directional Sockets - SKB, DRV
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

On Fri, 20 Nov 2020 at 20:45, Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> > Adds following tests:
> >
> > 1. AF_XDP SKB mode
> >     d. Bi-directional Sockets
> >        Configure sockets as bi-directional tx/rx sockets, sets up fill
> >        and completion rings on each socket, tx/rx in both directions.
> >        Only nopoll mode is used
> >
> > 2. AF_XDP DRV/Native mode
> >     d. Bi-directional Sockets
> >     * Only copy mode is supported because veth does not currently support
> >       zero-copy mode
> >
> > Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> > ---
> >   tools/testing/selftests/bpf/Makefile          |   4 +-
> >   .../bpf/test_xsk_drv_bidirectional.sh         |  23 ++++
> >   .../selftests/bpf/test_xsk_drv_teardown.sh    |   3 -
> >   .../bpf/test_xsk_skb_bidirectional.sh         |  20 ++++
> >   tools/testing/selftests/bpf/xdpxceiver.c      | 100 +++++++++++++-----
> >   tools/testing/selftests/bpf/xdpxceiver.h      |   4 +
> >   6 files changed, 126 insertions(+), 28 deletions(-)
> >   create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> >   create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 515b29d321d7..258bd72812e0 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -78,7 +78,9 @@ TEST_PROGS := test_kmod.sh \
> >       test_xsk_drv_nopoll.sh \
> >       test_xsk_drv_poll.sh \
> >       test_xsk_skb_teardown.sh \
> > -     test_xsk_drv_teardown.sh
> > +     test_xsk_drv_teardown.sh \
> > +     test_xsk_skb_bidirectional.sh \
> > +     test_xsk_drv_bidirectional.sh
> >
> >   TEST_PROGS_EXTENDED := with_addr.sh \
> >       with_tunnels.sh \
> > diff --git a/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> > new file mode 100755
> > index 000000000000..d3a7e2934d83
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> > @@ -0,0 +1,23 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright(c) 2020 Intel Corporation.
> > +
> > +# See test_xsk_prerequisites.sh for detailed information on tests
> > +
> > +. xsk_prereqs.sh
> > +. xsk_env.sh
> > +
> > +TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
> > +
> > +vethXDPnative ${VETH0} ${VETH1} ${NS1}
> > +
> > +params=("-N" "-B")
> > +execxdpxceiver params
> > +
> > +retval=$?
> > +test_status $retval "${TEST_NAME}"
> > +
> > +# Must be called in the last test to execute
> > +cleanup_exit ${VETH0} ${VETH1} ${NS1}
>
> This also makes hard to run tests as users will not know this unless
> they are familiar with the details of the tests.
>
> How about you have another scripts test_xsk.sh which includes all these
> individual tests and pull the above cleanup_exit into test_xsk.sh?
> User just need to run test_xsk.sh will be able to run all tests you
> implemented here.
>
This works, test_xsk_* >> test_xsk.sh, will ship out as v3.

> > +
> > +test_exit $retval 0
> > diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
> [...]
