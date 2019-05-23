Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C7427B31
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 12:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfEWK6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 06:58:11 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35434 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEWK6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 06:58:11 -0400
Received: from vc1.ecl.ntt.co.jp (vc1.ecl.ntt.co.jp [129.60.86.153])
        by tama500.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4NAvixo029942;
        Thu, 23 May 2019 19:57:44 +0900
Received: from vc1.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id 09A79EA8074;
        Thu, 23 May 2019 19:57:44 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id F3086EA8073;
        Thu, 23 May 2019 19:57:43 +0900 (JST)
Received: from makita-ubuntu.m.ecl.ntt.co.jp (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id DC29A4007AA;
        Thu, 23 May 2019 19:57:43 +0900 (JST)
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Subject: [PATCH bpf-next 0/3] veth: Bulk XDP_TX
Date:   Thu, 23 May 2019 19:56:45 +0900
Message-Id: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-Mailer: git-send-email 2.7.4
X-CC-Mail-RelayStamp: 1
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an infrastructure for bulk XDP_TX and makes veth use it.
Improves XDP_TX performance by approximately 8%. The detailed
performance numbers are shown in patch 3.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

Toshiaki Makita (3):
  xdp: Add bulk XDP_TX queue
  xdp: Add tracepoint for bulk XDP_TX
  veth: Support bulk XDP_TX

 drivers/net/veth.c         | 26 +++++++++++++++++++++++++-
 include/net/xdp.h          |  7 +++++++
 include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 net/core/xdp.c             |  3 +++
 5 files changed, 61 insertions(+), 1 deletion(-)

-- 
1.8.3.1


