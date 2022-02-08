Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7EE4AD103
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbiBHFdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbiBHFcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:32:33 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A302C0401F2
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 21:32:28 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id s6-20020a0568301e0600b0059ea5472c98so12477184otr.11
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 21:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ih0HJIPP2NuD6mUg+6ea16czJEG5Xj38k3otEegbFXs=;
        b=MNgxPpKg7y2QsX1CIgybuC+bzWJXAtPL0wQCWY6vVoELl7674I/Q7sBRZifWpHayus
         gULQPSpucW01uuR/wwl8wBS1rJacgmCGs/tOOwd9kf4i4MfBO2F4Tgb40787ZPiQ9tR4
         LS4OC4qWZUSRpOdtlq3OH61Dq3dNUvmFGUi35Uo3YaTOrC5Xx1EyjI43+AfLVyJ6ABkC
         lGGd0+5/NNw+rueaEcLBNFM8MIMIZSkCWNTRWRAkRPJc4rRBPxOPVBO8QBIsB5+ky6ln
         KK8ovEVYGRAdgjFlFXOpXVT3Wky4318rV0kIUFNoMTSpAquZLROZqQYmVBC95tVwdjTl
         mwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ih0HJIPP2NuD6mUg+6ea16czJEG5Xj38k3otEegbFXs=;
        b=yATinBdNujRyFVp4uU/11uln8cpCYOQEiyH+l1oVSL2Auzcuc4Hz/1WOcg6/gdETH2
         9CRKYOuLIoQmV2LnbZtETovFzTUl//F1K6gcIDppIouX0Bb0CrLr5stin+dqdSA0XZCn
         rtfihXXzgQVJvnlS0EFSkkse2Mlbd7HPmr2ULnTxkNnYek45qvLDTw8v27OUFOlY4bIK
         FC1YHlV+/q2Rhgi2RlA88Uz1RI4gfc9YUqRuqdIb+yi7MmdKSAE+on/q4JwJKdfajbJz
         2Z3NTzJX3LZVsXvxfjcNPbmfCxs7sk7S013ZE244iTgesPFdjquq4XwMgfTh6o1V6hSg
         OfUw==
X-Gm-Message-State: AOAM53224rTsNusrGeU6+ldR5+hld72pYWYHu0CaqR6RMVC/Qylh3N+E
        hQAOCbqQ/60UghBit2RGdQNn7psUsBUHvQ==
X-Google-Smtp-Source: ABdhPJz1tMF0qUsJQal7NFgDcxTSKaacpjMkcos34SBZwRfiySu5cP1p56dna2DzKnPVWTssCYetfg==
X-Received: by 2002:a05:6830:1554:: with SMTP id l20mr1247986otp.225.1644298347708;
        Mon, 07 Feb 2022 21:32:27 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id e7sm5114912oow.47.2022.02.07.21.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 21:32:27 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        trivial@kernel.org, Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: typo in comment
Date:   Tue,  8 Feb 2022 02:32:10 -0300
Message-Id: <20220208053210.14831-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 include/net/dsa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ca8c14b547b4..fd1f62a6e0a8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1281,7 +1281,7 @@ module_exit(dsa_tag_driver_module_exit)
 /**
  * module_dsa_tag_drivers() - Helper macro for registering DSA tag
  * drivers
- * @__ops_array: Array of tag driver strucutres
+ * @__ops_array: Array of tag driver structures
  *
  * Helper macro for DSA tag drivers which do not do anything special
  * in module init/exit. Each module may only use this macro once, and
-- 
2.35.1

