Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9C65741B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFZWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:05:26 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58371 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfFZWF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 18:05:26 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Yxsv1zbNz9s7h;
        Thu, 27 Jun 2019 08:05:22 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561586723;
        bh=aFVKHRPVPEo0qXPtz+bXPjvSCVM6YK0xpM05+SIg750=;
        h=Date:From:To:Cc:Subject:From;
        b=e0t5w33F8NCtUDVOnNGJQLmxUFMalIfdo5tCmljxiP6eTO1IJ6GcY22Bhr69zTKCb
         cLwJXqj7MU9VQQFSJvRLw3lAs8bXRTwTY69MfESN4Ub3VYhR5EUFLZYkG0pGw4IXDw
         sn5qakBnmd6thQ1sOTIcUna06wAVxxBlUPVnSx5ixf4GknQnU/RLvPjHWLD9q9E71/
         m03/nXoCN0QwzA6Eq5xcnoDD8MSoh61W7vbUdkJXA9kXcU5sSvHXfZC4Ge53riIzJz
         IkL5ujqYYdIDmHK0vqePo1tM16Jx1u5nccnYNs8BI5U1g1gdfEqk3QCGuIEmPAB/W9
         fI1zRpT/yuB7Q==
Date:   Thu, 27 Jun 2019 08:05:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: linux-next: Fixes tag needs some work in the bpf tree
Message-ID: <20190627080521.5df8ccfc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8Ta+s6lmpk2nM8laSgNAE6G"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8Ta+s6lmpk2nM8laSgNAE6G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  12771345a467 ("bpf: fix cgroup bpf release synchronization")

Fixes tag

  Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please don't split Fixes tags across more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/8Ta+s6lmpk2nM8laSgNAE6G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0T7CEACgkQAVBC80lX
0GzJqQf/S4NbQBhkJx7jju0NV9PRQ+Z8h2fHnrZO6MfyJMWkAL9RvcEb04dbS7hb
oCIA32EwuHbyIBqA2iYJ0YaIRf6I9pKLQ/gj40DhJYxUpeelb36zrBhs8TJ2UTRZ
sGnf9V8buF7k9wTa/qWW8lh7zMbdh93dbSy9SEi6/CsxiFHne7Qi0JOXAFvZld17
Pi6b3w5OpIrCmcUPtjQmMUCrmJoxHy+R65XMTV5Fe7MsiKCfYfxCc60ihXgVr2C7
v1QC/UXQd1yanCUIi+oSf7CgCKiIrnbUL7yBLtQp5AwgzqIkr5ouMn1UvnNe7/pC
4cPNUCL4f4/yZe/otn99OkefNr+n5Q==
=ARa9
-----END PGP SIGNATURE-----

--Sig_/8Ta+s6lmpk2nM8laSgNAE6G--
