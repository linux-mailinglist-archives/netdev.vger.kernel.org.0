Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337F322E04
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 10:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfETIKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 04:10:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38730 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727626AbfETIKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 04:10:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 May 2019 11:09:53 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4K89rBh000406;
        Mon, 20 May 2019 11:09:53 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Mikhael Goikhman <migo@mellanox.com>,
        Tzafrir Cohen <tzafrirc@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH ethtool] ethtool.spec: Use standard file location macros
Date:   Mon, 20 May 2019 11:09:40 +0300
Message-Id: <1558339780-8314-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mikhael Goikhman <migo@mellanox.com>

Use _prefix and _sbindir macros to allow building the package under a
different prefix.

Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
Signed-off-by: Tzafrir Cohen <tzafrirc@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 ethtool.spec.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ethtool.spec.in b/ethtool.spec.in
index 6e9e1f591240..9c01b07abf2b 100644
--- a/ethtool.spec.in
+++ b/ethtool.spec.in
@@ -22,7 +22,7 @@ network devices, especially Ethernet devices.
 
 
 %build
-CFLAGS="${RPM_OPT_FLAGS}" ./configure --prefix=/usr --mandir=%{_mandir}
+CFLAGS="${RPM_OPT_FLAGS}" ./configure --prefix=%{_prefix} --mandir=%{_mandir}
 make
 
 
@@ -32,7 +32,7 @@ make install DESTDIR=${RPM_BUILD_ROOT}
 
 %files
 %defattr(-,root,root)
-/usr/sbin/ethtool
+%{_sbindir}/ethtool
 %{_mandir}/man8/ethtool.8*
 %doc AUTHORS COPYING NEWS README
 
-- 
1.8.3.1

