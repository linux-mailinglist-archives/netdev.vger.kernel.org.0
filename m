Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB7C6AB261
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 22:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCEVDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 16:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCEVDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 16:03:01 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7195FE6;
        Sun,  5 Mar 2023 13:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=NYUNbeipY1ll3kDdL3XkOMucDZXwJo2Uc/kulc79M2s=; b=hPWs5lc/IYKSKeLLNBx+N8/oOj
        xRdjnPpvD8kJySTWAFkkygVJKy9csvy8clK86YZAyMeO/98U57nlQ72nhcyPbbB0iqU24t2rb1shO
        054ik3/A60Ad8aqwq6h5SCwghk+THIUY1bPvr5V6zD4jk+5fGtYNRyfBh7xsqwpDt2DBa4qRT31Dh
        s4ok9kH8Xe+JDfyaPfAl/DtK8gODsbk/2I878vA2wXuoyN9XJjNPR37XE0LqDt+5cD0860QxQdaK0
        wRP2ZPkzYmvC5MDsff1QjetjV5TU2p07I32JbXV0Kr7RV3z+qfRaHA/hKMG3fJ+ARzDtYYvs1jwkx
        6/FsTrhA==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pYvVN-001E7L-DK; Sun, 05 Mar 2023 21:02:53 +0000
From:   Bastian Germann <bage@debian.org>
To:     toke@toke.dk, Kalle Valo <kvalo@kernel.org>
Cc:     Bastian Germann <bage@debian.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
Date:   Sun,  5 Mar 2023 22:02:43 +0100
Message-Id: <20230305210245.9831-1-bage@debian.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop a wrongly claimed USB ID.

Bastian Germann (1):
  wifi: ath9k: Remove Qwest/Actiontec 802AIN ID

 drivers/net/wireless/ath/ath9k/hif_usb.c | 2 --
 1 file changed, 2 deletions(-)

-- 
2.39.2

