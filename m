Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B091D33D2E2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhCPLYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbhCPLY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 07:24:28 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5417FC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:28 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dx17so71535649ejb.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 04:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jkqOTcyZx4cosbU3TAvy3byGU6n4HVueUp9yRdrrJvU=;
        b=NE+sfw9MlvhhLRyeFv+MFcFRf97NCtENv6PnvVugF6I65HimyRLSdX125ZnDniDZpi
         9LMzVu3e8sCYL2aWacqTWYv09e0ftMIX7KKY3b9Ihv2+Q9IRUEFVQRxNUUEoFRMHpQ5z
         pQ51orsjnGiiGdEuSFUDpHHfKjyq50SR2iTsrFYxk3DKfSvgHL2svSYaTpAdCvlPYrPZ
         Bz27QzClojNieuUgN0BBPUfZjAYljrIMSfimf8gQn2Xrlv4mBL3QTaCRg9wJltYiDesK
         N6vxpWm0igTR2u8/elKVZ6T4YvWmt0UPE5Gd8KLKPoTTUmBXE5EPk4lk1TJIjW4VDLXH
         TgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jkqOTcyZx4cosbU3TAvy3byGU6n4HVueUp9yRdrrJvU=;
        b=Fo4TvhK4Yz/zvjAd2xNz5mog7S03gAk8wo+XS3pJA+fBVx85Qcy6C7t8EEWQAWpzzm
         fxLsiaUSIxi4Ep3LBOLMtWX/73gucij8A4NAPciycPpeanTArNoj5EqZBd3Eai0WpKkV
         OUMATo4UbqTL+Ur7XLb1NfelCjNcXHKNmJqVCBE1a9h0eQFR5db/zgpaxpxaYLJEAp1n
         0PMoq7mkrPSmh2me7mCNO94kN+qnu9rzdnEWhjHeKcbnT72F1vWz0dyRRS2IzeEAQbzC
         BcFxL2Lx2QX4LYQ8apRiMGSPrXGbh/zzB4Juw2sYQz/CuYmhDpdoiiDsophje9HE7qQ4
         C6ug==
X-Gm-Message-State: AOAM5332ZDvNlGesSN2jd75RvQaER7FzkIYEkwMkLaG8xUO1W9MPkkbB
        Rta2DAjIHd0A6DRPRzz+4VoJmEU8QPw=
X-Google-Smtp-Source: ABdhPJzyu1N4rFVNwwLrI1m9AzX1CiWk9fGYvl4Sow6h0eJ75W4mCjwJLXXoE/DKJQVzaqrxLUdgXQ==
X-Received: by 2002:a17:906:4150:: with SMTP id l16mr29355375ejk.90.1615893866675;
        Tue, 16 Mar 2021 04:24:26 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id y12sm9294825ejb.104.2021.03.16.04.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 04:24:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 00/12] Documentation updates for switchdev and DSA
Date:   Tue, 16 Mar 2021 13:24:07 +0200
Message-Id: <20210316112419.1304230-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Many changes were made to the code but of course the documentation was
not kept up to date. This is an attempt to update some of the verbiage.

The documentation is still not complete, but it's time to make some more
changes to the code first, before documenting the rest.

Changes in v2:
Integrated feedback from Andrew, Florian, Tobias, Ido, George.

Florian Fainelli (1):
  Documentation: networking: switchdev: clarify device driver behavior

Vladimir Oltean (11):
  Documentation: networking: update the graphical representation
  Documentation: networking: dsa: rewrite chapter about tagging protocol
  Documentation: networking: dsa: remove static port count from
    limitations
  Documentation: networking: dsa: remove references to switchdev
    prepare/commit
  Documentation: networking: dsa: remove TODO about porting more vendor
    drivers
  Documentation: networking: dsa: document the port_bridge_flags method
  Documentation: networking: dsa: mention integration with devlink
  Documentation: networking: dsa: add paragraph for the LAG offload
  Documentation: networking: dsa: add paragraph for the MRP offload
  Documentation: networking: dsa: add paragraph for the HSR/PRP offload
  Documentation: networking: switchdev: fix command for static FDB
    entries

 Documentation/networking/dsa/dsa.rst   | 371 +++++++++++++++++++++----
 Documentation/networking/switchdev.rst | 199 ++++++++++++-
 2 files changed, 500 insertions(+), 70 deletions(-)

-- 
2.25.1

