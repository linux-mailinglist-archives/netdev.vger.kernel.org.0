Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574E2F38D4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392090AbhALS1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390350AbhALS1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 13:27:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7C202311A;
        Tue, 12 Jan 2021 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610475984;
        bh=nzSqKmq2VL+tGEnevlVhWuU1PSyAMFx7sRj50ycZJx0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZA7mjb6tQZdsefgrbXX6EpiI94Ts3jkIzhO2Eg9EXdEwbntqlPRQqa6ZLljLxcXjG
         D4j0AejPCC8ztBd/n22L7xhq73nLXS4U/rpqx2nEwFT+cU/uO4Aot0/X9adnW4RYPK
         VPB94kXySHu/JrD2Q/7Lk42EnvCYK0KbFjWCb4CshNUFlY3gOrHf8AGX5nLfr35s9I
         osISkljgjr/cfOF6qFHjwhbjgMrZHng+kq9JLAtQ3n4W5zxudK2CQ56+E5G6PaUxNC
         ofnIzGnppiUKaS2dZLLqqy1j0b1Dn7PElKUyrBiXRqfkrrCKcTBxKEmWD/oU8kcNEI
         7PpO7GprsFEvg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com
Subject: [PATCH v2 bpf-next 0/2] add xdp_build_skb_from_frame utility routine
Date:   Tue, 12 Jan 2021 19:26:11 +0100
Message-Id: <cover.1610475660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame routines
to build the skb from a xdp_frame. Respect to __xdp_build_skb_from_frame,
xdp_build_skb_from_frame will allocate the skb object.
Rely on __xdp_build_skb_from_frame/xdp_build_skb_from_frame in cpumap and
veth code.

Changes since v1:
- fix a checkpatch warning
- improve commit log in patch 2/2

Lorenzo Bianconi (2):
  net: xdp: introduce __xdp_build_skb_from_frame utility routine
  net: xdp: introduce xdp_build_skb_from_frame utility routine

 drivers/net/veth.c  | 18 +++-----------
 include/net/xdp.h   |  5 ++++
 kernel/bpf/cpumap.c | 46 ++---------------------------------
 net/core/xdp.c      | 59 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 59 deletions(-)

-- 
2.29.2

