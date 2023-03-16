Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2D6BC792
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCPHqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjCPHqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:46:16 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C1A4B21
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=wwU+UVxfUIoPiP7KJnLzD0UYhME
        SYZhQ8/8Tp4QXAlE=; b=MpWqH7w3YVOBsCg3LwXkWFX+X3inlOu24sGg/7DSmcp
        hIrQQIKB/o89+WGb4ffhCI/Yuf/5jGLpdH813kuV1MU4z2BiAMLia/UgTcA4QQTv
        tDWVWOQEREowwH6DthU7PrvbUezCR3c0nMVlvatoQIh5tjrbRR6P9Fy/8hdDaZsQ
        =
Received: (qmail 3694188 invoked from network); 16 Mar 2023 08:46:09 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 08:46:09 +0100
X-UD-Smtp-Session: l3s3148p1@F0Q0p//2apIujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] smsc: fix bugs when interface is not up
Date:   Thu, 16 Mar 2023 08:45:56 +0100
Message-Id: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I found two issues dealing with the SMSC911x on the Renesas APE6-EVM
when the interface is not up yet. Each patch here deals with one of
them. Please read the patch description for details.

Wolfram Sang (2):
  Revert "net: smsc911x: Make Runtime PM handling more fine-grained"
  smsc911x: avoid PHY being resumed when interface is not up

 drivers/net/ethernet/smsc/smsc911x.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

-- 
2.30.2

