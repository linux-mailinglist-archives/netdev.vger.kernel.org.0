Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2562DC720
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388759AbgLPTdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388753AbgLPTdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:02 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com
Subject: [PATCH bpf-next 0/2] add xdp_build_skb_from_frame utility routine
Date:   Wed, 16 Dec 2020 19:38:32 +0100
Message-Id: <cover.1608142960.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame routines to
build the skb from a xdp_frame. Respect to __xdp_build_skb_from_frame,
xdp_build_skb_from_frame will allocate the skb object.
Rely on __xdp_build_skb_from_frame/xdp_build_skb_from_frame in cpumap and veth
code.

Lorenzo Bianconi (2):
  net: xdp: introduce __xdp_build_skb_from_frame utility routine
  net: xdp: introduce xdp_build_skb_from_frame utility routine

 drivers/net/veth.c  | 18 +++-----------
 include/net/xdp.h   |  5 ++++
 kernel/bpf/cpumap.c | 45 +---------------------------------
 net/core/xdp.c      | 59 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 59 deletions(-)

-- 
2.29.2

