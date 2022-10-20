Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4262C606838
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiJTSbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJTSbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:31:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDE11FAE43;
        Thu, 20 Oct 2022 11:31:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548B861C14;
        Thu, 20 Oct 2022 18:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6508AC433C1;
        Thu, 20 Oct 2022 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666290656;
        bh=LidB1smPJLiSNxSiSTWkVKWdSRC18cTLNqF64oUkfHE=;
        h=From:To:Cc:Subject:Date:From;
        b=azjdQmvVop6YiLzTrQi8TsKUZ/7QxA9UJU9hniriVRdmYQKs0Kr45m/eZyfjnnIp7
         tVRAX4Sni6RDHmISP4DV5y22UqZDN+0BzClbPJ02ZgYpvak8uif5J/Ake4kifp4a08
         T/8r30MLbpNA83fPAW+J4SAaHUuiGyybkotMkhQTRYtVPt1VZKzCdt4Zam/kwqDdQo
         o2M/tjJlu+SSh7f2g/xJO48QO9RbyfjY2x6KTtTUtWn65M8uojg9aSU8A+dRMX0DpD
         No8Sy0uTdgcwWpaxd30iebnWaKf333ZjQPf9xMjnwZMZoVbg3NduHZ7xiSm4XHb5ZH
         wQ5juq379qtdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        bpf@vger.kernel.org, jesse.brandeburg@intel.com,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: netdev: offer performance feedback to contributors
Date:   Thu, 20 Oct 2022 11:30:31 -0700
Message-Id: <20221020183031.1245964-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of us gotten used to producing large quantities of peer feedback
at work, every 3 or 6 months. Extending the same courtesy to community
members seems like a logical step. It may be hard for some folks to
get validation of how important their work is internally, especially
at smaller companies which don't employ many kernel experts.

The concept of "peer feedback" may be a hyperscaler / silicon valley
thing so YMMV. Hopefully we can build more context as we go.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index d14007081595..1fa5ab8754d3 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -319,3 +319,13 @@ unpatched tree to confirm infrastructure didn't mangle it.
 Finally, go back and read
 :ref:`Documentation/process/submitting-patches.rst <submittingpatches>`
 to be sure you are not repeating some common mistake documented there.
+
+My company uses peer feedback in employee performance reviews. Can I ask netdev maintainers for feedback?
+---------------------------------------------------------------------------------------------------------
+
+Yes, especially if you spend significant amount of time reviewing code
+and go out of your way to improve shared infrastructure.
+
+The feedback must be requested by you, the contributor, and will always
+be shared with you (even if you request for it to be submitted to your
+manager).
-- 
2.37.3

