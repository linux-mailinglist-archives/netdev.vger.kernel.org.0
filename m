Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CC82623D4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIIANn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgIIANl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:13:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A376C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yAFjkOiWnPHfd259fSrlgaC94MndSwdYJepS1Cm58Os=; b=QdfuQqIal/1AnKQf8MC1dIoa+Y
        xTEOSYiIgSEmCtgz7OK/1tiA3iLet2VM4cyYQ5GR21ojVCZJ6POjVJJ7/XDYJMVhW+nQ8+aHphchP
        D8dLZoJqgRwJuEMSXIITzuqbeZXV4ukZnPqJlXWHkKyPYCgAQgHfMTRKyg0WEPH00e1eWpe3f+nie
        cdn52TlfO64VWmXX5dle7kyaZ8nj6/xzcf1g/zAAjZE5hKKmzErGhW7kuaOoaNfGMxmJOE1OXZWr0
        pIT7MvrVhJRPZTXwvoIXuD22NzJUJ4TkMeH5ynXrwni+gmXpCkGwDu5WUs2tXXo6XBfjxOaXGMdSm
        884yeTQA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFnjt-0004LJ-DL; Wed, 09 Sep 2020 00:13:29 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <trivial@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH trivial] nfc: pn533/usb.c: fix spelling of "functions"
Message-ID: <fc1a9118-39d5-2084-8a1d-0974f70f80ad@infradead.org>
Date:   Tue, 8 Sep 2020 17:13:25 -0700
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

Fix typo/spello of "functions".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-nfc@lists.01.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>
---
 drivers/nfc/pn533/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200908.orig/drivers/nfc/pn533/usb.c
+++ linux-next-20200908/drivers/nfc/pn533/usb.c
@@ -210,7 +210,7 @@ static void pn533_usb_abort_cmd(struct p
 	usb_kill_urb(phy->in_urb);
 }
 
-/* ACR122 specific structs and fucntions */
+/* ACR122 specific structs and functions */
 
 /* ACS ACR122 pn533 frame definitions */
 #define PN533_ACR122_TX_FRAME_HEADER_LEN (sizeof(struct pn533_acr122_tx_frame) \


