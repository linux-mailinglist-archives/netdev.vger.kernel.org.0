Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB099180D2B
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgCKBJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51036 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgCKBJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id a5so298749wmb.0;
        Tue, 10 Mar 2020 18:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vVRR4OgupYaiYbHKhmSicBHQ95FN9+SKT9CQzo7pJnM=;
        b=qvULlz99rWRiLqex5Lnn1QU1NhB/rQU7Wu8/SvYwZHZSifBTXvmU8WAGQIj8+/k9mT
         aOVd9vPoRvUPnFcecDzQZJE/MygViKIMPSuwXoeS/2yWxorCxdJ46MTFNPSZTs1uI7QI
         w9FvmdwQHbfNUuGOToq0xasCIJPmi6NZSf3ctusJjmrxW+GR938JEwGd5F0JFzDPivOO
         szaaDIuuKlTSOVORMmp5nEd/i6JMrX/UdDYo/lAEO7Nyl/St7iCJdbRVgsBFcaQhCd/r
         4SpKYdnrvHW9Qb3RxC9tj92GCqz2Q8MuSJ6BWtEmTsTRSfNyT9COuXCLgLD+Fawc7mun
         n6wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vVRR4OgupYaiYbHKhmSicBHQ95FN9+SKT9CQzo7pJnM=;
        b=UMmhJvxprM8hWggW5kjm/b3a+mfr9iQ0Nq0O41qahfl/oRAzROigefpOQosq1FWMsG
         FiMjwgKIWRV0BvcDBmcRNADVhAEF97eo4ATzx+XAdz+GzHRptRfh2hzwiP+dn/mp1555
         C/PqIduFrpmSrhNONQ/vCjeyMi/PY7tQqb5RQ2TJ9I458bdLpaTMYGLYIvWGg9TzBcwY
         haD269S+Lw8Zjr2ktgbuT2XfrGft35NlMa0s+Gtpy6jmObdur3vVAjeRqksc4WLpTe6r
         8DK9kuKORxc1V1ByxASNdZuoth/drsa62PDK99mHC04evH1zL7s5KcwInGLn5ZrIMqGp
         B64w==
X-Gm-Message-State: ANhLgQ3sbGhpFtwMXoG+sihjrdXkODJ0TDEOojpc5ZZmUAfqGZmcsCyN
        zY4/PjbuuJWBycxVlpYCi+6IAIt0sLsZ
X-Google-Smtp-Source: ADFU+vtXpCSp5JFuiBAC9PWH1R2+yQ8jDwpK5A9aOUQnqqdqMGMCmmBBcK5PstShOSvBnZVXdm1TtQ==
X-Received: by 2002:a7b:c4cc:: with SMTP id g12mr379000wmk.104.1583888971399;
        Tue, 10 Mar 2020 18:09:31 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:31 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH 5/8] netfilter: conntrack: Add missing annotations for nf_conntrack_all_lock() and nf_conntrack_all_unlock()
Date:   Wed, 11 Mar 2020 01:09:05 +0000
Message-Id: <20200311010908.42366-6-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311010908.42366-1-jbi.octave@gmail.com>
References: <0/8>
 <20200311010908.42366-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports warnings at nf_conntrack_all_lock()
	and nf_conntrack_all_unlock()

warning: context imbalance in nf_conntrack_all_lock()
	- wrong count at exit
warning: context imbalance in nf_conntrack_all_unlock()
	- unexpected unlock

Add the missing __acquires(&nf_conntrack_locks_all_lock)
Add missing __releases(&nf_conntrack_locks_all_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d1305423640f..a0bc122d5df1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -143,6 +143,7 @@ static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
 }
 
 static void nf_conntrack_all_lock(void)
+	__acquires(&nf_conntrack_locks_all_lock)
 {
 	int i;
 
@@ -162,6 +163,7 @@ static void nf_conntrack_all_lock(void)
 }
 
 static void nf_conntrack_all_unlock(void)
+	__releases(&nf_conntrack_locks_all_lock)
 {
 	/* All prior stores must be complete before we clear
 	 * 'nf_conntrack_locks_all'. Otherwise nf_conntrack_lock()
-- 
2.24.1

