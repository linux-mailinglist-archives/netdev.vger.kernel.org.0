Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C26F2F9
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 13:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGULbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 07:31:07 -0400
Received: from kadath.azazel.net ([81.187.231.250]:56642 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbfGULbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 07:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VJRSGajARep6p7KKoJqQ0CLEyaEYyfIvfEhmYxbFiV0=; b=MCmupqOp9wpXn++LC8xufm5gHG
        iLbu321Rbfpq9EBvB6QbQJ10ef0MAzx1Xx+oAAMvZY1DsQRwaqmpxViiPtujhRhU1UsgekXKPggV+
        RdUo6C5jWdzrVbKjMtkdz8t/4N33k5++dA+NL1EP+mZH9Q/YNhf/qCW5c3tqpDvx5I6WkcCqBCoUv
        iznSRilkaoBzWhZMS0bMpJUHOdw1KyPbVU3/+ugBEMDzmENay9a9boITxbsBBb94Ei8k/sX+r/R9n
        MaBGuvbzKPMbVTt79KBsKa7a55kHeKbW1b3o1oXPiZ2D8TOqI73TR1Wyreyv9bb91IoRXKz1kuHvd
        49O/apRw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hpA3V-0002t6-8L; Sun, 21 Jul 2019 12:31:05 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] kbuild: add net/netfilter/nf_tables_offload.h to header-test blacklist.
Date:   Sun, 21 Jul 2019 12:31:05 +0100
Message-Id: <20190721113105.19301-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719100743.2ea14575@cakuba.netronome.com>
References: <20190719100743.2ea14575@cakuba.netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/netfilter/nf_tables_offload.h includes net/netfilter/nf_tables.h
which is itself on the blacklist.

Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/Kbuild b/include/Kbuild
index 7e9f1acb9dd5..8de846a83d8f 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -909,6 +909,7 @@ header-test-			+= net/netfilter/nf_tables.h
 header-test-			+= net/netfilter/nf_tables_core.h
 header-test-			+= net/netfilter/nf_tables_ipv4.h
 header-test-			+= net/netfilter/nf_tables_ipv6.h
+header-test-			+= net/netfilter/nf_tables_offload.h
 header-test-			+= net/netfilter/nft_fib.h
 header-test-			+= net/netfilter/nft_meta.h
 header-test-			+= net/netfilter/nft_reject.h
-- 
2.20.1

