Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011A96DD61B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjDKJBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDKJB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:01:28 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95169F2;
        Tue, 11 Apr 2023 02:01:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D185F1C0012;
        Tue, 11 Apr 2023 09:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681203685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6MsnXyxapAJi/yR+D3gA/Fog4MlS6Jv6XqIQ/lYi5U=;
        b=EYoUi0TXg2Fc9Ub947TOwWG5Hnu9GqLJ6UjDBICJJ05I+/1V4JIXDGgYZhyISJNWwwcmT2
        RJSeRZtU6GVVsm5kDZYE5EJKBWbG6rGQIVashiS2jNraFOHsGv41pEvS9Hk/I9cJhNVqqj
        fo9GOvzHMU/tZ3wjTY+be+BTa0hKl58GXF1f6B6bgbT6uKJoQL4fF1ZzjR2bBxWUwkIe27
        JAE8S1zU4OwNUpfw+4p/fqBZw0UT0zKLqqUruGrx0ivxF/xiIaeb1C/A1OlzK3535ueUsC
        CWBBJHjeZWb1+urGSUukkUcq/bTRj08J2yQ0unKKnUt9/m2B3AzkvkGh8Hh/Kw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 2/2] MAINTAINERS: Add wpan patchwork
Date:   Tue, 11 Apr 2023 11:01:22 +0200
Message-Id: <20230411090122.419761-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411090122.419761-1-miquel.raynal@bootlin.com>
References: <20230411090122.419761-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchwork instance is hosted on kernel.org and has been used for a
long time already, it was just not mentioned in MAINTAINERS.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 26d0edc024a7..75baf27a3ff7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9889,6 +9889,7 @@ M:	Miquel Raynal <miquel.raynal@bootlin.com>
 L:	linux-wpan@vger.kernel.org
 S:	Maintained
 W:	https://linux-wpan.org/
+Q:	https://patchwork.kernel.org/project/linux-wpan/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan-next.git
 F:	Documentation/networking/ieee802154.rst
-- 
2.34.1

