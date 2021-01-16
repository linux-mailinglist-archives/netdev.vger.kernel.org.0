Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D3B2F8FD2
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 00:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbhAPXWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 18:22:42 -0500
Received: from mga17.intel.com ([192.55.52.151]:41106 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbhAPXWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 18:22:41 -0500
IronPort-SDR: le2IaN9tJFApbpU+hiSQ1tUeQdb+zma8657KWEiSU+p8qjfkaeqB11usDb1dPMx0e+TWJ8y4Qb
 YxajHz4w4XLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9866"; a="158463685"
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="scan'208";a="158463685"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2021 15:22:01 -0800
IronPort-SDR: 79BMRk/GOSobwF7Sl9NGMgyy2OGAk6BLP+YjUAB77iZHoD0sXKbBMmw9JsNV6rWxtfu1cleMYl
 WHKK8FNIt/fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,352,1602572400"; 
   d="scan'208";a="390456834"
Received: from lkp-server01.sh.intel.com (HELO 260eafd5ecd0) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 16 Jan 2021 15:21:59 -0800
Received: from kbuild by 260eafd5ecd0 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l0utK-0001BY-UN; Sat, 16 Jan 2021 23:21:58 +0000
Date:   Sun, 17 Jan 2021 07:20:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Pavel =?utf-8?Q?=C5=A0imerda?= <code@simerda.eu>
Subject: [RFC PATCH] net: mdio: mdio_debug_fops can be static
Message-ID: <20210116232057.GA89809@49432ef1697d>
References: <20210116211916.8329-1-code@simerda.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116211916.8329-1-code@simerda.eu>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 mdio-debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-debugfs.c b/drivers/net/phy/mdio-debugfs.c
index abed40052c20a1d..f1c9a3c604714c2 100644
--- a/drivers/net/phy/mdio-debugfs.c
+++ b/drivers/net/phy/mdio-debugfs.c
@@ -151,7 +151,7 @@ static unsigned int mdio_debug_poll(struct file *file, poll_table *wait)
 	return data->value == -1 ? POLLOUT : POLLIN;
 }
 
-struct file_operations mdio_debug_fops = {
+static struct file_operations mdio_debug_fops = {
 	.owner = THIS_MODULE,
 	.open = mdio_debug_open,
 	.release = mdio_debug_release,
@@ -181,7 +181,7 @@ void mdio_debugfs_remove(struct mii_bus *bus)
 }
 EXPORT_SYMBOL_GPL(mdio_debugfs_remove);
 
-int __init mdio_debugfs_init(void)
+static int __init mdio_debugfs_init(void)
 {
 	mdio_debugfs_dentry = debugfs_create_dir("mdio", NULL);
 
@@ -189,7 +189,7 @@ int __init mdio_debugfs_init(void)
 }
 module_init(mdio_debugfs_init);
 
-void __exit mdio_debugfs_exit(void)
+static void __exit mdio_debugfs_exit(void)
 {
 	debugfs_remove(mdio_debugfs_dentry);
 }
