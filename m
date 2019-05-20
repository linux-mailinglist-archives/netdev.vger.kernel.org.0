Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E019923624
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390331AbfETMn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 08:43:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43999 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389397AbfETM2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 08:28:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so189909pgv.10;
        Mon, 20 May 2019 05:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hB3PHyrs53San/vhDwKRpRyPdI0a/I1a2f3pjFTkUE4=;
        b=Dj6rxER+7wkxWxh9ncQ8235KU6jkkd6A60sumII2etXOJfRWzKRMI+PilghA5nj4EG
         jRr+1A3Q7sDU1MIUwj5Ln1rQmAzYMjqW0wXbeHqt4fmdseaVwTVi4djbj/JdjOHxFNLR
         pyamqSgmB1aFeaW4Z9n8kmVJrpWDvw1Gn/4nn8Lw1A7aA3SSsppCi4fWPgJqbclRf4Sl
         7d6v4T7sX1kRHyCxbwC8lhdpDbY9e3DOsZZvvNdVzKJ+o/XDxhaPYlbxIeGMfuge4vUa
         ArvAoihzT4Y3V9a1Sw7sbFd9GWzgmA1HCuzhhHJY+2JaYHiwq5IXOugEoKcGvJ+AtYlC
         VJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hB3PHyrs53San/vhDwKRpRyPdI0a/I1a2f3pjFTkUE4=;
        b=I7sQpabtCwB/Lsz/eCdLSbectA4U2npASBlXeL4ttTNk97BxjFRZoSIdIOHyD75tA6
         Ujvf3Pt6APhLV2OmgF6/TP6siQ3ZXnYMSFno1mb6xIcmXUE764pcHW09NXPz8FiqSdRm
         iur64syb55wJDi+dY4dWgHiMfyNaJBibe/nndTpoj0Bm8qWhvgg7ES8QX6IE82tewG1x
         AGbm5ewEbm72fPARGoezOIOuSlluAmbA+Zme7n/xkLpzsxQrI4Nx6Do+QDpY4F284kFn
         r5wYIwH+WtETQhVScmBWWpV7OpnlOI4PcZm8IcBi/lhrPWD898YW1eURnuMtf4IAJDom
         PohA==
X-Gm-Message-State: APjAAAXmFFMhfddaPAyJYothzyp3XrkhfZgq3VzAISj0kQ5jA16wnhu/
        PjkVqv9cL6maolktBMZDImI=
X-Google-Smtp-Source: APXvYqwaLDrWw7c0Fs1bKjKOaDP5fyg9p7qm+2PKXEbMZux7rZ1ZmgUv7+LmqyKVykIc0nPFeA/87Q==
X-Received: by 2002:a63:7909:: with SMTP id u9mr68890137pgc.223.1558355334363;
        Mon, 20 May 2019 05:28:54 -0700 (PDT)
Received: from localhost ([43.224.245.181])
        by smtp.gmail.com with ESMTPSA id s2sm16226302pfe.105.2019.05.20.05.28.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 05:28:53 -0700 (PDT)
From:   Weitao Hou <houweitaoo@gmail.com>
To:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, kvalo@codeaurora.org, davem@davemloft.net,
        houweitaoo@gmail.com, rafal@milecki.pl
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] brcmfmac: fix typos in code comments
Date:   Mon, 20 May 2019 20:28:25 +0800
Message-Id: <20190520122825.981-1-houweitaoo@gmail.com>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix lengh to length

Signed-off-by: Weitao Hou <houweitaoo@gmail.com>
---
- fix prefix
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

