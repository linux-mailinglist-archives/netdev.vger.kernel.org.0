Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D2623E14C
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgHFSmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:42:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:27886 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbgHFSUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:20:01 -0400
IronPort-SDR: noAHKqFJIQV3sD5SUhb4a/r8pkm8jihDVMMa6s+aJI6nF3YNTFBlYfyQiehKjbdDCO8GePPCv3
 g+192+pulvQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="132448828"
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="132448828"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 11:18:28 -0700
IronPort-SDR: exZ+VA/4rPSrLhgnrM0hOuqyMMY99Ay6UL5nlXad7g94VaZuIZ5HNAbkEidoLHlkkDTLQl3E+w
 Eo/pXnnAf8fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,441,1589266800"; 
   d="scan'208";a="316248781"
Received: from lkp-server02.sh.intel.com (HELO 37a337f97289) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 06 Aug 2020 11:18:26 -0700
Received: from kbuild by 37a337f97289 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k3kTB-0001fc-MR; Thu, 06 Aug 2020 18:18:25 +0000
Date:   Fri, 7 Aug 2020 02:18:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        brouer@redhat.com, dlxu@fb.com
Subject: [RFC PATCH] bpf: user_verifier_ops can be static
Message-ID: <20200806181814.GA5058@26715c783541>
References: <20200801084721.1812607-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801084721.1812607-2-songliubraving@fb.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 bpf_trace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index cbe789bc1b986..4b8f380694a10 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1852,12 +1852,12 @@ user_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
-const struct bpf_verifier_ops user_verifier_ops = {
+static const struct bpf_verifier_ops user_verifier_ops = {
 	.get_func_proto		= user_prog_func_proto,
 	.is_valid_access	= user_prog_is_valid_access,
 };
 
-const struct bpf_prog_ops user_prog_ops = {
+static const struct bpf_prog_ops user_prog_ops = {
 	.test_run	= bpf_prog_test_run_user,
 };
 
