Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95F2E2105
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgLWTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728620AbgLWTqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 14:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608752675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EuGy6qIW0/paAvyDjWz+UUhD6lrJF9atn4prE3pJJ6w=;
        b=WDNwjDgnVXgEcEYAYwbZ7ml5NALur6oqeNj/zWptfALNiywVAC2AT2jaazoWny3CjNJZso
        VlMdH2ICNYtzyq+mIyGLSgaMSthTewtb6e2a6pTJhTF6lKASFJO+fUpRDCOft5E1FlrEOK
        NFdOnjnrvTKhAXnaS1PsPA8azksI3TU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-AKrtKLjGPxeccq_JspZQuA-1; Wed, 23 Dec 2020 14:44:32 -0500
X-MC-Unique: AKrtKLjGPxeccq_JspZQuA-1
Received: by mail-qk1-f197.google.com with SMTP id p185so66588qkc.9
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 11:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EuGy6qIW0/paAvyDjWz+UUhD6lrJF9atn4prE3pJJ6w=;
        b=YK+8Qz0ksh/yo4ksvR32n8uKzyMkKO72hhOJ+epDIJcjaUIVoNg4xpu1qDhP+4oOG8
         HcHZBWf6OfkkfGxssIL6LFBio/0UAlTDgHwegDdphvrJyGTyzM+UZOZQ6ddqG2F09xoV
         1mNslb+T8eY3Ak4z9Y8QcHf7c740MQkMKkgk+hCFuVaESGBAb4iVh05oECuiYRUb1rQC
         EXgTmp5sFvoipxE0bUTJke8CV1MBbXBZIUP9DE2FXNs6VW3DKkKuDYh94+YKwn8KlEeT
         mVNg3RqiNE+LStv7K7/CXaDGs6uOnJURr8L8ShWbJffeevS7Y6np3cXWJ2hVcpGVcEV1
         Jh9w==
X-Gm-Message-State: AOAM533GBX89aC93terAhmogylsX4oVCm4FQwnPYwflgO4U4B7ERMN0f
        fcKKPuhQ7lmWBZNqMra6S3GOTT4uSXcuKwoxEhYHRZU3Cy2RqQMjMzTIdiPSrSqxQB+LSyNjcyn
        UZAQu40KWNLhbjfZs
X-Received: by 2002:a37:5b46:: with SMTP id p67mr28428052qkb.124.1608752672457;
        Wed, 23 Dec 2020 11:44:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnc84b1xei0cRwwa2LGRxGKjZwkeTxy1ErJZY1x5QNthF2Qqq8Btc61gyWkWl6PYehaSPqyw==
X-Received: by 2002:a37:5b46:: with SMTP id p67mr28428041qkb.124.1608752672297;
        Wed, 23 Dec 2020 11:44:32 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p75sm16054644qka.72.2020.12.23.11.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 11:44:31 -0800 (PST)
From:   trix@redhat.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] igb: remove h from printk format specifier
Date:   Wed, 23 Dec 2020 11:44:25 -0800
Message-Id: <20201223194425.125605-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..cb682232df16 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3156,7 +3156,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * the PCIe SR-IOV capability.
 	 */
 	if (pdev->is_virtfn) {
-		WARN(1, KERN_ERR "%s (%hx:%hx) should not be a VF!\n",
+		WARN(1, KERN_ERR "%s (%x:%x) should not be a VF!\n",
 			pci_name(pdev), pdev->vendor, pdev->device);
 		return -EINVAL;
 	}
-- 
2.27.0

