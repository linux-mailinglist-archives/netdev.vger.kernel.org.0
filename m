Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1AE4E8533
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbiC0C4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiC0C4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106EF427F1;
        Sat, 26 Mar 2022 19:54:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A164E60E9E;
        Sun, 27 Mar 2022 02:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC2DC34100;
        Sun, 27 Mar 2022 02:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349652;
        bh=Ymms6xCtmq72Ojp991fo5pHDOd1C+6SngUKoV4QeW3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRiMjoXSx+iIoCKDgDeBiyxKPIS1VwbHSXd2zP7kJwWO4BbMNuw+L7MHZGfMU/iia
         AbrI7sdLgFXcwDUr+I4jQ29O9QxlRfQwWWDN4Ifg+aT98/Pyumb3yav4SD7XejNSlD
         85ZDD5+2FOfd41hMjkMO2lgy5PHFXtwRAF69A4Km20I94ZgJPYhE+dDmEQuWvHsmwe
         QGihwkTzOgbKUugGYll4qjvueJJBmT7mtJI5gwWo9fCpEXk2GUU45vbcHqH03nAJRp
         7ukvXO7ZDt9lECifAMa6Ol9rdq2xm7drvKUKTD3DZ0K3dz+hbj0PeviTCbK+hMsBjx
         naXvUGPwpIagg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 08/13] docs: netdev: add a question about re-posting frequency
Date:   Sat, 26 Mar 2022 19:53:55 -0700
Message-Id: <20220327025400.2481365-9-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220327025400.2481365-1-kuba@kernel.org>
References: <20220327025400.2481365-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index d2ad55db7d8a..85a0af5dca65 100644
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

