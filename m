Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B027F380CAA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 17:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhENPRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 11:17:53 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:45876 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhENPRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 11:17:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UYrw9fr_1621005397;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UYrw9fr_1621005397)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 May 2021 23:16:38 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net 0/2] virtio-net: fix for build_skb()
Date:   Fri, 14 May 2021 23:16:35 +0800
Message-Id: <20210514151637.117596-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
  virtio-net: get build_skb() buf by data ptr

 drivers/net/virtio_net.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--
2.31.0

