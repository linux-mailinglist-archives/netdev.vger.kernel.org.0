Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509C1563DE6
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiGBDMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBDMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CD537A37
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29F91B8302B
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E852C341CA;
        Sat,  2 Jul 2022 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656731532;
        bh=QJv7rAReW64oNYwzDAtLt8ee5+EljI3frGw5vuRVvww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DucL/tUFEIfWc+DGQByRsVHN9B14RUbgJjmS0a6OcZaXGz6nOPml4nfsSPmL+jZMN
         +WBCpj6cOGX8EkAd4m9pjBFGFnJi4ikQc3Ag/PNYPaG2uBsjAYfREwZOUWxa7YLGXm
         OgchtWlY/tYqi00b5awM+qA0w15xjGad0Zq1jmJhUweN8Mbj5etllCjRsa29Jfk5eS
         t6Aaaal38OSV0TLLTfdSZJlnFTPo1DwT+iEk0vcn1TbOInE4Ht6ZjjRHfvDf2iW7gM
         m3/H27GpDN23D24hN8H+Lo8CB1oV0kngqa+6O3BWX4/NoBt6vGDVoYfTK5oc+M9sXL
         wmkTVDqbL0/JQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 1/3] docs: netdev: document that patch series length limit
Date:   Fri,  1 Jul 2022 20:12:07 -0700
Message-Id: <20220702031209.790535-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702031209.790535-1-kuba@kernel.org>
References: <20220702031209.790535-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had been asking people to avoid massive patch series but it does
not appear in the FAQ.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index c456b5225d66..79a10d05031e 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -136,6 +136,20 @@ it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
 
+How do I divide my work into patches?
+-------------------------------------
+
+Put yourself in the shoes of the reviewer. Each patch is read separately
+and therefore should constitute a comprehensible step towards your stated
+goal.
+
+Avoid sending series longer than 15 patches. Larger series takes longer
+to review as reviewers will defer looking at it until they find a large
+chunk of time. A small series can be reviewed in a short time, so Maintainers
+just do it. As a result, a sequence of smaller series gets merged quicker and
+with better review coverage. Re-posting large series also increases the mailing
+list traffic.
+
 I made changes to only a few patches in a patch series should I resend only those changed?
 ------------------------------------------------------------------------------------------
 No, please resend the entire patch series and make sure you do number your
-- 
2.36.1

