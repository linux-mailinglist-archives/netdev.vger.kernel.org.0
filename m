Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C99A1F2B6A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732926AbgFIAP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:15:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:34121 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732864AbgFIAPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 20:15:23 -0400
IronPort-SDR: 8q8AjhwCPAKRB63o0Rdenxzrtcq4XJKcOyjIkIux6/fuS3j9iK5wZ+9r83ue3oWvndP897GM5/
 Re/OO7EBHuzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 17:15:21 -0700
IronPort-SDR: h4gXjZE+EBOrWdTDzIBVdyDssU3TJJ3lTUru/MY8SVcqhndPyK+QGc/jgs0u4oLW7L2FpQMCAa
 8kCLMxtPu3lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400"; 
   d="scan'208";a="379581107"
Received: from lkp-server01.sh.intel.com (HELO 12d5c0ac8e64) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 08 Jun 2020 17:15:19 -0700
Received: from kbuild by 12d5c0ac8e64 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jiRvD-00000p-6k; Tue, 09 Jun 2020 00:15:19 +0000
Date:   Tue, 9 Jun 2020 03:55:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     kbuild-all@lists.01.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [RFC PATCH] bpf: bpf_anon_inode_getfd() can be static
Message-ID: <20200608195547.GA88820@01856db44629>
References: <159163507753.1967373.62249862728421448.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159163507753.1967373.62249862728421448.stgit@firesoul>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 syscall.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6eba236aacd1f..fcd9860cdf148 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -689,8 +689,8 @@ const struct file_operations bpf_map_fops = {
 };
 
 /* Code is similar to anon_inode_getfd(), except starts at FD 1 */
-int bpf_anon_inode_getfd(const char *name, const struct file_operations *fops,
-			 void *priv, int flags)
+static int bpf_anon_inode_getfd(const char *name, const struct file_operations *fops,
+				void *priv, int flags)
 {
 	int error, fd;
 	struct file *file;
