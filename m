Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A23F19599
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfEIXOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:14:21 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42540 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfEIXOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:14:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id d4so2563480qkc.9
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WY786JUPsKK3mzxSVolA6BL813RN1mRtjjSfB5szvts=;
        b=haf23+IHFoxLOIkPd//GIrtZN7kxHKFgY+oQescUyI0JIszCDwsWNl5otlLH2/e7ob
         gdNsBHa5KKA1/SFBY1HGAtI/Vx4IwqeJ3qq9ZeNw9ekpLO89NlvD59I/nb4I2Durtj14
         1L4dto0tDvXUB0C3U/VNgjtR37qhRfxyWYqxsJNhnLh2Ry+vTXb26LfOUO73OxOf1j+9
         nL5VEtyniGOeyQFz37dwqbx4O3ofJYYiW7xRfThkidJ/wYNLr30Bgmt8TwpeZVZlbJjW
         2lZitSSp4hcHVYX+X8B/+rKK2poDryRgvqJCAoDAGSLy8ho8lHJiTlOO9i8tC6I3q2nr
         6OJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WY786JUPsKK3mzxSVolA6BL813RN1mRtjjSfB5szvts=;
        b=IzKysZ75VclndY15TSfWcG9dtdBQbXZ1Bcdkr9s06H/zr2UIy9mP4yj2M5wBJSxLmv
         CH21ZuZhm5ws+7AaQIfpIldL79Y5+T+VOIlZsDJ11HFY1eGKZ/qe8laY1ysNNbv//Df3
         j5hP2gSFOt9YQBXk+C0jPQuDnOqYNtFlirOsmGIFFn7N7VtFxdpAxt8xx49MFtkHQBoa
         ND74dOnJ+uxOrleEm0aNu0N7S1SfYLmNeJ1zCeAySSXtdmR8qUmh4dUDuqhKYJFNoWus
         5vqdxdFCoggv8mS6a029kYsDx2wOLTDJzU8RVjAvowJhHzSXRerFNFcrzaVYaa6l2kIC
         Tk8g==
X-Gm-Message-State: APjAAAWZ5bBsJGzmeyuZGOxcmBj1fOgBaGfwVOj2k1RR8c+xWp9JUkpM
        BT6SLMyWv3Ly26TMpBo/xt+aPXjepls=
X-Google-Smtp-Source: APXvYqzkh73Q7CHP/g/aXQLnt4njD0VnGjmKUDXBYNAaszSgK+zlfKhVChJiRpPEm55JCwIyQ8WUWw==
X-Received: by 2002:a37:4c04:: with SMTP id z4mr6063985qka.312.1557443659685;
        Thu, 09 May 2019 16:14:19 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s42sm2036778qth.45.2019.05.09.16.14.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:14:19 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net 1/2] net/tls: remove set but not used variables
Date:   Thu,  9 May 2019 16:14:06 -0700
Message-Id: <20190509231407.25685-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509231407.25685-1-jakub.kicinski@netronome.com>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4504ab0e6eb8 ("net/tls: Inform user space about send buffer availability")
made us report write_space regardless whether partial record
push was successful or not.  Remove the now unused return value
to clean up the following W=1 warning:

net/tls/tls_device.c: In function ‘tls_device_write_space’:
net/tls/tls_device.c:546:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
  int rc = 0;
      ^~

CC: Vakul Garg <vakul.garg@nxp.com>
CC: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index ad1580ac097a..ca54a7c7ec81 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -541,14 +541,11 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
 {
-	int rc = 0;
-
 	if (!sk->sk_write_pending && tls_is_partially_sent_record(ctx)) {
 		gfp_t sk_allocation = sk->sk_allocation;
 
 		sk->sk_allocation = GFP_ATOMIC;
-		rc = tls_push_partial_record(sk, ctx,
-					     MSG_DONTWAIT | MSG_NOSIGNAL);
+		tls_push_partial_record(sk, ctx, MSG_DONTWAIT | MSG_NOSIGNAL);
 		sk->sk_allocation = sk_allocation;
 	}
 }
-- 
2.21.0

