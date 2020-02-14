Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1415D7F0
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgBNNH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:07:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726191AbgBNNH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 08:07:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581685675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1832xFEQ/vqOUquw3BW7qf1Tz86S2ygW8Q27WNGEQwM=;
        b=h3dHIGSXVXXSOZ8dG71ZePINL4PpBi9q/4EfPLEM2VDmYuMKywbewjakEtL+kBPy4EV8BX
        eTVKA2UNvlpQ1+c9eP/SvoN98zeHLBqZlxrhEbRDJWFoDAQhoq7UNvzbKCWPDH92ot0+uI
        wF5M6rD5SbAi3MI2gnjeL7bq4AS8HTQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-G1g_rkKnO5ac3d_jcJDXqQ-1; Fri, 14 Feb 2020 08:07:53 -0500
X-MC-Unique: G1g_rkKnO5ac3d_jcJDXqQ-1
Received: by mail-wm1-f72.google.com with SMTP id b8so833619wmj.0
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 05:07:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1832xFEQ/vqOUquw3BW7qf1Tz86S2ygW8Q27WNGEQwM=;
        b=QM9fSgPUwd/x4KVxraCF6U+x2kb0jqTYlfhlOStZXt5QPidUmhsMgJcN9vXpw1Nd42
         sOsmcOfSIgCn9FdQVvkAVjLM/0z44SjsV/+Mjqxa8cSNuchJO/anEyF0hHAOrvsCn/kr
         ZOtb7pH0c/zzj4vOhJKl15fTtUILkwyvasfS/DBLp1qzPK4JHzJKH/sNuzWu2r+wqtkz
         FMfHu8tNj1Q8NGtj8sDyalpy+tbcAjv9VUJ2QYqAJR3DKo9wGsRyoG8hiI+7pVD48Rru
         FsI9+7Ov8+VoPGmsI73s0Kc/tPuce4UHp2zR2jstypAXPvdpS0f8BoNaed1fsrnlRteC
         NUcg==
X-Gm-Message-State: APjAAAUN2e8BRmGoNu+xJRn0Rs9yioPVmiMlS9XhMm2l54Z+GZdkFUrT
        FKN1nqBXs6Ek0HWwHHzIqAepkNHDZmzl681PhZbBge+vfLeHMnJu1bFjSDf9TFwCRlqVGIKFSB7
        SRMQ7hJgjJRoyI/nl
X-Received: by 2002:adf:f0cb:: with SMTP id x11mr4034074wro.421.1581685672334;
        Fri, 14 Feb 2020 05:07:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1+X/LSGJbNFIQIc0zspTRiuWA1SmDcQRTsI0AIgtgMfeDii0ltH/9WQWfhAhTpVQxi8z8YA==
X-Received: by 2002:adf:f0cb:: with SMTP id x11mr4034045wro.421.1581685672067;
        Fri, 14 Feb 2020 05:07:52 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id g15sm6689333wro.65.2020.02.14.05.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 05:07:51 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     mtk.manpages@gmail.com
Cc:     Jorgen Hansen <jhansen@vmware.com>, linux-man@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org
Subject: [PATCH v2] vsock.7: add VMADDR_CID_LOCAL description
Date:   Fri, 14 Feb 2020 14:07:49 +0100
Message-Id: <20200214130749.126603-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux 5.6 added the new well-known VMADDR_CID_LOCAL for
local communication.

This patch explains how to use it and remove the legacy
VMADDR_CID_RESERVED no longer available.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
    * rephrased "Local communication" description [Stefan]
    * added a mention of previous versions that supported
      loopback only in the guest [Stefan]
---
 man7/vsock.7 | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/man7/vsock.7 b/man7/vsock.7
index c5ffcf07d..78ac22b1e 100644
--- a/man7/vsock.7
+++ b/man7/vsock.7
@@ -127,8 +127,8 @@ There are several special addresses:
 means any address for binding;
 .B VMADDR_CID_HYPERVISOR
 (0) is reserved for services built into the hypervisor;
-.B VMADDR_CID_RESERVED
-(1) must not be used;
+.B VMADDR_CID_LOCAL
+(1) is the well-known address for local communication (loopback);
 .B VMADDR_CID_HOST
 (2)
 is the well-known address of the host.
@@ -164,6 +164,16 @@ Consider using
 .B VMADDR_CID_ANY
 when binding instead of getting the local CID with
 .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
+.SS Local communication
+The
+.B VMADDR_CID_LOCAL
+(1) directs packets to the same host that generated them. This is useful
+for testing applications on a single host and for debugging.
+.PP
+The local CID obtained with
+.BR IOCTL_VM_SOCKETS_GET_LOCAL_CID
+can be used for the same purpose, but it is preferable to use
+.B VMADDR_CID_LOCAL .
 .SH ERRORS
 .TP
 .B EACCES
@@ -222,6 +232,11 @@ are valid.
 Support for VMware (VMCI) has been available since Linux 3.9.
 KVM (virtio) is supported since Linux 4.8.
 Hyper-V is supported since Linux 4.14.
+.PP
+VMADDR_CID_LOCAL is supported since Linux 5.6.
+Local communication in the guest and on the host is available since Linux 5.6.
+Previous versions partially supported it only in the guest and only with some
+transports (VMCI and virtio).
 .SH SEE ALSO
 .BR bind (2),
 .BR connect (2),
-- 
2.24.1

