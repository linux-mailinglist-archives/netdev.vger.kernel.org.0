Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9067A43B4B1
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJZOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:50:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:9883 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhJZOuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:50:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="229788033"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="229788033"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 07:47:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="497370427"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 26 Oct 2021 07:47:54 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        marta.a.plantykow@intel.com, alexandr.lobakin@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 0/2] ice: ethtool -L fixes
Date:   Tue, 26 Oct 2021 18:47:17 +0200
Message-Id: <20211026164719.1766911-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

here are the two fixes for issues around ethtool's set_channels()
callback for ice driver. Both are related to XDP resources. First one
corrects the size of vsi->txq_map that is used to track the usage of Tx
resources and the second one prevents the wrong refcounting of bpf_prog.

Thanks!

Maciej Fijalkowski (2):
  ice: fix vsi->txq_map sizing
  ice: avoid bpf_prog refcount underflow

 drivers/net/ethernet/intel/ice/ice_lib.c  |  9 +++++++--
 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.31.1

