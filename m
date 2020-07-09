Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0991B21A8D5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgGIUWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGIUWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:22:19 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F337C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 13:22:19 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so3636624ejc.8
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 13:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y0m2MJEWhOkWOzW5KNvMiiF73hyFxsNv+ajCO67bvgM=;
        b=pzQOxPnKEO6QGhvkP6zeAYTJjVpFZx8L9weo0STvrKEB4wgw7jTA09QVLQ285w2CJg
         D26uXTzwA51LQxQ6FD1VS8amqqe9S/WQkR3aL6UV72sVCavMgrwox/sAdcRNjcm1MYtG
         +4Y8mtnsZBmj0A+jTUO07r0UxYDcELXGrosftc98Z37zSdOcPVOaAc3WbiNSDyLQmGoJ
         /20azR3T8CMdKqObFCTNPChBfKDJDjVCWYqyIsHRbFM2Zspboul51e+nfplUSyYu3dAW
         UujEz28kY3JH5l2X7hsi74/ahfbrVu6+m/eX6tiMNUKcRuOqmZgtH3bsUgUNYkZY3FVv
         2cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y0m2MJEWhOkWOzW5KNvMiiF73hyFxsNv+ajCO67bvgM=;
        b=PpFr+wmjtPTNW5ZWgoCD2KjD9foreSkgBcQIJqWXHxjp6dGcKhPqgs66791GVuI47R
         ufF31Xt2xRewyqxoI9qRK2wPaQzUXOuj2ZpkjZRMAU+aWrd2Dz7kiWog8oWKZEoSWI09
         YWdVM/IwKbPhv0FSK83/23mblE08wQ/IctgOhWvUgWPI+nf0ojjHduYjR8Jc4nKVPxiU
         AAYlGygyY96+OohFSqhO+IFvmTBrwqCXfKgk/j6iV0pBD8+Z16PW0HhP1Xs4gg/bxEEM
         Nh1RDwd85yVzulXtOJCiLwMeR1lyYnzZlXpyVI/MFrRkdYXzoTN+IeXmgADxgsnymFP7
         QQbA==
X-Gm-Message-State: AOAM533lHX3cQI8PKJEd+6wb6xqwp/BTGDeSUrW9L9Ekox9D2Ue2kXLJ
        feAUwg37kgvd4CQO2tGtExUThE0L
X-Google-Smtp-Source: ABdhPJxvfymg3DHJdTghom+yvZuF/L0jBeClwP7c+T88arKDxlSauk4IGUs/AYTr01KQPu/M2HWiiA==
X-Received: by 2002:a17:907:110d:: with SMTP id qu13mr35707647ejb.217.1594326137525;
        Thu, 09 Jul 2020 13:22:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id d26sm2612567edz.93.2020.07.09.13.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 13:22:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     richardcochran@gmail.com, sorganov@gmail.com, andrew@lunn.ch
Subject: [PATCH net-next] docs: networking: timestamping: replace tabs with spaces in code blocks
Date:   Thu,  9 Jul 2020 23:22:10 +0300
Message-Id: <20200709202210.72985-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reading the document in vim is currently not a pleasant experience. Its
rst syntax highlighting is confused by the "*/" sequences which it's not
interpreting as part of the code blocks for some reason.

Replace the tabs with spaces, so that syntax highlighters (at least the
one in vim) have a better idea where code blocks start and where they
end.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/timestamping.rst | 114 +++++++++++-----------
 1 file changed, 57 insertions(+), 57 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 03f7beade470..5fa4e2274dd9 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -257,13 +257,13 @@ setsockopt::
 
   struct msghdr *msg;
   ...
-  cmsg			       = CMSG_FIRSTHDR(msg);
-  cmsg->cmsg_level	       = SOL_SOCKET;
-  cmsg->cmsg_type	       = SO_TIMESTAMPING;
-  cmsg->cmsg_len	       = CMSG_LEN(sizeof(__u32));
+  cmsg                         = CMSG_FIRSTHDR(msg);
+  cmsg->cmsg_level             = SOL_SOCKET;
+  cmsg->cmsg_type              = SO_TIMESTAMPING;
+  cmsg->cmsg_len               = CMSG_LEN(sizeof(__u32));
   *((__u32 *) CMSG_DATA(cmsg)) = SOF_TIMESTAMPING_TX_SCHED |
-				 SOF_TIMESTAMPING_TX_SOFTWARE |
-				 SOF_TIMESTAMPING_TX_ACK;
+                                 SOF_TIMESTAMPING_TX_SOFTWARE |
+                                 SOF_TIMESTAMPING_TX_ACK;
   err = sendmsg(fd, msg, 0);
 
 The SOF_TIMESTAMPING_TX_* flags set via cmsg will override
@@ -273,7 +273,7 @@ Moreover, applications must still enable timestamp reporting via
 setsockopt to receive timestamps::
 
   __u32 val = SOF_TIMESTAMPING_SOFTWARE |
-	      SOF_TIMESTAMPING_OPT_ID /* or any other flag */;
+              SOF_TIMESTAMPING_OPT_ID /* or any other flag */;
   err = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
 
 
@@ -354,14 +354,14 @@ SOL_SOCKET, cmsg_type SCM_TIMESTAMPING, and payload of type
 
 For SO_TIMESTAMPING_OLD::
 
-	struct scm_timestamping {
-		struct timespec ts[3];
-	};
+        struct scm_timestamping {
+                struct timespec ts[3];
+        };
 
 For SO_TIMESTAMPING_NEW::
 
-	struct scm_timestamping64 {
-		struct __kernel_timespec ts[3];
+        struct scm_timestamping64 {
+                struct __kernel_timespec ts[3];
 
 Always use SO_TIMESTAMPING_NEW timestamp to always get timestamp in
 struct scm_timestamping64 format.
@@ -468,11 +468,11 @@ Hardware time stamping must also be initialized for each device driver
 that is expected to do hardware time stamping. The parameter is defined in
 include/uapi/linux/net_tstamp.h as::
 
-	struct hwtstamp_config {
-		int flags;	/* no flags defined right now, must be zero */
-		int tx_type;	/* HWTSTAMP_TX_* */
-		int rx_filter;	/* HWTSTAMP_FILTER_* */
-	};
+        struct hwtstamp_config {
+                int flags;      /* no flags defined right now, must be zero */
+                int tx_type;    /* HWTSTAMP_TX_* */
+                int rx_filter;  /* HWTSTAMP_FILTER_* */
+        };
 
 Desired behavior is passed into the kernel and to a specific device by
 calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
@@ -505,42 +505,42 @@ not been implemented in all drivers.
 
 ::
 
-    /* possible values for hwtstamp_config->tx_type */
-    enum {
-	    /*
-	    * no outgoing packet will need hardware time stamping;
-	    * should a packet arrive which asks for it, no hardware
-	    * time stamping will be done
-	    */
-	    HWTSTAMP_TX_OFF,
-
-	    /*
-	    * enables hardware time stamping for outgoing packets;
-	    * the sender of the packet decides which are to be
-	    * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
-	    * before sending the packet
-	    */
-	    HWTSTAMP_TX_ON,
-    };
-
-    /* possible values for hwtstamp_config->rx_filter */
-    enum {
-	    /* time stamp no incoming packet at all */
-	    HWTSTAMP_FILTER_NONE,
-
-	    /* time stamp any incoming packet */
-	    HWTSTAMP_FILTER_ALL,
-
-	    /* return value: time stamp all packets requested plus some others */
-	    HWTSTAMP_FILTER_SOME,
-
-	    /* PTP v1, UDP, any kind of event packet */
-	    HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
-
-	    /* for the complete list of values, please check
-	    * the include file include/uapi/linux/net_tstamp.h
-	    */
-    };
+   /* possible values for hwtstamp_config->tx_type */
+   enum {
+           /*
+           * no outgoing packet will need hardware time stamping;
+           * should a packet arrive which asks for it, no hardware
+           * time stamping will be done
+           */
+           HWTSTAMP_TX_OFF,
+
+           /*
+           * enables hardware time stamping for outgoing packets;
+           * the sender of the packet decides which are to be
+           * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
+           * before sending the packet
+           */
+           HWTSTAMP_TX_ON,
+   };
+
+   /* possible values for hwtstamp_config->rx_filter */
+   enum {
+           /* time stamp no incoming packet at all */
+           HWTSTAMP_FILTER_NONE,
+
+           /* time stamp any incoming packet */
+           HWTSTAMP_FILTER_ALL,
+
+           /* return value: time stamp all packets requested plus some others */
+           HWTSTAMP_FILTER_SOME,
+
+           /* PTP v1, UDP, any kind of event packet */
+           HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
+
+           /* for the complete list of values, please check
+           * the include file include/uapi/linux/net_tstamp.h
+           */
+   };
 
 3.1 Hardware Timestamping Implementation: Device Drivers
 --------------------------------------------------------
@@ -555,10 +555,10 @@ to the shared time stamp structure of the skb call skb_hwtstamps(). Then
 set the time stamps in the structure::
 
     struct skb_shared_hwtstamps {
-	    /* hardware time stamp transformed into duration
-	    * since arbitrary point in time
-	    */
-	    ktime_t	hwtstamp;
+            /* hardware time stamp transformed into duration
+            * since arbitrary point in time
+            */
+            ktime_t     hwtstamp;
     };
 
 Time stamps for outgoing packets are to be generated as follows:
-- 
2.25.1

