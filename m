Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5E312CF6A
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 12:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfL3LV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 06:21:57 -0500
Received: from correo.us.es ([193.147.175.20]:59224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbfL3LVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 869F54DE732
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:21:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78DCDDA715
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 12:21:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6E935DA70E; Mon, 30 Dec 2019 12:21:52 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47E76DA70E;
        Mon, 30 Dec 2019 12:21:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B056941E4800;
        Mon, 30 Dec 2019 12:21:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/17] netfilter: Document ingress hook
Date:   Mon, 30 Dec 2019 12:21:28 +0100
Message-Id: <20191230112143.121708-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Amend kerneldoc of struct net_device to fix a "make htmldocs" warning:

include/linux/netdevice.h:2045: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 30745068fb39..0b097bbd3663 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1708,6 +1708,7 @@ enum netdev_priv_flags {
  *	@miniq_ingress:		ingress/clsact qdisc specific data for
  *				ingress processing
  *	@ingress_queue:		XXX: need comments on this one
+ *	@nf_hooks_ingress:	netfilter hooks executed for ingress packets
  *	@broadcast:		hw bcast address
  *
  *	@rx_cpu_rmap:	CPU reverse-mapping for RX completion interrupts,
-- 
2.11.0

