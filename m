Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36C235457
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 22:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHAUvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 16:51:12 -0400
Received: from mout.gmx.net ([212.227.17.21]:33979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgHAUvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 16:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596315066;
        bh=B/50ZbX72xCsD3zcoTe9rMt4Om07oHgjN4bs2Ens30Q=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=chU1otzM+2IpQ+iaWpGIzQ8BzQ2J3CKDsk91KovWiHbsMAMVF3YXsGDyit+YQNB41
         PcsV0rW2pvMaYEyOCwMdAAANbxkAujaTsEf/NnRyg2yy47sK8Ab7hDrMwcpqfdylmv
         lSnjAhrgxqHi/4EuNf9fSCi5RZYExMVjBRF0xDbs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([91.0.98.233]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mgeo8-1kgWLV3iSy-00h7tZ; Sat, 01
 Aug 2020 22:51:05 +0200
Date:   Sat, 1 Aug 2020 22:51:04 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 0/2 v2 net-next] 8390: core cleanups
Message-ID: <20200801205104.GA7954@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:4zoKtY8iaBEpUkMCUBtBNZQ/8FVoRgx0Eq4tLY7LfgA20+2V5Zt
 kek7tLSUNx+0kUL32jslgiBKTrsFZETggaHgDMRv2CPLGWrLa9sJbNpHBnwdwrPsFugDODk
 roR91dKLdP4zjGWei5o7GMTYF6Pd5RcppdYxrvsjjyxxwE788gdBjTB35yLwrjTKT14DZTw
 A5aBPTdfmOKCuLowCn68A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:K3LvXJJhqC4=:CqHSglOIyc6oMFHrIEmgAt
 WG9zI7y8arNQkE5VrEK8Wuz3uluxhO5Lbnh8I8AZGxYpVUI0kmRTw4poMU81wnrIDUdd8i+9C
 kx5GmAT58E9VyEbafkxAkQHdePPe+pTsa47g41VBk1ivymV3YH39k2AFOHlbt29Encwo1l0lQ
 pF8jAXiw2SANT1jJBl2plMPKl8hLP1vTlbnnQfzYk4HYokhR1jf+2KyB8U8tlpZkpZRe3XqWW
 bhUN7t1yRu8o6XOOf9wLd9xyHK30rX1nl2Wh7A/NuPexZ0y2Bp6WX3+u4WLxKVcyBLFysZDRs
 C5N7eDgt5G+R+pGUnK35a0RJGBaFvG9jODqn4vI/0Q0qXyonv3UY2E3TZziJ1kZftIy+eSOe4
 mJYAlmnqn1N7H5Dt5YdZfiAb+sukN3rMu+lKYX+A1cW72Sg/EN/8FRSFbDYKPkOSRRjjfLu6h
 WkodpzkNazytIVYycks33pXPvd4QNq9+hyW7MGkd3TdcvkdRys1gpubD+nHzHMxzjLKKswWsb
 i+bYa5CiLxdRqLFWfBH1efeOk6Kz1BGCKfm2dipuIqLCwNtnWU0zQsB+PdzzJ2xtXVRuYcNzH
 BKKPq1HvXS2bjMBGJZ/dC60dwKFg0a4T7TrHA+8PbnZPG6fii5m1kQjkLdwBFTyhgiUtJSnEW
 WhPgNC/vH8rgbf0w0wQfjumjaw9mKlSvfAZ5u6HQGk7WQni08KH8w1lfXRhzeJCvqUHGw+NNU
 zfVk8tjASB+4O1+36Gr0JmgvUtHmTCV3IT2o8BQEiED84ctlB789YL71ZW+zvI8PLhkv6WOZa
 Opmh1zNreki4EcnX1GSpUIQZW+4DlxVmqeqbP2+cnfPu4qQsZGQRfM61AcXvc66DELrpQjRgk
 mm3CmwUC6/ZYd4n2q7m7+qMgVmtdYb87qARipDwzKnLb4lQuZMw5IffHiv6OUR3NIU8rjSfBV
 LNcUNTmPtyEpDlT29HVIEFbQll/M1CZ3lrplveF+aCamx2B4oBuBLypZFNY12WFz+W/+ZQP3q
 L10ykXrsu+/No8/tLzh0v4p5OvljROR7nmn2212iWMK7rgC1LSgXrGbcud5c79xtj/7S1J8Cc
 SqD9P5DiU7JB2h5dn+n8nCjPRBahhmmidpjBo5w5dRLfPkCGf+wo4KPvtsYDNl20h4uKez8b+
 KKXuVpzJ9fwl0koZRxn++HXkeJU2m6R4C4DJj1El358XEKvNKNGp3U98KhGR3qU0Qh8A3FM/v
 kMP3Ut7GyxOxTHWPG
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some
cleanups in lib8390.c and 8390.c.

While most cleanups are coding-style related,
pt_cont() usage was replaced by a more SMP-safe construct.

Other functional changes include the removal of
version-printing in lib8390.c so modules using lib8390.c
do not need a global version-string in order to compile
successfully.

Patches do compile and run flawless on 5.8.0-rc6 with
a RTL8029AS nic using ne2k-pci.

v2 changes:
- change "librarys" to "libraries" in 8390.c commit
- improve 8390.c commit
- prevent uneven whitespaces in error message (lib8390.c)
- do not destroy kernel doc comments in lib8390.c
- fix some typos in lib8390.c

Armin Wolf (2):
  8390: Miscellaneous cleanups
  lib8390: Fix coding-style issues and remove verion printing

 drivers/net/ethernet/8390/8390.c    |  25 +-
 drivers/net/ethernet/8390/lib8390.c | 606 ++++++++++++++--------------
 2 files changed, 321 insertions(+), 310 deletions(-)

=2D-
2.20.1

