Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C412623D5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIIAOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgIIAOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:14:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD658C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Sv8UV9boXP/fu4sTmxcb5dRstdGhWgDrMkhzsOH27MU=; b=HzK4YMWnAIHS/NX0rJxkDLsbkZ
        qr+je+YjQjbElOUT5KXsItW790MKdoap4K1SIolAVIYvY5VBcXYcMzPsAycaxbQr/oljHkZVUNoFV
        2K4omp16urGRJi/UKznM/A10kJQ0NSG082dPxhTJcmkd8q7l5GC43pyMmHEH2rPaEkrukLU0ClFvU
        bjR+Hcil/6bE51JU11ysTzd0iPJbjQLrkbI5ireh6t3BaOscEGqwXaX5IEBrkDvGc0bmL39WRKc4s
        hnOzd/I2DJbl1r+vSm4IjM2ac/QoW2bFUdOK7e1PtaOLJpX8JHEMg/TnRI32Q2vIpOy0RZtU9MwmH
        vA0E70vg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFnl8-0004MX-HD; Wed, 09 Sep 2020 00:14:47 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <trivial@kernel.org>, Jon Mason <jdmason@kudzu.us>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH trivial] net: ethernet/neterion/vxge: fix spelling of
 "functionality"
Message-ID: <d6a2c287-a0bd-202b-d7c2-6d4cdb390b34@infradead.org>
Date:   Tue, 8 Sep 2020 17:14:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix typo/spello of "functionality".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Mason <jdmason@kudzu.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200908.orig/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ linux-next-20200908/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4539,7 +4539,7 @@ vxge_probe(struct pci_dev *pdev, const s
 	 * due to the fact that HWTS is using the FCS as the location of the
 	 * timestamp.  The HW FCS checking will still correctly determine if
 	 * there is a valid checksum, and the FCS is being removed by the driver
-	 * anyway.  So no fucntionality is being lost.  Since it is always
+	 * anyway.  So no functionality is being lost.  Since it is always
 	 * enabled, we now simply use the ioctl call to set whether or not the
 	 * driver should be paying attention to the HWTS.
 	 */

