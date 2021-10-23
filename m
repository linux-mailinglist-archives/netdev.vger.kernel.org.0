Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31B743829F
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 11:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhJWJ2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 05:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJWJ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 05:28:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E79C061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a26so2404756edy.11
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 02:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuIHyLQJdZG8YdF3RIoTy8IWS1N9u/uXwT6efxdrRxU=;
        b=A4nfZawCcT8eCZk22MqD6btNuI/uDMuuakej5DCQ6MKAuSRAU50PYiWyDFlqauOefc
         wJrs9ULciPvxkjo3kXA6Q9ESxdmL8zWO5FSqnjX4XH58/AviBAP/WSIgZACrdS++ALFt
         wCMJ4z+bpsayrNyot4UMwN86e4h/cEAq5KWYtmNQrVOomGiVyMm/2dMe8eq0mTfVRRLQ
         RLxYJgbHQMXKvDvda0MzeKz8YxHGCSwKFPsyLq/7sYiOscqvkWx/Atn3ZmAfWdQV9Bm+
         iEcp1xrtEdPoPDxKjZib53upNvAQJcQAvSWV/RYCQht/ScHt4v+boNyHJ41Z90H/ca9F
         DtTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xuIHyLQJdZG8YdF3RIoTy8IWS1N9u/uXwT6efxdrRxU=;
        b=uSb8MfY3Z6YJi56IByYn8TNoXngi1GEuXbztd9wfgsXwbzC2V9Kk1fA8Mm5r6IXNq/
         juBsrbj4P2Bzkaewtd0r02aL4PuSy5DRgRPHclDV7mh8I7TUTgs5h7Za9d/Huxxui7qA
         vsPNXfO4Zu4Zhf6CJNOy3BjvOsHF7g6EvIVi1iWtZT5WXs57J2bQAoRb18SzSGj1thhE
         HabIwrMcoTp7CB78zlF9fEBuiC3IQ+bkXHztdgN4VImMfd3EjeblH424VdY+E9yfV8Df
         4RcSGeWdx6FdtvCQ5/aQGatpB0WjX0Dp98U8MWGUc2FzbxUU7kuLMYSrM2spcH4LpAxp
         5fxQ==
X-Gm-Message-State: AOAM533NUTfUNX9gOnx3GkdGgEvMO2Vz2Zpaud3ER6AhGpy8a4SFUeVP
        oz2c7LVASacOis/AmwYIjI4=
X-Google-Smtp-Source: ABdhPJyLwMj2eFRXFNM7LNUgmDUzDkqZgBQv51Pn77oYUQawl0j6j7xVYi2JLxCSlHg7GCmlqMiPSw==
X-Received: by 2002:a05:6402:94c:: with SMTP id h12mr7308956edz.21.1634981192333;
        Sat, 23 Oct 2021 02:26:32 -0700 (PDT)
Received: from localhost ([185.31.175.215])
        by smtp.gmail.com with ESMTPSA id d22sm4887022ejj.47.2021.10.23.02.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 02:26:32 -0700 (PDT)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Small fixes for true expression checks
Date:   Sat, 23 Oct 2021 03:26:16 -0600
Message-Id: <cover.1634974124.git.sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1634974124.git.sakiwit@gmail.com>
References: <cover.1634974124.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

This series fixes checks of true !rc expression.

Jean Sacren (2):
  net: qed_ptp: fix check of true !rc expression
  net: qed_dev: fix check of true !rc expression

 drivers/net/ethernet/qlogic/qed/qed_dev.c | 2 +-
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

