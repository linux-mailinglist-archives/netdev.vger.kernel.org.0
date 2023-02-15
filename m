Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825AD6975E8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjBOFhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjBOFhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:37:41 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C782A9B0;
        Tue, 14 Feb 2023 21:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Jz1+VJIZ0aRqq1aTi0zpYrB+is+bC7Y+La1wr/xDfSw=; b=oOpXes6I0lIouUBEoat6MXU0e0
        GjkP3RxIUFSoftEIm4wjOsYC/FzF+OdRwxee//qbvmdjF5m57LF+LWBa3HaHtZ+VXmai+5pTaS6i3
        nuv7yW7DgGL3sF7tKZSEEai2hVjwp9kC9KkRMekWCaMwg79mb/lunGp1lTk0oBkwhpXDvTny2fJ7X
        kIPOnk/54C3SkZFLrstLlXyheGcx9koQ/AWuZp8cZ78dDkfsDzezlhQdRI2LeJD02lzN+l9m4Wvw1
        G2Dk2RbYVZVI9mnCGPR4lVCCZzKZkx1Ajhk0BiOeibs451e4DtgtdSs7AEOw0dECXyQJH5S8zag+v
        N7HTQfTQ==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pSAU6-004nZ8-Ur; Wed, 15 Feb 2023 05:37:39 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [PATCH v3] Documentation: core-api: packing: correct spelling
Date:   Tue, 14 Feb 2023 21:37:38 -0800
Message-Id: <20230215053738.11562-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
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

Correct spelling problems for Documentation/core-api/packing.rst as
reported by codespell.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
v3: split into a separate patch as requested by Jakub.

 Documentation/core-api/packing.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/Documentation/core-api/packing.rst b/Documentation/core-api/packing.rst
--- a/Documentation/core-api/packing.rst
+++ b/Documentation/core-api/packing.rst
@@ -161,6 +161,6 @@ xxx_packing() that calls it using the pr
 
 The packing() function returns an int-encoded error code, which protects the
 programmer against incorrect API use.  The errors are not expected to occur
-durring runtime, therefore it is reasonable for xxx_packing() to return void
+during runtime, therefore it is reasonable for xxx_packing() to return void
 and simply swallow those errors. Optionally it can dump stack or print the
 error description.
