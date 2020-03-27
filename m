Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7793319558A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgC0Kp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:45:29 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30135 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgC0Kp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:45:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585305928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jt16yL+4ZRfyITC9f44NOc4gH24PyhKW5jFfk+8hDNc=;
        b=bNPM2xybJf7H6I/elgwj8qUzJhFEPj9M023PPLCB31ezY9Qyk0pydQOBiy0yeUAjGh63cU
        tOlOdgZgQ7uu7sSt1StmL9iCMY/IfDGTjq6rUeql/EdD0HG3lT5uR88FTw5vKyNxoIAfMO
        9lzv3FjqmGe5+OhXpbMuNUibShpUed4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-8SeIilmrMU6TKS7F14kxmA-1; Fri, 27 Mar 2020 06:45:25 -0400
X-MC-Unique: 8SeIilmrMU6TKS7F14kxmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EE8B107ACC7;
        Fri, 27 Mar 2020 10:45:24 +0000 (UTC)
Received: from renaissance-vector.redhat.com (ovpn-114-239.ams2.redhat.com [10.36.114.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A481CDBC1;
        Fri, 27 Mar 2020 10:45:22 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] man: bridge.8: fix bridge link show description
Date:   Fri, 27 Mar 2020 11:45:12 +0100
Message-Id: <526ddb1d57a6b054809fc9c0e33ff947fbe4bbe0.1585305448.git.aclaudi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple bridges are present, 'bridge link show' diplays ports
for all bridges. Make this clear in the command description, and
point out the user to the ip command to display ports for a specific
bridge.

Reported-by: Marc Muehlfeld <mmuehlfe@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 man/man8/bridge.8 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 1804f0b42b2b6..b9bd6bc5c7141 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -420,9 +420,12 @@ link setting is configured on the software bridge (d=
efault)
 .BR "\-t" , " \-timestamp"
 display current time when using monitor option.
=20
-.SS bridge link show - list bridge port configuration.
+.SS bridge link show - list ports configuration for all bridges.
=20
-This command displays the current bridge port configuration and flags.
+This command displays port configuration and flags for all bridges.
+
+To display port configuration and flags for a specific bridge, use the
+"ip link show master <bridge_device>" command.
=20
 .SH bridge fdb - forwarding database management
=20
--=20
2.25.1

