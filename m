Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F89420483
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 02:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhJDATH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 20:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhJDATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 20:19:05 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD12C0613EC;
        Sun,  3 Oct 2021 17:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=8DRtRDzq2iYJ1LU0x0hVhMKxLXtz4MwoLerUwHPXNt4=; b=vWNXsTtm6UQ+kyynnp9PPhdaty
        ecehHWSKwMZ4EAtIRudXCG8JTfmsVmhRIRK5kBY0lK6pDp9gKZ71+2p099BRM/jzolVjrP1kSo7lh
        hBFRDMenI9sXaFvjGMPJkg8e8YZjimbCS8CrFIJ3pk6IzGbkgfpnH/mhBUGTToEY9fxJ4DiUUD4UC
        ULifz4gT7KAF/2ezPaAqgiUag81cHXwSA5GBsyhPCgyLnmnkwIL6z8DkhdO/OZ7S/BfaoiZ5dQj8w
        CrYAB1xNlzS4mbib0p1cebn6hr4DLrbrR4/9DszPJHOMk9EK0Nevro3aHlWgNXdSRo/DlNCrABUDB
        JX/qFSXA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mXBfQ-004klM-QG; Mon, 04 Oct 2021 00:17:16 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] net: iwlwifi: rfi.c: fix non-kernel-doc comment
Date:   Sun,  3 Oct 2021 17:17:16 -0700
Message-Id: <20211004001716.25199-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change a comment from a kernel-doc comment to a regular comment to
prevent a kernel-doc warning:

rfi.c:11: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * DDR needs frequency in units of 16.666MHz, so provide FW with the
rfi.c:11: warning: missing initial short description on line:
 * DDR needs frequency in units of 16.666MHz, so provide FW with the

Fixes: 21254908cbe9 ("iwlwifi: mvm: add RFI-M support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211001.orig/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ linux-next-20211001/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -7,7 +7,7 @@
 #include "fw/api/commands.h"
 #include "fw/api/phy-ctxt.h"
 
-/**
+/*
  * DDR needs frequency in units of 16.666MHz, so provide FW with the
  * frequency values in the adjusted format.
  */
