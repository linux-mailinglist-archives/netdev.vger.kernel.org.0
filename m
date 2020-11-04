Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960512A601D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgKDJGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgKDJG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:29 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A89C061A4A
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:28 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 205so1587017wma.4
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ai/IJbUl7BkHWFCRULoIxTKsMqh/iQX3oMXysG8BbAc=;
        b=S41ZIgdXvVqTIgwwHbRXU3qfzFvgTAbmi4OWfczFRVPCiGiRdj4qPlG5SOwJ5uywTz
         C7T7OcVUBRLLxIeNO1QBd6/dgafcDX/GrnfmzizRtYXClJsrxrkGYkWkzE5HV8vFkaYm
         Vm61EVcb9Sio3FhWr9lOwxMrnovggHCVkOkzb0eA792KgMHqH3xEnNBPRY8O+66QW3Yc
         pKOreTHSGLVhX8ZVb+05G5abH0ecdZVfsgebI7kNT8hHny5gz9YRmE/z8vMpM6ao4ZYf
         160pps1JJ56uHvikDyXT7rqZwNprsktEAGhRk+gUGwr6bikQFEa3BQtdX6sM0bryOOoO
         uMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ai/IJbUl7BkHWFCRULoIxTKsMqh/iQX3oMXysG8BbAc=;
        b=D5UGragoYBLOAM72kWQ0do5PK3EBbiPeZAiOTHfAbs5ho9qhaRlUTG0lCbupt2cjax
         DZEmkJ/p3nMMVnrU+xxXrSeseiS8KAESopwXUocSwOXibtosFN/vJ1WAYymtDRJn/1M4
         QsM0/b9OFITXwpLMWxra6FmI1tgb07tbT5zx2UygxcPfcFmeOPhahPjUAp6PKr7cyhjK
         WRQbFsBRGkDZsW2BMGICTM4cB0SxbGPVwZmh0r7xBPXI4Y04jjH6PgvlVdmoFUb4cMbk
         D3PJ3/I1eKB+PuxiO2N/0SA9fKUe6P74uZfe52Eb2lFHi8pbCWLak1Ss7QYfYwQrSObE
         OuLA==
X-Gm-Message-State: AOAM533IfK5fij/UzKWAZpCU7ubnS1txl4bk77W38OlPu5Rf/lwdq9BC
        MFATBVMqwjL0Ep19pYjNZ+vuqQ==
X-Google-Smtp-Source: ABdhPJwm087ycZiPgwd2s+xPskQ6ypamydQcf3m85VIQR8L0POFSczG6jP7uSl1Gv+7c/M6zdHG47g==
X-Received: by 2002:a1c:6643:: with SMTP id a64mr3528227wmc.142.1604480787291;
        Wed, 04 Nov 2020 01:06:27 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        John Williams <john.williams@xilinx.com>,
        netdev@vger.kernel.org
Subject: [PATCH 03/12] net: ethernet: xilinx: xilinx_emaclite: Document 'txqueue' even if it is unused
Date:   Wed,  4 Nov 2020 09:06:01 +0000
Message-Id: <20201104090610.1446616-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/xilinx/xilinx_emaclite.c:525: warning: Function parameter or member 'txqueue' not described in 'xemaclite_tx_timeout'

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Shannon Nelson <snelson@pensando.io>
Cc: Martin Habets <mhabets@solarflare.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: John Williams <john.williams@xilinx.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5bcc523a..2c98e4cc07a5b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -518,6 +518,7 @@ static int xemaclite_set_mac_address(struct net_device *dev, void *address)
 /**
  * xemaclite_tx_timeout - Callback for Tx Timeout
  * @dev:	Pointer to the network device
+ * @txqueue:	Unused
  *
  * This function is called when Tx time out occurs for Emaclite device.
  */
-- 
2.25.1

