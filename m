Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A21A4B21EB
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348571AbiBKJ2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:28:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbiBKJ2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:28:22 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE045CE7;
        Fri, 11 Feb 2022 01:28:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id c8-20020a17090a674800b001b91184b732so8880376pjm.5;
        Fri, 11 Feb 2022 01:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gMqMmpWnTzniWqKEMO7UBChWrAVFntZ90Cuy2eCOt8k=;
        b=iekSr8ajpH5NTm5HGsXvXjMg2IDKsYie/oY3pGant7hB4r4ijuxhEJUxiPP5axPlYP
         UxYxVQMGGSBwi+12z+EZHr4lsodIMtXMhsYJO39/YmnQIIkcUGqp/DZMdXbGU7IfM30L
         hZoLBCqUnkhsgJR1URTWUPxq2jbW5xQ+xx4ul47OGoTKW07h4ptPgwbTAmFfJBSZoL7N
         LRbo1ELTnZjEGU/6S6eXdVITLLPRAltjIIZBSnSsA/sIqcozSv2COkc2AnjCDs1Z9Z47
         MzW6Y38pzfnhAEd5JdznOP2BJ/SoAT7Le7p4idSyS4OCK4ays1Hcdlt6wK2HSRVS39NJ
         hhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gMqMmpWnTzniWqKEMO7UBChWrAVFntZ90Cuy2eCOt8k=;
        b=Db3lFDLd+EEUdU3D8NKN/z3W/Z+8WlvQAaSEXKgf8V1IhI8V6dQpaszRqXHqUh97l2
         2Lq4mfW2wukpg5/4aLOpAcziN4/XPbrmYWFNDoYYgu18GEichA4q48s1lXbzaiYEKPnI
         R15YFx3UwZljhy1O7k5CuwDq8UMcMhQ2/L2h25cdvB9Qb12XIqRaksSfPmm2pQFd77sc
         1JF7xq+RdEgWkLQdJSOZ7dWRtPcQuzUi+OMSzPcV2iGtrEmlWs35Mb4XD2f8bOmhK/Ry
         qxjbb6utFLffjbHCASt9tlEV7vDjEoCi4I/eSCx7bOsTOsDtg2LzXbw/vXlLQqlQpG/e
         C3ag==
X-Gm-Message-State: AOAM530BoB4jzk76NkZrkEmYuuh2S17ZAL3iaVqIJedLn+w99OpeUYtp
        uYeeBTSUS7jcgz/8EjC43Pw=
X-Google-Smtp-Source: ABdhPJxPq3pxZbwhabvWFyW/mYI43XuCI5oucnUwD/44di+jlx7PcGq16GZcWgE91kDQ8KxiiMCT8A==
X-Received: by 2002:a17:90b:3ec4:: with SMTP id rm4mr435248pjb.65.1644571700997;
        Fri, 11 Feb 2022 01:28:20 -0800 (PST)
Received: from localhost.localdomain (61-231-111-88.dynamic-ip.hinet.net. [61.231.111.88])
        by smtp.gmail.com with ESMTPSA id 13sm25704040pfm.161.2022.02.11.01.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 01:28:20 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v20, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 11 Feb 2022 17:27:54 +0800
Message-Id: <20220211092756.27274-1-josright123@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DM9051 is a spi interface chip,
need cs/mosi/miso/clock with an interrupt gpio pin

Joseph CHAMG (2):
  dt-bindings: net: Add Davicom dm9051 SPI ethernet controller
  net: Add dm9051 driver

 .../bindings/net/davicom,dm9051.yaml          |   62 +
 drivers/net/ethernet/davicom/Kconfig          |   31 +
 drivers/net/ethernet/davicom/Makefile         |    1 +
 drivers/net/ethernet/davicom/dm9051.c         | 1260 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  162 +++
 5 files changed, 1516 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

