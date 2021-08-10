Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78113E801D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhHJRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234835AbhHJRnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 018C26108C;
        Tue, 10 Aug 2021 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628617154;
        bh=x9H+NUxjrSY8iTRt4JN3h5bFREXqBinLLp8tASoNvC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTA5Eypuu0CjZPKnUSVtpWszH0KNkx0I13x4VPubdE4G+VwlpbfQ1GZyl1NaIpg7T
         +sKvju1HcjQnf0GvQV3n7TuwKjyJ0Q+ukAclJ3ShBYwX7M4mkrQwIdCaryJZadqNzl
         yIXeJ03nZYtJJTN4X9ZdzQ6xNg0MVvyItSf9VWB7smfmQHg+OHT+aCrktRCWAoTzNl
         IPeVh0Jfta8IPHbZi68/qIKe4JXC60FZ+9IT7XH5bOu/7qznzxJYzHvGVemJPZUGDE
         BPzk9KTxAkJT+XOHZtIy0HzuwO9YPEXsXY+z7mbAgf1gnPadY8D82hOOJHyYe1UT6U
         B3pzq9I3G34fg==
Date:   Tue, 10 Aug 2021 10:39:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, andrii.nakryiko@gmail.com, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2021-08-10
Message-ID: <20210810103913.4f818328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810130038.16927-1-daniel@iogearbox.net>
References: <20210810130038.16927-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 15:00:38 +0200 Daniel Borkmann wrote:
> 1) Native XDP support for bonding driver & related BPF selftests, from Ju=
ssi Maki.
>=20
> 2) Large batch of new BPF JIT tests for test_bpf.ko that came out as a re=
sult from
>    32-bit MIPS JIT development, from Johan Almbladh.
>=20
> 3) Rewrite of netcnt BPF selftest and merge into test_progs, from Stanisl=
av Fomichev.
>=20
> 4) Fix XDP bpf_prog_test_run infra after net to net-next merge, from Andr=
ii Nakryiko.
>=20
> 5) Follow-up fix in unix_bpf_update_proto() to enforce socket type, from =
Cong Wang.
>=20
> 6) Fix bpf-iter-tcp4 selftest to print the correct dest IP, from Jose Bla=
nquicet.
>=20
> 7) Various misc BPF XDP sample improvements, from Niklas S=C3=B6derlund, =
Matthew Cover,
>    and Muhammad Falak R Wani.

Pulled, thanks!
