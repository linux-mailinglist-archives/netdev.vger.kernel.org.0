Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C4B6E6FCD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDRXCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjDRXCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:02:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEC78A6C
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:02:33 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1AD85219DA;
        Tue, 18 Apr 2023 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681858952; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=tQ0I1LpmchAW/JLLZJ5+Ml4nSsj8PckawkxAjn8UaeQ=;
        b=QyNqgR4Dai9NjawEc/2vFhaOqzdhZXAgpP9g3eS0TTvTpLZoh1RgJWYBfQbSlBGWETVixf
        8ZzR8jjqyBKTLCIRaZInUy3HvCvgw3K/J33JDMIZWRY5+wCZknUwFStSY7pxxwkXQjfMRv
        QPVFOF0DtMT9EdKfRF70qXujLI1NM+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681858952;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=tQ0I1LpmchAW/JLLZJ5+Ml4nSsj8PckawkxAjn8UaeQ=;
        b=vwqHj9fum+EvwHMsiWzF9m4kWJ3mTG0OVrXHxOWtgOJuxnHTxcPUra0+J/Lc6A3wKx+OKx
        LmMolX6H10yqXBAA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 072C02C141;
        Tue, 18 Apr 2023 23:02:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D25FE60517; Wed, 19 Apr 2023 01:02:31 +0200 (CEST)
Message-Id: <94285a649ff0dd06fc61c51b8c3ac273a76723b3.1681858286.git.mkubecek@suse.cz>
In-Reply-To: <cover.1681858286.git.mkubecek@suse.cz>
References: <cover.1681858286.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Date:   Wed, 19 Apr 2023 00:13:46 +0200
Subject: [PATCH ethtool 3/3] update UAPI header copies
To:     netdev@vger.kernel.org
Cc:     Thomas Devoogdt <thomas@devoogdt.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel v6.3-rc7.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 uapi/linux/const.h       |  36 ++++++
 uapi/linux/if_addr.h     |  77 +++++++++++
 uapi/linux/if_ether.h    | 181 ++++++++++++++++++++++++++
 uapi/linux/libc-compat.h | 267 +++++++++++++++++++++++++++++++++++++++
 uapi/linux/neighbour.h   | 224 ++++++++++++++++++++++++++++++++
 uapi/linux/posix_types.h |  38 ++++++
 uapi/linux/rtnetlink.h   |   1 +
 uapi/linux/socket.h      |  38 ++++++
 uapi/linux/stddef.h      |  47 +++++++
 uapi/linux/types.h       |  53 ++++++++
 10 files changed, 962 insertions(+)
 create mode 100644 uapi/linux/const.h
 create mode 100644 uapi/linux/if_addr.h
 create mode 100644 uapi/linux/if_ether.h
 create mode 100644 uapi/linux/libc-compat.h
 create mode 100644 uapi/linux/neighbour.h
 create mode 100644 uapi/linux/posix_types.h
 create mode 100644 uapi/linux/socket.h
 create mode 100644 uapi/linux/stddef.h
 create mode 100644 uapi/linux/types.h

diff --git a/uapi/linux/const.h b/uapi/linux/const.h
new file mode 100644
index 000000000000..5e4898725168
--- /dev/null
+++ b/uapi/linux/const.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#define _AT(T,X)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#endif
+
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
+
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#endif /* _LINUX_CONST_H */
diff --git a/uapi/linux/if_addr.h b/uapi/linux/if_addr.h
new file mode 100644
index 000000000000..d6db3ff7fa10
--- /dev/null
+++ b/uapi/linux/if_addr.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_IF_ADDR_H
+#define __LINUX_IF_ADDR_H
+
+#include <linux/types.h>
+#include <linux/netlink.h>
+
+struct ifaddrmsg {
+	__u8		ifa_family;
+	__u8		ifa_prefixlen;	/* The prefix length		*/
+	__u8		ifa_flags;	/* Flags			*/
+	__u8		ifa_scope;	/* Address scope		*/
+	__u32		ifa_index;	/* Link index			*/
+};
+
+/*
+ * Important comment:
+ * IFA_ADDRESS is prefix address, rather than local interface address.
+ * It makes no difference for normally configured broadcast interfaces,
+ * but for point-to-point IFA_ADDRESS is DESTINATION address,
+ * local address is supplied in IFA_LOCAL attribute.
+ *
+ * IFA_FLAGS is a u32 attribute that extends the u8 field ifa_flags.
+ * If present, the value from struct ifaddrmsg will be ignored.
+ */
+enum {
+	IFA_UNSPEC,
+	IFA_ADDRESS,
+	IFA_LOCAL,
+	IFA_LABEL,
+	IFA_BROADCAST,
+	IFA_ANYCAST,
+	IFA_CACHEINFO,
+	IFA_MULTICAST,
+	IFA_FLAGS,
+	IFA_RT_PRIORITY,	/* u32, priority/metric for prefix route */
+	IFA_TARGET_NETNSID,
+	IFA_PROTO,		/* u8, address protocol */
+	__IFA_MAX,
+};
+
+#define IFA_MAX (__IFA_MAX - 1)
+
+/* ifa_flags */
+#define IFA_F_SECONDARY		0x01
+#define IFA_F_TEMPORARY		IFA_F_SECONDARY
+
+#define	IFA_F_NODAD		0x02
+#define IFA_F_OPTIMISTIC	0x04
+#define IFA_F_DADFAILED		0x08
+#define	IFA_F_HOMEADDRESS	0x10
+#define IFA_F_DEPRECATED	0x20
+#define IFA_F_TENTATIVE		0x40
+#define IFA_F_PERMANENT		0x80
+#define IFA_F_MANAGETEMPADDR	0x100
+#define IFA_F_NOPREFIXROUTE	0x200
+#define IFA_F_MCAUTOJOIN	0x400
+#define IFA_F_STABLE_PRIVACY	0x800
+
+struct ifa_cacheinfo {
+	__u32	ifa_prefered;
+	__u32	ifa_valid;
+	__u32	cstamp; /* created timestamp, hundredths of seconds */
+	__u32	tstamp; /* updated timestamp, hundredths of seconds */
+};
+
+/* backwards compatibility for userspace */
+#define IFA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifaddrmsg))))
+#define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
+
+/* ifa_proto */
+#define IFAPROT_UNSPEC		0
+#define IFAPROT_KERNEL_LO	1	/* loopback */
+#define IFAPROT_KERNEL_RA	2	/* set by kernel from router announcement */
+#define IFAPROT_KERNEL_LL	3	/* link-local set by kernel */
+
+#endif
diff --git a/uapi/linux/if_ether.h b/uapi/linux/if_ether.h
new file mode 100644
index 000000000000..a1aff8e33799
--- /dev/null
+++ b/uapi/linux/if_ether.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * INET		An implementation of the TCP/IP protocol suite for the LINUX
+ *		operating system.  INET is implemented using the  BSD Socket
+ *		interface as the means of communication with the user level.
+ *
+ *		Global definitions for the Ethernet IEEE 802.3 interface.
+ *
+ * Version:	@(#)if_ether.h	1.0.1a	02/08/94
+ *
+ * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
+ *		Donald Becker, <becker@super.org>
+ *		Alan Cox, <alan@lxorguk.ukuu.org.uk>
+ *		Steve Whitehouse, <gw7rrm@eeshack3.swan.ac.uk>
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_IF_ETHER_H
+#define _LINUX_IF_ETHER_H
+
+#include <linux/types.h>
+
+/*
+ *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
+ *	and FCS/CRC (frame check sequence).
+ */
+
+#define ETH_ALEN	6		/* Octets in one ethernet addr	 */
+#define ETH_TLEN	2		/* Octets in ethernet type field */
+#define ETH_HLEN	14		/* Total octets in header.	 */
+#define ETH_ZLEN	60		/* Min. octets in frame sans FCS */
+#define ETH_DATA_LEN	1500		/* Max. octets in payload	 */
+#define ETH_FRAME_LEN	1514		/* Max. octets in frame sans FCS */
+#define ETH_FCS_LEN	4		/* Octets in the FCS		 */
+
+#define ETH_MIN_MTU	68		/* Min IPv4 MTU per RFC791	*/
+#define ETH_MAX_MTU	0xFFFFU		/* 65535, same as IP_MAX_MTU	*/
+
+/*
+ *	These are the defined Ethernet Protocol ID's.
+ */
+
+#define ETH_P_LOOP	0x0060		/* Ethernet Loopback packet	*/
+#define ETH_P_PUP	0x0200		/* Xerox PUP packet		*/
+#define ETH_P_PUPAT	0x0201		/* Xerox PUP Addr Trans packet	*/
+#define ETH_P_TSN	0x22F0		/* TSN (IEEE 1722) packet	*/
+#define ETH_P_ERSPAN2	0x22EB		/* ERSPAN version 2 (type III)	*/
+#define ETH_P_IP	0x0800		/* Internet Protocol packet	*/
+#define ETH_P_X25	0x0805		/* CCITT X.25			*/
+#define ETH_P_ARP	0x0806		/* Address Resolution packet	*/
+#define	ETH_P_BPQ	0x08FF		/* G8BPQ AX.25 Ethernet Packet	[ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_IEEEPUP	0x0a00		/* Xerox IEEE802.3 PUP packet */
+#define ETH_P_IEEEPUPAT	0x0a01		/* Xerox IEEE802.3 PUP Addr Trans packet */
+#define ETH_P_BATMAN	0x4305		/* B.A.T.M.A.N.-Advanced packet [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_DEC       0x6000          /* DEC Assigned proto           */
+#define ETH_P_DNA_DL    0x6001          /* DEC DNA Dump/Load            */
+#define ETH_P_DNA_RC    0x6002          /* DEC DNA Remote Console       */
+#define ETH_P_DNA_RT    0x6003          /* DEC DNA Routing              */
+#define ETH_P_LAT       0x6004          /* DEC LAT                      */
+#define ETH_P_DIAG      0x6005          /* DEC Diagnostics              */
+#define ETH_P_CUST      0x6006          /* DEC Customer use             */
+#define ETH_P_SCA       0x6007          /* DEC Systems Comms Arch       */
+#define ETH_P_TEB	0x6558		/* Trans Ether Bridging		*/
+#define ETH_P_RARP      0x8035		/* Reverse Addr Res packet	*/
+#define ETH_P_ATALK	0x809B		/* Appletalk DDP		*/
+#define ETH_P_AARP	0x80F3		/* Appletalk AARP		*/
+#define ETH_P_8021Q	0x8100          /* 802.1Q VLAN Extended Header  */
+#define ETH_P_ERSPAN	0x88BE		/* ERSPAN type II		*/
+#define ETH_P_IPX	0x8137		/* IPX over DIX			*/
+#define ETH_P_IPV6	0x86DD		/* IPv6 over bluebook		*/
+#define ETH_P_PAUSE	0x8808		/* IEEE Pause frames. See 802.3 31B */
+#define ETH_P_SLOW	0x8809		/* Slow Protocol. See 802.3ad 43B */
+#define ETH_P_WCCP	0x883E		/* Web-cache coordination protocol
+					 * defined in draft-wilson-wrec-wccp-v2-00.txt */
+#define ETH_P_MPLS_UC	0x8847		/* MPLS Unicast traffic		*/
+#define ETH_P_MPLS_MC	0x8848		/* MPLS Multicast traffic	*/
+#define ETH_P_ATMMPOA	0x884c		/* MultiProtocol Over ATM	*/
+#define ETH_P_PPP_DISC	0x8863		/* PPPoE discovery messages     */
+#define ETH_P_PPP_SES	0x8864		/* PPPoE session messages	*/
+#define ETH_P_LINK_CTL	0x886c		/* HPNA, wlan link local tunnel */
+#define ETH_P_ATMFATE	0x8884		/* Frame-based ATM Transport
+					 * over Ethernet
+					 */
+#define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
+#define ETH_P_PROFINET	0x8892		/* PROFINET			*/
+#define ETH_P_REALTEK	0x8899          /* Multiple proprietary protocols */
+#define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
+#define ETH_P_ETHERCAT	0x88A4		/* EtherCAT			*/
+#define ETH_P_8021AD	0x88A8          /* 802.1ad Service VLAN		*/
+#define ETH_P_802_EX1	0x88B5		/* 802.1 Local Experimental 1.  */
+#define ETH_P_PREAUTH	0x88C7		/* 802.11 Preauthentication */
+#define ETH_P_TIPC	0x88CA		/* TIPC 			*/
+#define ETH_P_LLDP	0x88CC		/* Link Layer Discovery Protocol */
+#define ETH_P_MRP	0x88E3		/* Media Redundancy Protocol	*/
+#define ETH_P_MACSEC	0x88E5		/* 802.1ae MACsec */
+#define ETH_P_8021AH	0x88E7          /* 802.1ah Backbone Service Tag */
+#define ETH_P_MVRP	0x88F5          /* 802.1Q MVRP                  */
+#define ETH_P_1588	0x88F7		/* IEEE 1588 Timesync */
+#define ETH_P_NCSI	0x88F8		/* NCSI protocol		*/
+#define ETH_P_PRP	0x88FB		/* IEC 62439-3 PRP/HSRv0	*/
+#define ETH_P_CFM	0x8902		/* Connectivity Fault Management */
+#define ETH_P_FCOE	0x8906		/* Fibre Channel over Ethernet  */
+#define ETH_P_IBOE	0x8915		/* Infiniband over Ethernet	*/
+#define ETH_P_TDLS	0x890D          /* TDLS */
+#define ETH_P_FIP	0x8914		/* FCoE Initialization Protocol */
+#define ETH_P_80221	0x8917		/* IEEE 802.21 Media Independent Handover Protocol */
+#define ETH_P_HSR	0x892F		/* IEC 62439-3 HSRv1	*/
+#define ETH_P_NSH	0x894F		/* Network Service Header */
+#define ETH_P_LOOPBACK	0x9000		/* Ethernet loopback packet, per IEEE 802.3 */
+#define ETH_P_QINQ1	0x9100		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_QINQ2	0x9200		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_QINQ3	0x9300		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_DSA_8021Q	0xDADB		/* Fake VLAN Header for DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_DSA_A5PSW	0xE001		/* A5PSW Tag Value [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
+#define ETH_P_AF_IUCV   0xFBFB		/* IBM af_iucv [ NOT AN OFFICIALLY REGISTERED ID ] */
+
+#define ETH_P_802_3_MIN	0x0600		/* If the value in the ethernet type is more than this value
+					 * then the frame is Ethernet II. Else it is 802.3 */
+
+/*
+ *	Non DIX types. Won't clash for 1500 types.
+ */
+
+#define ETH_P_802_3	0x0001		/* Dummy type for 802.3 frames  */
+#define ETH_P_AX25	0x0002		/* Dummy protocol id for AX.25  */
+#define ETH_P_ALL	0x0003		/* Every packet (be careful!!!) */
+#define ETH_P_802_2	0x0004		/* 802.2 frames 		*/
+#define ETH_P_SNAP	0x0005		/* Internal only		*/
+#define ETH_P_DDCMP     0x0006          /* DEC DDCMP: Internal only     */
+#define ETH_P_WAN_PPP   0x0007          /* Dummy type for WAN PPP frames*/
+#define ETH_P_PPP_MP    0x0008          /* Dummy type for PPP MP frames */
+#define ETH_P_LOCALTALK 0x0009		/* Localtalk pseudo type 	*/
+#define ETH_P_CAN	0x000C		/* CAN: Controller Area Network */
+#define ETH_P_CANFD	0x000D		/* CANFD: CAN flexible data rate*/
+#define ETH_P_CANXL	0x000E		/* CANXL: eXtended frame Length */
+#define ETH_P_PPPTALK	0x0010		/* Dummy type for Atalk over PPP*/
+#define ETH_P_TR_802_2	0x0011		/* 802.2 frames 		*/
+#define ETH_P_MOBITEX	0x0015		/* Mobitex (kaz@cafe.net)	*/
+#define ETH_P_CONTROL	0x0016		/* Card specific control frames */
+#define ETH_P_IRDA	0x0017		/* Linux-IrDA			*/
+#define ETH_P_ECONET	0x0018		/* Acorn Econet			*/
+#define ETH_P_HDLC	0x0019		/* HDLC frames			*/
+#define ETH_P_ARCNET	0x001A		/* 1A for ArcNet :-)            */
+#define ETH_P_DSA	0x001B		/* Distributed Switch Arch.	*/
+#define ETH_P_TRAILER	0x001C		/* Trailer switch tagging	*/
+#define ETH_P_PHONET	0x00F5		/* Nokia Phonet frames          */
+#define ETH_P_IEEE802154 0x00F6		/* IEEE802.15.4 frame		*/
+#define ETH_P_CAIF	0x00F7		/* ST-Ericsson CAIF protocol	*/
+#define ETH_P_XDSA	0x00F8		/* Multiplexed DSA protocol	*/
+#define ETH_P_MAP	0x00F9		/* Qualcomm multiplexing and
+					 * aggregation protocol
+					 */
+#define ETH_P_MCTP	0x00FA		/* Management component transport
+					 * protocol packets
+					 */
+
+/*
+ *	This is an Ethernet frame header.
+ */
+
+/* allow libcs like musl to deactivate this, glibc does not implement this. */
+#ifndef __UAPI_DEF_ETHHDR
+#define __UAPI_DEF_ETHHDR		1
+#endif
+
+#if __UAPI_DEF_ETHHDR
+struct ethhdr {
+	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
+	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
+	__be16		h_proto;		/* packet type ID field	*/
+} __attribute__((packed));
+#endif
+
+
+#endif /* _LINUX_IF_ETHER_H */
diff --git a/uapi/linux/libc-compat.h b/uapi/linux/libc-compat.h
new file mode 100644
index 000000000000..a1599911e7a9
--- /dev/null
+++ b/uapi/linux/libc-compat.h
@@ -0,0 +1,267 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Compatibility interface for userspace libc header coordination:
+ *
+ * Define compatibility macros that are used to control the inclusion or
+ * exclusion of UAPI structures and definitions in coordination with another
+ * userspace C library.
+ *
+ * This header is intended to solve the problem of UAPI definitions that
+ * conflict with userspace definitions. If a UAPI header has such conflicting
+ * definitions then the solution is as follows:
+ *
+ * * Synchronize the UAPI header and the libc headers so either one can be
+ *   used and such that the ABI is preserved. If this is not possible then
+ *   no simple compatibility interface exists (you need to write translating
+ *   wrappers and rename things) and you can't use this interface.
+ *
+ * Then follow this process:
+ *
+ * (a) Include libc-compat.h in the UAPI header.
+ *      e.g. #include <linux/libc-compat.h>
+ *     This include must be as early as possible.
+ *
+ * (b) In libc-compat.h add enough code to detect that the comflicting
+ *     userspace libc header has been included first.
+ *
+ * (c) If the userspace libc header has been included first define a set of
+ *     guard macros of the form __UAPI_DEF_FOO and set their values to 1, else
+ *     set their values to 0.
+ *
+ * (d) Back in the UAPI header with the conflicting definitions, guard the
+ *     definitions with:
+ *     #if __UAPI_DEF_FOO
+ *       ...
+ *     #endif
+ *
+ * This fixes the situation where the linux headers are included *after* the
+ * libc headers. To fix the problem with the inclusion in the other order the
+ * userspace libc headers must be fixed like this:
+ *
+ * * For all definitions that conflict with kernel definitions wrap those
+ *   defines in the following:
+ *   #if !__UAPI_DEF_FOO
+ *     ...
+ *   #endif
+ *
+ * This prevents the redefinition of a construct already defined by the kernel.
+ */
+#ifndef _LIBC_COMPAT_H
+#define _LIBC_COMPAT_H
+
+/* We have included glibc headers... */
+#if defined(__GLIBC__)
+
+/* Coordinate with glibc net/if.h header. */
+#if defined(_NET_IF_H) && defined(__USE_MISC)
+
+/* GLIBC headers included first so don't define anything
+ * that would already be defined. */
+
+#define __UAPI_DEF_IF_IFCONF 0
+#define __UAPI_DEF_IF_IFMAP 0
+#define __UAPI_DEF_IF_IFNAMSIZ 0
+#define __UAPI_DEF_IF_IFREQ 0
+/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 0
+/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
+#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
+#endif /* __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO */
+
+#else /* _NET_IF_H */
+
+/* Linux headers included first, and we must define everything
+ * we need. The expectation is that glibc will check the
+ * __UAPI_DEF_* defines and adjust appropriately. */
+
+#define __UAPI_DEF_IF_IFCONF 1
+#define __UAPI_DEF_IF_IFMAP 1
+#define __UAPI_DEF_IF_IFNAMSIZ 1
+#define __UAPI_DEF_IF_IFREQ 1
+/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
+/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
+
+#endif /* _NET_IF_H */
+
+/* Coordinate with glibc netinet/in.h header. */
+#if defined(_NETINET_IN_H)
+
+/* GLIBC headers included first so don't define anything
+ * that would already be defined. */
+#define __UAPI_DEF_IN_ADDR		0
+#define __UAPI_DEF_IN_IPPROTO		0
+#define __UAPI_DEF_IN_PKTINFO		0
+#define __UAPI_DEF_IP_MREQ		0
+#define __UAPI_DEF_SOCKADDR_IN		0
+#define __UAPI_DEF_IN_CLASS		0
+
+#define __UAPI_DEF_IN6_ADDR		0
+/* The exception is the in6_addr macros which must be defined
+ * if the glibc code didn't define them. This guard matches
+ * the guard in glibc/inet/netinet/in.h which defines the
+ * additional in6_addr macros e.g. s6_addr16, and s6_addr32. */
+#if defined(__USE_MISC) || defined (__USE_GNU)
+#define __UAPI_DEF_IN6_ADDR_ALT		0
+#else
+#define __UAPI_DEF_IN6_ADDR_ALT		1
+#endif
+#define __UAPI_DEF_SOCKADDR_IN6		0
+#define __UAPI_DEF_IPV6_MREQ		0
+#define __UAPI_DEF_IPPROTO_V6		0
+#define __UAPI_DEF_IPV6_OPTIONS		0
+#define __UAPI_DEF_IN6_PKTINFO		0
+#define __UAPI_DEF_IP6_MTUINFO		0
+
+#else
+
+/* Linux headers included first, and we must define everything
+ * we need. The expectation is that glibc will check the
+ * __UAPI_DEF_* defines and adjust appropriately. */
+#define __UAPI_DEF_IN_ADDR		1
+#define __UAPI_DEF_IN_IPPROTO		1
+#define __UAPI_DEF_IN_PKTINFO		1
+#define __UAPI_DEF_IP_MREQ		1
+#define __UAPI_DEF_SOCKADDR_IN		1
+#define __UAPI_DEF_IN_CLASS		1
+
+#define __UAPI_DEF_IN6_ADDR		1
+/* We unconditionally define the in6_addr macros and glibc must
+ * coordinate. */
+#define __UAPI_DEF_IN6_ADDR_ALT		1
+#define __UAPI_DEF_SOCKADDR_IN6		1
+#define __UAPI_DEF_IPV6_MREQ		1
+#define __UAPI_DEF_IPPROTO_V6		1
+#define __UAPI_DEF_IPV6_OPTIONS		1
+#define __UAPI_DEF_IN6_PKTINFO		1
+#define __UAPI_DEF_IP6_MTUINFO		1
+
+#endif /* _NETINET_IN_H */
+
+/* Coordinate with glibc netipx/ipx.h header. */
+#if defined(__NETIPX_IPX_H)
+
+#define __UAPI_DEF_SOCKADDR_IPX			0
+#define __UAPI_DEF_IPX_ROUTE_DEFINITION		0
+#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	0
+#define __UAPI_DEF_IPX_CONFIG_DATA		0
+#define __UAPI_DEF_IPX_ROUTE_DEF		0
+
+#else /* defined(__NETIPX_IPX_H) */
+
+#define __UAPI_DEF_SOCKADDR_IPX			1
+#define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
+#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
+#define __UAPI_DEF_IPX_CONFIG_DATA		1
+#define __UAPI_DEF_IPX_ROUTE_DEF		1
+
+#endif /* defined(__NETIPX_IPX_H) */
+
+/* Definitions for xattr.h */
+#if defined(_SYS_XATTR_H)
+#define __UAPI_DEF_XATTR		0
+#else
+#define __UAPI_DEF_XATTR		1
+#endif
+
+/* If we did not see any headers from any supported C libraries,
+ * or we are being included in the kernel, then define everything
+ * that we need. Check for previous __UAPI_* definitions to give
+ * unsupported C libraries a way to opt out of any kernel definition. */
+#else /* !defined(__GLIBC__) */
+
+/* Definitions for if.h */
+#ifndef __UAPI_DEF_IF_IFCONF
+#define __UAPI_DEF_IF_IFCONF 1
+#endif
+#ifndef __UAPI_DEF_IF_IFMAP
+#define __UAPI_DEF_IF_IFMAP 1
+#endif
+#ifndef __UAPI_DEF_IF_IFNAMSIZ
+#define __UAPI_DEF_IF_IFNAMSIZ 1
+#endif
+#ifndef __UAPI_DEF_IF_IFREQ
+#define __UAPI_DEF_IF_IFREQ 1
+#endif
+/* Everything up to IFF_DYNAMIC, matches net/if.h until glibc 2.23 */
+#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS 1
+#endif
+/* For the future if glibc adds IFF_LOWER_UP, IFF_DORMANT and IFF_ECHO */
+#ifndef __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO
+#define __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO 1
+#endif
+
+/* Definitions for in.h */
+#ifndef __UAPI_DEF_IN_ADDR
+#define __UAPI_DEF_IN_ADDR		1
+#endif
+#ifndef __UAPI_DEF_IN_IPPROTO
+#define __UAPI_DEF_IN_IPPROTO		1
+#endif
+#ifndef __UAPI_DEF_IN_PKTINFO
+#define __UAPI_DEF_IN_PKTINFO		1
+#endif
+#ifndef __UAPI_DEF_IP_MREQ
+#define __UAPI_DEF_IP_MREQ		1
+#endif
+#ifndef __UAPI_DEF_SOCKADDR_IN
+#define __UAPI_DEF_SOCKADDR_IN		1
+#endif
+#ifndef __UAPI_DEF_IN_CLASS
+#define __UAPI_DEF_IN_CLASS		1
+#endif
+
+/* Definitions for in6.h */
+#ifndef __UAPI_DEF_IN6_ADDR
+#define __UAPI_DEF_IN6_ADDR		1
+#endif
+#ifndef __UAPI_DEF_IN6_ADDR_ALT
+#define __UAPI_DEF_IN6_ADDR_ALT		1
+#endif
+#ifndef __UAPI_DEF_SOCKADDR_IN6
+#define __UAPI_DEF_SOCKADDR_IN6		1
+#endif
+#ifndef __UAPI_DEF_IPV6_MREQ
+#define __UAPI_DEF_IPV6_MREQ		1
+#endif
+#ifndef __UAPI_DEF_IPPROTO_V6
+#define __UAPI_DEF_IPPROTO_V6		1
+#endif
+#ifndef __UAPI_DEF_IPV6_OPTIONS
+#define __UAPI_DEF_IPV6_OPTIONS		1
+#endif
+#ifndef __UAPI_DEF_IN6_PKTINFO
+#define __UAPI_DEF_IN6_PKTINFO		1
+#endif
+#ifndef __UAPI_DEF_IP6_MTUINFO
+#define __UAPI_DEF_IP6_MTUINFO		1
+#endif
+
+/* Definitions for ipx.h */
+#ifndef __UAPI_DEF_SOCKADDR_IPX
+#define __UAPI_DEF_SOCKADDR_IPX			1
+#endif
+#ifndef __UAPI_DEF_IPX_ROUTE_DEFINITION
+#define __UAPI_DEF_IPX_ROUTE_DEFINITION		1
+#endif
+#ifndef __UAPI_DEF_IPX_INTERFACE_DEFINITION
+#define __UAPI_DEF_IPX_INTERFACE_DEFINITION	1
+#endif
+#ifndef __UAPI_DEF_IPX_CONFIG_DATA
+#define __UAPI_DEF_IPX_CONFIG_DATA		1
+#endif
+#ifndef __UAPI_DEF_IPX_ROUTE_DEF
+#define __UAPI_DEF_IPX_ROUTE_DEF		1
+#endif
+
+/* Definitions for xattr.h */
+#ifndef __UAPI_DEF_XATTR
+#define __UAPI_DEF_XATTR		1
+#endif
+
+#endif /* __GLIBC__ */
+
+#endif /* _LIBC_COMPAT_H */
diff --git a/uapi/linux/neighbour.h b/uapi/linux/neighbour.h
new file mode 100644
index 000000000000..5e67a7eaf4a7
--- /dev/null
+++ b/uapi/linux/neighbour.h
@@ -0,0 +1,224 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_NEIGHBOUR_H
+#define __LINUX_NEIGHBOUR_H
+
+#include <linux/types.h>
+#include <linux/netlink.h>
+
+struct ndmsg {
+	__u8		ndm_family;
+	__u8		ndm_pad1;
+	__u16		ndm_pad2;
+	__s32		ndm_ifindex;
+	__u16		ndm_state;
+	__u8		ndm_flags;
+	__u8		ndm_type;
+};
+
+enum {
+	NDA_UNSPEC,
+	NDA_DST,
+	NDA_LLADDR,
+	NDA_CACHEINFO,
+	NDA_PROBES,
+	NDA_VLAN,
+	NDA_PORT,
+	NDA_VNI,
+	NDA_IFINDEX,
+	NDA_MASTER,
+	NDA_LINK_NETNSID,
+	NDA_SRC_VNI,
+	NDA_PROTOCOL,  /* Originator of entry */
+	NDA_NH_ID,
+	NDA_FDB_EXT_ATTRS,
+	NDA_FLAGS_EXT,
+	NDA_NDM_STATE_MASK,
+	NDA_NDM_FLAGS_MASK,
+	__NDA_MAX
+};
+
+#define NDA_MAX (__NDA_MAX - 1)
+
+/*
+ *	Neighbor Cache Entry Flags
+ */
+
+#define NTF_USE		(1 << 0)
+#define NTF_SELF	(1 << 1)
+#define NTF_MASTER	(1 << 2)
+#define NTF_PROXY	(1 << 3)	/* == ATF_PUBL */
+#define NTF_EXT_LEARNED	(1 << 4)
+#define NTF_OFFLOADED   (1 << 5)
+#define NTF_STICKY	(1 << 6)
+#define NTF_ROUTER	(1 << 7)
+/* Extended flags under NDA_FLAGS_EXT: */
+#define NTF_EXT_MANAGED		(1 << 0)
+#define NTF_EXT_LOCKED		(1 << 1)
+
+/*
+ *	Neighbor Cache Entry States.
+ */
+
+#define NUD_INCOMPLETE	0x01
+#define NUD_REACHABLE	0x02
+#define NUD_STALE	0x04
+#define NUD_DELAY	0x08
+#define NUD_PROBE	0x10
+#define NUD_FAILED	0x20
+
+/* Dummy states */
+#define NUD_NOARP	0x40
+#define NUD_PERMANENT	0x80
+#define NUD_NONE	0x00
+
+/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change and make no
+ * address resolution or NUD.
+ *
+ * NUD_PERMANENT also cannot be deleted by garbage collectors. This holds true
+ * for dynamic entries with NTF_EXT_LEARNED flag as well. However, upon carrier
+ * down event, NUD_PERMANENT entries are not flushed whereas NTF_EXT_LEARNED
+ * flagged entries explicitly are (which is also consistent with the routing
+ * subsystem).
+ *
+ * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
+ * states don't make sense and thus are ignored. Such entries don't age and
+ * can roam.
+ *
+ * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
+ * of a user space control plane, and automatically refreshed so that (if
+ * possible) they remain in NUD_REACHABLE state.
+ *
+ * NTF_EXT_LOCKED flagged bridge FDB entries are entries generated by the
+ * bridge in response to a host trying to communicate via a locked bridge port
+ * with MAB enabled. Their purpose is to notify user space that a host requires
+ * authentication.
+ */
+
+struct nda_cacheinfo {
+	__u32		ndm_confirmed;
+	__u32		ndm_used;
+	__u32		ndm_updated;
+	__u32		ndm_refcnt;
+};
+
+/*****************************************************************
+ *		Neighbour tables specific messages.
+ *
+ * To retrieve the neighbour tables send RTM_GETNEIGHTBL with the
+ * NLM_F_DUMP flag set. Every neighbour table configuration is
+ * spread over multiple messages to avoid running into message
+ * size limits on systems with many interfaces. The first message
+ * in the sequence transports all not device specific data such as
+ * statistics, configuration, and the default parameter set.
+ * This message is followed by 0..n messages carrying device
+ * specific parameter sets.
+ * Although the ordering should be sufficient, NDTA_NAME can be
+ * used to identify sequences. The initial message can be identified
+ * by checking for NDTA_CONFIG. The device specific messages do
+ * not contain this TLV but have NDTPA_IFINDEX set to the
+ * corresponding interface index.
+ *
+ * To change neighbour table attributes, send RTM_SETNEIGHTBL
+ * with NDTA_NAME set. Changeable attribute include NDTA_THRESH[1-3],
+ * NDTA_GC_INTERVAL, and all TLVs in NDTA_PARMS unless marked
+ * otherwise. Device specific parameter sets can be changed by
+ * setting NDTPA_IFINDEX to the interface index of the corresponding
+ * device.
+ ****/
+
+struct ndt_stats {
+	__u64		ndts_allocs;
+	__u64		ndts_destroys;
+	__u64		ndts_hash_grows;
+	__u64		ndts_res_failed;
+	__u64		ndts_lookups;
+	__u64		ndts_hits;
+	__u64		ndts_rcv_probes_mcast;
+	__u64		ndts_rcv_probes_ucast;
+	__u64		ndts_periodic_gc_runs;
+	__u64		ndts_forced_gc_runs;
+	__u64		ndts_table_fulls;
+};
+
+enum {
+	NDTPA_UNSPEC,
+	NDTPA_IFINDEX,			/* u32, unchangeable */
+	NDTPA_REFCNT,			/* u32, read-only */
+	NDTPA_REACHABLE_TIME,		/* u64, read-only, msecs */
+	NDTPA_BASE_REACHABLE_TIME,	/* u64, msecs */
+	NDTPA_RETRANS_TIME,		/* u64, msecs */
+	NDTPA_GC_STALETIME,		/* u64, msecs */
+	NDTPA_DELAY_PROBE_TIME,		/* u64, msecs */
+	NDTPA_QUEUE_LEN,		/* u32 */
+	NDTPA_APP_PROBES,		/* u32 */
+	NDTPA_UCAST_PROBES,		/* u32 */
+	NDTPA_MCAST_PROBES,		/* u32 */
+	NDTPA_ANYCAST_DELAY,		/* u64, msecs */
+	NDTPA_PROXY_DELAY,		/* u64, msecs */
+	NDTPA_PROXY_QLEN,		/* u32 */
+	NDTPA_LOCKTIME,			/* u64, msecs */
+	NDTPA_QUEUE_LENBYTES,		/* u32 */
+	NDTPA_MCAST_REPROBES,		/* u32 */
+	NDTPA_PAD,
+	NDTPA_INTERVAL_PROBE_TIME_MS,	/* u64, msecs */
+	__NDTPA_MAX
+};
+#define NDTPA_MAX (__NDTPA_MAX - 1)
+
+struct ndtmsg {
+	__u8		ndtm_family;
+	__u8		ndtm_pad1;
+	__u16		ndtm_pad2;
+};
+
+struct ndt_config {
+	__u16		ndtc_key_len;
+	__u16		ndtc_entry_size;
+	__u32		ndtc_entries;
+	__u32		ndtc_last_flush;	/* delta to now in msecs */
+	__u32		ndtc_last_rand;		/* delta to now in msecs */
+	__u32		ndtc_hash_rnd;
+	__u32		ndtc_hash_mask;
+	__u32		ndtc_hash_chain_gc;
+	__u32		ndtc_proxy_qlen;
+};
+
+enum {
+	NDTA_UNSPEC,
+	NDTA_NAME,			/* char *, unchangeable */
+	NDTA_THRESH1,			/* u32 */
+	NDTA_THRESH2,			/* u32 */
+	NDTA_THRESH3,			/* u32 */
+	NDTA_CONFIG,			/* struct ndt_config, read-only */
+	NDTA_PARMS,			/* nested TLV NDTPA_* */
+	NDTA_STATS,			/* struct ndt_stats, read-only */
+	NDTA_GC_INTERVAL,		/* u64, msecs */
+	NDTA_PAD,
+	__NDTA_MAX
+};
+#define NDTA_MAX (__NDTA_MAX - 1)
+
+ /* FDB activity notification bits used in NFEA_ACTIVITY_NOTIFY:
+  * - FDB_NOTIFY_BIT - notify on activity/expire for any entry
+  * - FDB_NOTIFY_INACTIVE_BIT - mark as inactive to avoid multiple notifications
+  */
+enum {
+	FDB_NOTIFY_BIT		= (1 << 0),
+	FDB_NOTIFY_INACTIVE_BIT	= (1 << 1)
+};
+
+/* embedded into NDA_FDB_EXT_ATTRS:
+ * [NDA_FDB_EXT_ATTRS] = {
+ *     [NFEA_ACTIVITY_NOTIFY]
+ *     ...
+ * }
+ */
+enum {
+	NFEA_UNSPEC,
+	NFEA_ACTIVITY_NOTIFY,
+	NFEA_DONT_REFRESH,
+	__NFEA_MAX
+};
+#define NFEA_MAX (__NFEA_MAX - 1)
+
+#endif
diff --git a/uapi/linux/posix_types.h b/uapi/linux/posix_types.h
new file mode 100644
index 000000000000..9a7a740b35a2
--- /dev/null
+++ b/uapi/linux/posix_types.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_POSIX_TYPES_H
+#define _LINUX_POSIX_TYPES_H
+
+#include <linux/stddef.h>
+
+/*
+ * This allows for 1024 file descriptors: if NR_OPEN is ever grown
+ * beyond that you'll have to change this too. But 1024 fd's seem to be
+ * enough even for such "real" unices like OSF/1, so hopefully this is
+ * one limit that doesn't have to be changed [again].
+ *
+ * Note that POSIX wants the FD_CLEAR(fd,fdsetp) defines to be in
+ * <sys/time.h> (and thus <linux/time.h>) - but this is a more logical
+ * place for them. Solved by having dummy defines in <sys/time.h>.
+ */
+
+/*
+ * This macro may have been defined in <gnu/types.h>. But we always
+ * use the one here.
+ */
+#undef __FD_SETSIZE
+#define __FD_SETSIZE	1024
+
+typedef struct {
+	unsigned long fds_bits[__FD_SETSIZE / (8 * sizeof(long))];
+} __kernel_fd_set;
+
+/* Type of a signal handler.  */
+typedef void (*__kernel_sighandler_t)(int);
+
+/* Type of a SYSV IPC key.  */
+typedef int __kernel_key_t;
+typedef int __kernel_mqd_t;
+
+#include <asm/posix_types.h>
+
+#endif /* _LINUX_POSIX_TYPES_H */
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index 217b25b963f5..2132e941b93a 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -787,6 +787,7 @@ enum {
 	TCA_ROOT_FLAGS,
 	TCA_ROOT_COUNT,
 	TCA_ROOT_TIME_DELTA, /* in msecs */
+	TCA_ROOT_EXT_WARN_MSG,
 	__TCA_ROOT_MAX,
 #define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
 };
diff --git a/uapi/linux/socket.h b/uapi/linux/socket.h
new file mode 100644
index 000000000000..89c227f3d4cd
--- /dev/null
+++ b/uapi/linux/socket.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_SOCKET_H
+#define _LINUX_SOCKET_H
+
+/*
+ * Desired design of maximum size and alignment (see RFC2553)
+ */
+#define _K_SS_MAXSIZE	128	/* Implementation specific max size */
+
+typedef unsigned short __kernel_sa_family_t;
+
+/*
+ * The definition uses anonymous union and struct in order to control the
+ * default alignment.
+ */
+struct __kernel_sockaddr_storage {
+	union {
+		struct {
+			__kernel_sa_family_t	ss_family; /* address family */
+			/* Following field(s) are implementation specific */
+			char __data[_K_SS_MAXSIZE - sizeof(unsigned short)];
+				/* space to achieve desired size, */
+				/* _SS_MAXSIZE value minus size of ss_family */
+		};
+		void *__align; /* implementation specific desired alignment */
+	};
+};
+
+#define SOCK_SNDBUF_LOCK	1
+#define SOCK_RCVBUF_LOCK	2
+
+#define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
+
+#define SOCK_TXREHASH_DEFAULT	255
+#define SOCK_TXREHASH_DISABLED	0
+#define SOCK_TXREHASH_ENABLED	1
+
+#endif /* _LINUX_SOCKET_H */
diff --git a/uapi/linux/stddef.h b/uapi/linux/stddef.h
new file mode 100644
index 000000000000..bb6ea517efb5
--- /dev/null
+++ b/uapi/linux/stddef.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_STDDEF_H
+#define _LINUX_STDDEF_H
+
+
+
+#ifndef __always_inline
+#define __always_inline __inline__
+#endif
+
+/**
+ * __struct_group() - Create a mirrored named and anonyomous struct
+ *
+ * @TAG: The tag name for the named sub-struct (usually empty)
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (usually empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical layout
+ * and size: one anonymous and one named. The former's members can be used
+ * normally without sub-struct naming, and the latter can be used to
+ * reason about the start, end, and size of the group of struct members.
+ * The named struct can also be explicitly tagged for layer reuse, as well
+ * as both having struct attributes appended.
+ */
+#define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct TAG { MEMBERS } ATTRS NAME; \
+	}
+
+/**
+ * __DECLARE_FLEX_ARRAY() - Declare a flexible array usable in a union
+ *
+ * @TYPE: The type of each flexible array element
+ * @NAME: The name of the flexible array member
+ *
+ * In order to have a flexible array member in a union or alone in a
+ * struct, it needs to be wrapped in an anonymous struct with at least 1
+ * named member, but that member can be empty.
+ */
+#define __DECLARE_FLEX_ARRAY(TYPE, NAME)	\
+	struct { \
+		struct { } __empty_ ## NAME; \
+		TYPE NAME[]; \
+	}
+#endif
diff --git a/uapi/linux/types.h b/uapi/linux/types.h
new file mode 100644
index 000000000000..6546100a69f2
--- /dev/null
+++ b/uapi/linux/types.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_TYPES_H
+#define _LINUX_TYPES_H
+
+#include <asm/types.h>
+
+#ifndef __ASSEMBLY__
+
+#include <linux/posix_types.h>
+
+
+/*
+ * Below are truly Linux-specific types that should never collide with
+ * any application/library that wants linux/types.h.
+ */
+
+/* sparse defines __CHECKER__; see Documentation/dev-tools/sparse.rst */
+#ifdef __CHECKER__
+#define __bitwise	__attribute__((bitwise))
+#else
+#define __bitwise
+#endif
+
+/* The kernel doesn't use this legacy form, but user space does */
+#define __bitwise__ __bitwise
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+/*
+ * aligned_u64 should be used in defining kernel<->userspace ABIs to avoid
+ * common 32/64-bit compat problems.
+ * 64-bit values align to 4-byte boundaries on x86_32 (and possibly other
+ * architectures) and to 8-byte boundaries on 64-bit architectures.  The new
+ * aligned_64 type enforces 8-byte alignment so that structs containing
+ * aligned_64 values have the same alignment on 32-bit and 64-bit architectures.
+ * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
+ */
+#define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_be64 __be64 __attribute__((aligned(8)))
+#define __aligned_le64 __le64 __attribute__((aligned(8)))
+
+typedef unsigned __bitwise __poll_t;
+
+#endif /*  __ASSEMBLY__ */
+#endif /* _LINUX_TYPES_H */
-- 
2.40.0

