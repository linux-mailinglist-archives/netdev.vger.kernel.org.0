Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C209554A13
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiFVMf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiFVMfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:35:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E27B22B35;
        Wed, 22 Jun 2022 05:35:51 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D05CA22248;
        Wed, 22 Jun 2022 14:35:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1655901349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vATlMTEkReM5stqHgM0MtSkPV42XLwNMpxK49S0i0o4=;
        b=lEDJkgOj9TV/yY+psfXTiBm3V9hd4TPdj7c3GZdCkjn6TaYyaEikxBqi1urTcRUCGSpUl0
        MRf8e/Ae4EtgkTJ5rD1WLKQIwdT6Q8owexQ4f7ZCe8R0vNK5xtJu1oV2KNh86PQeKckTvl
        d0rnv9+OZcksm6oBwdHMZ8zi0kYexkg=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/2] net: use new hwmon_sanitize_name()
Date:   Wed, 22 Jun 2022 14:35:41 +0200
Message-Id: <20220622123543.3463209-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are the remaining patches of my former series [1] which were hold
back because it would have required a stable branch between the subsystems.

[1] https://lore.kernel.org/r/20220405092452.4033674-1-michael@walle.cc/

Michael Walle (2):
  net: sfp: use hwmon_sanitize_name()
  net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()

 drivers/net/phy/nxp-tja11xx.c | 11 +++--------
 drivers/net/phy/sfp.c         | 10 +++-------
 2 files changed, 6 insertions(+), 15 deletions(-)

-- 
2.30.2

