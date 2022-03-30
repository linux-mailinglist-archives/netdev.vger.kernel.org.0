Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762FC4EB981
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbiC3E1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242499AbiC3E06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D572FDFE2;
        Tue, 29 Mar 2022 21:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6630E61561;
        Wed, 30 Mar 2022 04:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD663C340F0;
        Wed, 30 Mar 2022 04:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614314;
        bh=GiQdRnvOD79OWqlDvg6Sf9vtrfZD84+3sCIuYPexe1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSGhcRD5JWoHlxMqNPIsPDmbTMb30xYVQxshK/PgfHfWBQXBwMAoUskIe7KaDS6wu
         56DVEfK1Nm0CkEfo5JaEdzVbzcj3DFPGmxyHjsF1qt0vg+4CJSrjzUHz4PoHpnkPoT
         QZDLtyRK5yn12tfKgzWQpkUrS4D6oN9mRZNqhU1oaQIZDYNsAjZgsZ0wXteAofXp7v
         3v+6aplyh1PiCluiPQCNuI1/ZjYgHc50hXS3p++tt7A5NsW7+lXnvLfVoV+hOpCHts
         R1/mYaJXLria8Ppt6b2TzfzyjZb6nKArKT6ozLv+vNZC38PTgxbAx185P/anecl+L6
         MLP7TzMJuHFQg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 05/14] docs: netdev: note that RFC postings are allowed any time
Date:   Tue, 29 Mar 2022 21:24:56 -0700
Message-Id: <20220330042505.2902770-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330042505.2902770-1-kuba@kernel.org>
References: <20220330042505.2902770-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document that RFCs are allowed during the merge window.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2: new patch
---
 Documentation/networking/netdev-FAQ.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 041993258dda..f4c77efa75d4 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -74,6 +74,9 @@ sent to netdev, but knowing the above, you can predict that in advance.
   Do not send new ``net-next`` content to netdev during the
   period during which ``net-next`` tree is closed.
 
+RFC patches sent for review only are obviously welcome at any time
+(use ``--subject-prefix='RFC net-next'`` with ``git format-patch``).
+
 Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
 tree for ``net-next`` reopens to collect content for the next (vX.Y+1)
 release.
-- 
2.34.1

