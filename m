Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7F4A4E94
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356707AbiAaShz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356713AbiAaSh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 13:37:29 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3D6C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:37:28 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id l25so27114237wrb.13
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 10:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=lKtA3DhtaWtkIH5UsQ9oQVxQxSpvvO/J7hzm8/3EI5U=;
        b=ZWDdLOVh4lAihtGTx1X/+Awqa78dUOH7IBlp+c3Gpyxo3cKKhdSXeZNqoV4PkHk1EB
         QKPulhHVRbOXMof6YTMlZ282RdN7nWqlXQRlmiQDbMnVFktCL93JpSZnAryf4aa4E32s
         p4WQ4VfarrRKuWWwAISaxRrZ+5OaXqa2Rftr5bNtkXqi/BO4XTOmcDa+GOczKI7SsHsv
         Lw4fbo826HpEuKjLeq6n237Fym9tG4FXixRyWDuYQrj88WXEnYlQHBmgq8RaFab3xR6E
         NA6eoybB6gmvbV7EngsHP0UFqT2CuuKXI9fg2fxFDyTHc4OUcw81NxcV6YQHLUl1OIA2
         c8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=lKtA3DhtaWtkIH5UsQ9oQVxQxSpvvO/J7hzm8/3EI5U=;
        b=7enV/hXMGdJsLRVYO10Dh1huLw3gRyfj5+WYyJhJ0uX4MQjgmLk7W0LgHcB9Q0+Q5g
         1AcifPSPKQbHcG+joF8WEDIG6QZK/o2GewE3xWyiNNvnuV/Y7+2ErhTLE2MqxzYZhh1U
         syQuJJ/IzYBLHD4yeywSzIPkAOv+oytsGFGj5rTzkfQqlpV7M9sSV+vrYlM71CpCqsUd
         mYTVy2i+Lav9NIWf8VBhPBwocC4UZOXSLtYySRftNJrEwxE7UmyE/+ni620IBtEGYCpz
         EkCb/zCmgHpiAl7DZu6joo6Hj8zAx/oWawTAW+eWHFjkpPzokatbznpVxXYDkwB+5/Cb
         EA9w==
X-Gm-Message-State: AOAM531i60xFso6miC0mTFNGT8nF7CZRw0y+VGqtpRKANPE+x41ATsp/
        bfmHGwqs+2I8NHWRFXsmCZ5BFh0yRsY=
X-Google-Smtp-Source: ABdhPJx/4f1pe3YuuM4sJcxNpDhZfSUOp7UJRag/GMXyCJ/iYEhYv3BXlekaKf45gknfheTxvwpxCg==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr18714773wrn.648.1643654247345;
        Mon, 31 Jan 2022 10:37:27 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:5999:1eb2:814b:f0be? (p200300ea8f4d2b0059991eb2814bf0be.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:5999:1eb2:814b:f0be])
        by smtp.googlemail.com with ESMTPSA id e9sm6573821wrg.60.2022.01.31.10.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 10:37:26 -0800 (PST)
Message-ID: <4784d5ce-38ac-046a-cbfa-5fdd9773f820@gmail.com>
Date:   Mon, 31 Jan 2022 19:37:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: support L1.2 control on RTL8168h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Realtek RTL8168h supports the same L1.2 control as RTL8125.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3c3d1506b..7a3d489ca 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2686,6 +2686,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
 
 		switch (tp->mac_version) {
+		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			/* reset ephy tx/rx disable timer */
 			r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
@@ -2697,6 +2698,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		}
 	} else {
 		switch (tp->mac_version) {
+		case RTL_GIGA_MAC_VER_45 ... RTL_GIGA_MAC_VER_48:
 		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
 			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
 			break;
-- 
2.35.0

