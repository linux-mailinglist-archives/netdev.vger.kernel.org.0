Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B762749C1
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIVUEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVUEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 16:04:04 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E42C061755;
        Tue, 22 Sep 2020 13:04:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id n14so13460517pff.6;
        Tue, 22 Sep 2020 13:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=raI+QVbC2G+Sm4NSqtCVz0mf55/V/jwNAalaxam1OZw=;
        b=WL0ur06FwhqzS3/hTnI3/gNGftH0ByOksChfDJC7tO3/Ob218kDp95j/3i18FSn6jY
         a1dmQU8BJQVw/OmhgXbQk6AYWoz06NUPmZBakA2ve3pC1yyssAwhx+yCDaE07dVbgG+Z
         Vxa7vbBe4ig6dpR0gUWZnHFu0m/WFSSQMIPpIId1vIS5M27L3xq2QY6i+fym3cC/kQ0M
         dy7jVJITnRrh9POVUN/VnBt9wgDq1Iusr3GO/1BEf8Ub9Wf3voFPqFocpqcmNSbwj6h4
         YTv9t1iAyJ4lxQdCj4UNoWF69Z5dnOqEikbn2dwhF4JHkG4Z2/zToam649R+WVbgOtVu
         PCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=raI+QVbC2G+Sm4NSqtCVz0mf55/V/jwNAalaxam1OZw=;
        b=RBPrgQJOC1hDtg3ZTz+xGqa/svzT1PCZ15s/PFKFYZlB7zJ7Mey5CrhlB815t5Bbw1
         fUuJpzn2f5em4fj4DJqSqa0Nip0DPK0kQRlH5bAXygYMsXEOUrq/YIPioSRknjVTEv9l
         9kvvgCDdwyDp/Zd91cXDONDWEaOMVfWFDozgOsjyexK4qHsF75PbRn1sUyclHj7pRN/4
         jb48OSW/nS0hhlLUNPRGKaJrKAe4KmjhRnBtFMk3NYfm0TWlB4jC/CWLeYHbTGsF1j+t
         MRqUz+nGFujCTziwzEceKFUiq7Bp8eJfPOX03NqT7eyJZq750m7n7rN6jTtMOFuOKHxx
         ntag==
X-Gm-Message-State: AOAM532FV/Txo6PlZABXcn2jy1DZ/18BP+/CqIusHqMPN9qB9XzUsV1c
        /SGzngZmXFAa3sDSJIOUelPhQ5N7vlgtEA==
X-Google-Smtp-Source: ABdhPJzen5yMD3M2El2N7pJ+6vPPXtVMxP66QFxBJtjRH9klbnDdBbpMsbU0HXzBoJjJyAcC4eWNdQ==
X-Received: by 2002:a17:902:522:b029:d1:9bc8:15df with SMTP id 31-20020a1709020522b02900d19bc815dfmr6400861plf.25.1600805043084;
        Tue, 22 Sep 2020 13:04:03 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q18sm15562700pfg.158.2020.09.22.13.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 13:04:02 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: dsa: bcm_sf2: Additional DT changes
Date:   Tue, 22 Sep 2020 13:03:54 -0700
Message-Id: <20200922200356.2611257-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch series includes some additional changes to the bcm_sf2 in
order to support the Device Tree firmwares provided on such platforms.

Florian Fainelli (2):
  net: dsa: bcm_sf2: Disallow port 5 to be a DSA CPU port
  net: dsa: bcm_sf2: Include address 0 for MDIO diversion

 drivers/net/dsa/bcm_sf2.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
2.25.1

