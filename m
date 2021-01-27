Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023F53050F0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhA0EbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:31:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhA0C7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EC6206A4;
        Wed, 27 Jan 2021 02:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611713925;
        bh=rMwC+sIYbUx69G3qjpCRxqAXW+BSUyEW4rv49e7Clwg=;
        h=From:To:Cc:Subject:Date:From;
        b=AiPzDU2EKihX4RYnCp/bpaz3e/l2uC+ZZf2v0VvYP0CBQK19c3rlGAnG1zKxQuR2c
         q3N+OQPZMSE4gdxJZ5iWiEjs1s1DkxTVozFD/3wIQkoJD269K5jc9V2Tay2IIQ53ul
         dTg9Kie6HQ9/FDTnG0jtJCrkpsBdMkZ+vDf4OdQCfdwq6tIMob2/DJmMUSAqJBb3nd
         M20tXIrJ6haXR76t7ZndoMSAlM8jqC9u4W3AfXzFiNmwF5Sa/5pl2hgfBI+Oy3EOxM
         6MuyAtNcpSqGUCrekz3wE30UcCZm52KO5u+YhwWjSCIQCKhLpcCZX9pE+IfMWedMw/
         4jHbMx2ktLUiw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] MAINTAINERS: add missing header for bonding
Date:   Tue, 26 Jan 2021 18:18:44 -0800
Message-Id: <20210127021844.4071706-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

include/net/bonding.h is missing from bonding entry.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8f68b591be57..4deef5791101 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3239,6 +3239,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://sourceforge.net/projects/bonding/
 F:	drivers/net/bonding/
+F:	include/net/bonding.h
 F:	include/uapi/linux/if_bonding.h
 
 BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
-- 
2.26.2

