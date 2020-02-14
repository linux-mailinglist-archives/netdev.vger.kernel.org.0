Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBDB15F814
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbgBNUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:49:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55951 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388656AbgBNUs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:48:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so11330811wmj.5;
        Fri, 14 Feb 2020 12:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6XsQT0gObPoSU0UgJgA1GdqnzHklrUE0AMoAAAklsQY=;
        b=QrUJ8uRZoP8v/Sa9/OXY2Ur1o6rwClRgBosKHcqHIhy4H6FCEGUiUI3U1iWG7dM9B/
         ZtxPAx5tCLR820zCr479QJBa3X/1y9n2/Uf3MzepzbLcj2e/7iB58lSCUFLQ8pn+MTqI
         DcF6okbihwy/vkt6VqCfo7wvWbJ0377cV5/42hVXS1vWmmgw/YE5f3JzpjNU9JK3UhBP
         1E41y1TUZWfPbFnQrYMb1BhwgFOTfKTaodaZGTy52+CdnuuW1xMA1MwhRk/hhDAhWO47
         2RHjEYPag5NNX6nFTnR0Nh3+AYXX2GiiOyQlprhoOMoocl1+e5GZetn8SO2HuE24WKCx
         mLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6XsQT0gObPoSU0UgJgA1GdqnzHklrUE0AMoAAAklsQY=;
        b=K2FEt5bgiNi6TerBpdsMo0qRQv4C7rfILwQ5KMfKgAo1kmEpZOYbKZLHHySeRcpA4k
         nXcAmbfW4wa0RBI83T0uNfYSqOMt3qBQhCbI4m3FKdWp9JdonBlspT0U8iSAeldOzfpw
         AdVE0Q8yZB5FDlgLBobry1xkgjA4qcwk66h++t2d9fC6pIjYgaWHIu4HGZtIr1C7/iYx
         YSsPN3h0Bzc2j9UwSDnGXUYd9LdMSHFimdsHsGJVKIsIUA84BxCg6CtkrjTqtNPQJ0QS
         BW8sY6bgri+28l4F4HA9yjX4mATvKHechM8sAy9Y8cznxfQ4E4tSixsZ5V/Y6x/OwN4r
         Rejg==
X-Gm-Message-State: APjAAAX45jIQ9WNU89W5sfqz1QRcUkIP4U8s93J7c05o1dB37ZBmiyAT
        H2GoXDzN46rVOyTL633ovvg6teQzlcCN
X-Google-Smtp-Source: APXvYqzXldjdFQ/xKQ5jBqDIQpiHONTSFYIi8yTrE5t2bn1g4hUzvWWa2Wp6eOkMAlMxgJK8ZEno0A==
X-Received: by 2002:a7b:c7cb:: with SMTP id z11mr6289679wmk.29.1581713337000;
        Fri, 14 Feb 2020 12:48:57 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:48:56 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:SFC NETWORK DRIVER)
Subject: [PATCH 21/30] sfc: Add missing annotation for efx_ef10_try_update_nic_stats_vf()
Date:   Fri, 14 Feb 2020 20:47:32 +0000
Message-Id: <20200214204741.94112-22-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at  efx_ef10_try_update_nic_stats_vf()

warning: context imbalance in  efx_ef10_try_update_nic_stats_vf()
	 - unexpected unlock

The root cause is the missing annotation at
efx_ef10_try_update_nic_stats_vf()
Add the missing __must_hold(&efx->stats_lock) annotattion

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 52113b7529d6..b1102c7e814d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1820,6 +1820,7 @@ static size_t efx_ef10_update_stats_pf(struct efx_nic *efx, u64 *full_stats,
 }
 
 static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
+	__must_hold(&efx->stats_lock)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAC_STATS_IN_LEN);
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-- 
2.24.1

