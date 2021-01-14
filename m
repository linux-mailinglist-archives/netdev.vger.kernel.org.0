Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF872F632D
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbhANOeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:34:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:24511 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbhANOeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 09:34:01 -0500
IronPort-SDR: 4Ba9M/5ro7TQGb1b2drNbJOPT0MvIlOa+JVGSSzf8VOurlWGN/zzf0R0OMCOHPbzf2nLIyVzpY
 yoVLXCTIRjXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="174868353"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="174868353"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 06:33:21 -0800
IronPort-SDR: 5OH1mM9YLhru887LKhDZe6ZrdK+nL0duUlnEfgAAU8iaEVzVrRvDZDNs5cS1YMx2kzYT73QLBj
 I8raqjAmNX4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="353919526"
Received: from silpixa00400572.ir.intel.com ([10.237.213.34])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2021 06:33:19 -0800
From:   Cristian Dumitrescu <cristian.dumitrescu@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, edwin.verplanke@intel.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH net-next 0/4] i40e: small improvements on XDP path
Date:   Thu, 14 Jan 2021 14:33:14 +0000
Message-Id: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces some small and straightforward improvements
to the Intel i40e driver XDP path. Each improvement is fully described
in its associated patch.

Cristian Dumitrescu (4):
  i40e: remove unnecessary memory writes of the next to clean pointer
  i40e: remove unnecessary cleaned_count updates
  i40e: remove the redundant buffer info updates
  i40: consolidate handling of XDP program actions

 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 149 +++++++++++----------
 1 file changed, 79 insertions(+), 70 deletions(-)

-- 
2.25.1

