Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C894B1EC9
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 07:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347026AbiBKGur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 01:50:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbiBKGup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 01:50:45 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267951120;
        Thu, 10 Feb 2022 22:50:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so7941212pjh.3;
        Thu, 10 Feb 2022 22:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QK+l7rHXU3PT/N2JWyDQzzRxR1HXLB6Sj1tRivvxqc=;
        b=cbJkopy9cebFp9fOjClchpixRdtd7Uu7G5tx4TfOHWUElDf9ka6z1Xzwb3WhfvwLdr
         Uo3EPeoeri05hFHFISa4yiDFKoiUXJ8PDNk1mIWsv0L5JDYLaLDNXVN8WlTdsSqf4yUv
         ptxIXHNuedxnPk2g/+lZSAtNaSqY4br6Fld7cpk5CAm4RYIdf95+MH2Gjel22kUVE59k
         huK/qAYxYIz/4BOQpJXO/BxOVFypExASzs5Kus74l6LrM3fzpa6HiygnUfvpwf7T76Uw
         49DpdCXnJ8rMWvRJ5vlRO12viiWnpOJpj5B/2/F2W3OMX7uHnm9bwGJDVJ+GergYous5
         mRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0QK+l7rHXU3PT/N2JWyDQzzRxR1HXLB6Sj1tRivvxqc=;
        b=Ivp+iD5bRCyVXYT5h1AWIhpKBUFUJlklCNE4hAYESGPwKM6PxrMpFNUqacuFV168id
         pg8mKp7BzraRUJIO7kM8Ns30nJ28sgiiTe3Shk17rsescTtdFx3rTrxEDhJqUjM2ez2j
         wfSBkTQIogGbI1A3DYQx3gkEr3FRqI4Km4JDdfV/PLhS/ObDUkPFNF1dVU0mb2hiWuLs
         CKoW3WRDm4CtuA5NIoypukP29XVw8mZEJ1IcnSLqLZrs4e3pWBku0fN72Q0DK9BOnhg9
         aLBe1kOVmOGrmVOjaDAwHH9MZCH76fo9tg6gQ9Uec28RRgzFyA1fqgjwC0RmkTr6UqRV
         ErmA==
X-Gm-Message-State: AOAM5318evuWWuO5l7HDDDe2z0nTmRXjvOLQZLVYW/C5yTBGz0hmpPZK
        FsW65DoveWVjRjUTe4lPMMs=
X-Google-Smtp-Source: ABdhPJz97NFh99hzwYGctR2BCBnHvNL6oO5CtyLyDLlnc5SQkoYi59g8D4yhwcp4cyNW5lZ7TDVU8w==
X-Received: by 2002:a17:90a:5a48:: with SMTP id m8mr1195425pji.97.1644562244190;
        Thu, 10 Feb 2022 22:50:44 -0800 (PST)
Received: from localhost.localdomain (61-231-111-88.dynamic-ip.hinet.net. [61.231.111.88])
        by smtp.gmail.com with ESMTPSA id o1sm28171257pfu.88.2022.02.10.22.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 22:50:43 -0800 (PST)
From:   Joseph CHAMG <josright123@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Joseph CHANG <josright123@gmail.com>,
        joseph_chang@davicom.com.tw
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: [PATCH v19, 0/2] ADD DM9051 ETHERNET DRIVER
Date:   Fri, 11 Feb 2022 14:50:02 +0800
Message-Id: <20220211065004.25444-1-josright123@gmail.com>
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
 drivers/net/ethernet/davicom/dm9051.c         | 1239 +++++++++++++++++
 drivers/net/ethernet/davicom/dm9051.h         |  162 +++
 5 files changed, 1495 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h


base-commit: 9d922f5df53844228b9f7c62f2593f4f06c0b69b
-- 
2.20.1

