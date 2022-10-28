Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B47B61093F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 06:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJ1EWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJ1EWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 00:22:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7376E161FF8
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 21:22:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u6so3806595plq.12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 21:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=52CSyV5TS6i30h+HoUr9cWpTxpE6qBoUrBeo9Be9Ljk=;
        b=cKIaUiZE9VcXM+QiJ5RqVOysahlXb1z3rqgHFNXxnpLRjU4H/8e9Fe9P7MaQ83JMao
         tm55mXImwu8Eb5dNJRLT5eKuCUzVhf4hcuZduB2iXF5xaAVj6hZ+h5ncRyB29pQGFWyD
         vU00QxZYwea/2M+ik19eTMXK+dMoLIKqO7ji02/c605g2OB46DXSfAuNYwvTLUtz/HvW
         qCiZhrKvsJX5dfp2gzOLj1Jh1v62J8p326/qZXaeTt4AfE9VYxesVL7FaCY62GsIh92U
         IyAYhqUbdwfZFBvqnpmruGVOX++4y7FfDp1icW7zHrGmIndSaFVIlf5kyH6jJLSyM7CS
         7uIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=52CSyV5TS6i30h+HoUr9cWpTxpE6qBoUrBeo9Be9Ljk=;
        b=2F9Ap7nkpN6M74MuITQv0UawaMHapLgcYGYSOjVOf92RijzwNTQv1slUUDnHylVjdc
         J0ycR/0HNGZEW5ibhyPNX9CDpdVxuhA+0QqFFQANzxiXo8HgaT4fGsCyjm5Q1DeBgU6D
         Am6tqdghx2/vdIy63oNaCe8v3+p+9RD7OVh3N8YazbGaXsguEtn30Tvmev1DqMw/L29l
         6qjPff0E0CrQ527j32rFoHW/hUqd4XtQClU5IzKgzvGTMv9QqPRWWnyJFg0wIgYUSFg4
         j+ULrVOk3W2aDyYO2I/6sbPB9N8nNkQlqmz3aLm5FFW7vgfZqXIJ9bde6/huugWeCIQt
         o9JA==
X-Gm-Message-State: ACrzQf1t0PK+gsHSZHocUr/2zvCVPygBJ4Hi1y/tqW+kT4l7qxjM/Rvr
        0UkhBUcPqvXCZcgcuMwPH761Bv4wKVYxMg==
X-Google-Smtp-Source: AMsMyM6triS02PMu9MMjKFhmVtzFQlULOWu9rjAL7fozw8ui5l2hzGiGEWd/xQ4EVu2EbjyvC4AjBA==
X-Received: by 2002:a17:90b:f06:b0:212:cb07:fb82 with SMTP id br6-20020a17090b0f0600b00212cb07fb82mr13689986pjb.221.1666930923837;
        Thu, 27 Oct 2022 21:22:03 -0700 (PDT)
Received: from localhost ([128.107.241.161])
        by smtp.gmail.com with UTF8SMTPSA id s15-20020a170902b18f00b00185002f0c6csm1968133plr.134.2022.10.27.21.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 21:22:03 -0700 (PDT)
From:   Govindarajulu Varadarajan <govind.varadar@gmail.com>
To:     netdev@vger.kernel.org
Cc:     benve@cisco.com, satishkh@cisco.com,
        Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH net-next] enic: MAINTAINERS: Update enic maintainers
Date:   Thu, 27 Oct 2022 21:21:59 -0700
Message-Id: <20221028042159.735670-1-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.37.3
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

Update enic maintainers.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 377aedb3808b..e79dc7ee5454 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5039,7 +5039,7 @@ F:	drivers/scsi/snic/
 
 CISCO VIC ETHERNET NIC DRIVER
 M:	Christian Benvenuti <benve@cisco.com>
-M:	Govindarajulu Varadarajan <_govind@gmx.com>
+M:	Satish Kharat <satishkh@cisco.com>
 S:	Supported
 F:	drivers/net/ethernet/cisco/enic/
 
-- 
2.37.3

