Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301702D307E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbgLHRD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729585AbgLHRD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 12:03:58 -0500
Date:   Tue, 8 Dec 2020 09:03:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607446998;
        bh=hOxuE1yQii1MZ5uR5LWDKoL24MnmLt2SEUCCB265/ow=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zy2Icuu6Tc/wAPCjg+hlXbwqWtI/np7rvQJKtMOPYjyv4FEfAqW+1AVNsxKCcRl7t
         TW4Ejn07tpvAdxiHNRWpAZCA8IVmpUG1Pf7MwYnoSL1KKIBqTuzZzPOQnQflPxmNyT
         cb+fskkE89kZaYau5mk5U/nJCUyr8D/8v2rN9nkxolTXENRB7dTUwVXN6fZxReOjb0
         yEB5HcrgrNcDF7x5yw4LoxLOEhc2f9KekGiUmWQH3gAwNsf2bDCkK/X9l2WdaZvw9X
         bcEreRZSpa5G+uVEqztFXnQ0zPN80WapmHRiK7z06NTfWp7bxyCzyAqvFA3Csk8nek
         ehgqZ3I8dbXfw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 0/7] selftests/bpf: Restore test_offload.py to
 working order
Message-ID: <20201208090315.5106c049@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <87360gidoo.fsf@toke.dk>
References: <160708272217.192754.14019805999368221369.stgit@toke.dk>
        <87360gidoo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Dec 2020 15:18:31 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>=20
> > This series restores the test_offload.py selftest to working order. It =
seems a
> > number of subtle behavioural changes have crept into various subsystems=
 which
> > broke test_offload.py in a number of ways. Most of these are fairly ben=
ign
> > changes where small adjustments to the test script seems to be the best=
 fix, but
> > one is an actual kernel bug that I've observed in the wild caused by a =
bad
> > interaction between xdp_attachment_flags_ok() and the rework of XDP pro=
gram
> > handling in the core netdev code.
> >
> > Patch 1 fixes the bug by removing xdp_attachment_flags_ok(), and the re=
minder of
> > the patches are adjustments to test_offload.py, including a new feature=
 for
> > netdevsim to force a BPF verification fail. Please see the individual p=
atches
> > for details.
> >
> > Changelog:
> >
> > v2:
> > - Replace xdp_attachment_flags_ok() with a check in dev_xdp_attach()
> > - Better packing of struct nsim_dev =20
>=20
> Any feedback on v2? Would be great to get it merged before the final
> 5.10 release :)

LGTM but if my opinion mattered this could would not have been changed
in the first place :)
