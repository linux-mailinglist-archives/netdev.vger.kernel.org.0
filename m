Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383442B1241
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgKLW4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:56:40 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54803 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgKLW4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:56:40 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CXH5v1Fwnz9sTK;
        Fri, 13 Nov 2020 09:56:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605221797;
        bh=0pX8nIOtoAq1+7rtL+5P/hevnEzjcuHkAft2GGDIhU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TtZxDNxU3z13HHyrf9s7gIXP64XILbwfku2j6lu9Yz/+0RStgSOOkuE5zLVnLd7//
         osYHC21sPr93DlxYd+KSQxcprkxpUEFDaBW2At2SnyQOrwER4ADZO/u16Z2r+/n4pq
         rDAISKtek7yPOFQHROyBMC1j0YixDhldNvZnRRmpS8CwPjxNo6vC4TLmKeTXD88gJb
         083c7iWAf+hN3/+5QuP6FkPAbAvwS9KKkBo5Jqw3HjbiCq4JrYF5Mu1PEUv6VTFGD6
         025fGiGXUMJgSfWTdAQgQ1Y4gmY4yFz+dyyMQ/LfrX2GE7/v9USxiL52emb+RgtFQ5
         xRovR5gFq//0Q==
Date:   Fri, 13 Nov 2020 09:56:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Roman Gushchin <guro@fb.com>
Cc:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-ID: <20201113095632.489e66e2@canb.auug.org.au>
In-Reply-To: <20201112221543.3621014-2-guro@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
        <20201112221543.3621014-2-guro@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=IuuajhLUc48=qI8wDqPnmd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=IuuajhLUc48=qI8wDqPnmd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Roman,

On Thu, 12 Nov 2020 14:15:10 -0800 Roman Gushchin <guro@fb.com> wrote:
>
> Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
>=20
> Currently a non-slab kernel page which has been charged to a memory cgroup
> can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
> flag is defined as a page type (like buddy, offline, etc), so it takes a
> bit from a page->mapped counter.  Pages with a type set can't be mapped to
> userspace.
>
.....
>=20
> To make sure nobody uses a direct access, struct page's
> mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
>=20
> Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
> Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

What is going on here?  You are taking patches from linux-next and
submitting them to another maintainer?  Why?

You should not do that from Andrew's tree as it changes/rebases every
so often ... and you should not have my SOB on there as it is only
there because that patch is in linux-next i.e. I in the submission
chain to linux-next - if the patch is to go via some other tree, then
my SOB should not be there.  (The same may be true for Andrew's SOB.)
In general you cannot add someone else's SOB to one of your patch
submissions.

--=20
Cheers,
Stephen Rothwell

--Sig_/=IuuajhLUc48=qI8wDqPnmd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+tvaAACgkQAVBC80lX
0GyiWwf+OVKz0JM8eCLNsSIf5uoCARVabzFp0O+8xY8jd7RPiDORD97UcrS0d7TE
XHjO6q1llUGgw7KB+aZCr09pPIIvgF949tWY9yheehC7F/QhJkOFCMRHsxpJ77gT
43aaHmTKSGMmd53qmu0+Ycz3htyhVRHcgYVp5ely2e761NKf6l89A6HsnkGdRn8v
uJ61wv/o3pZeLxeXydX8k+ouOkG2M9zvkSRNYiz/JPb8PnrGqJReWdV5Gxq2nsCP
pzrDBGtFGk+pMMa+t0pu0ml22WaMf7e2WHUmzKAng8DIApAsl/sbSDtpuv80Lpgf
R/rwGpiYVyy1IIXB+CTXEjBOJsKpFg==
=C+xA
-----END PGP SIGNATURE-----

--Sig_/=IuuajhLUc48=qI8wDqPnmd--
