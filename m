Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8949D6E6FDA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjDRXOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0087AAE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA2662CF4
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1D7C4339B;
        Tue, 18 Apr 2023 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681859646;
        bh=+Mu6h9kentylkzQiOvIdx431yxQ3VK2fh5umXPmH9qg=;
        h=From:To:Cc:Subject:Date:From;
        b=a4q1mWIB07iNIPhDHszP0SFFHV5q/L0+X15Pg+haHPACEjFmeitjINdYp8ICytNY8
         fVPOj0RHGUUMlEYWgs6FxjIYsSrYj5iHGczPXQ9zJ9c5Lmp9wC0N4Wq1lvCoy5+/am
         sdzvcXgt3NHWsowUW+Xm1ue7u/Wy7BWFU/9LLJliO2maWf8rankOeuf5xLiHvPnh/Y
         JpsonKMFs8oLP5jmyVK9f4WMjU1JRxY5gfsFnP9qKo9KR5/WKtVSgvXnsO/B0qVI0o
         k5xa4DeuampveLaGdvM8wvj9e2dF8t3irtaSUWz8krOTF9SxchtTc3vhAFqF3RktnR
         lKseNkAmvMp3g==
From:   Mat Martineau <martineau@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com
Cc:     Mat Martineau <martineau@kernel.org>, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next] MAINTAINERS: Resume MPTCP co-maintainer role
Date:   Tue, 18 Apr 2023 16:13:18 -0700
Message-Id: <20230418231318.115331-1-martineau@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm returning to the MPTCP maintainer role I held for most of the
subsytem's history. This time I'm using my kernel.org email address.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/mptcp/af85e467-8d0a-4eba-b5f8-e2f2c5d24984@tessares.net/
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fc57dfd5fd0..e5ff4687d3f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14612,6 +14612,7 @@ F:	net/netlabel/
 
 NETWORKING [MPTCP]
 M:	Matthieu Baerts <matthieu.baerts@tessares.net>
+M:	Mat Martineau <martineau@kernel.org>
 L:	netdev@vger.kernel.org
 L:	mptcp@lists.linux.dev
 S:	Maintained
-- 
2.40.0

