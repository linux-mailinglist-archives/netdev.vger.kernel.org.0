Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961AE1E9E3F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgFAG3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:29:55 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55897 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgFAG3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 02:29:54 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1be67a07;
        Mon, 1 Jun 2020 06:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=2zuchTBoDSMUVbmLnGT73qgl38M=; b=mYXrYjhtO4pa0Dmt1ToS
        Dv2jA84nDTOiI2Xegn7rQqKJwFqUJK9L0vvRAa5rTYKXC7hp8auUf/PwX/WcJeBt
        JV07lO4d7IRvIXKQA5I3yRDNV1nTfwNeYYSXd5FIGOG9T1IOMGTApe1MaWNN4SNB
        uosihbRtVZjwDxD5WZJWyMlLst1Huu5Nf3I7QUI8sesqBfWTchwNwN3mfkvWaM7D
        BfY1Ojgyko7CYKMdusSutYRgETXcUmkz5TdW2JxS76HOcKCt9gELzVJPE1F73O9l
        nDmaXeGFFP9T10bN9P3075ZW3xgXoLPUWQTqIdVlcrmnlg8bSk6DgMi5q2dWZZl6
        ag==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f3fed291 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 1 Jun 2020 06:13:53 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 0/1] wireguard column reformatting for end of cycle
Date:   Mon,  1 Jun 2020 00:29:45 -0600
Message-Id: <20200601062946.160954-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dave,

This is a series of 1, and the sole patch inside of it has justification
regarding that patch itself. But I thought I'd mention in the cover
letter that this is being sent right at the tail end of the net-next
cycle, before you close it tomorrow afternoon, so that when net-next
subsequently opens up, this patch has already made it to net, and we
don't have any hassles with merges. I realize that in general this isn't
the type of patch anyone really likes because of the merge hassle, but I
think the timing is right for it, and WireGuard is still young enough
that this should be still pretty easily possible.

Thanks,
Jason

Jason A. Donenfeld (1):
  wireguard: reformat to 100 column lines

 drivers/net/wireguard/allowedips.c           |  98 +++---
 drivers/net/wireguard/allowedips.h           |  22 +-
 drivers/net/wireguard/cookie.c               |  90 ++----
 drivers/net/wireguard/cookie.h               |  15 +-
 drivers/net/wireguard/device.c               |  69 ++--
 drivers/net/wireguard/messages.h             |  10 +-
 drivers/net/wireguard/netlink.c              | 143 +++------
 drivers/net/wireguard/noise.c                | 321 ++++++++-----------
 drivers/net/wireguard/noise.h                |  20 +-
 drivers/net/wireguard/peer.c                 |  92 +++---
 drivers/net/wireguard/peer.h                 |   3 +-
 drivers/net/wireguard/peerlookup.c           |  96 +++---
 drivers/net/wireguard/peerlookup.h           |  27 +-
 drivers/net/wireguard/queueing.c             |  14 +-
 drivers/net/wireguard/queueing.h             |  66 ++--
 drivers/net/wireguard/ratelimiter.c          |  39 +--
 drivers/net/wireguard/receive.c              | 162 ++++------
 drivers/net/wireguard/selftest/allowedips.c  | 164 ++++------
 drivers/net/wireguard/selftest/counter.c     |  13 +-
 drivers/net/wireguard/selftest/ratelimiter.c |  35 +-
 drivers/net/wireguard/send.c                 | 163 ++++------
 drivers/net/wireguard/socket.c               |  75 ++---
 drivers/net/wireguard/socket.h               |  30 +-
 drivers/net/wireguard/timers.c               | 110 +++----
 drivers/net/wireguard/timers.h               |   3 +-
 include/uapi/linux/wireguard.h               |  89 +++--
 26 files changed, 753 insertions(+), 1216 deletions(-)

-- 
2.26.2

