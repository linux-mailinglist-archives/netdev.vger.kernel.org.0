Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD5380FE0
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhENSla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:41:30 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:44642 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhENSl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:41:29 -0400
Received: by mail-ej1-f54.google.com with SMTP id lz27so60226ejb.11;
        Fri, 14 May 2021 11:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lxrxc/3Z3jVIsCsgfSFIGV92bNeYHWS7yDIGi9KJTvU=;
        b=P5DTGQqiLEKFQcq8lCsvNn+4u/gQL6UlonT2HW1PJCH9kUnRFYQ5UlqOLG9VPD46kp
         O9sie0Mag4RGJw68HItyRxxrUQTzUOu/+xSiYXE8V0ux7HGqj1lzbgsti45xX3p5lRu5
         pEv5nzHr4lafdwoTq80Nlq3ILTpsSKSU2/huYoQeZEH15UnRh5sUgzZYdogeuC71AgG8
         hHbsDdhUFY/9W2+3y9t6TdVVD1U2k88ug1kNxscTC/RTZOhZKJbWDV+6/hmmTqHUrp/Q
         92w7t2oiuU99l5n5q8XWG/18153/cA4UVqY7XnB95yamA2Bf6TeR73JXpbuD1VtKC8oB
         5slA==
X-Gm-Message-State: AOAM531UxwOBkMn1eOWtHJwdumVE2OIInMC2tBsWqAl4ZMWtiuB2dpuQ
        qOXQIwHwbd/wtFES5wzGZhsgA94+L/tc4nyj
X-Google-Smtp-Source: ABdhPJxBodBBYmBXuen9Ejp5wfOYCaCjxZ1MET6PdnzFoJwHDXVXjsBYdM8lj2LlwI6HA+CHmlPOAQ==
X-Received: by 2002:a17:906:c0c3:: with SMTP id bn3mr50194763ejb.498.1621017616765;
        Fri, 14 May 2021 11:40:16 -0700 (PDT)
Received: from turbo.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id dj17sm5081505edb.7.2021.05.14.11.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:40:16 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next 0/3] net: use XDP helpers
Date:   Fri, 14 May 2021 20:39:51 +0200
Message-Id: <20210514183954.7129-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The commit 43b5169d8355 ("net, xdp: Introduce xdp_init_buff utility
routine") and commit be9df4aff65f ("net, xdp: Introduce xdp_prepare_buff
utility routine") introduces two useful helpers to populate xdp_buff.
Use it in drivers which still open codes that routines.

Matteo Croce (3):
  stmmac: use XDP helpers
  igc: use XDP helpers
  vhost_net: use XDP helpers

 drivers/net/ethernet/intel/igc/igc_main.c         | 9 +++------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++------
 drivers/vhost/net.c                               | 6 ++----
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
2.31.1

