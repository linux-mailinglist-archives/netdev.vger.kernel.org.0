Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1677E4EA6E3
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiC2FKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiC2FKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243236389;
        Mon, 28 Mar 2022 22:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7571B80E5E;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21500C34112;
        Tue, 29 Mar 2022 05:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530527;
        bh=rDmmtk6jBHB2BWcEq9lfA9bsPqbv1Uwej6e+nHUsHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfDU796K5RCTaS/UNvX5flN6Sd5sge9+dLdGIO7s2xyXsTYu8zSXKFGV/NISDfKTu
         YNgleXd3Hdo8k27u1SC0KJ6gpYTFp3AEbtEcLvgEHrjlBzkqdy4+aFPGpjNXkZX4YW
         jpfRKw37/cE5iq2Zj4+T2FjTNIz6d8+fZ08bHWow0Z/lnkPRyR7kBtVp9+udW1EUi1
         3xOdpdMOWw/1qNhtM5ZC037JRBJxjk9J1TnVmf//6NZKLKWwnek0tn0wTui7e4sbh9
         K5yl4rhDt2m90uk6PCoru9wAJ1gidcPZscXkGZM5pvH4v99JKEj2EdBgEp1/ueAa2U
         CIEnHfL81CPmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 06/14] docs: netdev: shorten the name and mention msgid for patch status
Date:   Mon, 28 Mar 2022 22:08:22 -0700
Message-Id: <20220329050830.2755213-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
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

Cut down the length of the question so it renders better in docs.
Mention that Message-ID can be used to search patchwork.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index f4c77efa75d4..e10a8140d642 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -105,14 +105,16 @@ and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
 probably imminent.
 
-I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
---------------------------------------------------------------------------------------------
+How can I tell the status of a patch I've sent?
+-----------------------------------------------
 Start by looking at the main patchworks queue for netdev:
 
   https://patchwork.kernel.org/project/netdevbpf/list/
 
 The "State" field will tell you exactly where things are at with your
-patch.
+patch. Patches are indexed by the ``Message-ID`` header of the emails
+which carried them so if you have trouble finding your patch append
+the value of ``Message-ID`` to the URL above.
 
 The above only says "Under Review".  How can I find out more?
 -------------------------------------------------------------
-- 
2.34.1

