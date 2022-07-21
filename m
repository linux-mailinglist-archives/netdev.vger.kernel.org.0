Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB5257CDC2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiGUOfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiGUOfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:35:52 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E9D186EB;
        Thu, 21 Jul 2022 07:35:50 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r24so1374380qtx.6;
        Thu, 21 Jul 2022 07:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TNm3aXN1thCBh+umGTMO255119B8nj1I3dKmFNCEHvU=;
        b=YCWFOqbwbpDDBfdHjdxnU94lcBxg08CwjCXk1EZUjbjBvWPuo3bfXOnM/lEGivq4wS
         ia2Q+j4EPucBzXG0DfHPOOZK20UPeSRktKWAE8JTGyaAPJ1ByyVSvV+CYzSUtA+PCxBl
         ohSl4H551LTW/9Zs/u9kdtlmmTrWHd0JIvjgWxo6QgGFp9KwCxqaV/b3dveRtD4xbMMC
         RTPMO6RIq3DMusYPBhsCe70N9oiWae99WWJX3DI2jrCVX7l7Qg//vzGveaKt8W5KGmEX
         pnVe538OweaMgtU4UlU7UhJ/a+4+QW3eDSEoqSVSyTCWAApb+vYhuAhH6CbNODWvvmHO
         +d2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TNm3aXN1thCBh+umGTMO255119B8nj1I3dKmFNCEHvU=;
        b=XXzA959wNajcDAEEQjNR0xFkQrrfycjxUMGCxfR3txaJX24b4iRN7oYzcBMpivfQmE
         lLaK/FQSsGdWkwTjq21zhHV360Xmt8lNtd1cq3SpUzFLrtTBj1EC9rEyYjf+fTakt4KG
         V+IxfdSj8a5AVl94u0aT3JEummnNiz/Y99meW/zM39lndh2kDgWFnw5eSm4KBh9UPamh
         /CJwwdg21zHQFpeQ78brKBbkGHYCCEtklVaAYozyHN07GeOJ783Mx1uz7am2NVQbiLhr
         b0tiGKzpqmO8wifsd1Eu98U0w0HWZ0Qe9sFWx7Gt0R731bcPt93O6m/5BsWS7F0DZzro
         kQng==
X-Gm-Message-State: AJIora+wNk2KN/ItHHA0DhK5RXND5Z9cctC/Jt24pplwYdBMtgJtOs7/
        d9R1dpkHOnCnRj5uNbtuElcqgA/McFk=
X-Google-Smtp-Source: AGRyM1uSy7GP6yBulr7nDh1U6Xo+MTIjhZNdr9VWz/vNGz5Ij/Ard9efpzAlTxvW+6u00OE9mrlDXg==
X-Received: by 2002:a05:622a:13ce:b0:31a:b4ce:1679 with SMTP id p14-20020a05622a13ce00b0031ab4ce1679mr33653394qtk.330.1658414149350;
        Thu, 21 Jul 2022 07:35:49 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y5-20020a05620a44c500b006b4880b08a9sm207452qkp.88.2022.07.21.07.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:35:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCHv2 net] Documentation: fix sctp_wmem in ip-sysctl.rst
Date:   Thu, 21 Jul 2022 10:35:46 -0400
Message-Id: <eb4af790717c41995cd8bee67686d69e6fbb141d.1658414146.git.lucien.xin@gmail.com>
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

v1->v2:
  - Improve the description as Marcelo suggested.

Fixes: 1033990ac5b2 ("sctp: implement memory accounting on tx path")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 0e58001f8580..af2f0dfd50db 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2870,7 +2870,14 @@ sctp_rmem - vector of 3 INTEGERs: min, default, max
 	Default: 4K
 
 sctp_wmem  - vector of 3 INTEGERs: min, default, max
-	Currently this tunable has no effect.
+	Only the first value ("min") is used, "default" and "max" are
+	ignored.
+
+	min: Minimum size of send buffer that can be used by SCTP sockets.
+	It is guaranteed to each SCTP socket (but not association) even
+	under moderate memory pressure.
+
+	Default: 4K
 
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
-- 
2.31.1

