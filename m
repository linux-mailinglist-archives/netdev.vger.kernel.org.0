Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C551629E8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRPym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:54:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbgBRPym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:54:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582041280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R8B7btjReU6qVqxwjEIY1YJ+fv46JUdfE/jDnMX3JJQ=;
        b=WLY3VuQnssOebvYWG8KVDv8JIHwThnJZz4BpE0Ng+GozEOGUuopAnQAwkFA5BYtUNf/Q6b
        8Ad+NMPDsxsAoqu9ztWJzJLeaRmLihNvBo78H/8x/rNR+iQlcOUp+7mZxDUGKc/9po2eIa
        czHJKl6XGJXLoJ+fhkr1yFCHzeGav30=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-Gla1TV-xMp2MEx_G9Q0X9g-1; Tue, 18 Feb 2020 10:54:38 -0500
X-MC-Unique: Gla1TV-xMp2MEx_G9Q0X9g-1
Received: by mail-wr1-f72.google.com with SMTP id v17so10954837wrm.17
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 07:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R8B7btjReU6qVqxwjEIY1YJ+fv46JUdfE/jDnMX3JJQ=;
        b=FbzDDM1Ypw1EjQXfDN0dw017ckOHRm9Rk94zQ5+ZWHB7LEVyFAm3VuefiBTH5gI+V3
         TnguWEur3qlLXDfbaKUNBe8LiSjynll3uonaWA8ZuCtsJkrT3+likcYPZ6Wj2Uclrzpl
         ILZGfkbFxI+5RSMOogtT3QbvABMXrwXfX57oppqIe1XiMKHKhpY20qsqpMyhtjzj5G2Y
         cbAjkkQuAPciPH5ZTWyoPpO2yFnklfOglwqqhERwcRi94U3dQuBfpL0aBY8VEkSK0BvB
         K+mDJMc7wMBS5/UrMUeGjH6oLeQNteNpTCpzDnD7G/ti02u/ecRSgwrtZlay5f1x0tFS
         emAQ==
X-Gm-Message-State: APjAAAUwdHEYaeOFWrQF0IMREzwlPpqCgodsKGC8EoHsdhlcHYJb4/ZU
        g+DBD+AQLlcID6xhzXfvvv2Yj21rs4ch3DxaRe8Ksp3QJYSp4IRAAoyY2S3w6iDL95gj/Dzigl/
        E4cPtQHsngMKPQvbn
X-Received: by 2002:a1c:7203:: with SMTP id n3mr3829525wmc.119.1582041277439;
        Tue, 18 Feb 2020 07:54:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwVMLwmI9lWeEdC/itvflVDqN7kJuopZW0hKDhTbHjVqtZfY5KD1vTHmGpoCxwXqLyXhxMdmQ==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr3829507wmc.119.1582041277173;
        Tue, 18 Feb 2020 07:54:37 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id f1sm6678029wro.85.2020.02.18.07.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 07:54:36 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     mtk.manpages@gmail.com
Cc:     Jorgen Hansen <jhansen@vmware.com>, netdev@vger.kernel.org,
        linux-man@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v4] vsock.7: add VMADDR_CID_LOCAL description
Date:   Tue, 18 Feb 2020 16:54:35 +0100
Message-Id: <20200218155435.172860-1-sgarzare@redhat.com>
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

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v4:
    * removed "The" in the "Local communication" section [Stefan]
v3:
    * rephrased "Previous versions" part [Jorgen]
v2:
    * rephrased "Local communication" description [Stefan]
    * added a mention of previous versions that supported
      loopback only in the guest [Stefan]
---
 man7/vsock.7 | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/man7/vsock.7 b/man7/vsock.7
index c5ffcf07d..fa2c6e17e 100644
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
@@ -164,6 +164,15 @@ Consider using
 .B VMADDR_CID_ANY
 when binding instead of getting the local CID with
 .BR IOCTL_VM_SOCKETS_GET_LOCAL_CID .
+.SS Local communication
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
@@ -222,6 +231,11 @@ are valid.
 Support for VMware (VMCI) has been available since Linux 3.9.
 KVM (virtio) is supported since Linux 4.8.
 Hyper-V is supported since Linux 4.14.
+.PP
+VMADDR_CID_LOCAL is supported since Linux 5.6.
+Local communication in the guest and on the host is available since Linux 5.6.
+Previous versions only supported local communication within a guest
+(not on the host), and only with some transports (VMCI and virtio).
 .SH SEE ALSO
 .BR bind (2),
 .BR connect (2),
-- 
2.24.1

