Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDAA158CAA
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 11:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgBKKZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 05:25:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57654 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728284AbgBKKZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 05:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581416738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MaKO/4RzA2khe3y4lY7ppPIXFRN7e9gTeNdzJG/BwUs=;
        b=O3q3uOKgqAmBcms7jJItIXuXikdp4QKfHH/X8FCqfaSlOdF0grwoYJ202CpDY2A58ZxTrD
        0f9P0TXkaWPeU/ojiyTljCzpJGoIRj+NUwpBret3adn1QfwAGFqhN/0cICWRwZ/HbOZCNk
        LA1bdYfRg3SffMMouAg60ENXTX9bDes=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-fmH5fYGAMiml45Chl9Rm8g-1; Tue, 11 Feb 2020 05:25:35 -0500
X-MC-Unique: fmH5fYGAMiml45Chl9Rm8g-1
Received: by mail-wr1-f72.google.com with SMTP id j4so6622684wrs.13
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 02:25:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MaKO/4RzA2khe3y4lY7ppPIXFRN7e9gTeNdzJG/BwUs=;
        b=o+XvClqI4u9kTCi8t52QW2ukM7yPYmwJhu5bGMtN28nC5oLVCg22lRI8KmeI/XSevY
         f1dK1+XvmLoqFhxGcUSyfD/S4UQogz3qcCP+nYjUPe42WSrtCXTGvVNJwMmpF5pdwXwY
         N4dsWZskgrtnAkeCzKUjtb2DxwMUUsFNkcLeT4OPq1tFYMk4L8FhNto+3kStMPEMzUqk
         OYUwpSgWT4V+L96pgvrug/pvbTUwjnR2n7JlMBOP3fEeL6sO4ZAXY9YiK6O6dMAFSyZV
         B06n1kr8jOni7dJs6HSVFMpcjuN3Jxfk5lRilxTB7nrKuWK5qlt/9BME1VISsTogKCl/
         CObw==
X-Gm-Message-State: APjAAAV0AYn6gvU1Svn4eVR0E8XXWotVnnLvuGdMd5i/3jMu7wjgsK+8
        XNkbVI5ylS6Dfep7YqV6QzVLaSwBPCvgbEfiVz6V2AJy07gIPS+Jt11rbVaNgpX0ghC/GVP9iH2
        EdLnhtZNN7qGEy2Go
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr4787126wma.24.1581416734369;
        Tue, 11 Feb 2020 02:25:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqwz0zddOWlFD9KufcFvIJHpG41yJOjdgVve70lwTZtnuC30FkQUxWHW8bBIOybJAmc0mxf4Zg==
X-Received: by 2002:a1c:41c4:: with SMTP id o187mr4787101wma.24.1581416734107;
        Tue, 11 Feb 2020 02:25:34 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id c4sm3076513wml.7.2020.02.11.02.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 02:25:33 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     mtk.manpages@gmail.com
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        linux-man@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH] vsock.7: add VMADDR_CID_LOCAL description
Date:   Tue, 11 Feb 2020 11:25:32 +0100
Message-Id: <20200211102532.56795-1-sgarzare@redhat.com>
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
 man7/vsock.7 | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/man7/vsock.7 b/man7/vsock.7
index c5ffcf07d..d7dc37dcc 100644
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
+(1) can be used to address itself. In this case all packets are redirected
+to the same host that generated them. Useful for testing and debugging.
+.PP
+The local CID obtained with
+.BR IOCTL_VM_SOCKETS_GET_LOCAL_CID
+can be used for the same purpose, but it is preferable to use
+.B VMADDR_CID_LOCAL .
 .SH ERRORS
 .TP
 .B EACCES
@@ -222,6 +232,8 @@ are valid.
 Support for VMware (VMCI) has been available since Linux 3.9.
 KVM (virtio) is supported since Linux 4.8.
 Hyper-V is supported since Linux 4.14.
+.PP
+VMADDR_CID_LOCAL is supported since Linux 5.6.
 .SH SEE ALSO
 .BR bind (2),
 .BR connect (2),
-- 
2.24.1

