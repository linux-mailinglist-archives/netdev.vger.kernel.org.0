Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135986900CA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBIHON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBIHOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:14:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB903F2A6;
        Wed,  8 Feb 2023 23:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vjMkg0CsA3ExXEoe5XfBRbE22936dlfCDtp+3PswdVo=; b=QbzRNOC00aWT5TTnDAt32AspMk
        Xh2RaKOQGmibuyYQwYiw91oYafMcsuB1A477+7BtSXJVD9koIcERj/bWGKUmr0tzgMzNmB7tPXOhT
        5sKgRK/FzVw9c9KaJYnL32i4whxpsLmHqAsqSFOrql4F4DMbj6aZmqQzNniBnVHYWw1Q5iqcWSxVL
        Lv18a0oQHOxKSb/CwsRUZ6ew1yZ4CDLaUTnODMoaJgljYXkRyZ8BvhwekNmk4e9mokyUU9KrrKkWy
        0pLZorJG7plzIHRBPdLyFwElgTn6Ph2xe3xL6/C85wnLIlDXbV05vnYywbp+6Y6T05YElA+uc6xpZ
        afyABTVw==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pQ18C-000LPt-15; Thu, 09 Feb 2023 07:14:08 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 08/24] Documentation: isdn: correct spelling
Date:   Wed,  8 Feb 2023 23:13:44 -0800
Message-Id: <20230209071400.31476-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209071400.31476-1-rdunlap@infradead.org>
References: <20230209071400.31476-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct spelling problems for Documentation/isdn/ as reported
by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/isdn/interface_capi.rst |    2 +-
 Documentation/isdn/m_isdn.rst         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -- a/Documentation/isdn/interface_capi.rst b/Documentation/isdn/interface_capi.rst
--- a/Documentation/isdn/interface_capi.rst
+++ b/Documentation/isdn/interface_capi.rst
@@ -323,7 +323,7 @@ If the lowest bit of showcapimsgs is set
 application up and down events.
 
 In addition, every registered CAPI controller has an associated traceflag
-parameter controlling how CAPI messages sent from and to tha controller are
+parameter controlling how CAPI messages sent from and to the controller are
 logged. The traceflag parameter is initialized with the value of the
 showcapimsgs parameter when the controller is registered, but can later be
 changed via the MANUFACTURER_REQ command KCAPI_CMD_TRACE.
diff -- a/Documentation/isdn/m_isdn.rst b/Documentation/isdn/m_isdn.rst
--- a/Documentation/isdn/m_isdn.rst
+++ b/Documentation/isdn/m_isdn.rst
@@ -3,7 +3,7 @@ mISDN Driver
 ============
 
 mISDN is a new modular ISDN driver, in the long term it should replace
-the old I4L driver architecture for passiv ISDN cards.
+the old I4L driver architecture for passive ISDN cards.
 It was designed to allow a broad range of applications and interfaces
 but only have the basic function in kernel, the interface to the user
 space is based on sockets with a own address family AF_ISDN.
