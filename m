Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF283A41C0
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 04:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHaCed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 22:34:33 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:56226 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbfHaCed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 22:34:33 -0400
Received: by mail-pf1-f202.google.com with SMTP id 22so6778713pfn.22
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 19:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a4rFTqioQJgL7bDCizE2uEN7gKuduEr/PEeqOE4KelA=;
        b=X6mkjQ+L6I57QTiTP9z37nxgauqLdrxNp+GYVqqoviLTp97AJ7zNZpFA3JTD6P/zHV
         nZNMPinATSq6dw8OkjfD0sJOd5HKU4bHcDr8p7mt32kXoroMSHYNH5HQ9wYAnI5WzP8F
         Dh/3ra7ewEGFHKEaUWUv/Xu2uV7k/q3+sOKuAVbjRsx3gswJyURoz+CQfylV1ak9acVj
         IUPGEWkc4BWdSSmlthRCOnSytEQE73f2DptLnr5ZLGbHLKZlOrCrCPrw0cX8OpRn5LMs
         m7yMNT9/JX0cgqSG8daY9cH21k2qPrPFpMgMKnJlyq7N+/xbzRDy0uC0T1NrPDQvUJG4
         sm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a4rFTqioQJgL7bDCizE2uEN7gKuduEr/PEeqOE4KelA=;
        b=ExJ4U/vhp+l+Hsj6Q7rzV1AXZSGFL8vhNEaZqS3H0blo1bPHIEASfGUHIvietrSuEy
         +GPUdYtlhX977gvXEUGW0dduzJfdw+VzscNu4LGR3HpWU0I6XUuSFh1d1XiflzRUk9Y7
         ii+MuonJrDE8zJGmYQAxjSb/8G17gc6Qacotpe4WSqSbT+of1HP9HDR3PhXZUl9KC14H
         h1TzdHzDErZa0xkKainJp46BAwhoD0hsJQr/r3triwb0LnRg2jlH8YWt+zgEl6Gja6hy
         o78oPgdJQyyJaAePvTpmt7zREaHT7dlDRMD9JW0OaJggBzjSBodUQr21hk7U0PIKAd78
         oGpw==
X-Gm-Message-State: APjAAAUdewYlFu1lHXCUiMYH/l2KVrqvOk1UdEq8YyRhJ6DvvIZ9krrU
        8tNTQaT63eyKptkD/vlAP7pZrdNl/BKCDt7I5VxvCdfVXU5Vql4wz3jN4FbtQRJq/XmN0Xk9mF9
        utYOlEWrlridjOUpfK8Wz9u4xjxvukEcvRQFw1VK6wDh7AB+pH0Zelw==
X-Google-Smtp-Source: APXvYqxpEwR0+2wWqWQonzc5LDOYL17L9zSKywuFQC0oiWaQTExrmuJEonEfLUBsCX4hZAooio57g/s=
X-Received: by 2002:a65:514c:: with SMTP id g12mr1449437pgq.76.1567218871948;
 Fri, 30 Aug 2019 19:34:31 -0700 (PDT)
Date:   Fri, 30 Aug 2019 19:34:27 -0700
In-Reply-To: <20190831023427.239820-1-sdf@google.com>
Message-Id: <20190831023427.239820-2-sdf@google.com>
Mime-Version: 1.0
References: <20190831023427.239820-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH bpf-next 2/2] selftests/bpf: test_progs: add missing \n to CHECK_FAIL
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy-paste error from CHECK.

Fixes: d38835b75f67 ("selftests/bpf: test_progs: remove global fail/success counts")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_progs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index 33da849cb765..c8edb9464ba6 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -107,7 +107,7 @@ extern struct ipv6_packet pkt_v6;
 	int __ret = !!(condition);					\
 	if (__ret) {							\
 		test__fail();						\
-		printf("%s:FAIL:%d ", __func__, __LINE__);		\
+		printf("%s:FAIL:%d\n", __func__, __LINE__);		\
 	}								\
 	__ret;								\
 })
-- 
2.23.0.187.g17f5b7556c-goog

