Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88D3125025
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfLRSHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:07:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727474AbfLRSH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8qrytZMVdHBi4BdEHQin5N9/kMWlYC5/mlW+wdXOXw=;
        b=YvoIhn7OMa9FYXAxQtGbL7ooJOIxrvLsSBs0xrBLs+9fT7ozdy7voU3YBSqw2PV5JsoAun
        f/znVuIvFgcAVCJsg8XLJGTRBOIW6FaZTuAi5gWDxTmabtSNY/VtO0NmvJ6VQFXNZa9fFc
        ez7WCUDpIAAPbvx59TdZMQ9xE27CraY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-rwlitvt8O5W6vyhltMDwnw-1; Wed, 18 Dec 2019 13:07:24 -0500
X-MC-Unique: rwlitvt8O5W6vyhltMDwnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 113F38024F7;
        Wed, 18 Dec 2019 18:07:23 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFB7B5D9E2;
        Wed, 18 Dec 2019 18:07:18 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 02/11] VSOCK: add SPDX identifiers to vsock tests
Date:   Wed, 18 Dec 2019 19:06:59 +0100
Message-Id: <20191218180708.120337-3-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
 * Aligned with the current SPDX [Stefano]
---
 tools/testing/vsock/control.h | 1 +
 tools/testing/vsock/timeout.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/vsock/control.h b/tools/testing/vsock/control.=
h
index 54a07efd267c..dac3964a891d 100644
--- a/tools/testing/vsock/control.h
+++ b/tools/testing/vsock/control.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef CONTROL_H
 #define CONTROL_H
=20
diff --git a/tools/testing/vsock/timeout.h b/tools/testing/vsock/timeout.=
h
index 77db9ce9860a..ecb7c840e65a 100644
--- a/tools/testing/vsock/timeout.h
+++ b/tools/testing/vsock/timeout.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef TIMEOUT_H
 #define TIMEOUT_H
=20
--=20
2.24.1

