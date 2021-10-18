Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613AB430D6F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbhJRB3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:29:55 -0400
Received: from mx.socionext.com ([202.248.49.38]:31204 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238640AbhJRB3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 21:29:54 -0400
Received: from unknown (HELO iyokan2-ex.css.socionext.com) ([172.31.9.54])
  by mx.socionext.com with ESMTP; 18 Oct 2021 10:27:43 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by iyokan2-ex.css.socionext.com (Postfix) with ESMTP id 4A6C72058B40;
        Mon, 18 Oct 2021 10:27:43 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 18 Oct 2021 10:27:43 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 8F54DB62B7;
        Mon, 18 Oct 2021 10:27:42 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net-next 0/2] net: ethernet: ave: Introduce UniPhier NX1 SoC support
Date:   Mon, 18 Oct 2021 10:27:35 +0900
Message-Id: <1634520457-16440-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes the patches to add basic support for new UniPhier NX1
SoC. NX1 SoC also has the same kinds of controls as the other UniPhier
SoCs.

Kunihiko Hayashi (2):
  dt-bindings: net: ave: Add bindings for NX1 SoC
  net: ethernet: ave: Add compatible string and SoC-dependent data for
    NX1 SoC

 .../devicetree/bindings/net/socionext,uniphier-ave4.yaml  |  1 +
 drivers/net/ethernet/socionext/sni_ave.c                  | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

-- 
2.7.4

