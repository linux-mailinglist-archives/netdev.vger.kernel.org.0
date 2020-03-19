Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15BF18BCD7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgCSQll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgCSQlk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 12:41:40 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72B02070A;
        Thu, 19 Mar 2020 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584636100;
        bh=nRFGy2I/nohQ4mAkKU1riEstccngBfNOTTKdKvm2qvQ=;
        h=From:To:Cc:Subject:Date:From;
        b=u5UEcT/3JCJxWVp+tf+QGHkOfnCm+N9pGz/Gv9kuG2esa/WBikjhBss0TH9/++Lnn
         wsQb3tQGxXaBFaY/s5oEb4ofBpwXtAQs9ZFUitXigQBgee0xL0LX+j8E/es2a8pBJ+
         EfSSfO0ylIVYdCi+Fjdwn5was5AMjVdgQtp0eLks=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 0/5] add more xdp stats to veth driver
Date:   Thu, 19 Mar 2020 17:41:24 +0100
Message-Id: <cover.1584635611.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align veth xdp stats accounting to mellanox, intel and marvell
implementation. Introduce the following xdp counters:
- rx_xdp_tx
- rx_xdp_tx_errors
- tx_xdp_xmit
- tx_xdp_xmit_errors
- rx_xdp_redirect

Lorenzo Bianconi (5):
  veth: move xdp stats in a dedicated structure
  veth: introduce more specialized counters in veth_stats
  veth: distinguish between rx_drops and xdp_drops
  veth: introduce more xdp counters
  veth: remove atomic64_add from veth_xdp_xmit hotpath

 drivers/net/veth.c | 174 ++++++++++++++++++++++++++++-----------------
 1 file changed, 110 insertions(+), 64 deletions(-)

-- 
2.25.1

