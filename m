Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9528FB32
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 00:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731384AbgJOWb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 18:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731189AbgJOWbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 18:31:25 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1F4C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 15:31:25 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id l8so401317qvz.2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 15:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=hS4wgPIOR99ty6jrB0/aqFg9dqNphNV/tqTdz3610qI=;
        b=PPDWzDGVfweOlDS3Zbgn4zedu04+MAuz2y+82bzVaiaNFIIrFcnHBgWYqoC7QjK/zm
         wnNh5oRy2Wey5/LFOVE9XDGfAa6cXCyZgkfL/NOzrI53a/yw4bfq0ZGI08DNNs7AdU8h
         wJFoHUa1wz58Ony1OqHw3BQWM3ZEOpkNyZb19DmYFZGpQGRKF+YtrLOtPPTFfNlOk7cb
         /yaPHIjfd7PMiBoszJOGmQ6lvHMAccAAokTqqJmXJVucRSvFzBNd/Oul2OSas11uRZ4J
         RiXXJWk3C7umbEUOy0bF3jv4g7JjM8ZD/YViPlT6XpyOUSWiIAyutb6uxi6HE/3WlF+T
         59dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=hS4wgPIOR99ty6jrB0/aqFg9dqNphNV/tqTdz3610qI=;
        b=DQiHQfdlhjoxfUtu0eB/RGg45tAiqfRV/fVZcOv9ydDVGF9YydPue+xLwmz7qzz1K9
         GvewTH/rJpXCYsKbb0gepc+17D2falKBeFT1w8Ou7iO7TriDMhPIwgSRtayH/Ncj11cs
         RydzAc/YjZuoE2usXcuZZ6e4EoPlGolvvXZvA2hCDAdwOjeZPZGtf7oEbxSIOjixoHiv
         rHd7Zvvx/le2P/2+Rxaxw/YE7tJN+pAUgcQQsRX+sgNQFGelvTAaHFHK1bJgoyTr0/IR
         XiPwfKAAlHYakublAyEr6sb/XA+78G6XsYpnSvFuE8pxGTqdeSk+DSvI2MMDtYRihBhP
         2SbQ==
X-Gm-Message-State: AOAM532LA09LdHmPKRSJfX6u03aA7wOxO6FkaXQEnjMLOH2ODSCAPdl4
        SrDe07TxwD1m1lialN9RwRwLdr8/iyf9
X-Google-Smtp-Source: ABdhPJy7czy2t1KFfafLG5vdyYGg1y3ci/Lw7zSYCRWGtcCE4uz4DBgDrWmr2yN/ZEh4RMUIHH3MD0nVrztm
Sender: "irogers via sendgmr" <irogers@irogers.svl.corp.google.com>
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:ad4:5843:: with SMTP id
 de3mr760748qvb.12.1602801084379; Thu, 15 Oct 2020 15:31:24 -0700 (PDT)
Date:   Thu, 15 Oct 2020 15:31:18 -0700
Message-Id: <20201015223119.1712121-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
Subject: [PATCH 1/2] tools/include: Update if_link.h and netlink.h
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Cassen <acassen@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are tested to be the latest as part of the tools/lib/bpf build.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/include/uapi/linux/if_link.h | 269 +++++++++++++++++++++++++----
 tools/include/uapi/linux/netlink.h | 107 ++++++++++++
 2 files changed, 342 insertions(+), 34 deletions(-)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 781e482dc499..c4b23f06f69e 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -7,24 +7,23 @@
 
 /* This struct should be in sync with struct rtnl_link_stats64 */
 struct rtnl_link_stats {
-	__u32	rx_packets;		/* total packets received	*/
-	__u32	tx_packets;		/* total packets transmitted	*/
-	__u32	rx_bytes;		/* total bytes received 	*/
-	__u32	tx_bytes;		/* total bytes transmitted	*/
-	__u32	rx_errors;		/* bad packets received		*/
-	__u32	tx_errors;		/* packet transmit problems	*/
-	__u32	rx_dropped;		/* no space in linux buffers	*/
-	__u32	tx_dropped;		/* no space available in linux	*/
-	__u32	multicast;		/* multicast packets received	*/
+	__u32	rx_packets;
+	__u32	tx_packets;
+	__u32	rx_bytes;
+	__u32	tx_bytes;
+	__u32	rx_errors;
+	__u32	tx_errors;
+	__u32	rx_dropped;
+	__u32	tx_dropped;
+	__u32	multicast;
 	__u32	collisions;
-
 	/* detailed rx_errors: */
 	__u32	rx_length_errors;
-	__u32	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u32	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u32	rx_frame_errors;	/* recv'd frame alignment error */
-	__u32	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u32	rx_missed_errors;	/* receiver missed packet	*/
+	__u32	rx_over_errors;
+	__u32	rx_crc_errors;
+	__u32	rx_frame_errors;
+	__u32	rx_fifo_errors;
+	__u32	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u32	tx_aborted_errors;
@@ -37,29 +36,200 @@ struct rtnl_link_stats {
 	__u32	rx_compressed;
 	__u32	tx_compressed;
 
-	__u32	rx_nohandler;		/* dropped, no handler found	*/
+	__u32	rx_nohandler;
 };
 
-/* The main device statistics structure */
+/**
+ * struct rtnl_link_stats64 - The main device statistics structure.
+ *
+ * @rx_packets: Number of good packets received by the interface.
+ *   For hardware interfaces counts all good packets received from the device
+ *   by the host, including packets which host had to drop at various stages
+ *   of processing (even in the driver).
+ *
+ * @tx_packets: Number of packets successfully transmitted.
+ *   For hardware interfaces counts packets which host was able to successfully
+ *   hand over to the device, which does not necessarily mean that packets
+ *   had been successfully transmitted out of the device, only that device
+ *   acknowledged it copied them out of host memory.
+ *
+ * @rx_bytes: Number of good received bytes, corresponding to @rx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @tx_bytes: Number of good transmitted bytes, corresponding to @tx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @rx_errors: Total number of bad packets received on this network device.
+ *   This counter must include events counted by @rx_length_errors,
+ *   @rx_crc_errors, @rx_frame_errors and other errors not otherwise
+ *   counted.
+ *
+ * @tx_errors: Total number of transmit problems.
+ *   This counter must include events counter by @tx_aborted_errors,
+ *   @tx_carrier_errors, @tx_fifo_errors, @tx_heartbeat_errors,
+ *   @tx_window_errors and other errors not otherwise counted.
+ *
+ * @rx_dropped: Number of packets received but not processed,
+ *   e.g. due to lack of resources or unsupported protocol.
+ *   For hardware interfaces this counter should not include packets
+ *   dropped by the device which are counted separately in
+ *   @rx_missed_errors (since procfs folds those two counters together).
+ *
+ * @tx_dropped: Number of packets dropped on their way to transmission,
+ *   e.g. due to lack of resources.
+ *
+ * @multicast: Multicast packets received.
+ *   For hardware interfaces this statistic is commonly calculated
+ *   at the device level (unlike @rx_packets) and therefore may include
+ *   packets which did not reach the host.
+ *
+ *   For IEEE 802.3 devices this counter may be equivalent to:
+ *
+ *    - 30.3.1.1.21 aMulticastFramesReceivedOK
+ *
+ * @collisions: Number of collisions during packet transmissions.
+ *
+ * @rx_length_errors: Number of packets dropped due to invalid length.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to a sum
+ *   of the following attributes:
+ *
+ *    - 30.3.1.1.23 aInRangeLengthErrors
+ *    - 30.3.1.1.24 aOutOfRangeLengthField
+ *    - 30.3.1.1.25 aFrameTooLongErrors
+ *
+ * @rx_over_errors: Receiver FIFO overflow event counter.
+ *
+ *   Historically the count of overflow events. Such events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   The recommended interpretation for high speed interfaces is -
+ *   number of packets dropped because they did not fit into buffers
+ *   provided by the host, e.g. packets larger than MTU or next buffer
+ *   in the ring was not available for a scatter transfer.
+ *
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   This statistics was historically used interchangeably with
+ *   @rx_fifo_errors.
+ *
+ *   This statistic corresponds to hardware events and is not commonly used
+ *   on software devices.
+ *
+ * @rx_crc_errors: Number of packets received with a CRC error.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.6 aFrameCheckSequenceErrors
+ *
+ * @rx_frame_errors: Receiver frame alignment errors.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to:
+ *
+ *    - 30.3.1.1.7 aAlignmentErrors
+ *
+ * @rx_fifo_errors: Receiver FIFO error counter.
+ *
+ *   Historically the count of overflow events. Those events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   This statistics was used interchangeably with @rx_over_errors.
+ *   Not recommended for use in drivers for high speed interfaces.
+ *
+ *   This statistic is used on software devices, e.g. to count software
+ *   packet queue overflow (can) or sequencing errors (GRE).
+ *
+ * @rx_missed_errors: Count of packets missed by the host.
+ *   Folded into the "drop" counter in `/proc/net/dev`.
+ *
+ *   Counts number of packets dropped by the device due to lack
+ *   of buffer space. This usually indicates that the host interface
+ *   is slower than the network interface, or host is not keeping up
+ *   with the receive packet rate.
+ *
+ *   This statistic corresponds to hardware events and is not used
+ *   on software devices.
+ *
+ * @tx_aborted_errors:
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *   For IEEE 802.3 devices capable of half-duplex operation this counter
+ *   must be equivalent to:
+ *
+ *    - 30.3.1.1.11 aFramesAbortedDueToXSColls
+ *
+ *   High speed interfaces may use this counter as a general device
+ *   discard counter.
+ *
+ * @tx_carrier_errors: Number of frame transmission errors due to loss
+ *   of carrier during transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.13 aCarrierSenseErrors
+ *
+ * @tx_fifo_errors: Number of frame transmission errors due to device
+ *   FIFO underrun / underflow. This condition occurs when the device
+ *   begins transmission of a frame but is unable to deliver the
+ *   entire frame to the transmitter in time for transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ * @tx_heartbeat_errors: Number of Heartbeat / SQE Test errors for
+ *   old half-duplex Ethernet.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices possibly equivalent to:
+ *
+ *    - 30.3.2.1.4 aSQETestErrors
+ *
+ * @tx_window_errors: Number of frame transmission errors due
+ *   to late collisions (for Ethernet - after the first 64B of transmission).
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.10 aLateCollisions
+ *
+ * @rx_compressed: Number of correctly received compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @tx_compressed: Number of transmitted compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @rx_nohandler: Number of packets received on the interface
+ *   but dropped by the networking stack because the device is
+ *   not designated to receive packets (e.g. backup link in a bond).
+ */
 struct rtnl_link_stats64 {
-	__u64	rx_packets;		/* total packets received	*/
-	__u64	tx_packets;		/* total packets transmitted	*/
-	__u64	rx_bytes;		/* total bytes received 	*/
-	__u64	tx_bytes;		/* total bytes transmitted	*/
-	__u64	rx_errors;		/* bad packets received		*/
-	__u64	tx_errors;		/* packet transmit problems	*/
-	__u64	rx_dropped;		/* no space in linux buffers	*/
-	__u64	tx_dropped;		/* no space available in linux	*/
-	__u64	multicast;		/* multicast packets received	*/
+	__u64	rx_packets;
+	__u64	tx_packets;
+	__u64	rx_bytes;
+	__u64	tx_bytes;
+	__u64	rx_errors;
+	__u64	tx_errors;
+	__u64	rx_dropped;
+	__u64	tx_dropped;
+	__u64	multicast;
 	__u64	collisions;
 
 	/* detailed rx_errors: */
 	__u64	rx_length_errors;
-	__u64	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u64	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u64	rx_frame_errors;	/* recv'd frame alignment error */
-	__u64	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u64	rx_missed_errors;	/* receiver missed packet	*/
+	__u64	rx_over_errors;
+	__u64	rx_crc_errors;
+	__u64	rx_frame_errors;
+	__u64	rx_fifo_errors;
+	__u64	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u64	tx_aborted_errors;
@@ -71,8 +241,7 @@ struct rtnl_link_stats64 {
 	/* for cslip etc */
 	__u64	rx_compressed;
 	__u64	tx_compressed;
-
-	__u64	rx_nohandler;		/* dropped, no handler found	*/
+	__u64	rx_nohandler;
 };
 
 /* The struct should be in sync with struct ifmap */
@@ -170,12 +339,22 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_PROTO_DOWN_REASON,
 	__IFLA_MAX
 };
 
 
 #define IFLA_MAX (__IFLA_MAX - 1)
 
+enum {
+	IFLA_PROTO_DOWN_REASON_UNSPEC,
+	IFLA_PROTO_DOWN_REASON_MASK,	/* u32, mask for reason bits */
+	IFLA_PROTO_DOWN_REASON_VALUE,   /* u32, reason bit value */
+
+	__IFLA_PROTO_DOWN_REASON_CNT,
+	IFLA_PROTO_DOWN_REASON_MAX = __IFLA_PROTO_DOWN_REASON_CNT - 1
+};
+
 /* backwards compatibility for userspace */
 #ifndef __KERNEL__
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
@@ -594,6 +773,18 @@ enum ifla_geneve_df {
 	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
 };
 
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_MULTIPROTO_MODE,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
 /* PPP section */
 enum {
 	IFLA_PPP_UNSPEC,
@@ -895,7 +1086,14 @@ enum {
 #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
 
 
-/* HSR section */
+/* HSR/PRP section, both uses same interface */
+
+/* Different redundancy protocols for hsr device */
+enum {
+	HSR_PROTOCOL_HSR,
+	HSR_PROTOCOL_PRP,
+	HSR_PROTOCOL_MAX,
+};
 
 enum {
 	IFLA_HSR_UNSPEC,
@@ -905,6 +1103,9 @@ enum {
 	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
 	IFLA_HSR_SEQ_NR,
 	IFLA_HSR_VERSION,		/* HSR version */
+	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
+					 * HSR. For example PRP.
+					 */
 	__IFLA_HSR_MAX,
 };
 
diff --git a/tools/include/uapi/linux/netlink.h b/tools/include/uapi/linux/netlink.h
index 0a4d73317759..c3816ff7bfc3 100644
--- a/tools/include/uapi/linux/netlink.h
+++ b/tools/include/uapi/linux/netlink.h
@@ -129,6 +129,7 @@ struct nlmsgerr {
  * @NLMSGERR_ATTR_COOKIE: arbitrary subsystem specific cookie to
  *	be used - in the success case - to identify a created
  *	object or operation or similar (binary)
+ * @NLMSGERR_ATTR_POLICY: policy for a rejected attribute
  * @__NLMSGERR_ATTR_MAX: number of attributes
  * @NLMSGERR_ATTR_MAX: highest attribute number
  */
@@ -137,6 +138,7 @@ enum nlmsgerr_attrs {
 	NLMSGERR_ATTR_MSG,
 	NLMSGERR_ATTR_OFFS,
 	NLMSGERR_ATTR_COOKIE,
+	NLMSGERR_ATTR_POLICY,
 
 	__NLMSGERR_ATTR_MAX,
 	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
@@ -249,4 +251,109 @@ struct nla_bitfield32 {
 	__u32 selector;
 };
 
+/*
+ * policy descriptions - it's specific to each family how this is used
+ * Normally, it should be retrieved via a dump inside another attribute
+ * specifying where it applies.
+ */
+
+/**
+ * enum netlink_attribute_type - type of an attribute
+ * @NL_ATTR_TYPE_INVALID: unused
+ * @NL_ATTR_TYPE_FLAG: flag attribute (present/not present)
+ * @NL_ATTR_TYPE_U8: 8-bit unsigned attribute
+ * @NL_ATTR_TYPE_U16: 16-bit unsigned attribute
+ * @NL_ATTR_TYPE_U32: 32-bit unsigned attribute
+ * @NL_ATTR_TYPE_U64: 64-bit unsigned attribute
+ * @NL_ATTR_TYPE_S8: 8-bit signed attribute
+ * @NL_ATTR_TYPE_S16: 16-bit signed attribute
+ * @NL_ATTR_TYPE_S32: 32-bit signed attribute
+ * @NL_ATTR_TYPE_S64: 64-bit signed attribute
+ * @NL_ATTR_TYPE_BINARY: binary data, min/max length may be specified
+ * @NL_ATTR_TYPE_STRING: string, min/max length may be specified
+ * @NL_ATTR_TYPE_NUL_STRING: NUL-terminated string,
+ *	min/max length may be specified
+ * @NL_ATTR_TYPE_NESTED: nested, i.e. the content of this attribute
+ *	consists of sub-attributes. The nested policy and maxtype
+ *	inside may be specified.
+ * @NL_ATTR_TYPE_NESTED_ARRAY: nested array, i.e. the content of this
+ *	attribute contains sub-attributes whose type is irrelevant
+ *	(just used to separate the array entries) and each such array
+ *	entry has attributes again, the policy for those inner ones
+ *	and the corresponding maxtype may be specified.
+ * @NL_ATTR_TYPE_BITFIELD32: &struct nla_bitfield32 attribute
+ */
+enum netlink_attribute_type {
+	NL_ATTR_TYPE_INVALID,
+
+	NL_ATTR_TYPE_FLAG,
+
+	NL_ATTR_TYPE_U8,
+	NL_ATTR_TYPE_U16,
+	NL_ATTR_TYPE_U32,
+	NL_ATTR_TYPE_U64,
+
+	NL_ATTR_TYPE_S8,
+	NL_ATTR_TYPE_S16,
+	NL_ATTR_TYPE_S32,
+	NL_ATTR_TYPE_S64,
+
+	NL_ATTR_TYPE_BINARY,
+	NL_ATTR_TYPE_STRING,
+	NL_ATTR_TYPE_NUL_STRING,
+
+	NL_ATTR_TYPE_NESTED,
+	NL_ATTR_TYPE_NESTED_ARRAY,
+
+	NL_ATTR_TYPE_BITFIELD32,
+};
+
+/**
+ * enum netlink_policy_type_attr - policy type attributes
+ * @NL_POLICY_TYPE_ATTR_UNSPEC: unused
+ * @NL_POLICY_TYPE_ATTR_TYPE: type of the attribute,
+ *	&enum netlink_attribute_type (U32)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_S: minimum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_S: maximum value for signed
+ *	integers (S64)
+ * @NL_POLICY_TYPE_ATTR_MIN_VALUE_U: minimum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MAX_VALUE_U: maximum value for unsigned
+ *	integers (U64)
+ * @NL_POLICY_TYPE_ATTR_MIN_LENGTH: minimum length for binary
+ *	attributes, no minimum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_MAX_LENGTH: maximum length for binary
+ *	attributes, no maximum if not given (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_IDX: sub policy for nested and
+ *	nested array types (U32)
+ * @NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE: maximum sub policy
+ *	attribute for nested and nested array types, this can
+ *	in theory be < the size of the policy pointed to by
+ *	the index, if limited inside the nesting (U32)
+ * @NL_POLICY_TYPE_ATTR_BITFIELD32_MASK: valid mask for the
+ *	bitfield32 type (U32)
+ * @NL_POLICY_TYPE_ATTR_MASK: mask of valid bits for unsigned integers (U64)
+ * @NL_POLICY_TYPE_ATTR_PAD: pad attribute for 64-bit alignment
+ */
+enum netlink_policy_type_attr {
+	NL_POLICY_TYPE_ATTR_UNSPEC,
+	NL_POLICY_TYPE_ATTR_TYPE,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_S,
+	NL_POLICY_TYPE_ATTR_MIN_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MAX_VALUE_U,
+	NL_POLICY_TYPE_ATTR_MIN_LENGTH,
+	NL_POLICY_TYPE_ATTR_MAX_LENGTH,
+	NL_POLICY_TYPE_ATTR_POLICY_IDX,
+	NL_POLICY_TYPE_ATTR_POLICY_MAXTYPE,
+	NL_POLICY_TYPE_ATTR_BITFIELD32_MASK,
+	NL_POLICY_TYPE_ATTR_PAD,
+	NL_POLICY_TYPE_ATTR_MASK,
+
+	/* keep last */
+	__NL_POLICY_TYPE_ATTR_MAX,
+	NL_POLICY_TYPE_ATTR_MAX = __NL_POLICY_TYPE_ATTR_MAX - 1
+};
+
 #endif /* _UAPI__LINUX_NETLINK_H */
-- 
2.29.0.rc1.297.gfa9743e501-goog

