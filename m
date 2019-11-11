Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D18F6BED
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfKKAOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 19:14:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:64219 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfKKAOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 19:14:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 16:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,290,1569308400"; 
   d="scan'208";a="403651562"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 10 Nov 2019 16:14:20 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iTxLY-000EYb-AA; Mon, 11 Nov 2019 08:14:20 +0800
Date:   Mon, 11 Nov 2019 08:13:34 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     kbuild-all@lists.01.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [RFC PATCH] page_pool: page_pool_empty_alloc_cache_once() can be
 static
Message-ID: <20191111001334.ymtc7krrv3wfq2a6@4978f4969bb8>
References: <157323722783.10408.5060384163093162553.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157323722783.10408.5060384163093162553.stgit@firesoul>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: a25e46ce7ecc ("page_pool: make inflight returns more robust via blocking alloc cache")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 page_pool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 89feee635d083..3c76e495e922a 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -376,7 +376,7 @@ void __page_pool_free(struct page_pool *pool)
 EXPORT_SYMBOL(__page_pool_free);
 
 /* Empty alloc cache once and block it */
-void page_pool_empty_alloc_cache_once(struct page_pool *pool)
+static void page_pool_empty_alloc_cache_once(struct page_pool *pool)
 {
 	struct page *page;
 
