Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D381618D5
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgBQRb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:31:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39938 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728575AbgBQRb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581960687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RDNr8uSJFx59Jhf7UFuMY4MdIqV6VZNKPmJEIQeiPFg=;
        b=PSFsu9BqksDSDC5Xsvpv34YO/dsbThoB1edttJVfTIBLFyqR98G0prdEtrW+6G1zAlH+6a
        bZSjGPiY97UCawkgNDVUm5fZuOTXNOaamvREoyIYsJOKsvsg8IIER1KP+W1gAxl06NyxDU
        HtxnIy4PR1MRCV3Tx0oh6CHqZWgD5Ms=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-x0g0exzkOw2591G_SPVGAA-1; Mon, 17 Feb 2020 12:31:26 -0500
X-MC-Unique: x0g0exzkOw2591G_SPVGAA-1
Received: by mail-wm1-f72.google.com with SMTP id p2so62717wma.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 09:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RDNr8uSJFx59Jhf7UFuMY4MdIqV6VZNKPmJEIQeiPFg=;
        b=HDk5tjp6JHInCE1h+F1I4Xinal8DakCWqopikDGVBbBmSGkV/gI5F6d3cSzN4do7wR
         Ys3sRbVr9J6rmRogt0MVuMHB7WzIlYbanjAL6VbFdizuzwio0RLBKegLkTKEBrcBEoTz
         Dc29RIRy+8br5Zb5KfE8DEATESMxGS041wlGoTgjfRgVGdf5ADtyglx3szpLBGsZbRGB
         tFMz97zvbvPfRfeqnJ7TahvFaO3MaQ1r0oLY8gSJCmgo+5b9TUz+wnHcaGT3gLA6kbDo
         8EGu2F/UXmzvQlxgF3IvV3ROwHOJ+83Ine6JOqIjeHL4vH4Wy3Lo2vTtGLiU75sRQkN8
         OQ/Q==
X-Gm-Message-State: APjAAAWMJz/EfVrNnK7suOZz/3C462FhBaZSVpNYZdTV1BA7zQgrAzXO
        h1O+g9MDDQKItjgBcaPxXIH66eqRYAYDq78vuxXsxR0wh/GhfUGh8lR8auJA4rpht1xem3iQljS
        QUwrgeh1g8yL+5mlc
X-Received: by 2002:a1c:a9c4:: with SMTP id s187mr83150wme.97.1581960684883;
        Mon, 17 Feb 2020 09:31:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqydEgIaLAMeg8L3wmkxuEFr+1Usg0RMHSX1PoJkBi8Zw0lHfES2eqo1OOcB+81A9ChrE+B7Jw==
X-Received: by 2002:a1c:a9c4:: with SMTP id s187mr83076wme.97.1581960683665;
        Mon, 17 Feb 2020 09:31:23 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id b13sm1924870wrq.48.2020.02.17.09.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:31:23 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     mtk.manpages@gmail.com
Cc:     linux-man@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>, netdev@vger.kernel.org
Subject: [PATCH v3] vsock.7: add VMADDR_CID_LOCAL description
Date:   Mon, 17 Feb 2020 18:31:21 +0100
Message-Id: <20200217173121.159132-1-sgarzare@redhat.com>
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
v3:
    * rephrased "Previous versions" part [Jorgen]
v2:
    * rephrased "Local communication" description [Stefan]
    * added a mention of previous versions that supported
      loopback only in the guest [Stefan]
---
 man7/vsock.7 | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/man7/vsock.7 b/man7/vsock.7
index c5ffcf07d..219e3505f 100644
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
+Previous versions only supported local communication within a guest
+(not on the host), and only with some transports (VMCI and virtio).
 .SH SEE ALSO
 .BR bind (2),
 .BR connect (2),
-- 
2.24.1

