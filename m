Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24214E2F1
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgA3TKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:10:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37397 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727677AbgA3TKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 14:10:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580411436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SUtSFdT+kYmI8Bo8IponmuE6vaTB5AiudIIi8xyUiPM=;
        b=fg92RMsbHHLhjkNsqU9PHB9FpdCywI6BBx8dTxZp1OJHIiwh6oVcoUthiHpF3gau63jCbx
        vLmaoH/SHMC5CYZHkd1/z+ma7bYzwVlDniAz7aim+dUxJWKMvnee1Qi6Eh/8hcQoXb5R3J
        udS41RkK4PRZt7zadQowf8ffb9EFdg8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-6uroAP8kMj65Mth2kU3EiQ-1; Thu, 30 Jan 2020 14:10:34 -0500
X-MC-Unique: 6uroAP8kMj65Mth2kU3EiQ-1
Received: by mail-wm1-f72.google.com with SMTP id z7so1292327wmi.0
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 11:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SUtSFdT+kYmI8Bo8IponmuE6vaTB5AiudIIi8xyUiPM=;
        b=PkL40YgEs1I3jCOhC6nU0pcnuGyhgMqhGLYqLkRoxnwasAxFXE1n6++2HaBaTVCmjf
         ZnQXzNts4H9uCWYm70SZOFHDdpqrKj4MLuQW5Dn3al2wiFtPI7/t5rojTIOoOR533qB7
         oIS39q/xscFZdlk5SWCqYNG0Dw5LHaqQPuoYeuNykR2sEz63+/jFSFm6t6AFNVcbM/Kf
         K/ZpwP2hJQby4Z6iKZ4s9ONfyP0xZN4reIjtzBKVwsf9FUchDFQ8JKsO69cPmLwjOPS3
         jtVwmqceu0iXDzboBjiICBQMT80Zdn1Bv8G2s2w3Pqn31rAaaiIIY2h+xW9VDrLPEqR6
         Pp1g==
X-Gm-Message-State: APjAAAUxXir+FXatvMhuc0zIShGMAQgAadhvUafoce2WvknrsK5VdSfj
        WayBTJ5ZaO7h8vUinVZjsnhCCLI+dLSr0Z4doetC9poWG5C84Gtit+9+A1PoGokGPUSig1EPgtS
        3Cmrab69rpPZMLT72
X-Received: by 2002:a5d:6708:: with SMTP id o8mr7467579wru.296.1580411433138;
        Thu, 30 Jan 2020 11:10:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqwd2K5FNDKGZYqIaB7n3fgbnyN9C2V+AsRZ0esnHsarDmz4aw6MjM7UxxTdj8JoUalHG+ySGg==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr7467555wru.296.1580411432866;
        Thu, 30 Jan 2020 11:10:32 -0800 (PST)
Received: from turbo.redhat.com (net-2-36-173-233.cust.vodafonedsl.it. [2.36.173.233])
        by smtp.gmail.com with ESMTPSA id s139sm7794275wme.35.2020.01.30.11.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 11:10:32 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: nf_flowtable: fix documentation
Date:   Thu, 30 Jan 2020 20:10:19 +0100
Message-Id: <20200130191019.19440-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the flowtable documentation there is a missing semicolon, the command
as is would give this error:

    nftables.conf:5:27-33: Error: syntax error, unexpected devices, expecting newline or semicolon
                    hook ingress priority 0 devices = { br0, pppoe-data };
                                            ^^^^^^^
    nftables.conf:4:12-13: Error: invalid hook (null)
            flowtable ft {
                      ^^

Fixes: 19b351f16fd9 ("netfilter: add flowtable documentation")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 Documentation/networking/nf_flowtable.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_flowtable.txt b/Documentation/networking/nf_flowtable.txt
index ca2136c76042..0bf32d1121be 100644
--- a/Documentation/networking/nf_flowtable.txt
+++ b/Documentation/networking/nf_flowtable.txt
@@ -76,7 +76,7 @@ flowtable and add one rule to your forward chain.
 
         table inet x {
 		flowtable f {
-			hook ingress priority 0 devices = { eth0, eth1 };
+			hook ingress priority 0; devices = { eth0, eth1 };
 		}
                 chain y {
                         type filter hook forward priority 0; policy accept;
-- 
2.24.1

