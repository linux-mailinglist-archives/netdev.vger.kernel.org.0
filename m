Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8285788EF
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbiGRRzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiGRRzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:55:05 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BD12D1FD;
        Mon, 18 Jul 2022 10:54:59 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id m16so5086594qka.12;
        Mon, 18 Jul 2022 10:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgCc7NDdNoxWJpMm8aZT+iVoyHMvE5emkDbq+xzf9xQ=;
        b=Fb13Uemltlqv1iVPUIi+8bO4TBvUGYUH+/lDk3BLngUTAaElgyyJ5/0bLSkPyVIK3w
         +JAmX6aBQ8TXp3WLtgxyfogByYfpI//EAxzW2eny+fOWwzNoWItSmHJ313WxILgw+puw
         jnhPzCRYDsABUT7z4Mu3hHgqwppqtvXqXVGZKe3r0VwKs5smqbyrxTu2RMPLuMAbDGzn
         D2mr/03t1xoSDZwlQfkEn54gMtrO14pBIybmIEO+TN7mHFykt6zNNgkE7MGix754d9pX
         Ifzr0OR9TaoqHWnMfnKQPXEqoP90lzpHdhfkTQZZIl4ExVJaYgfZUpcwKp+Z68od08hh
         cgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgCc7NDdNoxWJpMm8aZT+iVoyHMvE5emkDbq+xzf9xQ=;
        b=jOh6zo+8v878smYNDxDG8ayNEbYOpklj8Cr25U3NsKJPU0kNn++qZzRwFIG36H7aq0
         aEggbu9KKCbNSRXoeWgeZJ3vt58sQT4QLzxO33g+6kMFUqYm4RW6+fdIonDzri2hG2CD
         Jm9KCA8U7PGPi7ivZspPwcO8kFuiGC6Cu45Lz1ZNqzSWJ3f2qhywsXKlDpxxYoDmzlwr
         YEJMgypYKBD0ftedm3oVTNPt4Pk2uqBpgtNJHq1+Wksp3pYi3oLljDVk236kN8aqk6YA
         o/yCgpkLSS2GgLgumP14H8Q5JIkpgvVXmEWFuRlSMxeqitv8E3yj0TffTQpGuHEnB0V7
         liUA==
X-Gm-Message-State: AJIora9AQHQh4olqAZrX2oI23h28RcfPK1Lxu7A2l0hSyvC+/souENCA
        oP4Hr4xPEG4sBDC1lIB9R2codtYNBM4=
X-Google-Smtp-Source: AGRyM1u4VEsBIEinH/FkLU4QE51u/C2jq//Noge50Z/xYxxWkSFDhK+Q0GMZk48zthBwGooMF2kdEA==
X-Received: by 2002:a05:620a:424c:b0:6aa:cdf8:f6f3 with SMTP id w12-20020a05620a424c00b006aacdf8f6f3mr18167040qko.26.1658166898129;
        Mon, 18 Jul 2022 10:54:58 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z12-20020ac8710c000000b0031d3d0b2a04sm9470903qto.9.2022.07.18.10.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:54:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] Documentation: fix sctp_wmem in ip-sysctl.rst
Date:   Mon, 18 Jul 2022 13:54:56 -0400
Message-Id: <0ad4093257791efe9651303b91ece0de244aafa4.1658166896.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 1033990ac5b2 ("sctp: implement memory accounting on tx path"),
SCTP has supported memory accounting on tx path where 'sctp_wmem' is used
by sk_wmem_schedule(). So we should fix the description for this option in
ip-sysctl.rst accordingly.

Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 0e58001f8580..b7db2e5e5cc5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2870,7 +2870,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimal size of send buffer used by SCTP socket.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
-- 
2.31.1

