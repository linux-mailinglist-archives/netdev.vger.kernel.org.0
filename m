Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA05BB523
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 03:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIQBAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 21:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiIQBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 21:00:15 -0400
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96ACF2F002;
        Fri, 16 Sep 2022 18:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3p2bAZIzEigh2jLU1yoT2nluVGntFmiYadlwtXSbXBM=; b=JnQYt7vZy9GtGfhsFqr0IwD3wL
        bJPYkhB6a+m8X0KvUeCEQLrXxCdsbBslimLslHHgu5d6rO7NJcJ+tXFnuo/s7zY6PIEhxhwiGQ2rD
        UOK40lzOF/JWBX0ybbAXK07AJQIhwimNULyr9ZEWG40lyA0l40+hn5ytjoK7el/LhvG8hct26AkiU
        IztVaBOpPEvl2q9kfmFOFQ/zXKO4QwnmmmdkTl6PhD65S+db+3t0pcyG0/7FlHc0a93KUaYQ4clEw
        6Kbo/SA9zLJF41ypO6pBQptzVzUd7F8S/8pRxl5xNZRYTnTUHi8lGSQfqDGctS6wCSUm5pUHylFB6
        3LCmu6qw==;
Received: from p4fd2bf05.dip0.t-ipconnect.de ([79.210.191.5] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oZLNB-000nP7-8H; Sat, 17 Sep 2022 00:07:53 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Alexander Couzens <lynxis@fe80.eu>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] net: mt7531: pll & reset fixes
Date:   Sat, 17 Sep 2022 02:07:32 +0200
Message-Id: <20220917000734.520253-1-lynxis@fe80.eu>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:
 - commit message: add Fixes: tag
 - add missing target branch in subject

Alexander Couzens (2):
  net: mt7531: only do PLL once after the reset
  net: mt7531: ensure all MACs are powered down before reset

 drivers/net/dsa/mt7530.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

-- 
2.37.3

