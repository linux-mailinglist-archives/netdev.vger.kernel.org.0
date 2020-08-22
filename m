Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14D524E9A8
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgHVULf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgHVULe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A71C061573;
        Sat, 22 Aug 2020 13:11:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so513528pgd.5;
        Sat, 22 Aug 2020 13:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Uh4E6t+sDf2DIjlNQlWGWohk7ZtPPaOk143zxnFjWco=;
        b=VySoktlukSHPDa1PaQxiVO69MuxABDPo28XhWXQqGCq26Fz8pA+tG9m2mypfH5bCn0
         LgjIDw2aknhBMQ9lE83bAvV0/LciIxVtxsR1AG0WmDmfhrscWCUQurOfm4N/6XmQBBB6
         e6MCQ3MxBgj2DgXa7v1HIkfltCBIbYG0l+X9DmAw0sN8PIlAOHUgDYeJgBkwpwiCF+MP
         F9DU8H3j+xBlU2I//IHszmZiOBb3qsAd7tYWlBQDpDFIBxYEH/BZZx2Fxg92U2zlOnyO
         ya0yHeU8ETlqMaXZmrC2HNvwdmNv7ci/38wfMbhruUW+dDdPFlS7xOF1pT1II6Ao4jUo
         NeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Uh4E6t+sDf2DIjlNQlWGWohk7ZtPPaOk143zxnFjWco=;
        b=G4mGuOOhEAJDQhEBZPKyRqMLy2Xdy0+A7qnP0An/fSj3sSkMkBuGS0KdZGdcPGiNOV
         ratSiqDpk+JT4ttu0c2SDqRFXox0FJCgK12yJ8Aed+BkT1Qmhl/CY1T/mVRmWnf2ls3f
         m+5e8wHY/f4NMtQ9B8bIUWG/cYxvmSsAcoMm6w0kq/Q04uyZeNKOpLPhArkrXER3I5Oh
         uRRfkxUTrvH8Ygu5odn7mcUzHdQ2EZu4NDV+I826twNIRBgUoxiK5f1oQul1m0IWbbGv
         dPQO/IlVCNtEwVSAEhSgj49yjE8pFvHJlDsQYo/wpqyK+f5/EpHYxg/+JaiZ4oU7O2aj
         8LAA==
X-Gm-Message-State: AOAM530XAwlwa9L9wQOM7yMo7cZI5ukwieeVMXGMR1dnLA7YGr8S8laN
        YxIY53LTIqVDaWbMmcEre175gWiJzv0=
X-Google-Smtp-Source: ABdhPJzE02AXcCtWsG1ZsWFnfjE/B3G6FByVEQvvdUl42YSMkwcUobRT8vPtICRpfERA6pGPJc/Ohg==
X-Received: by 2002:a62:2c0e:: with SMTP id s14mr7187923pfs.289.1598127093181;
        Sat, 22 Aug 2020 13:11:33 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:32 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 0/6] MAINTAINERS: Remove self from PHY LIBRARY
Date:   Sat, 22 Aug 2020 13:11:20 -0700
Message-Id: <20200822201126.8253-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Heiner, Andrew, Russell,

This patch series aims at allowing myself to keep track of the Ethernet
PHY and MDIO bus drivers that I authored or contributed to without
being listed as a maintainer in the PHY library anymore.

Thank you for the fish, I will still be around.

This builds on top of Andrew's series:
https://lore.kernel.org/netdev/20200822180611.2576807-1-andrew@lunn.ch/

Florian Fainelli (6):
  MAINTAINERS: GENET: Add missing platform data file
  MAINTAINERS: B53: Add DT binding file
  MAINTAINERS: GENET: Add DT binding file
  MAINTAINERS: GENET: Add UniMAC MDIO controller files
  MAINTAINERS: Add entry for Broadcom Ethernet PHY drivers
  MAINTAINERS: Remove self from PHY LIBRARY

 MAINTAINERS | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

-- 
2.17.1

