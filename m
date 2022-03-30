Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A754EB996
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbiC3E1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242535AbiC3E1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:27:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2DADFEE;
        Tue, 29 Mar 2022 21:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7A89B81B3E;
        Wed, 30 Mar 2022 04:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155BDC340F2;
        Wed, 30 Mar 2022 04:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614316;
        bh=Sllik6iaE1cFnQrEoRqBsr3czJlnZUnNA2SzJ7V4NuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=as41uzSoty88duMR3fFhyTHJE9rK2pjXJj2+tJ8sNPltO82uEfjew3y/3Ms6V8z8p
         06iz4waRAfpwx9/z6MCzmI3t+/2r+GiDgtHQsnprRXCOvN/78jVCismJl3vZgf+VHJ
         /5H2/OK6zHePq7M26ITm8tgBqhP8SHJhxigvOKp03BERXs6Cmk5g6iwZ8Lyqgii/3n
         qCjUM8YHPspmbJOx4DBw93Az/KgXhOKgkTHq0oCKQKHqpEZWBcm4hYfHpFbyuFSkHN
         FRf3/OX7GxpA+JYFMk1abjUWzkEuAackYi8MXFXil/TxhVOZTPhilk8E5sHJqv/mm9
         mVqqocCUzTTLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 09/14] docs: netdev: add a question about re-posting frequency
Date:   Tue, 29 Mar 2022 21:25:00 -0700
Message-Id: <20220330042505.2902770-10-kuba@kernel.org>
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

We have to tell people to stop reposting to often lately,
or not to repost while the discussion is ongoing.
Document this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/netdev-FAQ.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 9c455d08510d..f8b89dc81cab 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -140,6 +140,17 @@ No, please resend the entire patch series and make sure you do number your
 patches such that it is clear this is the latest and greatest set of patches
 that can be applied.
 
+I have received review feedback, when should I post a revised version of the patches?
+-------------------------------------------------------------------------------------
+Allow at least 24 hours to pass between postings. This will ensure reviewers
+from all geographical locations have a chance to chime in. Do not wait
+too long (weeks) between postings either as it will make it harder for reviewers
+to recall all the context.
+
+Make sure you address all the feedback in your new posting. Do not post a new
+version of the code if the discussion about the previous version is still
+ongoing, unless directly instructed by a reviewer.
+
 I submitted multiple versions of a patch series and it looks like a version other than the last one has been accepted, what should I do?
 ----------------------------------------------------------------------------------------------------------------------------------------
 There is no revert possible, once it is pushed out, it stays like that.
-- 
2.34.1

