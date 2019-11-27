Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69010B1C6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbfK0PCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:02:06 -0500
Received: from mga07.intel.com ([134.134.136.100]:29073 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfK0PCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 10:02:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 07:02:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,249,1571727600"; 
   d="scan'208";a="206911535"
Received: from unknown (HELO s215.localdomain) ([10.237.94.20])
  by fmsmga007.fm.intel.com with ESMTP; 27 Nov 2019 07:02:04 -0800
From:   Radoslaw Tyl <radoslawx.tyl@intel.com>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, Radoslaw Tyl <radoslawx.tyl@intel.com>
Subject: [PATCH] ixgbe: Fix calculation of queue with VFs and flow director on interface flap
Date:   Wed, 27 Nov 2019 16:01:56 +0100
Message-Id: <20191127150156.15207-1-radoslawx.tyl@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191127090355.27708-1-cambda@linux.alibaba.com>
References: <20191127090355.27708-1-cambda@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zhu

Please next time send patch directly to Intel-wired-lan.
All Linux kernel patch submissions and issues reported
against Intel wired Ethernet LAN kernel drivers should 
use this list.

> 
> This patch fixes the calculation of queue when we restore flow director filters
> after resetting adapter. In ixgbe_fdir_filter_restore(), filter's vf may be zero
> which makes the queue outside of the rx_ring array.
> 
> The calculation is changed to the same as ixgbe_add_ethtool_fdir_entry().
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Reviewed-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
