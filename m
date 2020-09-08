Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D147261539
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgIHQqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731981AbgIHQaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:30:17 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930D3206B8;
        Tue,  8 Sep 2020 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599582616;
        bh=+Ff9tfEfDGPa87bDmnsXcpSS9HJqTBHEknRpnRCaDsw=;
        h=From:To:Cc:Subject:Date:From;
        b=VBIj6rRBOpnIKkxOAhRNOf3Rdy/vd8DnDoRRdbTzqKQs3Kuy/1Lfm2dHAL5qevOiI
         8mu8lgnMHKakSA/WOSPToPgzXTXgcjeyfXh3U/POcn2I7mufv1rOwOxcVrwz4tOLvK
         gW7+jSZdXsM9vsc8937JLpGu1fexiY/ZhA16jtno=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: remove John Allen from ibmvnic
Date:   Tue,  8 Sep 2020 09:30:12 -0700
Message-Id: <20200908163012.153155-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John's email has bounced and Thomas confirms he no longer
works on ibmvnic.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dca9bfd8c888..12be7ae4d989 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8322,7 +8322,6 @@ F:	drivers/pci/hotplug/rpaphp*
 
 IBM Power SRIOV Virtual NIC Device Driver
 M:	Thomas Falcon <tlfalcon@linux.ibm.com>
-M:	John Allen <jallen@linux.ibm.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmvnic.*
-- 
2.26.2

