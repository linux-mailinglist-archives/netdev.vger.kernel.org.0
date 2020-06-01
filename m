Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1F31EAD91
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgFASqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728444AbgFASqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:46:17 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4147C061A0E;
        Mon,  1 Jun 2020 11:46:16 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f5so564056wmh.2;
        Mon, 01 Jun 2020 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yC2JNqaMtAkcCstXMD1OLdmFXFYbSrgxv313zGmoBpg=;
        b=tTYJlBEYMNZvBGCBO6TjRr0O6X67GYQMyMfKFjlLyLagf61IkcvdCiQhSFSyi7pIRJ
         CjMclrZicbcfS9hpXyacz68X7gPO7Mhdqsr/G7uwLj6iIe8+iOBC/QfsVxow0AoeS/Vi
         NbGtdY6b6NW9oLjO5OZagpcavd3/nfiP5c9+6tb/41miM1KStCGyD77L/FmCgD16Ne7V
         DtzbigiIArZRCkyqidG3fbcHA0RFqHdbyoJHGu7xA6FwH2Ggoa7qV4oy0bhFQE9qQpM6
         BtugETeaVK4C/AfcuGrO4zQiSPpo/VJzSFPvLcvU5XQKuwA/Lb95QNFvFZz/GFVzvI+Y
         9Fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yC2JNqaMtAkcCstXMD1OLdmFXFYbSrgxv313zGmoBpg=;
        b=mpIYYapcDZE3Nj2SYlVZ2FRTqqxc/Rny7CFjNZPRiGADRBI9tBfFVbotXmv5I+BrXF
         JZjj9ifREbNggUtJ45kA/1YoPPz2YTkOHmGbCzJsuuNc7M/wMd5HA+AJwJ1NaYbFshLm
         28n7uhC6ZaSy+wFJzdHKe7BOZqWSwFSfOTlAmiNOKRFzXQxhfvSqpJ07560u7Lt6mskp
         0FOB5rb+i/pJdurfctgvADmHLlvcQ/oaU0ad2wzYqdSmB0aj9x/fDGcyT/SPYnY6K7NR
         X+dpeZutL4EElrcXRQeQfWutSKcQAsKGWxrKbV16JOeV4JVO7Uc1od1GeIptuQ/rYxLp
         Z9Ug==
X-Gm-Message-State: AOAM531TgSD7hxoFJ4rtll15tx3LLiptIfRiXavTamX3eUEXLkqKYiZc
        L+4f2+DQjnhuybPraY///BRUegOEuGs9
X-Google-Smtp-Source: ABdhPJxYAaKeGr4cCdAQgov6CqNU43C2XC13QVZdwZ1XaZCZ6K6WDudBOAjdkMCNUu6F5VhkUDUk/g==
X-Received: by 2002:a7b:c311:: with SMTP id k17mr582316wmj.148.1591037175510;
        Mon, 01 Jun 2020 11:46:15 -0700 (PDT)
Received: from earth3.lan (host-92-15-172-76.as43234.net. [92.15.172.76])
        by smtp.googlemail.com with ESMTPSA id 23sm302229wmg.10.2020.06.01.11.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 11:46:15 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, paulmck@kernel.org, mingo@redhat.com,
        boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:SFC NETWORK DRIVER)
Subject: [PATCH 5/5] sfc: add  missing annotation for efx_ef10_try_update_nic_stats_vf()
Date:   Mon,  1 Jun 2020 19:45:52 +0100
Message-Id: <20200601184552.23128-6-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200601184552.23128-1-jbi.octave@gmail.com>
References: <20200601184552.23128-1-jbi.octave@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at efx_ef10_try_update_nic_stats_vf()
warning: context imbalance in efx_ef10_try_update_nic_stats_vf()
	- unexpected unlock
The root cause is the missing annotation at
efx_ef10_try_update_nic_stats_vf()
Add the missing _must_hold(&efx->stats_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/ethernet/sfc/ef10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 3f16bd807c6e..e8bbbd366625 100644
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
2.18.2

