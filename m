Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B59E1299AA
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 18:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLWR5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 12:57:31 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39963 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfLWR5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 12:57:31 -0500
Received: by mail-qt1-f194.google.com with SMTP id e6so16022415qtq.7;
        Mon, 23 Dec 2019 09:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8JCaTSq/+02dJY9s7zbnW0TXVGk9/V0OTl8EOqzOV5A=;
        b=bDeSaNdFbIU6nxxlwffN/HsXUWwDaCPSShKHtyQbKKaynIvuhz86JKVxAS/0J9R37i
         vbwhVTFz+F8/mHJKx111vDiS0dZU5W+JwizBscFXY6YVtzLdCLE2XkdRoA4UF4km0m1b
         03AEaegBg1v9EnWEbfVtzLdN3DyPsRXS9NdoHGzZ624HsFuMtLzDqzFpzMlOtZkfN9v9
         2RBWv5TxY+ACBtnjUj2q57F6CMqb+abha30ySm8ZYtfzmq5h3r8vcLCfSWjDgKxevT/G
         Dpj2Cw6CQ4E6IosmokztY48xdszt+mI22lP8GMO9AhNMcFAxsWnC3B0Y0ZupI3lmBA/5
         5ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8JCaTSq/+02dJY9s7zbnW0TXVGk9/V0OTl8EOqzOV5A=;
        b=JxWWlAG2ATsJq4z1wHyp8Zgu6h+PHoX1+GXUS+VWiAa1rLhKitFJYqG8zKvIXdQVXa
         iC+7VLtr4phEA1sxUKjDq6/rq7s/tnVR7m5idXDa8mRAo8ly9VIaa9uYK09/LH7Em1t3
         ImGUJLQF/6PaSujCcb+1b2QCG+FD6XjOYz/nJIycF2ke7hJIxhcXeuorEli4VZXl6fVV
         mcSNaR3lRTQe2p/J8CaK99BFXEIfyx+iBr9rLZO38D2a6q/1Gdf1qswcL+o9mEPuxk9K
         W4bixKtI8nQLLUdFxHCynM3FAaZpA/7rEOfXXUw9aP8bNnNKkYBtBB//6sGtXD6WVul8
         SS8w==
X-Gm-Message-State: APjAAAV2xB6iteGmFB82tLJPw+Dz3uXawHOzbbp1iP8JudIVJumk6VVI
        zlEEOE+HgRxeR8c/H0x9Wzz+aNN5dX95y0BtprQ=
X-Google-Smtp-Source: APXvYqwUpOlxFq+gnM/X4F7GqoC/317UYOkBHGK7ubA8Xj1MbUxhLTlDVfAD7a9vLHJmcXzSH75ljncHL1pBVbmamDg=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr23936471qtj.117.1577123850208;
 Mon, 23 Dec 2019 09:57:30 -0800 (PST)
MIME-Version: 1.0
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
 <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com> <FE4A1C64-70CF-4831-922C-F3992C40E57B@redhat.com>
In-Reply-To: <FE4A1C64-70CF-4831-922C-F3992C40E57B@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 09:57:19 -0800
Message-ID: <CAEf4BzYppnG--OnEo0Ft9+pcvJ6+mY47XzY5F+r+2p3+FeUQcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 4:54 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 20 Dec 2019, at 0:02, Andrii Nakryiko wrote:
>
> > On Thu, Dec 19, 2019 at 3:04 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> Add a test that will attach a FENTRY and FEXIT program to the XDP
> >> test
> >> program. It will also verify data from the XDP context on FENTRY and
> >> verifies the return code on exit.
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95
> >> ++++++++++++++++++++
> >>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
> >>  2 files changed, 139 insertions(+)
> >>  create mode 100644
> >> tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> >>  create mode 100644
> >> tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> >>
> >
> > [...]
>
> Thanks for the review, updated my kernel to the latest bfp-next, but now
> I get the following build issue for the test suite:
>
>     GEN-SKEL [test_progs] loop3.skel.h
>     GEN-SKEL [test_progs] test_skeleton.skel.h
> libbpf: failed to find BTF for extern 'CONFIG_BPF_SYSCALL': -2

This looks like you have Clang without BTF types for extern. Can you
try pull the very latest Clang/LLVM and try again? The latest commit
you should have is e3d8ee35e4ad ("reland "[DebugInfo] Support to emit
debugInfo for extern variables"").

> Error: failed to open BPF object file: 0
> make: *** [Makefile:333:
> /data/linux_kernel/tools/testing/selftests/bpf/test_skeleton.skel.h]
> Error 255
> make: *** Deleting file
> '/data/linux_kernel/tools/testing/selftests/bpf/test_skeleton.skel.h'
>
> Verified, and I still have all the correct config and CLANG version.
> Something else I need to update?
> I have pahole v1.15 in my search path=E2=80=A6
>
> >
> >> +       /* Load XDP program to introspect */
> >> +       err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd)=
;
> >
> > Please use BPF skeleton for this test. It will make it significantly
> > shorter and clearer. See other fentry_fexit selftest for example.
> >
> >> +       if (CHECK_FAIL(err))
> >> +               return;
> >> +
> >
> > [...]
> >
> >> +
> >> +static volatile __u64 test_result_fentry;
> >
> > no need for static volatile anymore, just use global var
> >
> >> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
> >> +           struct xdp_buff *, xdp)
> >> +{
> >> +       test_result_fentry =3D xdp->rxq->dev->ifindex;
> >> +       return 0;
> >> +}
> >> +
> >> +static volatile __u64 test_result_fexit;
> >
> > same here
> >
> >> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
> >> +           struct xdp_buff*, xdp, int, ret)
> >> +{
> >> +       test_result_fexit =3D ret;
> >> +       return 0;
> >> +}
> >>
>
