Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6532E240BFF
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHJRcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgHJRcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 13:32:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A98702065C;
        Mon, 10 Aug 2020 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597080730;
        bh=ZjHkNaUkTh0bzvXWeMU9J/0OejMc9XVs3wpUaIznezo=;
        h=From:To:Cc:Subject:Date:From;
        b=ESJMqk9ECsL1vbodyqaXSGpj2eCT0hB64yOwS8/QFuhAh/eNEBHXCwozRmuh5iNfS
         PFBvtirOq/c7OlTL4a7pjzitUDhhF3CKV2DxisUzTbKun/8K2r3jFZUqvk1/64JQRU
         5B3UqAXfdIh/Rfg6Nzd5mSkrrL1W5emYt2wH3EAg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] nfp: update maintainer
Date:   Mon, 10 Aug 2020 10:32:04 -0700
Message-Id: <20200810173204.26222-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm not doing much work on the NFP driver any more.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d2784b502da0..83ea07711518 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11948,7 +11948,8 @@ F:	include/uapi/linux/netrom.h
 F:	net/netrom/
 
 NETRONOME ETHERNET DRIVERS
-M:	Jakub Kicinski <kuba@kernel.org>
+M:	Simon Horman <simon.horman@netronome.com>
+R:	Jakub Kicinski <kuba@kernel.org>
 L:	oss-drivers@netronome.com
 S:	Maintained
 F:	drivers/net/ethernet/netronome/
-- 
2.26.2

