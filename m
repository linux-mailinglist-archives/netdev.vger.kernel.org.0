Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5816885A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 21:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgBUU3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 15:29:17 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39383 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBUU3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 15:29:16 -0500
Received: by mail-pf1-f193.google.com with SMTP id 84so1839159pfy.6
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 12:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=es-iitr-ac-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=AhyF1vb5J/RNFh5gS2ZeVN61pIuMZEud+IXqME7A2aY=;
        b=jwlue2HYdUOtUGPGUVjbVXq5HJ2rdtSNWs+ZDK/Y+cW4vXSOIAez8Jx7Jf8LGCxEP2
         a7XGIyTM213EGwZu8d6sT1rcSj7wf4A0k9d/XRrKxeahVrfOrUqNfbZW0/1pVBN29TSh
         S/B1bn8I0UTpU3ah1q9HpW2nIOdDxx0YqsOeSZVwd00I00OYkcww7FSalaZbreyiQ+/k
         hGH5W5KbngHWQCNBZK+K4DU1GxkP6hz1IbTLUYiF6OD17EgSuQN7kx49w9eDBRK8EH1c
         jf+922Y7SD5MBYpGZ+TaNciPqTu2a0vlykggsd5n3KL4MLIrhqUVRstrQD0VKbwU5DYL
         k53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=AhyF1vb5J/RNFh5gS2ZeVN61pIuMZEud+IXqME7A2aY=;
        b=UBcz4/oLXoDxFJscj23AKrgVtUaX4aVm6db+kmjJbC4PqDhYdtt7djiApEhwO+ZdqR
         FX9zvKqi/HlbjO0TTL6Z9k29fBuir5nBmgEin+6TkDhmV4uM/bWGvZX1Jz9p6SdNVCgQ
         ullLoAtpLwSzxn+YlN/39Dm1tqay9jIHqvDBcgwBhYF+pYA8bkzPQIEuvhowdO8+dVp3
         UW/7cl0QumgZAvyamxCM6bpfaQs6FJjyijSySKTTM2eTuPJV/nV6mxCtA0tBRLlp1k4B
         BU7PDBRmKicDqpYHBBNCHZ53UiJRkVtHx/9R4Man5CNmTH0gf1ryq4GwC7wVNxV2hP8p
         z3JQ==
X-Gm-Message-State: APjAAAWRuSx+0JFWLFg2rrebywOm8RDe+4ebvP2pXjOyyKUH5jFsRjPm
        03Hfdc2dtdAIIyYa3nisDtZ3Pg==
X-Google-Smtp-Source: APXvYqxFWZN+hGzdjri4i8S+3BEyF1Y//evwgvtuMy4DH27kRD8V2nP2Qdg5E3PjrydgrvgYKNtFHw==
X-Received: by 2002:aa7:8597:: with SMTP id w23mr8980021pfn.38.1582316954634;
        Fri, 21 Feb 2020 12:29:14 -0800 (PST)
Received: from kaaira-HP-Pavilion-Notebook ([103.37.201.178])
        by smtp.gmail.com with ESMTPSA id az9sm3393890pjb.3.2020.02.21.12.29.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 12:29:14 -0800 (PST)
Date:   Sat, 22 Feb 2020 01:59:04 +0530
From:   Kaaira Gupta <kgupta@es.iitr.ac.in>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: add braces on all arms of if-else
Message-ID: <20200221202904.GA19627@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix all checkpatch.pl warnings of 'braces {} should be used on all arms
of this statement' in the file qlge_ethtool.c by adding the braces.

Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
---
 drivers/staging/qlge/qlge_ethtool.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 790997aff995..592ca7edfc44 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -259,8 +259,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -273,8 +274,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -290,8 +292,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -304,8 +307,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -316,8 +320,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Error reading status register 0x%.04x.\n", i);
 		goto end;
-	} else
+	} else {
 		*iter = data;
+	}
 end:
 	ql_sem_unlock(qdev, qdev->xg_sem_mask);
 quit:
@@ -488,8 +493,9 @@ static int ql_start_loopback(struct ql_adapter *qdev)
 	if (netif_carrier_ok(qdev->ndev)) {
 		set_bit(QL_LB_LINK_UP, &qdev->flags);
 		netif_carrier_off(qdev->ndev);
-	} else
+	} else {
 		clear_bit(QL_LB_LINK_UP, &qdev->flags);
+	}
 	qdev->link_config |= CFG_LOOPBACK_PCS;
 	return ql_mb_set_port_cfg(qdev);
 }
-- 
2.17.1

