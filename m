Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1C7193107
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgCYTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:34730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727174AbgCYTWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 15:22:18 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.139.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6529A206F6;
        Wed, 25 Mar 2020 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585164137;
        bh=1VBzrk25oOp/78Q9hLTJkAhHmZlZ9AGq6mxBW/88+H0=;
        h=From:To:Cc:Subject:Date:From;
        b=jFtYONDqX+uB86BvAsz2FzaCN++ZcSTMkDz9UZ8ldlrkQpAS7hfCUbo03yqQxBznh
         ZcEXGdoSNl3yyrqTIgFFklV7FtqVLE9tl8IjId+Pyo0oRoO/rbpzybP0caILV+6SQG
         Fp60pdOaTtus1uij6xiU4irMDKUrBPHMugLgA3ug=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, toshiaki.makita1@gmail.com, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: [PATCH net-next 0/2] move ndo_xdp_xmit stats to peer veth_rq
Date:   Wed, 25 Mar 2020 20:22:04 +0100
Message-Id: <cover.1585163874.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ndo_xdp_xmit ethtool stats accounting to peer veth_rq.
Move XDP_TX accounting to veth_xdp_flush_bq routine.

Lorenzo Bianconi (2):
  veth: rely on veth_rq in veth_xdp_flush_bq signature
  veth: rely on peer veth_rq for ndo_xdp_xmit accounting

 drivers/net/veth.c | 143 ++++++++++++++++++++++++++++-----------------
 1 file changed, 89 insertions(+), 54 deletions(-)

-- 
2.25.1

