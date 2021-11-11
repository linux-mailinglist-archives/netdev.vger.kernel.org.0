Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2EA44D98D
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbhKKPxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhKKPx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:53:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB35C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 07:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=n/2dVMyFhk34vPhKNZV2XkZeZHz2jrUNDdH1q4DabZU=; b=IrZiahqSh6k/vYKan0gYVnRn+s
        NRZTnEvlOdbnptYqMLBkwz5536gCqn8pUtbGP4JEMDkoKhy1Jn2v/4ITobdjq/o7fmKTh85sejVXr
        lzzlV+X88hMyHkU3zwl8p5ZluVicPJ5nC2bvx2XpMkxa9Fl0oAkgPd8B/1c8fKwZe0EPdb6vXHVZT
        Xp4qK44StlEVLX/R8UGtVpp65Dv796izL5EgGEYO9yYjJTwexp214U9CCtNjgvFVLYvLMLNuEIO12
        06lYOeZs+T6V6WlFQG5zyyDPzmPSQwiJi9filFACGnq1N8CsQbao2X6XqJWRpu0DyWDn/jHSrJyuZ
        Er1aMe8Q==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mlCLU-008Ieh-QU; Thu, 11 Nov 2021 15:50:36 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] ptp: ptp_clockmatrix: repair non-kernel-doc comment
Date:   Thu, 11 Nov 2021 07:50:34 -0800
Message-Id: <20211111155034.29153-1-rdunlap@infradead.org>
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

Then remove the kernel-doc-like function parameter descriptions
since they don't add any useful info. (suggested by Jakub)

Fixes: 794c3dffacc16 ("ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Min Li <min.li.xe@renesas.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: remove useless function argument descriptions

 drivers/ptp/ptp_clockmatrix.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-next-20211110.orig/drivers/ptp/ptp_clockmatrix.c
+++ linux-next-20211110/drivers/ptp/ptp_clockmatrix.c
@@ -1699,12 +1699,9 @@ static int initialize_dco_operating_mode
 
 /* PTP Hardware Clock interface */
 
-/**
+/*
  * Maximum absolute value for write phase offset in picoseconds
  *
- * @channel:  channel
- * @delta_ns: delta in nanoseconds
- *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
  * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
