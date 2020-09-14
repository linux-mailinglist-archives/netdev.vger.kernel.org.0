Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF5826974B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgINVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:01:58 -0400
Received: from mout.gmx.net ([212.227.17.22]:34071 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgINVB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117310;
        bh=yszypaZUXvX/TxTcoMQSFNzVkEURAfjWdIh8sU6g+jY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Q4FqxHBp3XOyoCvU8XSTyKoCOHPB5v4Bvvv6OsRxtad/tig8nPu9G2KMJf5Gp1kam
         pH9QHAjK8S09c3GIUWrohjJGY82K+n23nR1wj2gFTGTKQ7zJqWSLirJbYSRWk+CC74
         Y/DjXFQQuwgZzwdsFDj3BEiJkuJa3l8TYWZMpryM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1Ma24y-1k3a8Y241s-00VzUR; Mon, 14 Sep 2020 23:01:50 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 0/6] 8390: core cleanups
Date:   Mon, 14 Sep 2020 23:01:22 +0200
Message-Id: <20200914210128.7741-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d7WhfWhDE3W/zJvoaUsdUQlYjeKazhspVT8nWQRHwG+T2vPwLfC
 OBMofM4/Yw67zu45ilruHpopMBllk1IJFi+8l4UHHK9JkKfHccHqvw837JlI+DXLqTA7vJH
 PkjrKiYc6K07KXJ4g/MftpQwJkRRnymg8f6G/TPkHLJtXENfGznevkbnQLCZVJvDVxaf9t7
 Tz2TpRDscOCOUNOI4+j8g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0://JCNzdvFfM=:M5AJEU/p4b1y285NcUgY43
 nrsFKfq32IOShl4XbBGEpvZyUJSLyrQnburR/eZ2q0ERcGMW7r5iAyyJxTPnlVzF6PS1ks/nV
 l6ADiQkd2Flf52j0f3wjfNY1xyn2nxWGZuay2hV2Wrz9/l70XCPQbkgDKVZX70SU9+37nqh7M
 9NIjrmQHsAuOtfkaAkXyTf9TDsXHChZadc79JQqZn5vzB6DKjkYuQa6WyMUl2tAuHs6LrN+jv
 3l7QkCje8xSrevyUVvm5sGfFRiIdtShou4CupdxBQ/iy2QenjfUP6VPehK6Hv92RTOfyzHlUM
 sQrs59fyMYh3nMuk1HSq2vw6MXllNg5NxJZ+lN0nnK+FswVANoEP19as6AjDuCtMcGiNiVxUx
 vDwoszVhRslLQzgZv9kt9+h98oVQuv29Rn17kL7rNOPMu1RGQPx64Xv5GDtFWl98rOYuLm3Md
 wp6V05aDL5eT16b3CWG13RGk28PZ0a7WqXBmWMB9/5jUGhWBNjZx7nR1HoNErQ/D9YVoVT3iX
 NeceHa3OT2KUm4G7RgCD9KYAsr3SW4iZP9RjltkenfZNgXVhRt3jzihl4utMfoUVabgrGVtfc
 4vvynPK0FLIEEGOnS3Ka0/B5ZAC7zeYeKsCLIczd1sGUqe4JUHIwy9EnSgXw2yr+8Iy7G7mbJ
 JW2C8RKm5NhS6kNZGGQidcM/XYIkZN3R8h3EzmmyaNsT5QHNES794Dzn2wQXRthIcFu1m4ARX
 4G+6uj0ZXIRkLPeZXJecPWExOfHkSFU7jPiySfzpS6UXkJ18Kg/9qT0eRTQfYPwYifEnxzhHw
 QfqzVfJvcCFkAjA8B9mhEXXoS65h34MRcSnwIdmnjBqpj0dSDT6Xno8h1QPfzBDf4FgQXEQGQ
 s92H831uDnRnoSxw4irgiPK3FtjLoEpOeiIfMjpr/PG2YZCHmLC6Fim2tXQR+NwfCQ1bydtvE
 gDyKC3OtaTD2zc4fLWwQH3V2TK/RlaZ7ph7U0Bo9dW2KQBiNJH2Fn+nvLd4+ZbQUzC4TprABY
 k3QoG2U3iPyC6KoxCrIQ5wL997PF8k6CMvVR4D20TOgvtry3dHsCrxYz7jMTlifBoZqynxPVy
 S/o1c0jGod0VjApIW3PNiLbxYlwZfYXPy7oGqpWR2uvxRRpLHhf0s3YDxda1TbvVFZRtjcZQr
 iA8adh94mFaTQNfGKMF8HIarrwdspA+5qoUDjFcz/B8G/mep6ftC5xzqjGDYJuQ1Vqn5+btTQ
 RshgWit9QQCBhOMCg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this patchset is to do some
cleanups in lib8390.c and 8390.c

While most changes are coding style related,
pr_cont() usage in lib8390.c was replaced by
a more SMP-safe construct.

Other functional changes include the removal of
version-printing in lib8390.c so modules using lib8390.c
do not need a global version-string in order to compile
successfully.

Patches do compile and run flawless on 5.9.0-rc3 with
a RTL8029AS nic using ne2k-pci.

v5 changes:
- sort includes
- do not realign comments
- move pr_cont() -> netdev_err() change to separate patch
- remove unused DRV_RELDATA and DRV_NAME
- break 8390.c changes into separate patches

v4 changes:
- remove unused version string to prevent warnings

v3 changes:
- swap commits to not break buildability (sorry)
- move MODULE_LICENCE at the bottom and remove MODULE_VERSION in 8390.c

v2 changes:
- change "librarys" to "libraries" in 8390.c commit
- improve 8390.c commit
- prevent uneven whitespaces in error message (lib8390.c)
- do not destroy kernel doc comments in lib8390.c
- fix some typos in lib8390.c

Armin Wolf (6):
  lib8390: Fix coding style issues and remove version printing
  lib8390: Replace pr_cont() with SMP-safe construct
  8390: Replace version string with MODULE_* macros
  8390: Include necessary libraries
  8390: Fix coding style issues
  8390: Remove version string

 drivers/net/ethernet/8390/8390.c      |  18 +-
 drivers/net/ethernet/8390/8390p.c     |  15 +-
 drivers/net/ethernet/8390/ax88796.c   |   3 -
 drivers/net/ethernet/8390/etherh.c    |   3 -
 drivers/net/ethernet/8390/hydra.c     |   7 +-
 drivers/net/ethernet/8390/lib8390.c   | 433 ++++++++++++--------------
 drivers/net/ethernet/8390/mac8390.c   |   3 -
 drivers/net/ethernet/8390/mcf8390.c   |   3 -
 drivers/net/ethernet/8390/xsurf100.c  |   3 -
 drivers/net/ethernet/8390/zorro8390.c |   5 +-
 10 files changed, 232 insertions(+), 261 deletions(-)

=2D-
2.20.1

