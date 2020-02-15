Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBD9160123
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 00:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgBOXeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 18:34:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOXeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 18:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Uo7NlmOzMLt+a7yp1F+9dGT/PK5kr6Sa1Qub2GaBCgs=; b=E4XDRHe9bmr8N7DtgYek0P/C8e
        dPopiallWMRPi5jsCE7ru07kE6yWVycKZwiUbl0wlAKlABE52im5EBrHj194y8nBl0vj4ODln5/nY
        RqZvHcfFaPhXlaDZaS2o3gdz3Nxah+OEZBHnehaVDjja9xf2ly6rHG5rhPwQneurszJtAkO5/nbIy
        T213v+umtcuG4vubpMsTdkVJ+5yHXEDPTLbFGt1zQosS1PsHLv64ctHzbwZw7koQcJHhfj9VrIPYL
        IyMhw6E2CR85ltQju5vyGxAKgzq4Vq5FfOvg76wAjK4KNTjbBvqXkrAlBRo2ElRk2zWqEKIuxW8Ri
        H33STtGA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j36wq-0006zt-78; Sat, 15 Feb 2020 23:34:08 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] skbuff.h: fix all kernel-doc warnings
Message-ID: <ce570d32-1a3d-0438-d5fc-0e16b2d417df@infradead.org>
Date:   Sat, 15 Feb 2020 15:34:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix all kernel-doc warnings in <linux/skbuff.h>.
Fixes these warnings:

../include/linux/skbuff.h:890: warning: Function parameter or member 'list' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member '__pkt_vlan_present_offset' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'vlan_present' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
../include/linux/skbuff.h:890: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/skbuff.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- lnx-56-rc1.orig/include/linux/skbuff.h
+++ lnx-56-rc1/include/linux/skbuff.h
@@ -611,9 +611,15 @@ typedef unsigned char *sk_buff_data_t;
  *	@next: Next buffer in list
  *	@prev: Previous buffer in list
  *	@tstamp: Time we arrived/left
+ *	@skb_mstamp_ns: (aka @tstamp) earliest departure time; start point
+ *		for retransmit timer
  *	@rbnode: RB tree node, alternative to next/prev for netem/tcp
+ *	@list: queue head
  *	@sk: Socket we are owned by
+ *	@ip_defrag_offset: (aka @sk) alternate use of @sk, used in
+ *		fragmentation management
  *	@dev: Device we arrived on/are leaving by
+ *	@dev_scratch: (aka @dev) alternate use of @dev when @dev would be %NULL
  *	@cb: Control buffer. Free for use by every layer. Put private vars here
  *	@_skb_refdst: destination entry (with norefcount bit)
  *	@sp: the security path, used for xfrm
@@ -632,6 +638,9 @@ typedef unsigned char *sk_buff_data_t;
  *	@pkt_type: Packet class
  *	@fclone: skbuff clone status
  *	@ipvs_property: skbuff is owned by ipvs
+ *	@inner_protocol_type: whether the inner protocol is
+ *		ENCAP_TYPE_ETHER or ENCAP_TYPE_IPPROTO
+ *	@remcsum_offload: remote checksum offload is enabled
  *	@offload_fwd_mark: Packet was L2-forwarded in hardware
  *	@offload_l3_fwd_mark: Packet was L3-forwarded in hardware
  *	@tc_skip_classify: do not classify packet. set by IFB device
@@ -650,6 +659,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_index: Traffic control index
  *	@hash: the packet hash
  *	@queue_mapping: Queue mapping for multiqueue devices
+ *	@head_frag: skb was allocated from page fragments,
+ *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
@@ -660,15 +671,28 @@ typedef unsigned char *sk_buff_data_t;
  *	@wifi_acked_valid: wifi_acked was set
  *	@wifi_acked: whether frame was acked on wifi or not
  *	@no_fcs:  Request NIC to treat last 4 bytes as Ethernet FCS
+ *	@encapsulation: indicates the inner headers in the skbuff are valid
+ *	@encap_hdr_csum: software checksum is needed
+ *	@csum_valid: checksum is already valid
  *	@csum_not_inet: use CRC32c to resolve CHECKSUM_PARTIAL
+ *	@csum_complete_sw: checksum was completed by software
+ *	@csum_level: indicates the number of consecutive checksums found in
+ *		the packet minus one that have been verified as
+ *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@napi_id: id of the NAPI struct this skb came from
+ *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
  *	@mark: Generic packet mark
+ *	@reserved_tailroom: (aka @mark) number of bytes of free space available
+ *		at the tail of an sk_buff
+ *	@vlan_present: VLAN tag is present
  *	@vlan_proto: vlan encapsulation protocol
  *	@vlan_tci: vlan tag control information
  *	@inner_protocol: Protocol (encapsulation)
+ *	@inner_ipproto: (aka @inner_protocol) stores ipproto when
+ *		skb->inner_protocol_type == ENCAP_TYPE_IPPROTO;
  *	@inner_transport_header: Inner transport layer header (encapsulation)
  *	@inner_network_header: Network layer header (encapsulation)
  *	@inner_mac_header: Link layer header (encapsulation)
@@ -750,7 +774,9 @@ struct sk_buff {
 #endif
 #define CLONED_OFFSET()		offsetof(struct sk_buff, __cloned_offset)
 
+	/* private: */
 	__u8			__cloned_offset[0];
+	/* public: */
 	__u8			cloned:1,
 				nohdr:1,
 				fclone:2,
@@ -775,7 +801,9 @@ struct sk_buff {
 #endif
 #define PKT_TYPE_OFFSET()	offsetof(struct sk_buff, __pkt_type_offset)
 
+	/* private: */
 	__u8			__pkt_type_offset[0];
+	/* public: */
 	__u8			pkt_type:3;
 	__u8			ignore_df:1;
 	__u8			nf_trace:1;
@@ -798,7 +826,9 @@ struct sk_buff {
 #define PKT_VLAN_PRESENT_BIT	0
 #endif
 #define PKT_VLAN_PRESENT_OFFSET()	offsetof(struct sk_buff, __pkt_vlan_present_offset)
+	/* private: */
 	__u8			__pkt_vlan_present_offset[0];
+	/* public: */
 	__u8			vlan_present:1;
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;


