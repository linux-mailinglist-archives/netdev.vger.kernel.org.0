Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A34E7C2B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJ1WLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:11:48 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:44124 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJ1WLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:11:48 -0400
Received: by mail-lj1-f180.google.com with SMTP id c4so13019442lja.11
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Be/cdDZ19YZM4Q1cKVJ4g/t6FyGR/e9GyMJtmFdqwk=;
        b=BmrlP7Nz6rIcwNKabF33JrCuzZjUgZSVVacFvmRV6BAfV0A0Du/bpQ9wG30kiGTu/D
         qXdXKHQN4d+mTMOqbUQDYtaJ4bh+gYClz9akrzXi6P29G+bWX3VeujZpWFiH4ZCR9WWr
         Uq7jQNMYU2X4Eqry/4cRT7N5WAhBE7N5Csy11dFPVOjiTsSNzvGMK9o+h2cdt51Pb2iw
         05SuAEH1sMO/OOftYOO/QzEGbDhDgSVTrZR27hTZ7lNgwEXSFyaf4BaQmivAes0uL67K
         +5hM+dVB9C6IVqtKTeBwtuLk17goGqFFNMcq7bUPFQJtsw/S1MlLD6DN5BfE0JIudTFd
         Byug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Be/cdDZ19YZM4Q1cKVJ4g/t6FyGR/e9GyMJtmFdqwk=;
        b=G/Gf9+Og+MJFhAHVZyfGatSWjjqJGEqGZTtR/EJOZ5Zwgt5wb0nmjAW+vFQ/Oq9Hqw
         5Zc0Y0QkFK4NKPj0SustOH4vwHgwCgrPzrBI8+2zmvM4rqf6lkQMoKIsWBpufwmuaLe/
         skmpd1vJfFgFqynH78cMSUGu0GytVp1WMH55DSXrerzWMlM9I0+fFvbzQ0D4/2mAMKVh
         7G65zUrr3ZTnjnX1GhqlIGd3yG0WwJQqKWuriLDQIjL7tSUQmGB1wAZ8B+0Tx/YuDF3S
         hGlJ8iPkb6zWdQEgZk2vEbK8+30jYljwYt7JFRjaJ7ESjHFp3LrIFLzhxmSQk1G9CKlv
         t75g==
X-Gm-Message-State: APjAAAVsMZ5XJs1E5ban+HdGoE6kCXniOmaI6T1VAmOzo/l2J4aD/3i3
        qhzYotAZ3ZieF1gQFCx+XSYa7A==
X-Google-Smtp-Source: APXvYqy6H9L1BR3FMcLteHoweuEuIbynWzaa5KJqjVWl6ABfB7ckp7GS7ZujlvpFMI/3E7B7n8EgXw==
X-Received: by 2002:a2e:87d1:: with SMTP id v17mr73884ljj.5.1572300706317;
        Mon, 28 Oct 2019 15:11:46 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l5sm5469518lfk.17.2019.10.28.15.11.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 15:11:45 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] MAINTAINERS: remove Dave Watson as TLS maintainer
Date:   Mon, 28 Oct 2019 15:11:31 -0700
Message-Id: <20191028221131.2315-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave's Facebook email address is not working, and my attempts
to contact him are failing. Let's remove it to trim down the
list of TLS maintainers.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
David W please speak up if you're seeing this, if you're
interested in continuing the TLS work we'd much rather just
update your email..
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e51a68bf8ca8..b6b6c75f7e6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11407,7 +11407,6 @@ F:	include/trace/events/tcp.h
 NETWORKING [TLS]
 M:	Boris Pismenny <borisp@mellanox.com>
 M:	Aviad Yehezkel <aviadye@mellanox.com>
-M:	Dave Watson <davejwatson@fb.com>
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
 M:	Jakub Kicinski <jakub.kicinski@netronome.com>
-- 
2.23.0

