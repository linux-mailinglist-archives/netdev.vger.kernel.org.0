Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E214EB99E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiC3E1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiC3E1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF474DFE2;
        Tue, 29 Mar 2022 21:25:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C1F76154F;
        Wed, 30 Mar 2022 04:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E42C340EE;
        Wed, 30 Mar 2022 04:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614318;
        bh=v9JEe17Ci9gU/r2Rz9f+Qliuq1qdflaeXctdUD+BZRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dh+aT2bA3VJmbtRkZ8dnSWnm6etD8gGnn2FTfr+tf+izAcRBg8GQWPvA79fx40Xw8
         aTPJFEmxUTKV8CAznAsgYrFuIYfh1FEI64P4TQNEocMy8taoRcf+iML5DKO7AJsyr/
         hOTIu2OONrkTjH5Aq4HsktYfdIqMNJkYm55X0cbUwhbBMg1D50XmWIlm3K15OKz32B
         1kwSKcxjj/k9K4BWXAbWWLllbLRpt0Z+SJW4Rw5EUYFRbK/DUYekGFw/zNs15Hm2oC
         Ni97ojnQbPqk99Q/YzsWzHVfAmFaV4buyrnVlSzvhZeBikxKvsn+dHoh4jxWwTclx3
         Iw4bwjoSlvw8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 12/14] docs: netdev: call out the merge window in tag checking
Date:   Tue, 29 Mar 2022 21:25:03 -0700
Message-Id: <20220330042505.2902770-13-kuba@kernel.org>
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

Add the most important case to the question about "where are we
in the cycle" - the case of net-next being closed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 294ad9b0162d..a18e4e671e85 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -103,7 +103,9 @@ So where are we now in this cycle?
 
 and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
-probably imminent.
+probably imminent. If the most recent tag is a final release tag
+(without an ``-rcN`` suffix) - we are most likely in a merge window
+and ``net-next`` is closed.
 
 How can I tell the status of a patch I've sent?
 -----------------------------------------------
-- 
2.34.1

