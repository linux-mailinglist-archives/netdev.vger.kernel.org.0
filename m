Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211E725E988
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 19:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgIERmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 13:42:07 -0400
Received: from mout.gmx.net ([212.227.17.22]:43715 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgIERmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 13:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599327718;
        bh=5ghjbaTfAi5/PrPslnY+wjPoV5WUT3HMxmEISusAJxE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=UW4r6XV+yqqdUw12fTRofqLHO6dU6HAJ7LI1gCzdsiSkhDb/T3raFjKF8XcTQ3R7T
         4pL4R6j7Czn4gumIK1q//F+tQNBUxOXbtcCHGGp1+Bx04NOx+sERmLE9jpGlxfw9Ub
         7QrcjebB5uRhQ3DKMPp97QOWA4qXqZxBNVMz3p/s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.216.33]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MS3mt-1k79G11JLH-00TVpm; Sat, 05
 Sep 2020 19:41:58 +0200
Date:   Sat, 5 Sep 2020 19:41:57 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 0/3 v4 net-next] 8390: core cleanups
Message-ID: <20200905174156.GA5838@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:eLIfHP4sfgzrsM7utgfpOI0b6aQMM1MGtrPN2ws8fXUOhlJf3Vd
 MFUsYL+dL65tAvgt777uaJJi+wEqD9+FWN1q42n7WOAqUUgyFIimlltAXntpkdLvFZkdV3Q
 bd9si3XnDpILPMyfyw9kf7CzuG9aMFdkH/rX8MnWWv6ncp3F5tdMy0sImRRagxfhOR+YfTk
 VYldug0oa1xyygSC966ug==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RXvMvswGXMg=:OxV+tNGpIHJ28XN/2QWdgX
 LRFGE/il2XSlDN831s+nu5e7nwApekVSJD/TKyAy6PFtRpBHKDnrbtZV1/kbIElra3HqiCyZb
 sXfE1yiiCRgRTOns/IrYrI8SnULqj6BjJyvAZ2WueUeVuehRyHE215kzTT5DF0gG4NL71s5G6
 mtegDpJeuikCenNLKbOQLnG2BX1Z7dRYa/9ertAtH9Zler9e3agyprvYKeNDbhbUibCxjyuv4
 7PGVI8A7ps9T0fwZsC0flAsOsfcYYTEshsq0eTHC7rymyCfoYCAlOm9fHW02g48NHuG8/JmZ+
 TDEKALAuQh1TrbZyesIaEfmZ4y00rztfZWFrnrX4nFGNbEG4SwQkCj0ZRNw/hv19rZ9Fxpkf6
 AReKT9Vtzl120wwws+Bv+MNPECdYjhToVPQU0jneW87VQLt1YVJPT1v3n/MzYZwA6awLoiT3w
 DhDZCN8NC3V09LMUiQhLR3aeSX4jno+D80i7wnlNW5gOwrYyK7S0orA6R779Sdn/G3JOIfZ3a
 MOdyCm/MgRY6E3TC23atje9r+2YTrQ90j6DuAcVW+NUDhybUtJWytTMURw8FHLDnoALl5fuQf
 +S59UdJ8+KgVvlewO6FJE4xUFVPzXc8zBfbpCPzCQxWVSErf7X0hdnBXXRPTOqODv/QyE4r96
 0fbvW0L89/tPl8cnXfIYqlodW4fAB0tZ00xknN34CZ6zCS9raBE9ySDPjRbOgoC1hGqgOqDgR
 PQ2Mi8ivi6VFZ/7rSnwDx6nIGaKsJjV+Dx5g5ReZ2XElX16Wvfb8jN/QF5icr+VcHbkyOV1Wy
 NeHJwTm4kC+OY3JzyQxNGTfzLWHguavuSx+nBQ8NaUK92YYAsy/iCZYJfKb46WJheb/VSotbM
 2+OmOUeujlH9gws7rpxJfiiwfejy45B1aL+Cz1/HUlK+15lEonvFKkrwf7BINsGMsuO3AExF1
 xvsCud4g7cRMulI2zaEP3kj07Aezt3lVi5ADoZcvnzn74ltSYrFGZAdQ3lQjE+H1UbdL9W6SW
 kdW3abh7Hlt9qbWAo8WjxZmVZeH9A3ZStpXLT2Npn4/vaJdfEDKqPCj2WvcwdEJ+aETKhWMYV
 2ik3N3IhnMS4ff2w/39V1LC8qF4x0vM/es0seCAUPVel27RRA01M3bzUpCuKpy1+XaF2VZ3LL
 PtEDWs4+CJbVHUYw8ezF+S9VutR4lYSWCidQ4eugE4shk3/14uuM59t+SY897cVhM6Z/wT3Oy
 y+j3HFwyAiRUaKEP2
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some
cleanups in lib8390.c and 8390.c.

While most changes are coding-style related,
pr_cont() usage in lib8390.c was replaced by
a more SMP-safe construct.

Other functional changes include the removal of
version-printing in lib8390.c so modules using lib8390.c
do not need a global version-string in order to compile
successfully.

Patches do compile and run flawless on 5.9.0-rc1 with
a RTL8029AS nic using ne2k-pci.

v4 changes:
- Remove unused version strings to prevent warnings

v3 changes:
- swap commits to not break buildability (sorry)
- move MODULE_LICENCE at the bottom and remove MODULE_VERSION in 8390.c

v2 changes:
- change "librarys" to "libraries" in 8390.c commit
- improve 8390.c commit
- prevent uneven whitespaces in error message (lib8390.c)
- do not destroy kernel doc comments in lib8390.c
- fix some typos in lib8390.c

Armin Wolf (3):
  lib8390: Fix coding-style issues and remove verion printing
  8390: Miscellaneous cleanups
  8390: Remove version string

 drivers/net/ethernet/8390/8390.c      |  21 +-
 drivers/net/ethernet/8390/8390p.c     |  18 +-
 drivers/net/ethernet/8390/ax88796.c   |   3 -
 drivers/net/ethernet/8390/etherh.c    |   3 -
 drivers/net/ethernet/8390/hydra.c     |   8 +-
 drivers/net/ethernet/8390/lib8390.c   | 590 +++++++++++++-------------
 drivers/net/ethernet/8390/mac8390.c   |   3 -
 drivers/net/ethernet/8390/mcf8390.c   |   3 -
 drivers/net/ethernet/8390/xsurf100.c  |   3 -
 drivers/net/ethernet/8390/zorro8390.c |   5 +-
 10 files changed, 332 insertions(+), 325 deletions(-)

=2D-
2.20.1

