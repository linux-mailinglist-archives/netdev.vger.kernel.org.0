Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1E6EF51
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfGTMbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 08:31:36 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:34926 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbfGTMbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 08:31:35 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jul 2019 08:31:34 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id F2B03D2C
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 12:23:42 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7f_ltjft_EEW for <netdev@vger.kernel.org>;
        Sat, 20 Jul 2019 07:23:42 -0500 (CDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id CF451CB9
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 07:23:42 -0500 (CDT)
Received: by mail-io1-f70.google.com with SMTP id v11so37681608iop.7
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 05:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=K+9BHnE6RbUTOFhStcy8LrNMOZBD7Jm9/NExEpRtGTs=;
        b=VsAKaUY5H8pRtOL9M2UvY9iZeZDLaYKRfFF0N8a+Ayc6PHMdqmm/9LShwhaw19OENE
         pxtbM5Fx5DUA1WzHR5dxLHVeAKGy9wKZXYgRBawbE8gT60iqJsAjGCOPSjBdSDDgFxvu
         b7Wr0bcGk88XngcmuNvn83WoG1nUCpjjQaU9cJI+MIRtg86w26V7jxttyupJtMxWd/HB
         ZNw/Rn624IVLdtvABLf7EWYHrhdx7u+JpOfG34xrmKCHBbNWQawqc/DwOrZRcYdi1DQ/
         3tvSHgoFfGyPCW6CymV+IYbxh4sDtLrW7kVl2JQZ6QC8HV0+Ih1vS9KCl1OiZvVwOR6c
         aJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K+9BHnE6RbUTOFhStcy8LrNMOZBD7Jm9/NExEpRtGTs=;
        b=kg6/S1HAT/crpxWv6vjHOCdXXgdrUlqGZnnL0J8YcILuMAVgtBG2M5PP6gVJtM9zRD
         v3Vz2a4w8fn2F0bNe6jt8s9ry36hzQZC7ncvPECOuTs8sJEXXEyyqCQxKfYCbIEv4YoD
         BcK5xMPFx6Ww4QF9wueZauvNJQ9+pASwqIAMS/iEzAdrnArGe6KTtb5Q0Ja4cUKOedfB
         ZZ8I76Wpw7a+85q3bdaKWAw5EQ2bPPPzjHLkJT/bqB/fHxtIRHAR5vZDr3wilNtLH+OW
         WE5mxCNXehGjVGNHjD1Qjc/TKt6VtG/y4FbpuuWo0iNSHYw5eF30j8g8EfBhcdUa6Nlb
         MsnQ==
X-Gm-Message-State: APjAAAVGMnnLI5IHjzKEtDx8oU4oozen7P6pju1D4R6vM/AQUq39s4Ej
        EUkbXMytGzC4hHunxvCk+NLbGmUlObogYwajf3eoJnypybuz8ST/NxyxCw+KhguBkBeDDARbYhL
        1oKkMFWSkUhzRdftbQwS4
X-Received: by 2002:a6b:b206:: with SMTP id b6mr58517916iof.286.1563625422515;
        Sat, 20 Jul 2019 05:23:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxIvZ8x2BA1J9vY8UGimtCbB808vFCxS2Rq0GnEylvdPLpsmWAHPUhim/AqK6Ko3OIPJUTULA==
X-Received: by 2002:a6b:b206:: with SMTP id b6mr58517902iof.286.1563625422367;
        Sat, 20 Jul 2019 05:23:42 -0700 (PDT)
Received: from BlueSky.hil-mspphdt.msp.wayport.net ([107.17.71.65])
        by smtp.gmail.com with ESMTPSA id m10sm58326660ioj.75.2019.07.20.05.23.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 20 Jul 2019 05:23:41 -0700 (PDT)
From:   Wenwen Wang <wang6495@umn.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE),
        netdev@vger.kernel.org (open list:ETHERNET BRIDGE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] netfilter: ebtables: compat: fix a memory leak bug
Date:   Sat, 20 Jul 2019 07:22:45 -0500
Message-Id: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

In compat_do_replace(), a temporary buffer is allocated through vmalloc()
to hold entries copied from the user space. The buffer address is firstly
saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
the entries in this temporary buffer is copied to the internal kernel
structure through compat_copy_entries(). If this copy process fails,
compat_do_replace() should be terminated. However, the allocated temporary
buffer is not freed on this path, leading to a memory leak.

To fix the bug, free the buffer before returning from compat_do_replace().

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 963dfdc..fd84b48e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2261,8 +2261,10 @@ static int compat_do_replace(struct net *net, void __user *user,
 	state.buf_kern_len = size64;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	if (WARN_ON(ret < 0))
+	if (WARN_ON(ret < 0)) {
+		vfree(entries_tmp);
 		goto out_unlock;
+	}
 
 	vfree(entries_tmp);
 	tmp.entries_size = size64;
-- 
2.7.4

