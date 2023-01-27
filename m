Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51467DD8B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 07:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjA0GkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 01:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjA0GkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 01:40:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776D769500;
        Thu, 26 Jan 2023 22:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=swjGj2JGsgoS6As86ky5T5gStqDz1F5YkyPVKyHV0jk=; b=5G839/UAJb/cuL47f1MLvz5JiM
        JIzzclpfAngAmHt5ChGlBIj7wmO0SU4osdMpJi/cug7/TJCYGP+tYqcuC898uzyxYzUPMPpoeY7F7
        HdPi+AoYtMLni2toasm47FvEx6UsgYS6ji6Ad1zSuwWbJRaCoNdjnRGI7OsjHP9365FTBJPoRXsh6
        vllXt38/QU13Ex98G+dEBarT/ZrmKRw2SXmtjrhqJdIBDftl7sBJM0K11i/I16QiUKK64EuhpmOOd
        mIlrjxb5GDbCpKMh26zZEJcnSB4ZvAEXAgAArtG/Io4jZVK8NyGjgauoZKv1Oqz8qIQ94thEJ8L5V
        JAqPrxZA==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pLIPH-00DM0u-VN; Fri, 27 Jan 2023 06:40:16 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 13/35] Documentation: isdn: correct spelling
Date:   Thu, 26 Jan 2023 22:39:43 -0800
Message-Id: <20230127064005.1558-14-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127064005.1558-1-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
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
Cc: isdn4linux@listserv.isdn4linux.de
Cc: netdev@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
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
