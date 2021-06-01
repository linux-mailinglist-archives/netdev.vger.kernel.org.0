Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D546396D76
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAGln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:41:43 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49493 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231139AbhFAGln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 02:41:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UaqF-N8_1622529600;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UaqF-N8_1622529600)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Jun 2021 14:40:00 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net v2 0/2] virtio-net: fix for build_skb()
Date:   Tue,  1 Jun 2021 14:39:58 +0800
Message-Id: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#1 Fixed a serious error.
#2 Fixed a logical error, but this error did not cause any serious consequences.

The logic of this piece is really messy. Fortunately, my refactored patch can be
completed with a small amount of testing.

Thanks.

Xuan Zhuo (2):
  virtio-net: fix for unable to handle page fault for address
  virtio_net: get build_skb() buf by data ptr

 drivers/net/virtio_net.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--
2.31.0

