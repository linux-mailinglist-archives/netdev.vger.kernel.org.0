Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED24F59D7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbfKHV2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:28:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37690 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726819AbfKHV2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:28:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573248492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BVsCxrLwGFKT5ViAC7tTdmUQ37IBlMReGUdTqPDpm8A=;
        b=H5SLpKXHWhpTO1eahwj5/ZiQuW3w34K8N4fCWA2yrBB/9m1t0ejDco1dU+Dcbp/vDxFYZL
        hwmpPORkS6COU3BxUxOg38P5Q9efgEve5rNW+1QSh+sX4+rFBtnVURBfHmfVqHUKJaRH47
        lYAjuectEX4yORqmTg4ahB0RoZ5JI6s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-U2BZprmEPuidqOQcGv4zdg-1; Fri, 08 Nov 2019 16:28:08 -0500
Received: by mail-wm1-f71.google.com with SMTP id t203so3022922wmt.7
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:28:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=I/9bvgPG23qMrm8A4PH5h2TQ/NNvUhzpNw4cJ6eO9VI=;
        b=pXOQZ9QISc7cx7LfKVIZwxfjLRtQumiMEzwDqKcXPDv7LNF/qbV5TFtGfz82byg/oh
         ShRx7WLpdUKUOLapiAoGxAY5NFd929rBuWytIhmleTKzLTurU4BIk1Xe1ce9CVgWPR+f
         xfL9JTlrzw56yne9f/8Xy+AJVenJ8lf2dNP/dikz9IAIg3C0VJ74BKKS7Hkd/rsmRZr4
         A1ye7pxIc57ZfGtUXxhhFGRLbV4Z3/uTntQz809LFbGVi2w3iN/gySGs61fP8i5A56qm
         I7rBp1spYvpFrgtHS1+0IAJVlMdhgiDE/If5gxE0ZIZkhYh11zoYO0Rd+NLHB8pYkh0P
         78qw==
X-Gm-Message-State: APjAAAUN0svXOlivj1BRnda/x20AeDsnKw3N8RSlH0krP++NtU+3B1S/
        Ue6OY9gecreC7hyPa2Wr7BeJI3mjLjUVAc/fMymITtGkwsTMJQsQTIq8EuJj0zNJ889wdmE74Wg
        mxaNT0Fq1/iFCJa5O
X-Received: by 2002:a05:6000:12c4:: with SMTP id l4mr9920501wrx.110.1573248487212;
        Fri, 08 Nov 2019 13:28:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYHusE8MoWuw70tQ33S5fOxAmef6NfMiwvMgpwMQ6hq5izLCSIW+QoX3QEZDi5apdWdOAgpA==
X-Received: by 2002:a05:6000:12c4:: with SMTP id l4mr9920492wrx.110.1573248487019;
        Fri, 08 Nov 2019 13:28:07 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id v8sm10963170wra.79.2019.11.08.13.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:28:06 -0800 (PST)
Date:   Fri, 8 Nov 2019 22:28:04 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2-next] man: remove ppp from list of devices not
 allowed to change netns
Message-ID: <beefb89b340483d75c39c46a9ec69384e839f663.1573248448.git.gnault@redhat.com>
MIME-Version: 1.0
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: U2BZprmEPuidqOQcGv4zdg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPP devices can be moved to different network namespaces. The feature
was added by commit 79c441ae505c ("ppp: implement x-netns support")
in Linux 4.3.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 man/man8/ip-link.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 9629a649..939e2ad4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1921,7 +1921,7 @@ move the device to the network namespace associated w=
ith name
 .RI process " PID".
=20
 Some devices are not allowed to change network namespace: loopback, bridge=
,
-ppp, wireless. These are network namespace local devices. In such case
+wireless. These are network namespace local devices. In such case
 .B ip
 tool will return "Invalid argument" error. It is possible to find out
 if device is local to a single network namespace by checking
--=20
2.21.0

