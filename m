Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096485B21C
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 23:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfF3ViF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 17:38:05 -0400
Received: from ozlabs.org ([203.11.71.1]:50279 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfF3ViE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 17:38:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45cP4T0VwSz9s4V;
        Mon,  1 Jul 2019 07:38:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561930681;
        bh=1oreI+qTYQU398tCXEP8RWS9xin6eHTxpfGLcq+kzCQ=;
        h=Date:From:To:Cc:Subject:From;
        b=W9o3tDey/RXu44YYZhFJHaI3Y3Nf9Aai/zaivrKaeHjDPTmrUds3YmCYZJAOetZOp
         OB/FmEXItvc2dJM22vBnJRYoHYXzSMs1SEkylEsTOSVhMJ91XqLCejGeQRYg5dBlWF
         KIF7TSUfvX6EngNSjTqx1YNXOHJsebxemV6dxcq6K8Jm45Lrqy/JB/SPnHwuagHX4m
         SWI36QxNu3wSn0cJtYBqyg+4fsvOIK0O0a4lhx//qlSgSN5RwagE5w+r+OF0w7/s1w
         1pwJfuzNilcZw4aJEIxZeR2Sbc7YdR24gmfKR7Uib2twORguvFJT/Z6ImC6MKUf1b6
         czVfz+FFXTIiQ==
Date:   Mon, 1 Jul 2019 07:37:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20190701073753.1e14876c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/EW6fwqonz3G=+GK6vG/_twU"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EW6fwqonz3G=+GK6vG/_twU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  18d219b783da ("net: hns3: fix a -Wformat-nonliteral compile warning")

Fixes tag

  Fixes: 46a3df9f9718 ("Add HNS3 Acceleration Engine & Compatibility Layer =
Support")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/EW6fwqonz3G=+GK6vG/_twU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZK7EACgkQAVBC80lX
0Gx+xwgAoOIYqDc5IL4F+pG+vuNRxMxlJzev0iA0y+2sHoUHr2lHgmlhVbj8eivy
YnzOuOIBrI+CozETeq3i03YPcFKpjF+feXAuYFfHUllpHT7S50fcVHPhgIwhQz9l
GUcFZTsp3F/7AfICkhh2Z5fha8MCJr52rPjsPEvHY6W9NKMpH8cAwTXa/bumlTRv
UOr4HqItJbiGhzVT8ihc1jUpDmpDpOeprCqWb4GfAVCJqH9zPQnbi/KnLcZYojc7
uK23Nlehoh6OMNqTmePuQJ8GjddFsqiYbz2/7WvRVVzpUb2UuYfIqX4BRts+C2Zp
ljRyPRUDW4cR8MfKupjBfLuuZmNz6A==
=kmhY
-----END PGP SIGNATURE-----

--Sig_/EW6fwqonz3G=+GK6vG/_twU--
