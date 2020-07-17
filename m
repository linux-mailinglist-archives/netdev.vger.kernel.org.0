Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E0B2239E5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgGQLBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgGQLBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 07:01:41 -0400
Received: from localhost (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F09820717;
        Fri, 17 Jul 2020 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594983701;
        bh=+J7UJFmB74hYyjfhgJTFmQuUH6HDep+7PP15V9QLMrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1dVarzCM7nm6Jv3fpjeao1lAMHRTYUFKgnmRtAb8+z/VWCM8/h8r2+k9GtC2qfVGy
         SjxdVYKi39sdjvyQ3AxK0QGUX1dpbDiNDOjg1WTKPc6s7G4mpPOW5cYP6hA7dTd4V4
         YlrQM4MdbocJqI9rWkGtqSTAbkfGbmg1CDdtrmNQ=
Date:   Fri, 17 Jul 2020 13:01:36 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717110136.GA1683270@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <20200717120013.0926a74e@toad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20200717120013.0926a74e@toad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> This started showing up with when running ./test_progs from recent
> bpf-next (bfdfa51702de). Any chance it is related?
>=20
> [ 2950.440613] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>=20
> [ 3073.281578] INFO: task cpumap/0/map:26:536 blocked for more than 860 s=
econds.
> [ 3073.285492]       Tainted: G        W         5.8.0-rc4-01471-g15d51f3=
a516b #814
> [ 3073.289177] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [ 3073.293021] cpumap/0/map:26 D    0   536      2 0x00004000
> [ 3073.295755] Call Trace:
> [ 3073.297143]  __schedule+0x5ad/0xf10
> [ 3073.299032]  ? pci_mmcfg_check_reserved+0xd0/0xd0
> [ 3073.301416]  ? static_obj+0x31/0x80
> [ 3073.303277]  ? mark_held_locks+0x24/0x90
> [ 3073.305313]  ? cpu_map_update_elem+0x6d0/0x6d0
> [ 3073.307544]  schedule+0x6f/0x160
> [ 3073.309282]  schedule_preempt_disabled+0x14/0x20
> [ 3073.311593]  kthread+0x175/0x240
> [ 3073.313299]  ? kthread_create_on_node+0xd0/0xd0
> [ 3073.315106]  ret_from_fork+0x1f/0x30
> [ 3073.316365]
>                Showing all locks held in the system:
> [ 3073.318423] 1 lock held by khungtaskd/33:
> [ 3073.319642]  #0: ffffffff82d246a0 (rcu_read_lock){....}-{1:2}, at: deb=
ug_show_all_locks+0x28/0x1c3
>=20
> [ 3073.322249] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

Hi Jakub,

can you please provide more info? can you please identify the test that tri=
gger
the issue? I run test_progs with bpf-next master branch and it works fine f=
or me.
I run the tests in a vm with 4 vcpus and 4G of memory.

Regards,
Lorenzo

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxGFDQAKCRA6cBh0uS2t
rInEAQDe7/pdrv0Ie1lT9olMkBQa+KqFZXlHkNwci7VmzK5gngEApfR+jtvaZRj1
d4Zpbo4nouvJq6nnnShZPuMMVSYwswo=
=0S7x
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
