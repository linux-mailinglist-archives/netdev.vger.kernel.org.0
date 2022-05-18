Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BEB52C7E0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiERXnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiERXnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:43:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C88719F87;
        Wed, 18 May 2022 16:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB8161739;
        Wed, 18 May 2022 23:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D583C385A5;
        Wed, 18 May 2022 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652917428;
        bh=NbTFxgtIlF+GS9WudT/EY4/OA0jJX3++dd2Oa5g94o4=;
        h=From:To:Cc:Subject:Date:From;
        b=rEviZW5Sw8dVbcU3JGHlcaCtGHpkWqyojZ5dzH4JsHweLnUDkbaDB/A4k+J7AWYtf
         qLFwju6t2k+3FA30KMZikoBbG2TOBrBQbrepGAy09rkMCE39+idkxJsPpG/nJtnj5H
         NzE5ZLhDaccZfb3ZOQzTMnNhZI/kJqy+ruXtn8GJKN5Hy1y97hL+lj7fho6I73M2CD
         5ON6q0h28hZZQFqz8V5mkwo9nQUqllhT6Xuuod5pAR4NI45LNtj9BR7qXHZH8KpFhe
         tLbyagkK0XFmZY6rTM9GCVnaqsupN9bmkrbAnR1Ylq98TI3jNVghlGGZnms3LT/8jc
         wyJhrl5jLIcuQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] docs: change the title of networking docs
Date:   Wed, 18 May 2022 16:43:46 -0700
Message-Id: <20220518234346.2088436-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current title of our section of the documentation is
Linux Networking Documentation. Since we're describing
a section of Linux Documentation repeating those two
words seems redundant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: corbet@lwn.net
CC: linux-doc@vger.kernel.org
---
 Documentation/networking/index.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index a1c271fe484e..03b215bddde8 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -1,5 +1,5 @@
-Linux Networking Documentation
-==============================
+Networking
+==========
 
 Refer to :ref:`netdev-FAQ` for a guide on netdev development process specifics.
 
-- 
2.34.3

