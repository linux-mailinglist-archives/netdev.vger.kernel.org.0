Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C47169AE0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 00:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgBWXSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 18:18:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35757 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgBWXR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 18:17:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id b17so7457625wmb.0;
        Sun, 23 Feb 2020 15:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IxPYnFwdm6HYoZarbVA1a85F6D8H58D7m4Xg57cuQ3I=;
        b=hJEfNdUlRN46gddN4A6STA4svNTqFZlPSiI77hwK1jiYQT1XP65YDz+AlW4FiOnLUN
         ryNH7h1lp3DKqmBLABQWCa6SRfyU6cw/+F3UExOapJkj5Ne3LsP5wFvLnv4tOXXQP1ki
         eDO3INSfT9gfjsTUH//R3yOJp3akeoG1nSenyKm4m+HF1PQEG+xajZLxI/yX+B0t96FB
         RmQC58oGzsCLkL+uqrlzEOEQ9uQNCPtzNiyr9tSw/NFW/is5v9cGV0MFw80AoOqUEsOm
         ptSZae0ykgit8MCCAJhThawefmjmu6NO2oo7cluWhqsRvQpB0yCxRWj0ixjsef5SnY6S
         LX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IxPYnFwdm6HYoZarbVA1a85F6D8H58D7m4Xg57cuQ3I=;
        b=OJLpB0vEepckurDFnPiY1QkRfm3tS0aqc+CuuqAN9JNSy3+uUjzcA8XGnRvuCoAOxv
         CxSxnp3qI2IPssSzBgHv8VKjTwGXAeACL4RXHDWZ3HUCQ2N4q+MdFjQ0ImTlZXrE7aOC
         mtDBMWbc2MqMtpQTIFCXtOEuYG0C7p7X47Ct9svOddx1nok2yYrKeGKBxPqxKuQROtHv
         8pUPWOCTLj91gHDHOsFoh77FsazNm1K7Wd3/TWikR6+7/fEFX/HqGYA0d6FcHD6+puNE
         CX9z8fcpHC0SBMtO6SB9vsoZWCofwpgtOlXVgYa2MPVurhcHi1tLeBrTP2w40SIdOcO9
         mIxQ==
X-Gm-Message-State: APjAAAUQGvg9NQ+9aqK9M1s388QUSsIivr4DsDCN/ZJ1443rwwX/p2i5
        fJPdWvl60hGzyXbh0zIJuQ==
X-Google-Smtp-Source: APXvYqxlb5IshkvipPzCa0LMPNtrPnq+GZC2IYdqSD+wKq4wzMM1mhHnt/y8zw+TO/+8uNI6Og3k1w==
X-Received: by 2002:a1c:df09:: with SMTP id w9mr17047688wmg.143.1582499877478;
        Sun, 23 Feb 2020 15:17:57 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id q6sm8968203wrf.67.2020.02.23.15.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 15:17:57 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     jbi.octave@gmail.com, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org (open list:SCTP PROTOCOL),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 04/30] sctp: Add missing annotation for sctp_err_finish()
Date:   Sun, 23 Feb 2020 23:16:45 +0000
Message-Id: <20200223231711.157699-5-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200223231711.157699-1-jbi.octave@gmail.com>
References: <0/30>
 <20200223231711.157699-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at sctp_err_finish()
warning: context imbalance in sctp_err_finish() - unexpected unlock

The root cause is a missing annotation at sctp_err_finish()
Add the missing  __releases(&((__sk)->sk_lock.slock)) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/sctp/input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index efaaefc3bb1c..55d4fc6f371d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -548,6 +548,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 
 /* Common cleanup code for icmp/icmpv6 error handler. */
 void sctp_err_finish(struct sock *sk, struct sctp_transport *t)
+	__releases(&((__sk)->sk_lock.slock))
 {
 	bh_unlock_sock(sk);
 	sctp_transport_put(t);
-- 
2.24.1

