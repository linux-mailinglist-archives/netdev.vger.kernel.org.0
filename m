Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5600F53D17D
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347633AbiFCSeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347303AbiFCSeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:34:02 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E893715FCA;
        Fri,  3 Jun 2022 11:21:46 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F40E720002;
        Fri,  3 Jun 2022 18:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654280505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rk+/DEwzRe428tJYay7QpSriG8FWWAXiVMpdZZdxlDM=;
        b=gYD52ffGv2baRvcze/VuYQIDR/P0e/atk21IlbwLPkKefQO2DXvi78K8x99rc0qVHu7JPU
        Lha2x3f7Q7RlIhfVdmBVKUeMFYtUlMYWahT+z1/psb98dh9VaW7/ppAomLzPQlirIToiW9
        JAEhSuB7F2hMO+/dkHBOubifgkpnOZb2QOjt+oXO3xc0EsrRP9G07owtQz4kR6zk+AlDqS
        fMzuIMNabWRSsv/CxvULFI657hm5I7W+fGP2tJcyqUa3WniSQtFsKKBZF/YpNQLT4mUoGX
        dCVw+NlB9TxJFuumjIHUW4ubpk1ol6yBRY+OiuKWjSuwbD9YDYYa3uI0M+RRSA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 0/6] net: ieee802154: PAN management
Date:   Fri,  3 Jun 2022 20:21:37 +0200
Message-Id: <20220603182143.692576-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Last step before adding scan support, we need to introduce a proper PAN
description (with its main properties) and PAN management helpers.

This series provides generic code to do simple operations on PANs and
PAN coordinators.

Thanks,
Miquèl

David Girault (1):
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (5):
  net: ieee802154: Drop coordinator interface type
  net: ieee802154: Add support for internal PAN management
  net: ieee802154: Create a node type
  net: ieee802154: Add the PAN coordinator information
  net: ieee802154: Full PAN management

 include/net/cfg802154.h   |  31 +++++
 include/net/nl802154.h    |  61 +++++++++-
 net/ieee802154/Makefile   |   2 +-
 net/ieee802154/core.c     |   2 +
 net/ieee802154/core.h     |  42 +++++++
 net/ieee802154/nl802154.c | 232 ++++++++++++++++++++++++++++++++++-
 net/ieee802154/pan.c      | 246 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/trace.h    |  25 ++++
 8 files changed, 636 insertions(+), 5 deletions(-)
 create mode 100644 net/ieee802154/pan.c

-- 
2.34.1

