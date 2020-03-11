Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D7C1825EE
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731446AbgCKXhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731374AbgCKXhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 19:37:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3765720754;
        Wed, 11 Mar 2020 23:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583969830;
        bh=Tr9hDjf/YqH7exXNPblnBOHbIs8m0h/mnNyMYaPX8g4=;
        h=From:To:Cc:Subject:Date:From;
        b=DG2ViNVOunZYRdzISeCiv3S0wsR5CpWXh5gBNF0Sn3BbUozxwVEqHcW5AOsoAhtbi
         7tPz6/8O3vyFJqHKkWIUo8KKHft4o5LyMosPkbSw72Bc5Kq40aXEIXnx2AyuDGmIbQ
         9FOl2Qf0j+yJBqw8m9d54friLPxLD5UsFlp0WK6Q=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: remove Sathya Perla as Emulex NIC maintainer
Date:   Wed, 11 Mar 2020 16:37:02 -0700
Message-Id: <20200311233702.2179475-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove Sathya Perla, sathya.perla@broadcom.com is bouncing.
The driver has 3 more maintainers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6693ce1b9e21..39937a4d608e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6197,7 +6197,6 @@ S:	Supported
 F:	drivers/scsi/be2iscsi/
 
 Emulex 10Gbps NIC BE2, BE3-R, Lancer, Skyhawk-R DRIVER (be2net)
-M:	Sathya Perla <sathya.perla@broadcom.com>
 M:	Ajit Khaparde <ajit.khaparde@broadcom.com>
 M:	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
 M:	Somnath Kotur <somnath.kotur@broadcom.com>
-- 
2.24.1

