Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D413429EE5C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgJ2Oep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:34:45 -0400
Received: from mout.gmx.net ([212.227.17.20]:60773 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbgJ2Oeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1603982074;
        bh=IxEIQO2KpuRb79SAK+buUbGUAfS4vXmbpg4PvgzwuiU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=OMUs0CkfG+Oy8JVSGNtXw/9I5W2rWP1GkG4Q8P8JpdWSqjOJOdYVVETlJUvYxW0u9
         r7wwDsmksDBavWSNWAXU7bAg6A7UU1UKISn84rRuYOV/rYvQKdgOR/wa5bl/SpwRlY
         7xNbXF+7nH4tYaadKfJsL4P+Q1flJrOPWcDu/ddw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.162]) by mail.gmx.com
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MqJmF-1k2wuX0Kl1-00nNLb; Thu, 29 Oct 2020 15:34:34 +0100
From:   Armin Wolf <W_Armin@gmx.de>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net-next v3] ne2k: Fix Typo in RW-Bugfix
Date:   Thu, 29 Oct 2020 15:33:57 +0100
Message-Id: <20201029143357.7008-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RKIwab16yJv3G83k3oQQDE3KxNEeem02u/z9qcT413avML9JwTz
 jtgQ1E0Zm/DcC6f9nBGT8BLrlyLsBTc2o3rdtlPKahOs3o1n+6yZGB7FzQFZ1hKEGssF0kI
 DA7LeZ6CX7AeqgJ58OGsU6jJiyTSd6mCaDnyn8ZQHdUcdIHL+M/YuJGFvJFVxtYOF9s2ApD
 INqjBS/vhiA/eNj6D7VGw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y4NZtXy01Zc=:/mdU1qj1PPpYYfXsMZQZN8
 rs1XzqBSc4u7N0AB/+b43LRDAjPJGSvvGAF2Ame8G3tnQ69hxzXhmgz/rfRLyaLZXxVEBOW5V
 R6ZUyHkI9OOPKxL5lsGUJZF+MOHztZcs/31KgHRx8YMuyzvjE2LRJUM73yzSIfxYuQ/3bH1gD
 MkIcAiTlJrmn4eIKGO+vHBHCgeR/wa5OtdG0G+Z8SBHp9Ow+rDtVvly+wUY0g/tcAQcqU9PGo
 xAgcVDR+xePuxaxDtJUnK8QXmV6jE8d35KTgOmSJ1t0SIlS6A16WCUE6cpRvhB5Gi5am8U5Te
 tTKmdSjEkXEmBRdO0ucY+oWoRZiMgEqkTjBC/673OF0lhpIM5TlHOT66yQpidl/4pdSzo7KGR
 04yVipqBkEfL7MV4vznH4xw2LrUPVUarejeMxPJO2K/mF2qcGM9Em+X4VMuCjH8vilKuy96w0
 B00TdCjCMvlfsMcSvNj10yWOevAMo5BEyk1N74WcJ6h7fr8P6IgsfPBvdP+W8cy6tuYrnHTT4
 2aGPfU35PS4G09tGa7qQoG8v1kQfTvD5ylKTxbjd01Fz7qhxX9LYYZ/msumyjyQVJ662NCC+T
 VcwtIFb/mcSqx4vWBim+vcXFS2JuwiEmGMqQgi5syt19SROBXrZ9Lay2T7oh+LWVilHbl6YsT
 UE56jUj49a2sEm0yWYnVrAc9J7QXycPnfjcXRN2ob1uV9iE1ybz662jpp0GFFCiqB9kEhwodp
 sSRk6F2UNH6Hhgkh5lxEKEPjkSGT3wfa1snqRfb5UWNuQRkfFAeaDTsCJmXHQsYWqNSUnFYXI
 h/hzYGlzIy+dKqPtso8jadQ/Ge4Kr3vQBN4u2ZJV2abNYF0hCqaV1+WQCyMu26+YBu3sVCk/U
 PGYDCbstTYPgtYeZ52Gw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct a typo in ne.c and ne2k-pci.c which
prevented activation of the RW-Bugfix.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
v3 changes:
- do not enable the Bugfix by default
- change patch name

The reason for activating the Bugfix by default
was that a RealTek 8029AS nic caused symptoms
described in the original 8390 Datasheet as
beeing caused by the Read/Write-Bug, such as
sudden crashs, when the nic was in use.
But after further investigation, it seems that
the PSU is to blame for those problems, so there
is indeed no reason for activating the Bugfix by
default. Sorry for not noticing this sooner.
Nonetheless the discovered typos should be fixed,
since they prevent correct activation of the Bugfix
in both ne and ne2k-pci (even if noone seems to use
the Bugfix).

v2 changes:
- change NE8390_RW_BUGFIX to NE_RW_BUGFIX
=2D--
 drivers/net/ethernet/8390/ne.c       | 2 +-
 drivers/net/ethernet/8390/ne2k-pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne=
.c
index 1c97e39b478e..e9756d0ea5b8 100644
=2D-- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -710,7 +710,7 @@ static void ne_block_output(struct net_device *dev, in=
t count,
 retry:
 #endif

-#ifdef NE8390_RW_BUGFIX
+#ifdef NE_RW_BUGFIX
 	/* Handle the read-before-write bug the same way as the
 	   Crynwr packet driver -- the NatSemi method doesn't work.
 	   Actually this doesn't always work either, but if you have
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8=
390/ne2k-pci.c
index bc6edb3f1af3..d6715008e04d 100644
=2D-- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -610,7 +610,7 @@ static void ne2k_pci_block_output(struct net_device *d=
ev, int count,
 	/* We should already be in page 0, but to be safe... */
 	outb(E8390_PAGE0+E8390_START+E8390_NODMA, nic_base + NE_CMD);

-#ifdef NE8390_RW_BUGFIX
+#ifdef NE_RW_BUGFIX
 	/* Handle the read-before-write bug the same way as the
 	 * Crynwr packet driver -- the NatSemi method doesn't work.
 	 * Actually this doesn't always work either, but if you have
=2D-
2.20.1

