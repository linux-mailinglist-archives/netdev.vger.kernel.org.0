Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743403ACC58
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhFRNhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:37:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233894AbhFRNhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624023337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7mCct73RnwgXH1BQ0EFrvsasGFgPM8gKKeeGJpCib/k=;
        b=iRQNTu3CxpS6Y7epRY2/yekAsTpaBrlXax2qY63ldpETfAxlfncxq2tFjj9ywsKdGnSHt6
        /ws5uRY1gH7/1/Dy6oGPperRPMEfsgYhUVUMOVyaO3DLwjvdXjlgbb0SDYs2DW23kdBf5a
        19jdNSQ+Sga005WlFvu7o/Ivx3nYADg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-BPaOIvFPP9q6xV0MS2lJkQ-1; Fri, 18 Jun 2021 09:35:35 -0400
X-MC-Unique: BPaOIvFPP9q6xV0MS2lJkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3949D802C8A;
        Fri, 18 Jun 2021 13:35:34 +0000 (UTC)
Received: from steredhat.lan (ovpn-115-127.ams2.redhat.com [10.36.115.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D561000324;
        Fri, 18 Jun 2021 13:35:27 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] vsock: small fixes for seqpacket support
Date:   Fri, 18 Jun 2021 15:35:23 +0200
Message-Id: <20210618133526.300347-1-sgarzare@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains few patches to clean up a bit the code
of seqpacket recently merged in the net-next tree.

No functionality changes.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Stefano Garzarella (3):
  vsock: rename vsock_has_data()
  vsock: rename vsock_wait_data()
  vsock/virtio: remove redundant `copy_failed` variable

 net/vmw_vsock/af_vsock.c                | 18 ++++++++++--------
 net/vmw_vsock/virtio_transport_common.c |  7 ++-----
 2 files changed, 12 insertions(+), 13 deletions(-)

-- 
2.31.1

