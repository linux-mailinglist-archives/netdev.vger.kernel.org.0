Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1372C6B56
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgK0SHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:07:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731981AbgK0SHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:07:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606500438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=H7PcvPg+i5XoUPzJor4eQ+x6uH9OtzkraZC8rlH6KWc=;
        b=Sd6qm5sVs0pBC29sQ05iQg33dlr7sop+KCab0CrMRg9A3TRRZ+LGgq1GO8DOFRgqJsYShn
        0LPG7KY9KEfcAidQdlC7gdKXOhdmU8YEoCRyN+DO5aE/Hwf1tApRi7ghHoevKysYjz4lrL
        gy3J27PzTpx7IW3pKEEsya//LG3zgMY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-gun7KNNSPiu4bg4eQ4SsEQ-1; Fri, 27 Nov 2020 13:07:16 -0500
X-MC-Unique: gun7KNNSPiu4bg4eQ4SsEQ-1
Received: by mail-qt1-f197.google.com with SMTP id r29so3647227qtu.21
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H7PcvPg+i5XoUPzJor4eQ+x6uH9OtzkraZC8rlH6KWc=;
        b=L0RsLIKjLtfk+R/n6YBQWsV6N8ci5zg6Pp5sKvwJGWy5M9AHHU8ezFCiJ4v2Op2g7O
         oh6YT/YYc9E77VuuIj96tSnzLRKb9CBvU0WrZfeCidAYtfCvw0x/V/I9GfQvZ6uP1gGI
         dWOomE9/76Of7N+vqufGRJC8kH9y0uLnroEP8wKV5SpG8d6MkNbY1AJY3sPDR8ViZcyp
         1zNRKdN1IVIG42Z/zHI2DhuFavwGovdLqYi03E5o6SN7Ejy0j2ufWVT27fn/T7u2b1HJ
         mgBMdlqZYeTAeRbbRRLfFc8etr9j35eAGwFd8O0MrK7qpJAVa51AJDN1H76NMWVLE6b8
         mvag==
X-Gm-Message-State: AOAM5306yiLs7JjQ1VW/QCjvBTG5dz1W/1zY7cSggZUNNwVdNgjmU3fL
        fdsfqvFBcyKLuV2k1TfLEs7f548UoUj8ql1vKMVJe3R+7zPR7AgQe65uMpQuvywJi46amK1NkJJ
        mp3YBzWj0+NWBiQBH
X-Received: by 2002:ac8:5ccc:: with SMTP id s12mr9497615qta.364.1606500436291;
        Fri, 27 Nov 2020 10:07:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrczAlHXv6AxBn4va9GpnW6SljlzQRkczv7FkNfINZgV5uL21V1Nx739W7zcwEcXppYH5Pjg==
X-Received: by 2002:ac8:5ccc:: with SMTP id s12mr9497583qta.364.1606500436056;
        Fri, 27 Nov 2020 10:07:16 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id r127sm6740373qke.64.2020.11.27.10.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:07:15 -0800 (PST)
From:   trix@redhat.com
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        lee.jones@linaro.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: iwlwifi: remove trailing semicolon in macro definition
Date:   Fri, 27 Nov 2020 10:07:09 -0800
Message-Id: <20201127180709.2766925-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c      | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 9d55ece05020..7b2f71e48c97 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -318,7 +318,7 @@ iwlagn_accumulative_statistics(struct iwl_priv *priv,
 		    (__le32 *)&priv->delta_stats._name,		\
 		    (__le32 *)&priv->max_delta_stats._name,	\
 		    (__le32 *)&priv->accum_stats._name,		\
-		    sizeof(*_name));
+		    sizeof(*_name))
 
 	ACCUM(common);
 	ACCUM(rx_non_phy);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
index 68060085010f..8f7c9b7eeeac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/coex.h
@@ -199,7 +199,7 @@ enum iwl_bt_mxbox_dw3 {
 					 "\t%s: %d%s",			    \
 					 #_field,			    \
 					 BT_MBOX_MSG(notif, _num, _field),  \
-					 true ? "\n" : ", ");
+					 true ? "\n" : ", ")
 enum iwl_bt_activity_grading {
 	BT_OFF			= 0,
 	BT_ON_NO_CONNECTION	= 1,
-- 
2.18.4

