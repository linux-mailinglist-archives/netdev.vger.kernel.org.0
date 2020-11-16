Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7452B4A9B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbgKPQRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:17:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730837AbgKPQRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:17:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605543425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qiy7dPJkCedncPHfKBWxJXduYz70r7PiHicBol/8nJM=;
        b=WT9lP1CgEipIaqRr/5gr9oDQf5oBlWqYItdvsBcl26KaLANGNdXBiHsJ0S4YqCjT7/S+MU
        1piiu0grS5UYk7o+wIZsRVD/seMbw/TULokMuofdzie3BBhdYcXtryICuTbUqVXk8RaHlz
        uCoU6CmmHFuTNwMSRsvNomStgcZuvYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-8l_JSKdHMz-YnAKe83Dk9A-1; Mon, 16 Nov 2020 11:17:00 -0500
X-MC-Unique: 8l_JSKdHMz-YnAKe83Dk9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76C151868425;
        Mon, 16 Nov 2020 16:16:59 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-123.ams2.redhat.com [10.36.113.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E97255C5B0;
        Mon, 16 Nov 2020 16:16:54 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH] vringh: fix vringh_iov_push_*() documentation
Date:   Mon, 16 Nov 2020 17:16:53 +0100
Message-Id: <20201116161653.102904-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vringh_iov_push_*() functions don't have 'dst' parameter, but have
the 'src' parameter.

Replace 'dst' description with 'src' description.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 8bd8b403f087..b7403ba8e7f7 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -730,7 +730,7 @@ EXPORT_SYMBOL(vringh_iov_pull_user);
 /**
  * vringh_iov_push_user - copy bytes into vring_iov.
  * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
- * @dst: the place to copy.
+ * @src: the place to copy from.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
@@ -976,7 +976,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
 /**
  * vringh_iov_push_kern - copy bytes into vring_iov.
  * @wiov: the wiov as passed to vringh_getdesc_kern() (updated as we consume)
- * @dst: the place to copy.
+ * @src: the place to copy from.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL(vringh_iov_pull_iotlb);
  * vringh_iov_push_iotlb - copy bytes into vring_iov.
  * @vrh: the vring.
  * @wiov: the wiov as passed to vringh_getdesc_iotlb() (updated as we consume)
- * @dst: the place to copy.
+ * @src: the place to copy from.
  * @len: the maximum length to copy.
  *
  * Returns the bytes copied <= len or a negative errno.
-- 
2.26.2

