Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68C211EBEB
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfLMUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:36:08 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46442 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbfLMUgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:36:06 -0500
Received: by mail-lf1-f66.google.com with SMTP id f15so197812lfl.13;
        Fri, 13 Dec 2019 12:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ivncv5bPiRGk5bsGVEA1SzyIOzLB2bfta+26W2vvF4=;
        b=Rpw7ILWQu11s0Ta1iSpm/O5qLGjvNj/neO13mbh0G/kHsLzSGV1gFOvSJ9OhcekdTu
         byWUdyEdU/gdSu+KOBa6eoLQ0+XGI+g+SrMUR954+LWywGaV/8OMbbrsSEXg8zyuwsMm
         NoSFtsqsuouCWkUVqJKXTq1Tn08VewWt4OIxejFBwrvzHMKmrcEuQjHJg/b0UmgftFtf
         XHm74mcItGCXBRuT+WRhbU5DUd0AizdY1GXnFkKd+ioae/zsj0RfYQIdlJRzYwRyqgii
         zUDt4xBRnmJo0DX9s6kuWHAkXLrYEIRjYeO3CGx0Nwmk16UQH3C9CCwBLyXmR0KpWh9B
         pMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+ivncv5bPiRGk5bsGVEA1SzyIOzLB2bfta+26W2vvF4=;
        b=RsHtcMET9zBsr/anAXrWVe4twhSN8c79pHUECErjeahDm2WUuQPH840hFE0W3xoAVX
         Q1GPrKUdEXQAtIAEblRwtqZkvmEs6KLsnqbAdYnIGUrNYRJ2J3q0JeeF43Wb8/u0gxzQ
         6PAaVitN09eGqpBtgHI3uqK1Na+t2Z/YQah1xWyPyI0LERuBLZV9wL3ZUkMsFzPj8b/M
         zoFdw+xSQuZsHKioNui2W4aBkByIRLvoDPMm6Lr4ZSt/0bNDs2C/gRsa7VmVANyiERDi
         BXELVZnLgq1THMAuuCpK7hfTEGfE35LHT075CzCfOW1v88iCF65pRqtlsGfM1GZx+rb0
         v7Lw==
X-Gm-Message-State: APjAAAWfC9pLexHeiOW4Dq0HYaEc+iBUhTFrhJZn7jh11KmxE4DcqV69
        GH/ac5Jbe26DPP9let6YxdE=
X-Google-Smtp-Source: APXvYqzT4rrKDLkBuLZ+hiarCISp3A3rrZN91hCdM7gxpFqBKfisvvdj5KKLFvBbwzQc2Zfl3rJNJg==
X-Received: by 2002:ac2:55a8:: with SMTP id y8mr9907885lfg.117.1576269363396;
        Fri, 13 Dec 2019 12:36:03 -0800 (PST)
Received: from vostro.localdomain ([95.10.239.97])
        by smtp.gmail.com with ESMTPSA id l12sm3365930lji.52.2019.12.13.12.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 12:36:02 -0800 (PST)
From:   Mehmet Akif Tasova <makiftasova@gmail.com>
Cc:     makiftasova@gmail.com, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "iwlwifi: mvm: fix scan config command size"
Date:   Fri, 13 Dec 2019 23:35:10 +0300
Message-Id: <20191213203512.8250-1-makiftasova@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since Linux 5.4.1 released, iwlwifi could not initialize Intel(R) Dual Band
Wireless AC 9462 firmware, failing with following error in dmesg:

iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD

whole dmesg output of error can be found at:
https://gist.github.com/makiftasova/354e46439338f4ab3fba0b77ad5c19ec

also bug report from ArchLinux bug tracker (contains more info):
https://bugs.archlinux.org/task/64703

Reverting commit 06eb547c4ae4 ("iwlwifi: mvm: fix scan config command
size") seems to fix this issue  until proper solution is found.

This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.

Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index a046ac9fa852..a5af8f4128b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1213,7 +1213,7 @@ static int iwl_mvm_legacy_config_scan(struct iwl_mvm *mvm)
 		cmd_size = sizeof(struct iwl_scan_config_v2);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
-	cmd_size += num_channels;
+	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
 	if (!cfg)
-- 
2.24.1

