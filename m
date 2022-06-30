Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB58562177
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiF3RqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbiF3RqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:46:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F863633A;
        Thu, 30 Jun 2022 10:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8CEA1CE2DA0;
        Thu, 30 Jun 2022 17:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD69C341C7;
        Thu, 30 Jun 2022 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656611178;
        bh=ye2owgw1DQrOJkowisJwLp9vCXdnWw50v4FZrNUASHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIQByBI98JYCW1j4W6QH07Tt8DGRaQ4eC4wuUJPXlz3icY/Uf1GasyUQjZ+tdPabv
         fm+p6Bl4AnRjjVQJE0r5URaPramKq224qSSSOSW7CJDIsgk/4RVs3eEzPk7ZCxmDIc
         cmZLY7ZdPEykwKodxglHKRqCSxxeKp3pktre/mZZuNdRwTBDPliM5taY579SP45aNl
         6PXjoohKmjbcmX5QMh3/4Iud1GHWvFO7GbYiGnLqp5MIcdaACxe8K/6fM9v8k9EwhH
         ucNhZGkRgqqCWvDz8FnlPRUdMLVXHcZBPEYASveOwNweIHp3O5hR85dwoVqRrT0gX4
         WBlIrU/XtMDtA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] docs: netdev: document that patch series length limit
Date:   Thu, 30 Jun 2022 10:46:05 -0700
Message-Id: <20220630174607.629408-2-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630174607.629408-1-kuba@kernel.org>
References: <20220630174607.629408-1-kuba@kernel.org>
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
 Documentation/process/maintainer-netdev.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index c456b5225d66..862b6508fc22 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -136,6 +136,14 @@ it to the maintainer to figure out what is the most recent and current
 version that should be applied. If there is any doubt, the maintainer
 will reply and ask what should be done.
 
+How do I divide my work into patches?
+-------------------------------------
+
+Put yourself in the shoes of the reviewer. Each patch is read separately
+and therefore should constitute a comprehensible step towards your stated
+goal. Avoid sending series longer than 15 patches, they clog review queue
+and increase mailing list traffic when re-posted.
+
 I made changes to only a few patches in a patch series should I resend only those changed?
 ------------------------------------------------------------------------------------------
 No, please resend the entire patch series and make sure you do number your
-- 
2.36.1

