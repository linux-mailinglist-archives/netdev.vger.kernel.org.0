Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425E0358CC9
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDHSjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhDHSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:39:03 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3EC061760;
        Thu,  8 Apr 2021 11:38:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v6so3465887ejo.6;
        Thu, 08 Apr 2021 11:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wsl9mtBv168EKRC86vPEac8wYtCgy/LgRanxPjxp1is=;
        b=m8HP73sUK9jwOSXAktYnoiM5bo3nrilUDv3WRZ0PojX+Y/IsRX8TDMvtLYQ9vObrW3
         HH71cAY7PW4zDAfwh8CdoBcvp6s5I+/6/EcG+quWM8HLfGA2VUYm419yhLo/S0+UO+m2
         tDw1awR+Wv+HHCUGo+YDUe4PIUUOWtrpblFVd9ortXkRabRf6zneg1wyCxBIVjJe95Nl
         QdY4AGDQLHgce+7RBi4pZifw1zqUw1RVLv5gFceYOZO5U/iAch14sRBntaWmKVgOkfT5
         ORMzNfo3Dplk0S2mnjjWQkcm6bXZ05QZlyVu8f1FzxBLaZbA/aCCnbdSAtOgJKC29bdQ
         AYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wsl9mtBv168EKRC86vPEac8wYtCgy/LgRanxPjxp1is=;
        b=BW0MdAlyKZkK1sS08l1ccgUQON1n2Fz40ROu3CW6VILvluogIlN2VcfHXyYEDmeQU0
         fi4FLQgtk7aFlYKsgeEqas1enqoQrxVEhV1omsRYeIgHtECQh7xrlVNou7pcY9GVwCOs
         RMTOFms6SKtSWvqWsIlbdvgY815/5P2gx4SOIjd+RuqhPxSIVmEBD4Hc+dnk8nUL7o+L
         bmt6CHLgQwXKwj5d3kkGYSR1KZPupDVYhi76e63SZyriNNr4gClu9XBydREpOVJIGzWV
         e7HJcPb/Rxl4ymb0RN+RtgqRzwE3WftAk2Czn6NvKcFl15H6skZ+SB5KKyxv1aiVVWor
         OEsA==
X-Gm-Message-State: AOAM531vDFJI9TYWtnYgdYwsTXcLwU3dfy4ifNhkV4K9jy6d/tEonOtf
        xoKxqB1heESenek8+wfQPKY=
X-Google-Smtp-Source: ABdhPJy6ddS4DVZZT/Z89otAl/i2qG7oOt01OOGTH/wlR4qZ3GLEGQYFaj9weLA1DxqNBlyqNoNSNQ==
X-Received: by 2002:a17:906:94d2:: with SMTP id d18mr4648056ejy.531.1617907130552;
        Thu, 08 Apr 2021 11:38:50 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370e7400428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370e:7400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id yh6sm92125ejb.37.2021.04.08.11.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:38:50 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net v2 0/2] lantiq: GSWIP: two more fixes
Date:   Thu,  8 Apr 2021 20:38:26 +0200
Message-Id: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

after my last patch got accepted and is now in net as commit
3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set
the xMII clock") [0] some more people from the OpenWrt community
(many thanks to everyone involved) helped test the GSWIP driver: [1]

It turns out that the previous fix does not work for all boards.
There's no regression, but it doesn't fix as many problems as I
thought. This is why two more fixes are needed:
- the first one solves many (four known but probably there are
  a few extra hidden ones) reported bugs with the GSWIP where no
  traffic would flow. Not all circumstances are fully understood
  but testing shows that switching away from PHY auto polling
  solves all of them
- while investigating the different problems which are addressed
  by the first patch some small issues with the existing code were
  found. These are addressed by the second patch


Changes since v1 at [0]:
- Don't configure the link parameters in gswip_phylink_mac_config
  (as we're using the "modern" way in gswip_phylink_mac_link_up).
  Thanks to Andrew for the hint with the phylink documentation.
- Clarify that GSWIP_MII_CFG_RMII_CLK is ignored by the hardware in
  the description of the second patch as suggested by Hauke
- Don't set GSWIP_MII_CFG_RGMII_IBS in the second patch as we don't
  have any hardware available for testing this. The patch
  description now also reflects this.
- Added Andrew's Reviewed-by to the first patch (thank you!)


Best regards,
Martin


[0] https://patchwork.kernel.org/project/netdevbpf/cover/20210406203508.476122-1-martin.blumenstingl@googlemail.com/


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Don't use PHY auto polling
  net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits

 drivers/net/dsa/lantiq_gswip.c | 202 ++++++++++++++++++++++++++++-----
 1 file changed, 174 insertions(+), 28 deletions(-)

-- 
2.31.1

