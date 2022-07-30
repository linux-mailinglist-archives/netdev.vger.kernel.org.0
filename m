Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C5585853
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbiG3Dnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiG3Dnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:43:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E417B6D2D1;
        Fri, 29 Jul 2022 20:43:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C39DB82A44;
        Sat, 30 Jul 2022 03:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30AAC433C1;
        Sat, 30 Jul 2022 03:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659152627;
        bh=TncN4pJDqyDsQQJBNmQCqtvmBhz35mZwXUkkqwrJYEw=;
        h=From:To:Cc:Subject:Date:From;
        b=GL7HKou30XXgxw2Tpz9FKzVMRR6FvXoMgb+hg9MVDjdsoGOcTBgVd2SEftLkyZJWr
         JoOImjJlKMm5nwAOK+PlfUjWTpTjoiBwbnHEdbNX9Q1mR82tYqoc11Mz0QqlpwxwdI
         sQS3HqHYBZq1Tzi50iT+VGvpSpAUxsn7pVGaEuIow7q5Vgo4c/UYXnAUXyBziHvH9Y
         /ilOeS7GuY5qEdu00cCaIYVzKf+jr7XFB3RFE13eE5HzWNv+2UZ3sjd7qwD2sCadXJ
         d41RKdNweCP8P5BYNeC8o/1K3P3j36ERFAQPIjBR40h/+DFE5uzrAQdWmItNIpaF0f
         QDAbCwmFyTbBQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>, jiri@nvidia.com,
        corbet@lwn.net, vikas.gupta@broadcom.com, gospo@broadcom.com,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] docs: add devlink-selftests to the index
Date:   Fri, 29 Jul 2022 20:43:36 -0700
Message-Id: <20220730034336.746490-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

build bot says:
  Documentation/networking/devlink/devlink-selftests.rst: WARNING: document isn't included in any toctree

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 08f588fa301b ("devlink: introduce framework for selftests")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
CC: corbet@lwn.net
CC: vikas.gupta@broadcom.com
CC: gospo@broadcom.com
CC: linux-doc@vger.kernel.org
---
 Documentation/networking/devlink/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 850715512293..e3a5f985673e 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -38,6 +38,7 @@ general.
    devlink-region
    devlink-resource
    devlink-reload
+   devlink-selftests
    devlink-trap
    devlink-linecard
 
-- 
2.37.1

