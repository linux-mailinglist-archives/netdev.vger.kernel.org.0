Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6801D1069CF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 11:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfKVKUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 05:20:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726698AbfKVKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 05:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574418023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZWq3HtktWgJiFGS3sKMs6SJfF4IhV0hkiIXQfhIWWkw=;
        b=ABeki+SiYm+oP9XUe8/M+uq9C52JcoEYO66iidJsvBDesu4J+XYxo82O0yAG5wo1x77KW4
        d5qjnpgi96T1mlJvk+E61gq4vMHCyXvOIitVRuWRcrBoxnFsKqBotpocUolmQFH85U2890
        D90LAeyvwWH3u7l2+QFfI/fuyoiCQU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-t6X-cLIQOaisNykJdAq6Fw-1; Fri, 22 Nov 2019 05:20:19 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93475107ACC4;
        Fri, 22 Nov 2019 10:20:18 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-116.ams2.redhat.com [10.36.117.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A10014145;
        Fri, 22 Nov 2019 10:20:11 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] MAINTAINERS: Add myself as maintainer of virtio-vsock
Date:   Fri, 22 Nov 2019 11:20:10 +0100
Message-Id: <20191122102010.14346-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: t6X-cLIQOaisNykJdAq6Fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since I'm actively working on vsock and virtio/vhost transports,
Stefan suggested to help him to maintain it.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 993d4e1d4974..077c4ba438cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17212,6 +17212,7 @@ F:=09virt/lib/
=20
 VIRTIO AND VHOST VSOCK DRIVER
 M:=09Stefan Hajnoczi <stefanha@redhat.com>
+M:=09Stefano Garzarella <sgarzare@redhat.com>
 L:=09kvm@vger.kernel.org
 L:=09virtualization@lists.linux-foundation.org
 L:=09netdev@vger.kernel.org
--=20
2.21.0

