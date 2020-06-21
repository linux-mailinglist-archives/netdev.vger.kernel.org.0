Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1CA2027F5
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 04:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgFUCWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 22:22:41 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:32687 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbgFUCWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 22:22:40 -0400
Date:   Sun, 21 Jun 2020 02:22:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592706158;
        bh=J+OeX+4eyPga/gDUKZyWvFD1/UBFNesYDfkyLzSviPk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=sMeGhntT0p2Zs81ZgvFsiWUkGbBEF9AAei9xmh5FQ8rwcELwIfSj+XcMPw/0kSw7Y
         mVUeo8aGjc3x6JfOEoEcMisDpjLG5k+aYFU3WCnlv79WUIGygmoio090PokIA2z50m
         +hodmEds+Mqxs5wMUUOcXp5STUbD2fdIZjVnE6o4=
To:     davem@davemloft.net
From:   Colton Lewis <colton.w.lewis@protonmail.com>
Cc:     netdev@vger.kernel.org,
        Colton Lewis <colton.w.lewis@protonmail.com>
Reply-To: Colton Lewis <colton.w.lewis@protonmail.com>
Subject: [PATCH 1/3] net: core: correct trivial kernel-doc inconsistencies
Message-ID: <20200621022209.11814-2-colton.w.lewis@protonmail.com>
In-Reply-To: <20200621022209.11814-1-colton.w.lewis@protonmail.com>
References: <20200621022209.11814-1-colton.w.lewis@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence documentation build warnings by correcting kernel-doc comments.

./net/core/dev.c:7913: warning: Function parameter or member 'dev' not desc=
ribed in 'netdev_get_xmit_slave'

Signed-off-by: Colton Lewis <colton.w.lewis@protonmail.com>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6..cf20d286abfc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7898,6 +7898,7 @@ EXPORT_SYMBOL(netdev_bonding_info_change);
=20
 /**
  * netdev_get_xmit_slave - Get the xmit slave of master device
+ * @dev: The device
  * @skb: The packet
  * @all_slaves: assume all the slaves are active
  *
--=20
2.26.2


