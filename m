Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF43052A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfE3XHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:07:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:24800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfE3XHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 19:07:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 16:07:10 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 30 May 2019 16:07:08 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWU8a-0008nu-3S; Fri, 31 May 2019 07:07:08 +0800
Date:   Fri, 31 May 2019 07:06:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jason Baron <jbaron@akamai.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next] tcp: tcp_fastopen_alloc_ctx() can be static
Message-ID: <20190530230620.GA3979@lkp-kbuild15>
References: <201905310755.SmE6F5XI%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905310755.SmE6F5XI%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 9092a76d3cf8 ("tcp: add backup TFO key infrastructure")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 tcp_fastopen.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 8e15804..7d19fa4 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -72,9 +72,9 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
 }
 
-struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
-						    void *backup_key,
-						    unsigned int len)
+static struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
+							   void *backup_key,
+							   unsigned int len)
 {
 	struct tcp_fastopen_context *new_ctx;
 	void *key = primary_key;
