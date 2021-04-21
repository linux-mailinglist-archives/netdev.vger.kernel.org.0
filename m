Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD6366A62
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbhDUMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbhDUMFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:05:34 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B78C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id u4so47402347ljo.6
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=Q195i5LlzoVZ1oEl4Tz+fBIu0vY1xsoPr9t3lPnoPj0=;
        b=Aq92LRuhd+7ib74tI3vNqQuCT1X5LsejCpo7hXqSFXHMtvZEazHHvdjg9XMkHFh2Gf
         y3X+VKp0b3QDZ4+UbrKF8bhfqX5OzQCwxCErnGkdznZWuEwzW9pUJzndKEXXyKJOSs7v
         PFZ7fjo+5U8dkBHaCoAfFHUn7ypGC7vurwn8UpstrgHH4CIqWJS+28pN2p0OhR9muVlB
         BOJe+EuJ3AZaquvpk7z18aPDodex8xHz7TForTUtUm4r/oMDf7OC+CuHnfDWS5IXCRZ/
         EpCwkSFGRaC9TX3lwUsqsvV/eLfvDhW7f5ymaxgjY7i+MNBT2g6UfxbD9O9SaaNOYG+Y
         mMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=Q195i5LlzoVZ1oEl4Tz+fBIu0vY1xsoPr9t3lPnoPj0=;
        b=uGzonyGFcbttscKB/IHJsf5AxguV0NJwIyptsFrhMhU27otLmkqHVH/hlF53PZEh53
         I3VO2b1oyaTLraVwaoltRfbtv2hejdVZxcdE06cS4tCt/duhhzy7YICkEDlIknOC03FI
         bn2TdRfr+k7w6yS3QEriySW/xn4J8VI0gBQe3BT1l00R0+47nyYcq5F8TP6Xf67BSTkD
         z9y9Sp4bmpGKfHNroO2loF93VFqhquSEUXKkLXWHyRcljaZ/P0UG9R9OABABdzR89zlj
         SmHAb9Qfk0CKyp8IKZ/5BVdH6dyLNjegRab1uK0UtJnl6zd478DNpacVmLryWROXdGMM
         zu6g==
X-Gm-Message-State: AOAM532+bGbkloizd1cppx4u/5t1yxtNwA29ody8WO64gNPi3gJkGfDH
        etxIjjqyACvRAz3VhQGgtfal2g==
X-Google-Smtp-Source: ABdhPJz9/iKKRa1qOwOYXMw6olbtqvY73hy2dG04Ve15e1B+ackejI5/yhB1U0NXQJv7rzdi55Vq1w==
X-Received: by 2002:a2e:6a05:: with SMTP id f5mr4422213ljc.23.1619006699484;
        Wed, 21 Apr 2021 05:04:59 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r71sm193430lff.12.2021.04.21.05.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 05:04:59 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: dsa: mv88e6xxx: Tiny fixes/improvements
Date:   Wed, 21 Apr 2021 14:04:51 +0200
Message-Id: <20210421120454.1541240-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just some small things I have noticed that do not fit in any other
series.

Tobias Waldekranz (3):
  net: dsa: mv88e6xxx: Correct spelling of define "ADRR" -> "ADDR"
  net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
  net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region

 drivers/net/dsa/mv88e6xxx/chip.c    |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.h    |  3 ++
 drivers/net/dsa/mv88e6xxx/devlink.c | 58 ++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global2.c | 17 +++++++++
 drivers/net/dsa/mv88e6xxx/global2.h |  4 +-
 5 files changed, 81 insertions(+), 3 deletions(-)

-- 
2.25.1

