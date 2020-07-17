Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA39224099
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGQQbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgGQQbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 12:31:16 -0400
Received: from localhost (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99802070E;
        Fri, 17 Jul 2020 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595003476;
        bh=AT6Xk5ZCynJRlQGdg4Sve/N9xjzJoGZ4UuJDVlu1WGE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BF+4sQtu94AnZQ4k5yvgx05UJld1sj7jxBwQmy+bBXczSMhykIqslNqPyjUX+1I5C
         Ih/K9pJwMa1bkLVnpOj4Wi1nI+PQBV1HSfF0GlPXHCRy6JfQxbOHR8sbi1D54mm7gR
         z5oEzRaFGHbtIiZyjWVN2ezzdUG3rN8MQYfvONX0=
Date:   Fri, 17 Jul 2020 18:31:11 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717163111.GA633625@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <20200717120013.0926a74e@toad>
 <20200717110136.GA1683270@localhost.localdomain>
 <20200717171333.3fe979e6@toad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20200717171333.3fe979e6@toad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 17 Jul 2020 13:01:36 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > [...]
> >=20

[...]

> Was able to trigger it running the newly added selftest:
>=20
> virtme-init: console is ttyS0
> bash-5.0# ./test_progs -n 100
> #100/1 cpumap_with_progs:OK
> #100 xdp_cpumap_attach:OK
> Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
> bash-5.0# [  247.177168] INFO: task cpumap/0/map:3:198 blocked for more t=
han 122 seconds.
> [  247.181306]       Not tainted 5.8.0-rc4-01456-gbfdfa51702de #815
> [  247.184487] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disable=
s this message.
> [  247.188876] cpumap/0/map:3  D    0   198      2 0x00004000
> [  247.192624] Call Trace:
> [  247.194327]  __schedule+0x5ad/0xf10
> [  247.196860]  ? pci_mmcfg_check_reserved+0xd0/0xd0
> [  247.199853]  ? static_obj+0x31/0x80
> [  247.201917]  ? mark_held_locks+0x24/0x90
> [  247.204398]  ? cpu_map_update_elem+0x6d0/0x6d0
> [  247.207098]  schedule+0x6f/0x160
> [  247.209079]  schedule_preempt_disabled+0x14/0x20
> [  247.211863]  kthread+0x175/0x240
> [  247.213698]  ? kthread_create_on_node+0xd0/0xd0
> [  247.216054]  ret_from_fork+0x1f/0x30
> [  247.218363]
> [  247.218363] Showing all locks held in the system:
> [  247.222150] 1 lock held by khungtaskd/33:
> [  247.224894]  #0: ffffffff82d246a0 (rcu_read_lock){....}-{1:2}, at: deb=
ug_show_all_locks+0x28/0x1c3
> [  247.231113]
> [  247.232335] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> [  247.232335]
>=20
> qemu running with 4 vCPUs, 4 GB of memory. .config uploaded at
> https://paste.centos.org/view/0c14663d

ack, thx Jakub. I will look at it.

Regards,
Lorenzo

>=20
> HTH,
> -jkbs

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXxHSTQAKCRA6cBh0uS2t
rElGAQCBsIstryMpw+Zf3EHDZ3ZZ7g2AK4hOcazwVoGnts8C7AD/f+FELb2gNU5t
DuRqMPwhVBafnWJhuP7midANJiyUugo=
=P6Ff
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
