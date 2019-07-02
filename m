Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A065CF61
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGBMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:25:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39498 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfGBMZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:25:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so17585627wrt.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 05:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GbNC8LbnoEPSih6OLqSSkJED98Mu4T6t/hfxB34ZpQ4=;
        b=Oys2sIxClbSWvyOFXT/ZsaoDXuBxYswfwf2YTsrU5lu3XbEGk6RjQeB6D8F8IyFN01
         gjwOHWlxFMMZhywIdRHXZJFA3FFSaDd57pA2cEWuZy3dPsUfZyYr8DLr9Vxj2toD1gvj
         wgf4HDgLMHEWVRZXLq4BIOEVizruiYombSe+0CkA97bPM6g5h4MOt4DvOIpa3xaKxWKV
         bsbZKXUv2HCGYL7oaA2IdoCoFX2oRlrBNWfpfkJTO/zj2VqJUc8XC+EDJkJKJrvgSNHU
         yU0l1c7QXJBoEE7JDu6quxn8OeMWk508eSotWvH54LcYPaCtZR/IvwivPmkd/t9ibDrD
         7ljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GbNC8LbnoEPSih6OLqSSkJED98Mu4T6t/hfxB34ZpQ4=;
        b=h19b+Z8gKip4+zSYeNamblD3/i9+nkenl+5llavbuc7X1dFJAiWc+Nx4PKWOIwTMJm
         nDjxHXjavt+6JjiT0bNVVWAb/WSi0dmGRhZhPDCUtnQv3EmFbQeZNgGfs0E7HIU0Lrcf
         zxSjksdPmDhzcV4OpSKw6hntf/uj2yWsTZcsMN3gUrFLVvx5fHtgmTOtUQ5E7qSNVttw
         i+qqd3WXUB3vd+ALqYWYkdYHd9OYF88dayPhfqb0qYbimpi8arDdK7SQzWFpKnBHuTTM
         gvjd3LMStsve9TQRDrEFRiS+B+rIsmzoOp43G+M7S3l3actVCxOe7Zv3Wm0vDsl658oW
         BZpw==
X-Gm-Message-State: APjAAAW4arvaheN/QlSnONGsC24NQ1zSwbCA3Fmz908Pz+KYUidxInu3
        XIn2v8PKfSe+XFIwtnchc+VbaQ==
X-Google-Smtp-Source: APXvYqw3l6t6u4Pd6vxuTN2nH5DY7F6jzrQcecp1q72lmsA+/NpxIWXShnGnrPh1WWVknC0Udm4Ezw==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr23570713wre.205.1562070322383;
        Tue, 02 Jul 2019 05:25:22 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id z25sm3856126wmf.38.2019.07.02.05.25.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 05:25:21 -0700 (PDT)
Date:   Tue, 2 Jul 2019 14:25:21 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 04/15] ethtool: introduce ethtool netlink
 interface
Message-ID: <20190702122521.GN2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7fa3ad7e9cf4d7a8f9a2085e3166f7260845b0a.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:49:59PM CEST, mkubecek@suse.cz wrote:
>Basic genetlink and init infrastructure for the netlink interface, register
>genetlink family "ethtool". Add CONFIG_ETHTOOL_NETLINK Kconfig option to
>make the build optional. Add initial overall interface description into
>Documentation/networking/ethtool-netlink.txt, further patches will add more
>detailed information.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> Documentation/networking/ethtool-netlink.txt | 208 +++++++++++++++++++
> include/linux/ethtool_netlink.h              |   9 +
> include/uapi/linux/ethtool_netlink.h         |  36 ++++
> net/Kconfig                                  |   8 +
> net/ethtool/Makefile                         |   6 +-
> net/ethtool/netlink.c                        |  33 +++
> net/ethtool/netlink.h                        |  10 +
> 7 files changed, 309 insertions(+), 1 deletion(-)
> create mode 100644 Documentation/networking/ethtool-netlink.txt
> create mode 100644 include/linux/ethtool_netlink.h
> create mode 100644 include/uapi/linux/ethtool_netlink.h
> create mode 100644 net/ethtool/netlink.c
> create mode 100644 net/ethtool/netlink.h
>
>diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
>new file mode 100644
>index 000000000000..97c369aa290b
>--- /dev/null
>+++ b/Documentation/networking/ethtool-netlink.txt
>@@ -0,0 +1,208 @@
>+                        Netlink interface for ethtool
>+                        =============================
>+
>+
>+Basic information
>+-----------------
>+
>+Netlink interface for ethtool uses generic netlink family "ethtool" (userspace
>+application should use macros ETHTOOL_GENL_NAME and ETHTOOL_GENL_VERSION
>+defined in <linux/ethtool_netlink.h> uapi header). This family does not use
>+a specific header, all information in requests and replies is passed using
>+netlink attributes.
>+
>+The ethtool netlink interface uses extended ACK for error and warning
>+reporting, userspace application developers are encouraged to make these
>+messages available to user in a suitable way.
>+
>+Requests can be divided into three categories: "get" (retrieving information),
>+"set" (setting parameters) and "action" (invoking an action).
>+
>+All "set" and "action" type requests require admin privileges (CAP_NET_ADMIN
>+in the namespace). Most "get" type requests are allowed for anyone but there
>+are exceptions (where the response contains sensitive information). In some
>+cases, the request as such is allowed for anyone but unprivileged users have
>+attributes with sensitive information (e.g. wake-on-lan password) omitted.
>+
>+
>+Conventions
>+-----------
>+
>+Attributes which represent a boolean value usually use u8 type so that we can
>+distinguish three states: "on", "off" and "not present" (meaning the
>+information is not available in "get" requests or value is not to be changed
>+in "set" requests). For these attributes, the "true" value should be passed as
>+number 1 but any non-zero value should be understood as "true" by recipient.
>+
>+In the message structure descriptions below, if an attribute name is suffixed
>+with "+", parent nest can contain multiple attributes of the same type. This
>+implements an array of entries.
>+
>+
>+Request header
>+--------------
>+
>+Each request or reply message contains a nested attribute with common header.
>+Structure of this header is

Missing ":"


>+
>+    ETHTOOL_A_HEADER_DEV_INDEX	(u32)		device ifindex
>+    ETHTOOL_A_HEADER_DEV_NAME	(string)	device name
>+    ETHTOOL_A_HEADER_INFOMASK	(u32)		info mask
>+    ETHTOOL_A_HEADER_GFLAGS	(u32)		flags common for all requests
>+    ETHTOOL_A_HEADER_RFLAGS	(u32)		request specific flags
>+
>+ETHTOOL_A_HEADER_DEV_INDEX and ETHTOOL_A_HEADER_DEV_NAME identify the device
>+message relates to. One of them is sufficient in requests, if both are used,
>+they must identify the same device. Some requests, e.g. global string sets, do
>+not require device identification. Most GET requests also allow dump requests
>+without device identification to query the same information for all devices
>+providing it (each device in a separate message).
>+
>+Optional info mask allows to ask only for a part of data provided by GET

How this "infomask" works? What are the bits related to? Is that request
specific?


>+request types. If omitted or zero, all data is returned. The two flag bitmaps
>+allow enabling requestoptions; ETHTOOL_A_HEADER_GFLAGS are global flags common

s/requestoptions;/request options./  ?


>+for all request types, flags recognized in ETHTOOL_A_HEADER_RFLAGS and their
>+interpretation are specific for each request type. Global flags are
>+
>+    ETHTOOL_RF_COMPACT		use compact format bitsets in reply

Why "RF"? Isn't this "GF"? I would like "ETHTOOL_GFLAG_COMPACT" better.


>+    ETHTOOL_RF_REPLY		send optional reply (SET and ACT requests)
>+
>+Request specific flags are described with each request type. For both flag
>+attributes, new flags should follow the general idea that if the flag is not
>+set, the behaviour is the same as (or closer to) the behaviour before it was

"closer to" ? That would be unfortunate I believe...


>+introduced.
>+
>+
>+List of message types
>+---------------------
>+
>+All constants identifying message types use ETHTOOL_CMD_ prefix and suffix
>+according to message purpose:
>+
>+    _GET	userspace request to retrieve data
>+    _SET	userspace request to set data
>+    _ACT	userspace request to perform an action
>+    _GET_REPLY	kernel reply to a GET request
>+    _SET_REPLY	kernel reply to a SET request
>+    _ACT_REPLY  kernel reply to an ACT request
>+    _NTF	kernel notification
>+
>+"GET" requests are sent by userspace applications to retrieve device
>+information. They usually do not contain any message specific attributes.
>+Kernel replies with corresponding "GET_REPLY" message. For most types, "GET"
>+request with NLM_F_DUMP and no device identification can be used to query the
>+information for all devices supporting the request.
>+
>+If the data can be also modified, corresponding "SET" message with the same
>+layout as "GET" reply is used to request changes. Only attributes where

s/"GET" reply"/"GET_REPLY" ?
Maybe better to emphasize that the "GET_REPLY" is the one corresponding
with "SET". But perhaps I got this sentence all wrong :/


>+a change is requested are included in such request (also, not all attributes
>+may be changed). Replies to most "SET" request consist only of error code and
>+extack; if kernel provides additional data, it is sent in the form of
>+corresponding "SET_REPLY" message (if ETHTOOL_RF_REPLY flag was set in request
>+header).
>+
>+Data modification also triggers sending a "NTF" message with a notification.
>+These usually bear only a subset of attributes which was affected by the
>+change. The same notification is issued if the data is modified using other
>+means (mostly ioctl ethtool interface). Unlike notifications from ethtool
>+netlink code which are only sent if something actually changed, notifications
>+triggered by ioctl interface may be sent even if the request did not actually
>+change any data.

Interesting. What's the reason for that?


>+
>+"ACT" messages request kernel (driver) to perform a specific action. If some
>+information is reported by kernel (as requested by ETHTOOL_RF_REPLY flag in
>+request header), the reply takes form of an "ACT_REPLY" message. Performing an
>+action also triggers a notification ("NTF" message).
>+
>+Later sections describe the format and semantics of these messages.
>+
>+
>+Request translation
>+-------------------
>+
>+The following table maps ioctl commands to netlink commands providing their
>+functionality. Entries with "n/a" in right column are commands which do not
>+have their netlink replacement yet.
>+
>+ioctl command			netlink command
>+---------------------------------------------------------------------
>+ETHTOOL_GSET			n/a
>+ETHTOOL_SSET			n/a
>+ETHTOOL_GDRVINFO		n/a
>+ETHTOOL_GREGS			n/a
>+ETHTOOL_GWOL			n/a
>+ETHTOOL_SWOL			n/a
>+ETHTOOL_GMSGLVL			n/a
>+ETHTOOL_SMSGLVL			n/a
>+ETHTOOL_NWAY_RST		n/a
>+ETHTOOL_GLINK			n/a
>+ETHTOOL_GEEPROM			n/a
>+ETHTOOL_SEEPROM			n/a
>+ETHTOOL_GCOALESCE		n/a
>+ETHTOOL_SCOALESCE		n/a
>+ETHTOOL_GRINGPARAM		n/a
>+ETHTOOL_SRINGPARAM		n/a
>+ETHTOOL_GPAUSEPARAM		n/a
>+ETHTOOL_SPAUSEPARAM		n/a
>+ETHTOOL_GRXCSUM			n/a
>+ETHTOOL_SRXCSUM			n/a
>+ETHTOOL_GTXCSUM			n/a
>+ETHTOOL_STXCSUM			n/a
>+ETHTOOL_GSG			n/a
>+ETHTOOL_SSG			n/a
>+ETHTOOL_TEST			n/a
>+ETHTOOL_GSTRINGS		n/a
>+ETHTOOL_PHYS_ID			n/a
>+ETHTOOL_GSTATS			n/a
>+ETHTOOL_GTSO			n/a
>+ETHTOOL_STSO			n/a
>+ETHTOOL_GPERMADDR		rtnetlink RTM_GETLINK
>+ETHTOOL_GUFO			n/a
>+ETHTOOL_SUFO			n/a
>+ETHTOOL_GGSO			n/a
>+ETHTOOL_SGSO			n/a
>+ETHTOOL_GFLAGS			n/a
>+ETHTOOL_SFLAGS			n/a
>+ETHTOOL_GPFLAGS			n/a
>+ETHTOOL_SPFLAGS			n/a
>+ETHTOOL_GRXFH			n/a
>+ETHTOOL_SRXFH			n/a
>+ETHTOOL_GGRO			n/a
>+ETHTOOL_SGRO			n/a
>+ETHTOOL_GRXRINGS		n/a
>+ETHTOOL_GRXCLSRLCNT		n/a
>+ETHTOOL_GRXCLSRULE		n/a
>+ETHTOOL_GRXCLSRLALL		n/a
>+ETHTOOL_SRXCLSRLDEL		n/a
>+ETHTOOL_SRXCLSRLINS		n/a
>+ETHTOOL_FLASHDEV		n/a
>+ETHTOOL_RESET			n/a
>+ETHTOOL_SRXNTUPLE		n/a
>+ETHTOOL_GRXNTUPLE		n/a
>+ETHTOOL_GSSET_INFO		n/a
>+ETHTOOL_GRXFHINDIR		n/a
>+ETHTOOL_SRXFHINDIR		n/a
>+ETHTOOL_GFEATURES		n/a
>+ETHTOOL_SFEATURES		n/a
>+ETHTOOL_GCHANNELS		n/a
>+ETHTOOL_SCHANNELS		n/a
>+ETHTOOL_SET_DUMP		n/a
>+ETHTOOL_GET_DUMP_FLAG		n/a
>+ETHTOOL_GET_DUMP_DATA		n/a
>+ETHTOOL_GET_TS_INFO		n/a
>+ETHTOOL_GMODULEINFO		n/a
>+ETHTOOL_GMODULEEEPROM		n/a
>+ETHTOOL_GEEE			n/a
>+ETHTOOL_SEEE			n/a
>+ETHTOOL_GRSSH			n/a
>+ETHTOOL_SRSSH			n/a
>+ETHTOOL_GTUNABLE		n/a
>+ETHTOOL_STUNABLE		n/a
>+ETHTOOL_GPHYSTATS		n/a
>+ETHTOOL_PERQUEUE		n/a
>+ETHTOOL_GLINKSETTINGS		n/a
>+ETHTOOL_SLINKSETTINGS		n/a
>+ETHTOOL_PHY_GTUNABLE		n/a
>+ETHTOOL_PHY_STUNABLE		n/a
>+ETHTOOL_GFECPARAM		n/a
>+ETHTOOL_SFECPARAM		n/a
>diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
>new file mode 100644
>index 000000000000..0412adb4f42f
>--- /dev/null
>+++ b/include/linux/ethtool_netlink.h
>@@ -0,0 +1,9 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+
>+#ifndef _LINUX_ETHTOOL_NETLINK_H_
>+#define _LINUX_ETHTOOL_NETLINK_H_
>+
>+#include <uapi/linux/ethtool_netlink.h>
>+#include <linux/ethtool.h>
>+
>+#endif /* _LINUX_ETHTOOL_NETLINK_H_ */
>diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
>new file mode 100644
>index 000000000000..9a0fbd4f85d9
>--- /dev/null
>+++ b/include/uapi/linux/ethtool_netlink.h
>@@ -0,0 +1,36 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+/*
>+ * include/uapi/linux/ethtool_netlink.h - netlink interface for ethtool
>+ *
>+ * See Documentation/networking/ethtool-netlink.txt in kernel source tree for
>+ * doucumentation of the interface.
>+ */
>+
>+#ifndef _UAPI_LINUX_ETHTOOL_NETLINK_H_
>+#define _UAPI_LINUX_ETHTOOL_NETLINK_H_
>+
>+#include <linux/ethtool.h>
>+
>+/* message types - userspace to kernel */
>+enum {
>+	ETHTOOL_MSG_USER_NONE,
>+
>+	/* add new constants above here */
>+	__ETHTOOL_MSG_USER_CNT,
>+	ETHTOOL_MSG_USER_MAX = (__ETHTOOL_MSG_USER_CNT - 1)
>+};
>+
>+/* message types - kernel to userspace */
>+enum {
>+	ETHTOOL_MSG_KERNEL_NONE,
>+
>+	/* add new constants above here */
>+	__ETHTOOL_MSG_KERNEL_CNT,
>+	ETHTOOL_MSG_KERNEL_MAX = (__ETHTOOL_MSG_KERNEL_CNT - 1)
>+};
>+
>+/* generic netlink info */
>+#define ETHTOOL_GENL_NAME "ethtool"
>+#define ETHTOOL_GENL_VERSION 1
>+
>+#endif /* _UAPI_LINUX_ETHTOOL_NETLINK_H_ */
>diff --git a/net/Kconfig b/net/Kconfig
>index 57f51a279ad6..65b760d26eec 100644
>--- a/net/Kconfig
>+++ b/net/Kconfig
>@@ -447,6 +447,14 @@ config FAILOVER
> 	  migration of VMs with direct attached VFs by failing over to the
> 	  paravirtual datapath when the VF is unplugged.
> 
>+config ETHTOOL_NETLINK
>+	bool "Netlink interface for ethtool"
>+	default y
>+	help
>+	  An alternative userspace interface for ethtool based on generic
>+	  netlink. It provides better extensibility and some new features,
>+	  e.g. notification messages.
>+
> endif   # if NET
> 
> # Used by archs to tell that they support BPF JIT compiler plus which flavour.
>diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
>index 3ebfab2bca66..f30e0da88be5 100644
>--- a/net/ethtool/Makefile
>+++ b/net/ethtool/Makefile
>@@ -1,3 +1,7 @@
> # SPDX-License-Identifier: GPL-2.0
> 
>-obj-y		+= ioctl.o
>+obj-y				+= ioctl.o
>+
>+obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o

Hmm, I wonder, why not to make this always on? We want users to use
it, memory savings in case it is off would be minimal. RTNetlink is also
always on. Ethtool ioctl is also always on.


>+
>+ethtool_nl-y	:= netlink.o
>diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
>new file mode 100644
>index 000000000000..3c98b41f04e5
>--- /dev/null
>+++ b/net/ethtool/netlink.c
>@@ -0,0 +1,33 @@
>+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>+
>+#include <linux/ethtool_netlink.h>
>+#include "netlink.h"
>+
>+/* genetlink setup */
>+
>+static const struct genl_ops ethtool_genl_ops[] = {
>+};
>+
>+static struct genl_family ethtool_genl_family = {
>+	.name		= ETHTOOL_GENL_NAME,
>+	.version	= ETHTOOL_GENL_VERSION,
>+	.netnsok	= true,
>+	.parallel_ops	= true,
>+	.ops		= ethtool_genl_ops,
>+	.n_ops		= ARRAY_SIZE(ethtool_genl_ops),
>+};
>+
>+/* module setup */
>+
>+static int __init ethnl_init(void)
>+{
>+	int ret;
>+
>+	ret = genl_register_family(&ethtool_genl_family);
>+	if (WARN(ret < 0, "ethtool: genetlink family registration failed"))

WARN(ret, ...)


>+		return ret;
>+
>+	return 0;
>+}
>+
>+subsys_initcall(ethnl_init);
>diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
>new file mode 100644
>index 000000000000..257ae55ccc82
>--- /dev/null
>+++ b/net/ethtool/netlink.h
>@@ -0,0 +1,10 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+
>+#ifndef _NET_ETHTOOL_NETLINK_H
>+#define _NET_ETHTOOL_NETLINK_H
>+
>+#include <linux/ethtool_netlink.h>
>+#include <linux/netdevice.h>
>+#include <net/genetlink.h>
>+
>+#endif /* _NET_ETHTOOL_NETLINK_H */
>-- 
>2.22.0
>
