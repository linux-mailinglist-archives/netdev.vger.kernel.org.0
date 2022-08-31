Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A525A7C17
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 13:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiHaLTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 07:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiHaLTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 07:19:03 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7214CCC314;
        Wed, 31 Aug 2022 04:19:02 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 8A2BD126D;
        Wed, 31 Aug 2022 13:19:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661944740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p04O/CIBirtCabMm2McxdbE/HL9u16fsZCxrZFi0bCE=;
        b=TZeqX7+eHd8LkfGWAqMp3qzyhA1pOsBlxXnhto/GU5uDAHhyYFE2jNYE7QqkcbRtZ12Ukb
        kIuC0JQMcKFbQk2ucgi1wI70VtYkL1zc5/ABv9GfCJDjnQxZwLC7f7jh/jHno9/DIUvRtl
        tI7gsmi/Uq9XivW8OJs5ebwmSMO6oUin8/yYA4evkQEHdY7H27PzS7nhyxbLHbncw+5p0R
        gCnndVK53dPxKmyNkc7LPn3t9LmclriqLcaoN9VL5qOHsECWqXgNZigAymNfrOXbvkn68h
        o0V4MGZqF4haYybUwKPm3Fdiof+y6fRfpEtTQzug3icy4EdZybijMCfjP5dd2g==
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/2] net: lan966x: make reset optional
Date:   Wed, 31 Aug 2022 13:18:53 +0200
Message-Id: <20220831111855.1749646-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the remaining part of the reset rework on the LAN966x targetting
the netdev tree.

The former series can be found at:
https://lore.kernel.org/lkml/20220826115607.1148489-1-michael@walle.cc/

Michael Walle (2):
  dt-bindings: net: sparx5: don't require a reset line
  net: lan966x: make reset optional

 .../devicetree/bindings/net/microchip,sparx5-switch.yaml       | 2 --
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c          | 3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.30.2

