Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101F7214B7B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGEJVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 05:21:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:58499 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgGEJVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 05:21:01 -0400
IronPort-SDR: P4uSjWMWP5M1ua7hsaEAjbRfC1tpbMMjrc5nTu0dbk5p4u2C1fuhqjH0E/WZ/B9bFlK3DEi7F3
 rZ/4aapmYjqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9672"; a="135561355"
X-IronPort-AV: E=Sophos;i="5.75,314,1589266800"; 
   d="scan'208";a="135561355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2020 02:21:00 -0700
IronPort-SDR: Yig/QGCrEv1I+ZbWVj8LAADfFNZt8YO8onJVR6e4rIzu8r5ysDXLVVE4enmjSM0QU+7nfDJrPP
 5qMd+NIpmMbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,314,1589266800"; 
   d="scan'208";a="267690803"
Received: from lkp-server01.sh.intel.com (HELO 6dc8ab148a5d) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jul 2020 02:20:58 -0700
Received: from kbuild by 6dc8ab148a5d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1js0pV-0001hz-TI; Sun, 05 Jul 2020 09:20:57 +0000
Date:   Sun, 5 Jul 2020 17:20:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFC PATCH] bpf: sk_lookup_prog_ops can be static
Message-ID: <20200705092044.GA44776@7b422c9ed8a7>
References: <20200702092416.11961-3-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702092416.11961-3-jakub@cloudflare.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 filter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 477f3bb440c4c..d8153d217ca8e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9396,10 +9396,10 @@ static u32 sk_lookup_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
-const struct bpf_prog_ops sk_lookup_prog_ops = {
+static const struct bpf_prog_ops sk_lookup_prog_ops = {
 };
 
-const struct bpf_verifier_ops sk_lookup_verifier_ops = {
+static const struct bpf_verifier_ops sk_lookup_verifier_ops = {
 	.get_func_proto		= sk_lookup_func_proto,
 	.is_valid_access	= sk_lookup_is_valid_access,
 	.convert_ctx_access	= sk_lookup_convert_ctx_access,
