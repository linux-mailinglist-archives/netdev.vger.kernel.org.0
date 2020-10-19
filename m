Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7C3292E42
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgJSTPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731114AbgJSTPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 15:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603134909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=RGSj1Okw6bTtmOh6LtFIfqugUnOPwzH6b+MxduTDcFI=;
        b=fdR8k2imlnCbJ/V7SjU1fnNokjYAUPvEjCgYDGW3Jc4JBfZfdkVJKGD6UKAE8/rjAFBGZA
        E/aEP8w6/S7kQPMLBS4HLhkLpG+dJSySLCN1Ygx+71ssSjWGkt7iDTenxxU0ZAM6jeqfDT
        x9Z1F8BwtIdRZZzu+FP/fTkBDqTdvEk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-tYqfkafaM4ujP3G5JZXdYA-1; Mon, 19 Oct 2020 15:15:06 -0400
X-MC-Unique: tYqfkafaM4ujP3G5JZXdYA-1
Received: by mail-qt1-f200.google.com with SMTP id h31so659733qtd.14
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 12:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RGSj1Okw6bTtmOh6LtFIfqugUnOPwzH6b+MxduTDcFI=;
        b=TY19JmaHeXvVeTJhrAbp2ohK1CSBbAbGCZ8UJIi3NUG4YKquj9ngvIrApxPk8eg5lO
         +8HGsMDYDwA1Yl8yop57vtUVEb2Mkkouh0uZ1v1FTVjDKsKs6IvHDTyVnPHUWl7hIlAS
         j3837/12nPMPO3ICGd+FIzHiiJ95iotwmwEBnxp5oeM9PV1Cm/xofW/YRM9Q9GI3roNI
         2jLSUfseY7MKHDltQpjArAjG55royiJ3Dne69F9YRYuCpky+dBM9Rcug6K6YqgIJzKc6
         4uVpUj8HbPh1RCGZ9omMwY7uN9yz7HivdmiNQKiYiwRJhOJlFypYtCYVP3xrNRtnvDjC
         9LEw==
X-Gm-Message-State: AOAM531H7IaILzf3e4HGPX2f0pX47dJATzhVTOZrbHFC9Wc8QTuXd+SZ
        cetXaudY9Bo1jyTQaxcPyAPykthk/L8HfLoBa/vCIVCUe7wX/5Sr2LMfZ/+zewKvk1nDGu2BpnY
        DViZRt2bXQLqK06hh
X-Received: by 2002:a37:ac0e:: with SMTP id e14mr1073216qkm.336.1603134905682;
        Mon, 19 Oct 2020 12:15:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe7gZkbDPpHASbLaACCMlaKx46gerbINgHx+8qtcEjJmA0BMQ/ELyGF8Sg3X49xeIdSppc6w==
X-Received: by 2002:a37:ac0e:: with SMTP id e14mr1073199qkm.336.1603134905473;
        Mon, 19 Oct 2020 12:15:05 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id b191sm419142qkg.81.2020.10.19.12.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 12:15:04 -0700 (PDT)
From:   trix@redhat.com
To:     mgreer@animalcreek.com, davem@davemloft.net, bianpan2016@163.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] nfc: remove unneeded break
Date:   Mon, 19 Oct 2020 12:15:00 -0700
Message-Id: <20201019191500.9264-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/nfc/st21nfca/core.c | 1 -
 drivers/nfc/trf7970a.c      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index 2ce17932a073..6ca0d2f56b18 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -794,7 +794,6 @@ static int st21nfca_hci_im_transceive(struct nfc_hci_dev *hdev,
 					      skb->len,
 					      st21nfca_hci_data_exchange_cb,
 					      info);
-		break;
 	default:
 		return 1;
 	}
diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 3bd97c73f983..c70f62fe321e 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -1382,7 +1382,6 @@ static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
 	case ISO15693_CMD_WRITE_DSFID:
 	case ISO15693_CMD_LOCK_DSFID:
 		return 1;
-		break;
 	default:
 		return 0;
 	}
-- 
2.18.1

