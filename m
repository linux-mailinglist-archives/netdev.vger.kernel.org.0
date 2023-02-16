Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417B0698976
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBPAtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBPAtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:49:17 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53BD4344A;
        Wed, 15 Feb 2023 16:49:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qw12so1421053ejc.2;
        Wed, 15 Feb 2023 16:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=woF+P+TdWej45E4W5A5y9Ll0SzbpSd/vwQdeUiCTdUw=;
        b=E8T4MfG22BU/AnMrmRtl4dfanlRGlt27ts+F1BJ/MQBk9NVkieeS9NPC+oULU07khG
         D1OwbeUkssJtB7NwpVcVTbby8sZxBUIgDNS9ancCOQPxDFLz/CNARExJ6W+JkCehbaVi
         YXS98gGR6P4ffOgdGJyoetnpJK+Ufa7Te72HUt8s0Nz4Y47yl1a97O4LhDHiMiMORazp
         HgearXMl+2I2ESRhjUy77lYEN0jWaNedoUQdBHmY2XG+4YPw1QjkcFRasH1Cd6sHF45c
         UmxRkoE/R79I1+BBF3Gmbbh4RRRkImy5w6D9Q66augmNVgT0X4B60aTYmWfzSx9cPH7M
         dZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=woF+P+TdWej45E4W5A5y9Ll0SzbpSd/vwQdeUiCTdUw=;
        b=SQQjXrReiPGCcMRXGre1PjEFvCdSbcPR+E1RtE8nWTlWTKCx7P5yV45E48u/nPbqh9
         BIK1TQXZ8OuKmponK/laXJehd/u53XDzcGL5WiJUOJZxdrUXcRrQ7FuapuuGbiFyzdrB
         wHHDdGrdtdGWE2SY1mWXj5utJ0HW7/mKPmMLGSKculatagopHrKuGf82eB8euRxFiLwr
         DN/3okN4TVr07egYYcoZWZ6eATMyJBp4jdOWES/aY/9hEXFASeNPqAwe5yJiA+cEiCFF
         dHoJ+CmDQ9c5puyARKJH7gSecP7q0jyC/HEpcimn5ksyHKGcP97ehwJHlaDreSpQZAfe
         +HJQ==
X-Gm-Message-State: AO0yUKWukloKrFJ3c90jy9Ti/qoubTWDA2RefH63aH1aSAeQjegkFW32
        RJiV6ofDtdePSRA3PO5bW/NpMTN41eCQNw==
X-Google-Smtp-Source: AK7set/yqHVik1Wg49zCiM2kpPT/MV7arXQ2vn8V9y5dKijSlggwB173WkntpwtiYtlP8wyyfopDMg==
X-Received: by 2002:a17:906:82d1:b0:883:be32:cd33 with SMTP id a17-20020a17090682d100b00883be32cd33mr4732319ejy.35.1676508554238;
        Wed, 15 Feb 2023 16:49:14 -0800 (PST)
Received: from smurf (80.71.142.58.ipv4.parknet.dk. [80.71.142.58])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906805200b008b122d44edesm67818ejw.114.2023.02.15.16.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 16:49:13 -0800 (PST)
Date:   Thu, 16 Feb 2023 01:48:50 +0100 (CET)
From:   Jesper Juhl <jesperjuhl76@gmail.com>
To:     linux-kernel@vger.kernel.org
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [Patch] [drivers/net] Remove unneeded version.h includes
Message-ID: <f6b97db0-75a8-7daf-bd87-a43a8c20be69@gmail.com>
User-Agent: Alpine 2.26 (LNX 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,MALFORMED_FREEMAIL,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From bb51298e935ded65d79cb0d489d38f867a22a092 Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesperjuhl76@gmail.com>
Date: Mon, 13 Feb 2023 02:46:58 +0100
Subject: [PATCH 02/12] [drivers/net] Remove unneeded version.h includes
  pointed out by 'make versioncheck'

Signed-off-by: Jesper Juhl <jesperjuhl76@gmail.com>
---
  drivers/net/ethernet/qlogic/qede/qede.h         | 1 -
  drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 -
  2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..6ff1bd48d2aa 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -7,7 +7,6 @@
  #ifndef _QEDE_H_
  #define _QEDE_H_
  #include <linux/compiler.h>
-#include <linux/version.h>
  #include <linux/workqueue.h>
  #include <linux/netdevice.h>
  #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8034d812d5a0..374a86b875a3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -4,7 +4,6 @@
   * Copyright (c) 2019-2020 Marvell International Ltd.
   */

-#include <linux/version.h>
  #include <linux/types.h>
  #include <linux/netdevice.h>
  #include <linux/etherdevice.h>
-- 
2.39.2

