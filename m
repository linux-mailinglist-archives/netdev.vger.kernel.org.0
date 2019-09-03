Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F9CA62C2
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 09:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfICHiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 03:38:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbfICHiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 03:38:22 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CC83882FB
        for <netdev@vger.kernel.org>; Tue,  3 Sep 2019 07:38:22 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id v143so3881510qka.21
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 00:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=a2jRYEYJXw6y2ArAic1WZqLdnynYivPxAhcNn14RG7c=;
        b=scVcToe4X2Wf7tSaMZ6XoinLUhng757weXwFIdkx70JFHVnJ0pw9skAQrkgIAYZ9hY
         Ly4lGVN1v8OGbf7ktRys+TGsZ1+A6BBIVqGJ0PdGIvl0LeGAxYMH52FIEGvEJue726Ho
         shhUQICQZWTa2ZF8o1/jLOPhDFJdBZucziTHzPOpLhOrczzGDZhkJEoG7e7SCDH9A4ft
         USYyWFiFLEQL08O6JzkKCpMEoyBGE2O9oK2kB6GMLBonaUYi5Ki3iNYUgd0qkVm4bwfl
         dQQgaYnuZMOK4SABaVGsYdQKFkLfTirHCV2tWB0x8lRMtH2x8JS/0oT9odZ8A5WfASwU
         zznw==
X-Gm-Message-State: APjAAAUDvYU9RjCoPZPg+CST5sRjm0HEsEcYEU0soF2q+KooXRXzWTmx
        cv3/moYSz+a6n4ypVAO/BNJ0Arqj6S5m0Ubs2tSWR0FdvSM9zBV3KMOoIbEhcGPcHKu/qgd00Nq
        4cUlpYjd/ob1ho8Yd
X-Received: by 2002:a37:916:: with SMTP id 22mr14382509qkj.45.1567496301058;
        Tue, 03 Sep 2019 00:38:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEnVPgjH8NbtZ+KbyL7PJmWdEblMSRWxEsCgtDKuaFkqs5CZdV4JoHPHabqe6W7wY2j8VAvw==
X-Received: by 2002:a37:916:: with SMTP id 22mr14382497qkj.45.1567496300910;
        Tue, 03 Sep 2019 00:38:20 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id 1sm8725515qko.73.2019.09.03.00.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 00:38:19 -0700 (PDT)
Date:   Tue, 3 Sep 2019 03:38:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net-next] vsock/virtio: a better comment on credit update
Message-ID: <20190903073748.25214-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment we have is just repeating what the code does.
Include the *reason* for the condition instead.

Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 94cc0fa3e848..5bb70c692b1e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -307,8 +307,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 
 	spin_unlock_bh(&vvs->rx_lock);
 
-	/* We send a credit update only when the space available seen
-	 * by the transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE
+	/* To reduce the number of credit update messages,
+	 * don't update credits as long as lots of space is available.
+	 * Note: the limit chosen here is arbitrary. Setting the limit
+	 * too high causes extra messages. Too low causes transmitter
+	 * stalls. As stalls are in theory more expensive than extra
+	 * messages, we set the limit to a high value. TODO: experiment
+	 * with different values.
 	 */
 	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
 		virtio_transport_send_credit_update(vsk,
-- 
MST
