Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79884AFB16
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfIKLIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:08:46 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35745 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKLIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:08:46 -0400
Received: by mail-qk1-f195.google.com with SMTP id d26so20433987qkk.2
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=q4c4lKRlk2OQV8SSUUIL1vTg4Ar7L9OdpgREaMynTUY=;
        b=bwVnj6mMqwZ0Gi4L8ncoXRMLOl5uPVnr6LGBPCwz+M5dexVnEFzcxkluDnjyCTcN3a
         13vEsdgf2uYd8s227AKzMXdcWIQap+Av86kVqR5K6LUbM4AKOmUIXKkOlNDFqjjfNJhm
         0t21hPa92XhFaiQqx+W6/HGZTJeXYErKjb3YvuIpLDoRJllitJKCtcPovnS8BfeAAsaa
         CPLGcIk/Oa314qRvd12ZtiaZUHLud1TdDSzNsnqoWCFOpqpfqSslY59gEsS0opKgMTKh
         PO9JLgy+4HzMNOLiMe4ns7wxvqa/fmZQUogfzN7pqRLzT17iSPUqhybpAwN4D1dqxUWt
         0cLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q4c4lKRlk2OQV8SSUUIL1vTg4Ar7L9OdpgREaMynTUY=;
        b=FjEHEiVsJMo2TFFNAYrHp0/hXj22Vib0S3hVrdUizfZptmzscblarnXK/vNjfxKl8l
         iNyEZxf1CttLdB4WQzHr70Y17RUT8mCGGNRQFldK3JkNOA7qMCyYZDxGv8aF3U9G8rxF
         M3IU6WKoVjX5uP0s63Kty7BNtxFTu99A18kJA9rRImPGsuIlN8uwGulfuIvY2nTIupRn
         H3/qbHfATEXqvUjTYwPx+GzrZ9eazucD6px1gIps1VFzdhECO41gamBWc4EqQJHGeaQE
         QuELfP6xqufYoMdxAi7u/l03GXj6md61+LcXvbyKQnTFNTVzz12lVDWxFqTqQkl+wVar
         E0Gw==
X-Gm-Message-State: APjAAAXNoq3d8pIba7Vka1zZmWY55G/ZNQX9iFuPm3wBZrpfu6LSRmjm
        HvSLVJtLIkiqJNsOyr3lvwi7i9CxtJrG7g==
X-Google-Smtp-Source: APXvYqy4v+VIlgeTAAgOO45X408I3ix+GloMwF6HgA6Xv89qPxjl6j+2KWZYD5hkYidWTcwr/cNoPw==
X-Received: by 2002:ae9:ef4c:: with SMTP id d73mr33751950qkg.57.1568200125545;
        Wed, 11 Sep 2019 04:08:45 -0700 (PDT)
Received: from penelope.pa.netronome.com ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id a190sm10232501qkf.118.2019.09.11.04.08.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:08:44 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 0/2] devlink: add unknown 'fw_load_policy' value
Date:   Wed, 11 Sep 2019 12:08:31 +0100
Message-Id: <20190911110833.9005-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dirk says:

Recently we added an unknown value for the 'reset_dev_on_drv_probe' devlink
parameter. Extend the 'fw_load_policy' parameter in the same way.

The only driver that uses this right now is the nfp driver.

Dirk van der Merwe (2):
  devlink: add unknown 'fw_load_policy' value
  nfp: devlink: set unknown fw_load_policy

 drivers/net/ethernet/netronome/nfp/devlink_param.c | 3 ++-
 include/uapi/linux/devlink.h                       | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.11.0

