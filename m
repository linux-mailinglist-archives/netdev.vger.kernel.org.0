Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239752282D
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 20:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfESSBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 14:01:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42199 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfESSBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 14:01:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id 13so6068632pfw.9;
        Sun, 19 May 2019 11:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=czSHCdZXVQZecROM9WqMSFK1y+6AEn76N/qkIDTESik=;
        b=uDVVrwGwtnx8Npp3qrf5HiE/iWJDV19oWasAJ9FbABxVkN3lqGNb5GpH9ssUaMMR6Z
         aRsKNA7spPF3pxJh9i7sUaBTTrprTXLHiYJmWrVhPoIK8EC3e8toHmmbS0npjlo09rnr
         yxy9fb2lFgQnA7l7VAh2Rf40ZjqsYMHoiLAvwi4nXIlZh25QA30pgO7ftv3Qz3F83UjV
         Vkf4XGbLQv4FhPra+819T+EI1lx6jUkcf+CvAHAaOhfwg8bvoEsjUGFfNYNwKAYsYC23
         QYy0FjnzbOItyuIi8jgQApsOYLN4mAzkbJngw9ud4oYYBPDHw5ptJo+jfTLKwkVFPQ8C
         oG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=czSHCdZXVQZecROM9WqMSFK1y+6AEn76N/qkIDTESik=;
        b=oICnz7n/0GGug6Tg1YIfqQsIZUMg44WLK6hD8WlTSjMuwlaCYHuUliQcEa5FyZoLsJ
         V9YVh9VLiFkgCsTIBjBYb03HoLJqPY+crsOKp/fFgBxwa3WVhJLPwEhMjKI0oocuojt1
         DA+SZZ1HT6wN2tzzdD7XVHTtWJkvzDNTl8j2NsWn5uK2P65OgekJRTyyyoeNC5C3l40d
         LXC9XbtgW25b4bFIxSruI8wTtg4kEhmib6hWhb5Mii2ib+7teQV5dLVvctQdnMQEtgW3
         gIVtDXYnIhWv7zpVk+sYmOvg0N5X2jKh4v3H0NSRrxaFkYVOt3vwE7cbYhLyNYhj3D+t
         uMqw==
X-Gm-Message-State: APjAAAU05gzXHI28qCLEsEMRox800Y7IOUd9c3Wy3BpfS/lVPChMR4ag
        I0ZYqhIcIYEZMxCn4sY6iyLGItX0jEs=
X-Google-Smtp-Source: APXvYqy5mFZ/0dgZN58kh6weAW5W4WSKhUs1B9aSm5bjyAYVuJUDvBS7JONYmX+/CCvJadcc44ejsg==
X-Received: by 2002:a63:f710:: with SMTP id x16mr53164518pgh.216.1558236181646;
        Sat, 18 May 2019 20:23:01 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id x23sm13783871pfn.160.2019.05.18.20.23.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 20:23:00 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        houweitaoo@gmail.com, rafal@milecki.pl
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: fix typos in code comments
Date:   Sun, 19 May 2019 11:22:56 +0800
Message-Id: <20190519032256.19346-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix lengh to length

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index 8ea27489734e..edd2f09613d8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -314,7 +314,7 @@ brcmf_create_bsscfg(s32 bsscfgidx, char *name, char *data, u32 datalen,
 		return brcmf_create_iovar(name, data, datalen, buf, buflen);
 
 	prefixlen = strlen(prefix);
-	namelen = strlen(name) + 1; /* lengh of iovar  name + null */
+	namelen = strlen(name) + 1; /* length of iovar  name + null */
 	iolen = prefixlen + namelen + sizeof(bsscfgidx_le) + datalen;
 
 	if (buflen < iolen) {
-- 
2.18.0

