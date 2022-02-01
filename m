Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C764A62A0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbiBARiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:38:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:11148 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241546AbiBARiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 12:38:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643737089; x=1675273089;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f6JJ74Do55mLqnLA7cDVFqNZSX5AA3VKgPum7Ymxq8A=;
  b=Y21cW+cAnJjoIe+/AuwnaxE9uSuWouDgYesoAaS4q5dl+5GXgSGie9ef
   UhM9TXOBayU7GFPUUbCOsRhGpm1BlyuSOP/6dclvzk1NA3h1kx//rPzHn
   io0ciceH7MfARQ1n0Ab1wV7oTfihGVmbpKQa7r0+YeOZ5dXZGs1OHZL3v
   Yws8V1OnbQyKEmeuoazrG3y0lcs1FlxHaA4LKdcnm4IyLFB9u3ldfjGVk
   xo4hYJQipgASopvVNi+pogcM0L83v8FDE7mnIcEf6qoTPwBzmC3wqspvg
   1juEgOxj5IBsIJrzlJ1FovzwauoBoLexCMdvF+QLQQdAVsidwOSiKPkpw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="235141799"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="235141799"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 09:38:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="482465887"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Feb 2022 09:38:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2022-02-01
Date:   Tue,  1 Feb 2022 09:37:52 -0800
Message-Id: <20220201173754.580305-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e driver only.

Sasha removes CSME handshake with TGL platform as this is not supported
and is causing hardware unit hangs to be reported.

The following are changes since commit 881cc731df6af99a21622e9be25a23b81adcd10b:
  net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Sasha Neftin (2):
  e1000e: Separate ADP board type from TGP
  e1000e: Handshake with CSME starts from ADL platforms

 drivers/net/ethernet/intel/e1000e/e1000.h   |  4 ++-
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 20 +++++++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 39 +++++++++++----------
 3 files changed, 44 insertions(+), 19 deletions(-)

-- 
2.31.1

