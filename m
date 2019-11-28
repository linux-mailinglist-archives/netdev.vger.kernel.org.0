Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5F810CFB6
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 23:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfK1WSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 17:18:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfK1WSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 17:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NBD0zG2PBYB2MoqiIuelLiG8bprmYgMYAk9CFKOT1W8=; b=ORjtvOgH+nBft6f0vBs2XpXEe
        OXtBWa/c1kxl3qBV63gHsmhJUyEVUydPMdZRDqSqfJjjhwA8QWWTHc5nWDF4nBKTbdhXUUJlKtncA
        pnmOE4Yze5vpGhU9sPZjY07/kuSpYp8Di151KU43iN3isjxyf4OVLB++SoDWAtTaQZzb0Ee+kAtYN
        TlxxfYNZ/SSKzljbcG0iERQ8U3MKd0lp4YIIQSgLLMskYAqv6CogSNEkpa27Up/VifPR/qJKEPYqA
        s4LvoAJRC3ofH/o/xEDsHaudXneHVM9C3++7CwAPN4P2PwyHpiXPYF4dCZllf9Yu/BDp3cHxhz+bB
        DS5mQkYLQ==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iaS6q-000168-FO; Thu, 28 Nov 2019 22:18:00 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: emulex: benet: indent a Kconfig depends continuation
 line
Message-ID: <cb47882b-7417-ca32-41ac-70b76fae0ff2@infradead.org>
Date:   Thu, 28 Nov 2019 14:17:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Indent a Kconfig continuation line to improve readability.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Sathya Perla <sathya.perla@broadcom.com>
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: Somnath Kotur <somnath.kotur@broadcom.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/emulex/benet/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-54.orig/drivers/net/ethernet/emulex/benet/Kconfig
+++ lnx-54/drivers/net/ethernet/emulex/benet/Kconfig
@@ -49,4 +49,4 @@ config BE2NET_SKYHAWK
 
 comment "WARNING: be2net is useless without any enabled chip"
 	depends on BE2NET_BE2=n && BE2NET_BE3=n && BE2NET_LANCER=n && \
-	BE2NET_SKYHAWK=n && BE2NET
+		BE2NET_SKYHAWK=n && BE2NET

