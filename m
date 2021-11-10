Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6292A44CD27
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhKJW4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbhKJWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 17:55:56 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426E3C061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 14:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=nexbm/nvrCb4nfER+vG9pFsNpml3LQEWFepsYAQAjW0=; b=MysM3B2yRkxH0dL1pVKdHce0UD
        ZssN7nxSojLA8lpoea/MWQDaKqsTmf7hBDXGDNc8wU7t+SY+ngNdVzpDr6JPZjK6vksfWbPrefyUh
        GGYfQ1mv1SNwvhMsVCpPCHnlguip3I4Rk6Jw8FQ1IOU/IhNahAkvYuJBhvR/5a+pB2K9Kw7aYQw+x
        IJhPUSSi7CbWqjmwIMQJixCjXrnGddrFdqr039y7a1FeR+LMIhp2kevAPY2AkPrUcNDkxRA/5rwy4
        jci3mJhjVS2AyXm8NyERHTIxLvFmu0gQMcpHf2nk/u1fkEKawN3taU9Xlz/QA9ETPrpQLuaLnGwpi
        SzlYmAew==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkwSo-006azM-U0; Wed, 10 Nov 2021 22:53:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] ptp: ptp_clockmatrix: repair non-kernel-doc comment
Date:   Wed, 10 Nov 2021 14:53:06 -0800
Message-Id: <20211110225306.13483-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use "/**" to begin a comment that is not in kernel-doc format.

Prevents this docs build warning:

drivers/ptp/ptp_clockmatrix.c:1679: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Maximum absolute value for write phase offset in picoseconds

Fixes: 794c3dffacc16 ("ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Min Li <min.li.xe@renesas.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/ptp/ptp_clockmatrix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211110.orig/drivers/ptp/ptp_clockmatrix.c
+++ linux-next-20211110/drivers/ptp/ptp_clockmatrix.c
@@ -1699,7 +1699,7 @@ static int initialize_dco_operating_mode
 
 /* PTP Hardware Clock interface */
 
-/**
+/*
  * Maximum absolute value for write phase offset in picoseconds
  *
  * @channel:  channel
