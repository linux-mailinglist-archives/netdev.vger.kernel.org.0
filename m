Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2082D3F3FAA
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhHVOCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 10:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbhHVOCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 10:02:20 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C20C0617AD;
        Sun, 22 Aug 2021 07:01:34 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g138so8839677wmg.4;
        Sun, 22 Aug 2021 07:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=quc2glksFzIpYe/71nWFAnXvhf2MCzTs4gt4GOznpHY=;
        b=C5WPzJHGaKKwSyH1L7XF1ewVO2Sg4gwHXdCSzOl6tOXRTUp96aRQ57g5ZMWT53IgK8
         ReE1RHUOoYFDtwlLHLc5iVIpOj923Yu73Tkin2KeKtSPYQgGksW1z4k0XdjvCq2CtStw
         8BjlKb2HATWtDxrMekqg6Re4ARPVfNBhw/3JZF/3wpIufPvjuIYtydWi2yTwY5BzSeaC
         QNDU/YMVOLKV3EycWy71bjEEKAZ3O89FJmJwZ4WgvjEWM3yyKi25YZi8xN9MRpoOgQdZ
         glyTRZM8Reby66hydsiWICSbR4/G911y1G07eVZx3B6l3hhzhuvOGiF28X+PbnHbrD/R
         JvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=quc2glksFzIpYe/71nWFAnXvhf2MCzTs4gt4GOznpHY=;
        b=RxhO50EcP02ITfWKWyo5DlNuKiNnqNaTwOkXF3zYjUkZ9Gmof10YOT7aHf2qwaW9ah
         1Opn/l/cQqjYqAiC8ro7CBkQOZfDqm+RvjdlFNPqJrkNZ3pzMYS2eMSRsz8jk9WrFBnX
         Kb9gW2IVOdrVMUHI7UjdykXLalQ6m5wN/34oY3nhpKk3Ae46q70+PQKo5RzJqwIXwZ3s
         zr15frZlcI3LfVnje8i+9hXnbeLLCdSpJ5CkZtDfGbiHYZ1+AEoKkejHEnB2I1S6I7Rw
         xO3Jk9L9Q/r8en8epq+2oyZ9gGeuUEfCQwUW3vSS24R8nJS3NmPuvE/Mot8tyFSzokdk
         3rHw==
X-Gm-Message-State: AOAM533qohsxfeYdlzWW6I/bNogrkUVtjUWT4UxyuD68ekirLxh0ULJF
        tQvm/cIShiqe8/imFmxd2PECzqY3VyQFyA==
X-Google-Smtp-Source: ABdhPJwOOmBcA3shwYluKb7pEMCw+OL9YzdLlqPut57f6XKbaR4MZCbdtqtheeQj4VXJBgrsGgDsmQ==
X-Received: by 2002:a05:600c:3b98:: with SMTP id n24mr12102835wms.11.1629640892647;
        Sun, 22 Aug 2021 07:01:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:fc53:5e22:f926:c43b? (p200300ea8f084500fc535e22f926c43b.dip0.t-ipconnect.de. [2003:ea:8f08:4500:fc53:5e22:f926:c43b])
        by smtp.googlemail.com with ESMTPSA id d4sm12264651wrz.35.2021.08.22.07.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 07:01:32 -0700 (PDT)
Subject: [PATCH 10/12] cxgb4: Remove unused vpd_param member ec
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Message-ID: <30648e95-bfb9-9af3-0c8f-dd3e34df8b6b@gmail.com>
Date:   Sun, 22 Aug 2021 15:58:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1ca29408-7bc7-4da5-59c7-87893c9e0442@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Member ec isn't used, so remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h | 2 --
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 5 +----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 9058f09f9..ecea3cdd3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -84,7 +84,6 @@ extern struct mutex uld_mutex;
 enum {
 	MAX_NPORTS	= 4,     /* max # of ports */
 	SERNUM_LEN	= 24,    /* Serial # length */
-	EC_LEN		= 16,    /* E/C length */
 	ID_LEN		= 16,    /* ID length */
 	PN_LEN		= 16,    /* Part Number length */
 	MACADDR_LEN	= 12,    /* MAC Address length */
@@ -391,7 +390,6 @@ struct tp_params {
 
 struct vpd_params {
 	unsigned int cclk;
-	u8 ec[EC_LEN + 1];
 	u8 sn[SERNUM_LEN + 1];
 	u8 id[ID_LEN + 1];
 	u8 pn[PN_LEN + 1];
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 1ae3ee994..2aeb2f80f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2744,7 +2744,7 @@ int t4_seeprom_wp(struct adapter *adapter, bool enable)
 int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 {
 	int i, ret = 0, addr;
-	int ec, sn, pn, na;
+	int sn, pn, na;
 	u8 *vpd, base_val = 0;
 	unsigned int vpdr_len, kw_offset, id_len;
 
@@ -2807,7 +2807,6 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	}
 
-	FIND_VPD_KW(ec, "EC");
 	FIND_VPD_KW(sn, "SN");
 	FIND_VPD_KW(pn, "PN");
 	FIND_VPD_KW(na, "NA");
@@ -2815,8 +2814,6 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 
 	memcpy(p->id, vpd + PCI_VPD_LRDT_TAG_SIZE, id_len);
 	strim(p->id);
-	memcpy(p->ec, vpd + ec, EC_LEN);
-	strim(p->ec);
 	i = pci_vpd_info_field_size(vpd + sn - PCI_VPD_INFO_FLD_HDR_SIZE);
 	memcpy(p->sn, vpd + sn, min(i, SERNUM_LEN));
 	strim(p->sn);
-- 
2.33.0


