Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C937E4AA88B
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 13:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbiBEMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 07:10:33 -0500
Received: from mga04.intel.com ([192.55.52.120]:37205 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232479AbiBEMKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 07:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644063032; x=1675599032;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lZP4CupIkHIl8x9BJu41rQxOUyIclXltfTO1C9bu780=;
  b=RpS4nsTiEJVsRadApBDTxJxCnHyICwYpWc+itamsTmE9yGwoP2uplyl2
   0GBQqq/fFm350uPhy9oYh/oHfhJAp6QyeTBnZvlApbKBDqsdvbBdYZrgB
   /8dJsoXT4gGBdomRfINmG+mvX4ovA6lMlj8pX8KSnYg+7WP/ri2pZt5fz
   gtJ4uhjZU269xhdEsYAXnWHkrNTrhiOzWvl4VlLlpbobha8cegxvE5TUN
   9HGzZUYZg/EC5vyLB8YaLZzLMD56Z5ZUCxG2TGNw+Igl0p1Ye/9eY/HMd
   qsg7wAXffWM3p8+Cxd23UE5vUVald9XfwepK1ktuTS8iJaMj5rRdQEd6j
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="247340766"
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="247340766"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2022 04:10:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="584391910"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 05 Feb 2022 04:10:30 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nGJtd-000Z0M-H9; Sat, 05 Feb 2022 12:10:29 +0000
Date:   Sat, 5 Feb 2022 20:09:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>
Subject: [RFC PATCH] net/smc: smc_tcp_ls_wq can be static
Message-ID: <20220205120947.GA10751@d01e203e4d07>
References: <1d7365b47719546fe1f145affb01398d8287b381.1644041638.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d7365b47719546fe1f145affb01398d8287b381.1644041638.git.alibuda@linux.alibaba.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/smc/af_smc.c:62:25: warning: symbol 'smc_tcp_ls_wq' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 af_smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 05b88cbadf3d1..4969ac8029a98 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -59,7 +59,7 @@ static DEFINE_MUTEX(smc_client_lgr_pending);	/* serialize link group
 						 * creation on client
 						 */
 
-struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
+static struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
 struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
