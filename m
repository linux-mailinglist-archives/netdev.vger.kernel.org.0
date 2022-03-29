Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC684EA6F8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiC2FKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiC2FKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F818636B;
        Mon, 28 Mar 2022 22:08:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5093B815AA;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E74C34100;
        Tue, 29 Mar 2022 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530528;
        bh=vdjnHae9b0yzMsExMtKNC+WLL55dm1Lg2N7VoIhWL24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8Mz5RkARNFo3A/b3V1DEMDphv1PPEJnbGTyOFSJJfsXF5c+vVCqso3pE2qPfU+G4
         TaIrE7HN480TEesVxx3IOWqMRhlE1Tpio3nSK8hYEDfpSomBYCRLwbyoJXniploFtY
         8gdKvoD6g5zLYFpMpUZffzvw7CqSYdabpUI3skU6arJGbMA7sy6ZlCZlyhoQ8ich8N
         9EBFwBmb9itGGnpf43FDNUrc6o/afgwF2TlFASSmv2Gp5fw+cBIBFHe3a0gsuvgsnS
         VgWaJz3lmgD7IZDcMLXvIDJ/k7OrXSVtU9KHbLP41pabcdUeQZhSZd5jHHqxM+exY5
         gKhaibueVaZ+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 08/14] docs: netdev: rephrase the 'should I update patchwork' question
Date:   Mon, 28 Mar 2022 22:08:24 -0700
Message-Id: <20220329050830.2755213-9-kuba@kernel.org>
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

Make the question shorter and adjust the start of the answer accordingly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 00ac300ebe6a..9c455d08510d 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -125,9 +125,11 @@ Asking the maintainer for status updates on your
 patch is a good way to ensure your patch is ignored or pushed to the
 bottom of the priority list.
 
-I submitted multiple versions of the patch series. Should I directly update patchwork for the previous versions of these patch series?
---------------------------------------------------------------------------------------------------------------------------------------
-No, please don't interfere with the patch status on patchwork, leave
+Should I directly update patchwork state of my own patches?
+-----------------------------------------------------------
+It may be tempting to help the maintainers and update the state of your
+own patches when you post a new version or spot a bug. Please do not do that.
+Interfering with the patch status on patchwork will only cause confusion. Leave
 it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
-- 
2.34.1

