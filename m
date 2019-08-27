Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B29F9F311
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbfH0TRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:17:16 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38905 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731074AbfH0TRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 15:17:13 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Aug 2019 22:17:07 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7RJGuGu026842;
        Tue, 27 Aug 2019 22:17:05 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, jiri@mellanox.com,
        kwankhede@nvidia.com, cohuck@redhat.com, davem@davemloft.net
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>
Subject: [PATCH v1 4/5] mdev: Update sysfs documentation
Date:   Tue, 27 Aug 2019 14:16:53 -0500
Message-Id: <20190827191654.41161-5-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190827191654.41161-1-parav@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190827191654.41161-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated documentation for optional read only sysfs attribute.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 Documentation/driver-api/vfio-mediated-device.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
index 25eb7d5b834b..0ab03d3f5629 100644
--- a/Documentation/driver-api/vfio-mediated-device.rst
+++ b/Documentation/driver-api/vfio-mediated-device.rst
@@ -270,6 +270,7 @@ Directories and Files Under the sysfs for Each mdev Device
          |--- remove
          |--- mdev_type {link to its type}
          |--- vendor-specific-attributes [optional]
+         |--- alias [optional]
 
 * remove (write only)
 
@@ -281,6 +282,10 @@ Example::
 
 	# echo 1 > /sys/bus/mdev/devices/$mdev_UUID/remove
 
+* alias (read only)
+Whenever a parent requested to generate an alias, each mdev is assigned a unique
+alias by the mdev core. This file shows the alias of the mdev device.
+
 Mediated device Hot plug
 ------------------------
 
-- 
2.19.2

