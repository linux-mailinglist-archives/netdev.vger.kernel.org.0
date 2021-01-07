Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1433B2ED39F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbhAGPiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbhAGPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:38:21 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A49C0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g20so10356362ejb.1
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kB7duZbRSwG7nlifEfJU+rxNpJU6RNFYOSLbU84pff4=;
        b=TBKIrdDfsn4EPkSXMx5dYrkLaoyTZ77KRtsXGAJM1BFoTpUqcEj7sLO7latm36/onL
         PuCwe1byZEGDMDL8BYBo4RfAui9v/m4vnmxGynha4+yfwBgI8wv4tfibu8U5ctQGLkEB
         0beyuxmkMUhA6/DsRWEZGaqg2chDdUO7xJEWCYx+esyDAGityWzVOY7FMOhK3cy5ADgQ
         Ioj+XkSSH4vjKzeNFk8HjfkBlzPAljcd8aKCkz/+wEPrrnLbQYQv3ufl7SY7DxVnteVz
         K1FygjGlWkWJNtZh2sG8W55mziCIk1zd+5eQ8rjdYsArnB2iimcZyKaidNGjqK8yEf1c
         fb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kB7duZbRSwG7nlifEfJU+rxNpJU6RNFYOSLbU84pff4=;
        b=V1vt4eruFyvGkVunT2PYLIhNs8+S4kK2uqC0x18P/QoUedVgrCjvcTF+Yl86rhL/xj
         zoDywBZUr1WArvTScYDPWTjDwHl8B8+bFHLy+Dys9AIFj+ImGpwTC2460j9wXirTTAge
         p4skadbmlu4O1AtHZprKJypoSTxaIDHPrL+ttu9z7+HdZ+24q8AGz78XQi5+ldgD8FeM
         wBHaYiaOZmuAQJthbnVqF0I/pyoEAWXYBECh9etLNm9DCPaG7eKU6g07MWKSghAAbS4Q
         u6ZoJpogCphwXaIvIRIvPlvhJd4xr5ZwS1XugmMP9XlaSiFGDqUpGQoRKM/6nqBi7Z3g
         p/1g==
X-Gm-Message-State: AOAM532KJp5F8DgX8+vBw9vH3Jqre3U5Rcvha18BTz2O7j9Jfg5ob/Gb
        aspDFnA7jztroGmqQQE47yM=
X-Google-Smtp-Source: ABdhPJwMKJQP3A/PUTm/wqyFKCCUJgsthfg5l/Tv8rbm3VSzoNLgbxlCuBwQCdUgiDvtU2vz3UWwGQ==
X-Received: by 2002:a17:906:edc2:: with SMTP id sb2mr6417698ejb.159.1610033859988;
        Thu, 07 Jan 2021 07:37:39 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:39 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 0/6] dpaa2-mac: various updates
Date:   Thu,  7 Jan 2021 17:36:32 +0200
Message-Id: <20210107153638.753942-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The first two patches of this series extends the MAC statistics support
to also work for network interfaces which have their link status handled
by firmware (TYPE_FIXED).

The next two patches are fixing a sporadic problem which happens when
the connected DPMAC object is not yet discovered by the fsl-mc bus, thus
the dpaa2-eth is not able to get a reference to it. A referred probe
will be requested in this case.

Finally, the last two patches make some cosmetic changes, mostly
removing comments and unnecessary checks.


Ioana Ciornei (6):
  dpaa2-mac: split up initializing the MAC object from connecting to it
  dpaa2-mac: export MAC counters even when in TYPE_FIXED
  bus: fsl-mc: return -EPROBE_DEFER when a device is not yet discovered
  dpaa2-eth: retry the probe when the MAC is not yet discovered on the
    bus
  dpaa2-mac: remove an unnecessary check
  dpaa2-mac: remove a comment regarding pause settings

 drivers/bus/fsl-mc/fsl-mc-bus.c               |   9 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  53 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  13 ++
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  16 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 134 ++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   5 +
 6 files changed, 125 insertions(+), 105 deletions(-)

-- 
2.29.2

