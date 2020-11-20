Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A48E2BA525
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgKTIxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:53:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbgKTIxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 03:53:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605862400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ya3dNIkAZY6iHGGxpdSqGojKvsyjgILmiyBq9POOMuQ=;
        b=PGdw6ueEYNb4gRRd4LKLhySTHA4yj2Up03wSw4dlSJXMZQW/P54q5SzfhYWFCXspkOJSoW
        vV3ZdO1E1b0zgdMnw7tEUMZXULnyHzylbeD7akNYl7Bdy2/sppb8G3fgNX6ZlhfG/IxHvk
        VBYYFzZWxapRoQvBpV2ykhgKS4NO4KI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-QGyMsmvSMg-IJfh8GCbblQ-1; Fri, 20 Nov 2020 03:53:16 -0500
X-MC-Unique: QGyMsmvSMg-IJfh8GCbblQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56A17801B14;
        Fri, 20 Nov 2020 08:53:14 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C6A860BE2;
        Fri, 20 Nov 2020 08:53:11 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D12EE3213845D;
        Fri, 20 Nov 2020 09:53:09 +0100 (CET)
Subject: [PATCH net-next V3] MAINTAINERS: Update XDP and AF_XDP entries
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        joe@perches.com
Date:   Fri, 20 Nov 2020 09:53:09 +0100
Message-ID: <160586238944.2808432.4401269290440394008.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting too many false positive matches with current use
of the content regex K: and file regex N: patterns.

This patch drops file match N: and makes K: more restricted.
Some more normal F: file wildcards are added.

Notice that AF_XDP forgot to some F: files that is also
updated in this patch.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 MAINTAINERS |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index af9f6a3ab100..f827f504251b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19105,12 +19105,17 @@ L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
 F:	include/net/xdp.h
+F:	include/net/xdp_priv.h
 F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
 F:	kernel/bpf/devmap.c
 F:	net/core/xdp.c
-N:	xdp
-K:	xdp
+F:	samples/bpf/xdp*
+F:	tools/testing/selftests/bpf/*xdp*
+F:	tools/testing/selftests/bpf/*/*xdp*
+F:	drivers/net/ethernet/*/*/*/*/*xdp*
+F:	drivers/net/ethernet/*/*/*xdp*
+K:	(?:\b|_)xdp(?:\b|_)
 
 XDP SOCKETS (AF_XDP)
 M:	Björn Töpel <bjorn.topel@intel.com>
@@ -19119,9 +19124,12 @@ R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/af_xdp.rst
 F:	include/net/xdp_sock*
 F:	include/net/xsk_buff_pool.h
 F:	include/uapi/linux/if_xdp.h
+F:	include/uapi/linux/xdp_diag.h
+F:	include/net/netns/xdp.h
 F:	net/xdp/
 F:	samples/bpf/xdpsock*
 F:	tools/lib/bpf/xsk*


