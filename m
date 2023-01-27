Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E6867E21B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjA0KqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjA0Kp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:45:59 -0500
X-Greylist: delayed 1452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Jan 2023 02:45:49 PST
Received: from mail.simonwunderlich.de (mail.simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC65166C8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:45:49 -0800 (PST)
Received: from kero.packetmixer.de (p200300C5973eaED8832e80845eB11f67.dip0.t-ipconnect.de [IPv6:2003:c5:973e:aed8:832e:8084:5eb1:1f67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.simonwunderlich.de (Postfix) with ESMTPSA id 06532FAFDD;
        Fri, 27 Jan 2023 11:21:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1674814897; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkI4Op5NmFlUbJf6LZCtGkkkSLpzMMNyZfYraFDlRZI=;
        b=AFYgcjnFSL4ubLcTDUWOi1MCHrN0Yt0k77V/ogOa4Xx4JeC6cgFrNZBnG5u/RByBQLWteT
        DI0hiQarATsUyuSl2WaOin9kyqm2juKIQegzyir5vXJCzVq/HFs3vk+mx58QyBTstjWVTD
        Cx55ZhC58Qa/hPETPWu1nbTgp8aHfR4NkrxszcDuiuMGzUREpAM/eMcRsuwN6PgB1uUSz1
        38p5gSpHWpv3PgIfpZqnCw/RcIIB8Mul9y9wnDgZXt1JtPyd+PrFKKtC3FX69zC0yshp8u
        dN0FZMP44vNnSi+rEapakCuWKIQTkdjMNSgNHiUkGLf0elIE6XjY9ihJHfURUA==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/5] batman-adv: Fix mailing list address
Date:   Fri, 27 Jan 2023 11:21:31 +0100
Message-Id: <20230127102133.700173-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127102133.700173-1-sw@simonwunderlich.de>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1674814897;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkI4Op5NmFlUbJf6LZCtGkkkSLpzMMNyZfYraFDlRZI=;
        b=lIxFeWMJ+rpLO8Bs8E1HpXOJ932Bd6j5jqVjmbKWB0Q8cwPjy6AeEu1AJa6g9hCpMVC+vb
        5EOGyV8Io1qvNIvQt02JGvi16XGOpEbNR5c5tvecJ8mBt4xQTimSx18tynzwd33WjEEIeQ
        uUW4AF8BA8Wb42+QB107VHO6Ni0J9Gql2OpDctV5SVgK/aRkh+Om7CDbvhCXW0KV/vXtef
        2lqTraLeYLl4vUGbFuV99gftmTKExqiLUbbOWXG0b/K9ZXbx5F9vqG/Dwd8U+oEFwbpfjo
        9bGTZT9wNvKwdYTL3joyKHal3CqrNmKUwxj3cMS3sHorznKs/3H2nQD+VJCi1Q==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1674814897; a=rsa-sha256;
        cv=none;
        b=wXP2QKZqLYRrPWzf/uNsxqk2gVQaRC8ZxSWRA3izji1c9UaHY+td4+Q6e7Rwv0Ed8E3DrMxQmSlb71jnIEgEKnlddeSQ46LgQM5nmC/zYqSD0tcJGKI4kTaaBsAZ08Ayf0BTRmyucl6tNQ3P/eZ9WE7oE+SRrtlo0LG70g2/YWZR/i43qu92ZNc0vekqjFuSMr29wTbMwMa9vQpHGq8PriCSCuIWL+bo7GUZgbcumv+A02Jt+2tLyRZhUHsGRtx/38SJXAXDdOFnJ2kf/F92pQJifumdx3vHFnBSjBn1BwYM20xoo8ak/SDN4HBUu1nCbetWupxzshi/3ba5m9TMXg==
ARC-Authentication-Results: i=1;
        mail.simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 Documentation/networking/batman-adv.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/batman-adv.rst b/Documentation/networking/batman-adv.rst
index b85563ea3682..8a0dcb1894b4 100644
--- a/Documentation/networking/batman-adv.rst
+++ b/Documentation/networking/batman-adv.rst
@@ -159,7 +159,7 @@ Please send us comments, experiences, questions, anything :)
 IRC:
   #batadv on ircs://irc.hackint.org/
 Mailing-list:
-  b.a.t.m.a.n@open-mesh.org (optional subscription at
+  b.a.t.m.a.n@lists.open-mesh.org (optional subscription at
   https://lists.open-mesh.org/mailman3/postorius/lists/b.a.t.m.a.n.lists.open-mesh.org/)
 
 You can also contact the Authors:
-- 
2.30.2

