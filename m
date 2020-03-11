Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A76C180F5D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgCKFH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:07:28 -0400
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:42538 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728271AbgCKFH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:07:27 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id D286418223249;
        Wed, 11 Mar 2020 05:07:25 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1535:1605:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2741:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3867:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4049:4118:4250:4321:4605:5007:6261:7875:8957:9025:9040:9592:10004:10848:11026:11473:11658:11914:12043:12048:12296:12297:12438:12555:12679:12895:12986:13894:13972:14096:14394:21080:21433:21611:21627:21811:21939:21990:30045:30046:30054:30070:30075,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:0,LUA_SUMMARY:none
X-HE-Tag: work52_236f7ea7b4c4a
X-Filterd-Recvd-Size: 7640
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:07:23 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH -next 020/491] XEN HYPERVISOR INTERFACE: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:34 -0700
Message-Id: <93cb221f897e6d5d37539d9a8dcf8be7797bd401.1583896348.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/xen-blkfront.c               | 5 ++---
 drivers/net/xen-netfront.c                 | 2 +-
 drivers/pci/xen-pcifront.c                 | 2 +-
 drivers/scsi/xen-scsifront.c               | 2 +-
 drivers/xen/pvcalls-front.c                | 2 +-
 drivers/xen/xen-acpi-memhotplug.c          | 2 +-
 drivers/xen/xen-pciback/xenbus.c           | 2 +-
 drivers/xen/xen-scsiback.c                 | 2 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c | 6 ++----
 9 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9df516..fb07ee1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1402,7 +1402,6 @@ static enum blk_req_status blkif_rsp_to_req_status(int rsp)
 	case BLKIF_RSP_EOPNOTSUPP:
 		return REQ_EOPNOTSUPP;
 	case BLKIF_RSP_ERROR:
-		/* Fallthrough. */
 	default:
 		return REQ_ERROR;
 	}
@@ -1642,7 +1641,7 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				info->feature_flush = 0;
 				xlvbd_flush(info);
 			}
-			/* fall through */
+			fallthrough;
 		case BLKIF_OP_READ:
 		case BLKIF_OP_WRITE:
 			if (unlikely(bret->status != BLKIF_RSP_OKAY))
@@ -2480,7 +2479,7 @@ static void blkback_changed(struct xenbus_device *dev,
 	case XenbusStateClosed:
 		if (dev->state == XenbusStateClosed)
 			break;
-		/* fall through */
+		fallthrough;
 	case XenbusStateClosing:
 		if (info)
 			blkfront_closing(info);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c..2001606 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2038,7 +2038,7 @@ static void netback_changed(struct xenbus_device *dev,
 	case XenbusStateClosed:
 		if (dev->state == XenbusStateClosed)
 			break;
-		/* Fall through - Missed the backend's CLOSING state. */
+		fallthrough;	/* Missed the backend's CLOSING state */
 	case XenbusStateClosing:
 		xenbus_frontend_closed(dev);
 		break;
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index d1b16c..093ab8 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -1103,7 +1103,7 @@ static void __ref pcifront_backend_changed(struct xenbus_device *xdev,
 	case XenbusStateClosed:
 		if (xdev->state == XenbusStateClosed)
 			break;
-		/* fall through - Missed the backend's CLOSING state. */
+		fallthrough;	/* Missed the backend's CLOSING state */
 	case XenbusStateClosing:
 		dev_warn(&xdev->dev, "backend going away!\n");
 		pcifront_try_disconnect(pdev);
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index f0068e..259fc248 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -1111,7 +1111,7 @@ static void scsifront_backend_changed(struct xenbus_device *dev,
 	case XenbusStateClosed:
 		if (dev->state == XenbusStateClosed)
 			break;
-		/* fall through - Missed the backend's Closing state */
+		fallthrough;	/* Missed the backend's Closing state */
 	case XenbusStateClosing:
 		scsifront_disconnect(info);
 		break;
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 57592a6..0fccf0 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -1260,7 +1260,7 @@ static void pvcalls_front_changed(struct xenbus_device *dev,
 		if (dev->state == XenbusStateClosed)
 			break;
 		/* Missed the backend's CLOSING state */
-		/* fall through */
+		fallthrough;
 	case XenbusStateClosing:
 		xenbus_frontend_closed(dev);
 		break;
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memhotplug.c
index 745721..f914b72 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -229,7 +229,7 @@ static void acpi_memory_device_notify(acpi_handle handle, u32 event, void *data)
 	case ACPI_NOTIFY_BUS_CHECK:
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 			"\nReceived BUS CHECK notification for device\n"));
-		/* Fall Through */
+		fallthrough;
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		if (event == ACPI_NOTIFY_DEVICE_CHECK)
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 833b2d..a108740 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -544,7 +544,7 @@ static void xen_pcibk_frontend_changed(struct xenbus_device *xdev,
 		xenbus_switch_state(xdev, XenbusStateClosed);
 		if (xenbus_dev_is_online(xdev))
 			break;
-		/* fall through - if not online */
+		fallthrough;	/* if not online */
 	case XenbusStateUnknown:
 		dev_dbg(&xdev->dev, "frontend is gone! unregister device\n");
 		device_unregister(&xdev->dev);
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index ba0942e..9daef2 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1184,7 +1184,7 @@ static void scsiback_frontend_changed(struct xenbus_device *dev,
 		xenbus_switch_state(dev, XenbusStateClosed);
 		if (xenbus_dev_is_online(dev))
 			break;
-		/* fall through - if not online */
+		fallthrough;	/* if not online */
 	case XenbusStateUnknown:
 		device_unregister(&dev->dev);
 		break;
diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 8a1650..708917 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -402,13 +402,11 @@ static void xenbus_reset_frontend(char *fe, char *be, int be_state)
 	case XenbusStateConnected:
 		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosing);
 		xenbus_reset_wait_for_backend(be, XenbusStateClosing);
-		/* fall through */
-
+		fallthrough;
 	case XenbusStateClosing:
 		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateClosed);
 		xenbus_reset_wait_for_backend(be, XenbusStateClosed);
-		/* fall through */
-
+		fallthrough;
 	case XenbusStateClosed:
 		xenbus_printf(XBT_NIL, fe, "state", "%d", XenbusStateInitialising);
 		xenbus_reset_wait_for_backend(be, XenbusStateInitWait);
-- 
2.24.0

