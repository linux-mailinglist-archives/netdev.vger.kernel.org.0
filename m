Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB4FE0D40
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbfJVUb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34148 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730635AbfJVUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:25 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so11368965pfa.1
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6iXM3mcokOU+d6rC2Ic62G8lrpcbfe7IU4UIQPP1tq0=;
        b=3Ovmk3TVYz6WIpqBLV7ckAo/u48cRSAJNMF3wJJBk0j9+8/aK1NDdfMJ9T5QzQWohu
         PgTnk/i0yTTemg1fFNQ1OoTBvNNi9ePauykgQ47jRuSogzBX6EvmgqvDVvI7oYo4QPQq
         j2giuTj3Dr1SO7PTkHwEeLiloC3aezwvMzbVGi6VnzdR8N8n3QL88KVG4kM+sX7d03Xl
         EQRgIauTFbNnc+DTZHN77d8tkpl9IB0el4/GPpGy5PHnqSQjRwJ7PpDk4e5+A6b5ALWe
         PWDU8vbHZg+vQpqD5w2zkEVAYP54NeRrKDFGWZpI6w+ko36DBjR7m/F45vuNIZ0eKKHC
         mrmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6iXM3mcokOU+d6rC2Ic62G8lrpcbfe7IU4UIQPP1tq0=;
        b=GCM3uRpkKFNOEHxeZIkZ1mv2auHrgQ9M6/1Rbs9QdjC3snzidXMBAQkpX+oKQXnVTp
         B3EM7fg3Y2EDQznM0V+J4cjRGNS2qmtrW/PFB4RskGsIYfrKvczF1x1DNpXVQryVyVuJ
         YoUM+TejTKUU4bKBiNhU4BOf+gCErmaWwRHkSHmV3Ay2HLhivxNlaKmkdtvz44kkzsfu
         1PqJ3l+0ZdC3Xdnx1ediQ8PLl6mNiDm9J0Px8Muu5M1GpLHeWbc6s96+p654nleK+8ec
         gqM9iUVvSVKyDB3uVXKRCsJJMfO9h02kR5SGysdzAFZIOXmLysbhd8w9N3VI+4Au1ERZ
         bkXQ==
X-Gm-Message-State: APjAAAX0hIKEWIlnYo+cWEo57vn8z0HDCdoX7LepvIiGce9/WOua7OyD
        hgdphKdNgRwJ5ScZou8CxV3IvhiXjg6QuA==
X-Google-Smtp-Source: APXvYqxjsuZc9rvyUVBw40fZfGslH4Xy3nd2zmoGsW2Si+QE0SwKbJvRQQAMxKPCJF+DnFsb9eJj7Q==
X-Received: by 2002:aa7:924f:: with SMTP id 15mr6503568pfp.194.1571776283727;
        Tue, 22 Oct 2019 13:31:23 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: fix up struct name comments
Date:   Tue, 22 Oct 2019 13:31:08 -0700
Message-Id: <20191022203113.30015-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022203113.30015-1-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up struct names in the ionic_if.h comments

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 196 +++++++++---------
 1 file changed, 98 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 5bfdda19f64d..dbdb7c5ae8f1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -111,7 +111,7 @@ struct ionic_admin_cmd {
 };
 
 /**
- * struct admin_comp - General admin command completion format
+ * struct ionic_admin_comp - General admin command completion format
  * @status:     The status of the command (enum status_code)
  * @comp_index: The index in the descriptor ring for which this
  *              is the completion.
@@ -134,7 +134,7 @@ static inline u8 color_match(u8 color, u8 done_color)
 }
 
 /**
- * struct nop_cmd - NOP command
+ * struct ionic_nop_cmd - NOP command
  * @opcode: opcode
  */
 struct ionic_nop_cmd {
@@ -143,7 +143,7 @@ struct ionic_nop_cmd {
 };
 
 /**
- * struct nop_comp - NOP command completion
+ * struct ionic_nop_comp - NOP command completion
  * @status: The status of the command (enum status_code)
  */
 struct ionic_nop_comp {
@@ -152,7 +152,7 @@ struct ionic_nop_comp {
 };
 
 /**
- * struct dev_init_cmd - Device init command
+ * struct ionic_dev_init_cmd - Device init command
  * @opcode:    opcode
  * @type:      device type
  */
@@ -172,7 +172,7 @@ struct ionic_dev_init_comp {
 };
 
 /**
- * struct dev_reset_cmd - Device reset command
+ * struct ionic_dev_reset_cmd - Device reset command
  * @opcode: opcode
  */
 struct ionic_dev_reset_cmd {
@@ -192,7 +192,7 @@ struct ionic_dev_reset_comp {
 #define IONIC_IDENTITY_VERSION_1	1
 
 /**
- * struct dev_identify_cmd - Driver/device identify command
+ * struct ionic_dev_identify_cmd - Driver/device identify command
  * @opcode:  opcode
  * @ver:     Highest version of identify supported by driver
  */
@@ -284,7 +284,7 @@ enum ionic_lif_type {
 };
 
 /**
- * struct lif_identify_cmd - lif identify command
+ * struct ionic_lif_identify_cmd - lif identify command
  * @opcode:  opcode
  * @type:    lif type (enum lif_type)
  * @ver:     version of identify returned by device
@@ -297,7 +297,7 @@ struct ionic_lif_identify_cmd {
 };
 
 /**
- * struct lif_identify_comp - lif identify command completion
+ * struct ionic_lif_identify_comp - lif identify command completion
  * @status:  status of the command (enum status_code)
  * @ver:     version of identify returned by device
  */
@@ -325,7 +325,7 @@ enum ionic_logical_qtype {
 };
 
 /**
- * struct lif_logical_qtype - Descriptor of logical to hardware queue type.
+ * struct ionic_lif_logical_qtype - Descriptor of logical to hardware queue type.
  * @qtype:          Hardware Queue Type.
  * @qid_count:      Number of Queue IDs of the logical type.
  * @qid_base:       Minimum Queue ID of the logical type.
@@ -349,7 +349,7 @@ enum ionic_lif_state {
  * @name:           lif name
  * @mtu:            mtu
  * @mac:            station mac address
- * @features:       features (enum eth_hw_features)
+ * @features:       features (enum ionic_eth_hw_features)
  * @queue_count:    queue counts per queue-type
  */
 union ionic_lif_config {
@@ -367,7 +367,7 @@ union ionic_lif_config {
 };
 
 /**
- * struct lif_identity - lif identity information (type-specific)
+ * struct ionic_lif_identity - lif identity information (type-specific)
  *
  * @capabilities    LIF capabilities
  *
@@ -441,11 +441,11 @@ union ionic_lif_identity {
 };
 
 /**
- * struct lif_init_cmd - LIF init command
+ * struct ionic_lif_init_cmd - LIF init command
  * @opcode:       opcode
  * @type:         LIF type (enum lif_type)
  * @index:        LIF index
- * @info_pa:      destination address for lif info (struct lif_info)
+ * @info_pa:      destination address for lif info (struct ionic_lif_info)
  */
 struct ionic_lif_init_cmd {
 	u8     opcode;
@@ -457,7 +457,7 @@ struct ionic_lif_init_cmd {
 };
 
 /**
- * struct lif_init_comp - LIF init command completion
+ * struct ionic_lif_init_comp - LIF init command completion
  * @status: The status of the command (enum status_code)
  */
 struct ionic_lif_init_comp {
@@ -468,7 +468,7 @@ struct ionic_lif_init_comp {
 };
 
 /**
- * struct q_init_cmd - Queue init command
+ * struct ionic_q_init_cmd - Queue init command
  * @opcode:       opcode
  * @type:         Logical queue type
  * @ver:          Queue version (defines opcode/descriptor scope)
@@ -525,7 +525,7 @@ struct ionic_q_init_cmd {
 };
 
 /**
- * struct q_init_comp - Queue init command completion
+ * struct ionic_q_init_comp - Queue init command completion
  * @status:     The status of the command (enum status_code)
  * @ver:        Queue version (defines opcode/descriptor scope)
  * @comp_index: The index in the descriptor ring for which this
@@ -556,7 +556,7 @@ enum ionic_txq_desc_opcode {
 };
 
 /**
- * struct txq_desc - Ethernet Tx queue descriptor format
+ * struct ionic_txq_desc - Ethernet Tx queue descriptor format
  * @opcode:       Tx operation, see TXQ_DESC_OPCODE_*:
  *
  *                   IONIC_TXQ_DESC_OPCODE_CSUM_NONE:
@@ -735,7 +735,7 @@ static inline void decode_txq_desc_cmd(u64 cmd, u8 *opcode, u8 *flags,
 #define IONIC_RX_MAX_SG_ELEMS	8
 
 /**
- * struct txq_sg_desc - Transmit scatter-gather (SG) list
+ * struct ionic_txq_sg_desc - Transmit scatter-gather (SG) list
  * @addr:      DMA address of SG element data buffer
  * @len:       Length of SG element data buffer, in bytes
  */
@@ -748,7 +748,7 @@ struct ionic_txq_sg_desc {
 };
 
 /**
- * struct txq_comp - Ethernet transmit queue completion descriptor
+ * struct ionic_txq_comp - Ethernet transmit queue completion descriptor
  * @status:     The status of the command (enum status_code)
  * @comp_index: The index in the descriptor ring for which this
  *                 is the completion.
@@ -768,7 +768,7 @@ enum ionic_rxq_desc_opcode {
 };
 
 /**
- * struct rxq_desc - Ethernet Rx queue descriptor format
+ * struct ionic_rxq_desc - Ethernet Rx queue descriptor format
  * @opcode:       Rx operation, see RXQ_DESC_OPCODE_*:
  *
  *                   RXQ_DESC_OPCODE_SIMPLE:
@@ -789,7 +789,7 @@ struct ionic_rxq_desc {
 };
 
 /**
- * struct rxq_sg_desc - Receive scatter-gather (SG) list
+ * struct ionic_rxq_sg_desc - Receive scatter-gather (SG) list
  * @addr:      DMA address of SG element data buffer
  * @len:       Length of SG element data buffer, in bytes
  */
@@ -802,7 +802,7 @@ struct ionic_rxq_sg_desc {
 };
 
 /**
- * struct rxq_comp - Ethernet receive queue completion descriptor
+ * struct ionic_rxq_comp - Ethernet receive queue completion descriptor
  * @status:       The status of the command (enum status_code)
  * @num_sg_elems: Number of SG elements used by this descriptor
  * @comp_index:   The index in the descriptor ring for which this
@@ -896,7 +896,7 @@ enum ionic_eth_hw_features {
 };
 
 /**
- * struct q_control_cmd - Queue control command
+ * struct ionic_q_control_cmd - Queue control command
  * @opcode:     opcode
  * @type:       Queue type
  * @lif_index:  LIF index
@@ -1033,8 +1033,8 @@ enum ionic_port_loopback_mode {
 
 /**
  * Transceiver Status information
- * @state:    Transceiver status (enum xcvr_state)
- * @phy:      Physical connection type (enum phy_type)
+ * @state:    Transceiver status (enum ionic_xcvr_state)
+ * @phy:      Physical connection type (enum ionic_phy_type)
  * @pid:      Transceiver link mode (enum pid)
  * @sprom:    Transceiver sprom contents
  */
@@ -1051,9 +1051,9 @@ struct ionic_xcvr_status {
  * @mtu:                mtu
  * @state:              port admin state (enum port_admin_state)
  * @an_enable:          autoneg enable
- * @fec_type:           fec type (enum port_fec_type)
- * @pause_type:         pause type (enum port_pause_type)
- * @loopback_mode:      loopback mode (enum port_loopback_mode)
+ * @fec_type:           fec type (enum ionic_port_fec_type)
+ * @pause_type:         pause type (enum ionic_port_pause_type)
+ * @loopback_mode:      loopback mode (enum ionic_port_loopback_mode)
  */
 union ionic_port_config {
 	struct {
@@ -1080,7 +1080,7 @@ union ionic_port_config {
 
 /**
  * Port Status information
- * @status:             link status (enum port_oper_status)
+ * @status:             link status (enum ionic_port_oper_status)
  * @id:                 port id
  * @speed:              link speed (in Mbps)
  * @xcvr:               tranceiver status
@@ -1094,7 +1094,7 @@ struct ionic_port_status {
 };
 
 /**
- * struct port_identify_cmd - Port identify command
+ * struct ionic_port_identify_cmd - Port identify command
  * @opcode:     opcode
  * @index:      port index
  * @ver:        Highest version of identify supported by driver
@@ -1107,7 +1107,7 @@ struct ionic_port_identify_cmd {
 };
 
 /**
- * struct port_identify_comp - Port identify command completion
+ * struct ionic_port_identify_comp - Port identify command completion
  * @status: The status of the command (enum status_code)
  * @ver:    Version of identify returned by device
  */
@@ -1118,10 +1118,10 @@ struct ionic_port_identify_comp {
 };
 
 /**
- * struct port_init_cmd - Port initialization command
+ * struct ionic_port_init_cmd - Port initialization command
  * @opcode:     opcode
  * @index:      port index
- * @info_pa:    destination address for port info (struct port_info)
+ * @info_pa:    destination address for port info (struct ionic_port_info)
  */
 struct ionic_port_init_cmd {
 	u8     opcode;
@@ -1132,7 +1132,7 @@ struct ionic_port_init_cmd {
 };
 
 /**
- * struct port_init_comp - Port initialization command completion
+ * struct ionic_port_init_comp - Port initialization command completion
  * @status: The status of the command (enum status_code)
  */
 struct ionic_port_init_comp {
@@ -1141,7 +1141,7 @@ struct ionic_port_init_comp {
 };
 
 /**
- * struct port_reset_cmd - Port reset command
+ * struct ionic_port_reset_cmd - Port reset command
  * @opcode:     opcode
  * @index:      port index
  */
@@ -1152,7 +1152,7 @@ struct ionic_port_reset_cmd {
 };
 
 /**
- * struct port_reset_comp - Port reset command completion
+ * struct ionic_port_reset_comp - Port reset command completion
  * @status: The status of the command (enum status_code)
  */
 struct ionic_port_reset_comp {
@@ -1183,7 +1183,7 @@ enum ionic_port_attr {
 };
 
 /**
- * struct port_setattr_cmd - Set port attributes on the NIC
+ * struct ionic_port_setattr_cmd - Set port attributes on the NIC
  * @opcode:     Opcode
  * @index:      port index
  * @attr:       Attribute type (enum ionic_port_attr)
@@ -1207,7 +1207,7 @@ struct ionic_port_setattr_cmd {
 };
 
 /**
- * struct port_setattr_comp - Port set attr command completion
+ * struct ionic_port_setattr_comp - Port set attr command completion
  * @status:     The status of the command (enum status_code)
  * @color:      Color bit
  */
@@ -1218,7 +1218,7 @@ struct ionic_port_setattr_comp {
 };
 
 /**
- * struct port_getattr_cmd - Get port attributes from the NIC
+ * struct ionic_port_getattr_cmd - Get port attributes from the NIC
  * @opcode:     Opcode
  * @index:      port index
  * @attr:       Attribute type (enum ionic_port_attr)
@@ -1231,7 +1231,7 @@ struct ionic_port_getattr_cmd {
 };
 
 /**
- * struct port_getattr_comp - Port get attr command completion
+ * struct ionic_port_getattr_comp - Port get attr command completion
  * @status:     The status of the command (enum status_code)
  * @color:      Color bit
  */
@@ -1252,10 +1252,10 @@ struct ionic_port_getattr_comp {
 };
 
 /**
- * struct lif_status - Lif status register
+ * struct ionic_lif_status - Lif status register
  * @eid:             most recent NotifyQ event id
  * @port_num:        port the lif is connected to
- * @link_status:     port status (enum port_oper_status)
+ * @link_status:     port status (enum ionic_port_oper_status)
  * @link_speed:      speed of link in Mbps
  * @link_down_count: number of times link status changes
  */
@@ -1270,7 +1270,7 @@ struct ionic_lif_status {
 };
 
 /**
- * struct lif_reset_cmd - LIF reset command
+ * struct ionic_lif_reset_cmd - LIF reset command
  * @opcode:    opcode
  * @index:     LIF index
  */
@@ -1290,7 +1290,7 @@ enum ionic_dev_state {
 };
 
 /**
- * enum dev_attr - List of device attributes
+ * enum ionic_dev_attr - List of device attributes
  */
 enum ionic_dev_attr {
 	IONIC_DEV_ATTR_STATE    = 0,
@@ -1299,10 +1299,10 @@ enum ionic_dev_attr {
 };
 
 /**
- * struct dev_setattr_cmd - Set Device attributes on the NIC
+ * struct ionic_dev_setattr_cmd - Set Device attributes on the NIC
  * @opcode:     Opcode
- * @attr:       Attribute type (enum dev_attr)
- * @state:      Device state (enum dev_state)
+ * @attr:       Attribute type (enum ionic_dev_attr)
+ * @state:      Device state (enum ionic_dev_state)
  * @name:       The bus info, e.g. PCI slot-device-function, 0 terminated
  * @features:   Device features
  */
@@ -1319,7 +1319,7 @@ struct ionic_dev_setattr_cmd {
 };
 
 /**
- * struct dev_setattr_comp - Device set attr command completion
+ * struct ionic_dev_setattr_comp - Device set attr command completion
  * @status:     The status of the command (enum status_code)
  * @features:   Device features
  * @color:      Color bit
@@ -1335,9 +1335,9 @@ struct ionic_dev_setattr_comp {
 };
 
 /**
- * struct dev_getattr_cmd - Get Device attributes from the NIC
+ * struct ionic_dev_getattr_cmd - Get Device attributes from the NIC
  * @opcode:     opcode
- * @attr:       Attribute type (enum dev_attr)
+ * @attr:       Attribute type (enum ionic_dev_attr)
  */
 struct ionic_dev_getattr_cmd {
 	u8     opcode;
@@ -1346,7 +1346,7 @@ struct ionic_dev_getattr_cmd {
 };
 
 /**
- * struct dev_setattr_comp - Device set attr command completion
+ * struct ionic_dev_setattr_comp - Device set attr command completion
  * @status:     The status of the command (enum status_code)
  * @features:   Device features
  * @color:      Color bit
@@ -1376,7 +1376,7 @@ enum ionic_rss_hash_types {
 };
 
 /**
- * enum lif_attr - List of LIF attributes
+ * enum ionic_lif_attr - List of LIF attributes
  */
 enum ionic_lif_attr {
 	IONIC_LIF_ATTR_STATE        = 0,
@@ -1389,15 +1389,15 @@ enum ionic_lif_attr {
 };
 
 /**
- * struct lif_setattr_cmd - Set LIF attributes on the NIC
+ * struct ionic_lif_setattr_cmd - Set LIF attributes on the NIC
  * @opcode:     Opcode
- * @type:       Attribute type (enum lif_attr)
+ * @type:       Attribute type (enum ionic_lif_attr)
  * @index:      LIF index
  * @state:      lif state (enum lif_state)
  * @name:       The netdev name string, 0 terminated
  * @mtu:        Mtu
  * @mac:        Station mac
- * @features:   Features (enum eth_hw_features)
+ * @features:   Features (enum ionic_eth_hw_features)
  * @rss:        RSS properties
  *              @types:     The hash types to enable (see rss_hash_types).
  *              @key:       The hash secret key.
@@ -1426,11 +1426,11 @@ struct ionic_lif_setattr_cmd {
 };
 
 /**
- * struct lif_setattr_comp - LIF set attr command completion
+ * struct ionic_lif_setattr_comp - LIF set attr command completion
  * @status:     The status of the command (enum status_code)
  * @comp_index: The index in the descriptor ring for which this
  *              is the completion.
- * @features:   features (enum eth_hw_features)
+ * @features:   features (enum ionic_eth_hw_features)
  * @color:      Color bit
  */
 struct ionic_lif_setattr_comp {
@@ -1445,9 +1445,9 @@ struct ionic_lif_setattr_comp {
 };
 
 /**
- * struct lif_getattr_cmd - Get LIF attributes from the NIC
+ * struct ionic_lif_getattr_cmd - Get LIF attributes from the NIC
  * @opcode:     Opcode
- * @attr:       Attribute type (enum lif_attr)
+ * @attr:       Attribute type (enum ionic_lif_attr)
  * @index:      LIF index
  */
 struct ionic_lif_getattr_cmd {
@@ -1458,7 +1458,7 @@ struct ionic_lif_getattr_cmd {
 };
 
 /**
- * struct lif_getattr_comp - LIF get attr command completion
+ * struct ionic_lif_getattr_comp - LIF get attr command completion
  * @status:     The status of the command (enum status_code)
  * @comp_index: The index in the descriptor ring for which this
  *              is the completion.
@@ -1466,7 +1466,7 @@ struct ionic_lif_getattr_cmd {
  * @name:       The netdev name string, 0 terminated
  * @mtu:        Mtu
  * @mac:        Station mac
- * @features:   Features (enum eth_hw_features)
+ * @features:   Features (enum ionic_eth_hw_features)
  * @color:      Color bit
  */
 struct ionic_lif_getattr_comp {
@@ -1492,7 +1492,7 @@ enum ionic_rx_mode {
 };
 
 /**
- * struct rx_mode_set_cmd - Set LIF's Rx mode command
+ * struct ionic_rx_mode_set_cmd - Set LIF's Rx mode command
  * @opcode:     opcode
  * @lif_index:  LIF index
  * @rx_mode:    Rx mode flags:
@@ -1519,7 +1519,7 @@ enum ionic_rx_filter_match_type {
 };
 
 /**
- * struct rx_filter_add_cmd - Add LIF Rx filter command
+ * struct ionic_rx_filter_add_cmd - Add LIF Rx filter command
  * @opcode:     opcode
  * @qtype:      Queue type
  * @lif_index:  LIF index
@@ -1550,7 +1550,7 @@ struct ionic_rx_filter_add_cmd {
 };
 
 /**
- * struct rx_filter_add_comp - Add LIF Rx filter command completion
+ * struct ionic_rx_filter_add_comp - Add LIF Rx filter command completion
  * @status:     The status of the command (enum status_code)
  * @comp_index: The index in the descriptor ring for which this
  *              is the completion.
@@ -1567,7 +1567,7 @@ struct ionic_rx_filter_add_comp {
 };
 
 /**
- * struct rx_filter_del_cmd - Delete LIF Rx filter command
+ * struct ionic_rx_filter_del_cmd - Delete LIF Rx filter command
  * @opcode:     opcode
  * @lif_index:  LIF index
  * @filter_id:  Filter ID
@@ -1583,7 +1583,7 @@ struct ionic_rx_filter_del_cmd {
 typedef struct ionic_admin_comp ionic_rx_filter_del_comp;
 
 /**
- * struct qos_identify_cmd - QoS identify command
+ * struct ionic_qos_identify_cmd - QoS identify command
  * @opcode:    opcode
  * @ver:     Highest version of identify supported by driver
  *
@@ -1595,7 +1595,7 @@ struct ionic_qos_identify_cmd {
 };
 
 /**
- * struct qos_identify_comp - QoS identify command completion
+ * struct ionic_qos_identify_comp - QoS identify command completion
  * @status: The status of the command (enum status_code)
  * @ver:    Version of identify returned by device
  */
@@ -1610,7 +1610,7 @@ struct ionic_qos_identify_comp {
 #define IONIC_QOS_DSCP_MAX_VALUES	64
 
 /**
- * enum qos_class
+ * enum ionic_qos_class
  */
 enum ionic_qos_class {
 	IONIC_QOS_CLASS_DEFAULT		= 0,
@@ -1623,7 +1623,7 @@ enum ionic_qos_class {
 };
 
 /**
- * enum qos_class_type - Traffic classification criteria
+ * enum ionic_qos_class_type - Traffic classification criteria
  */
 enum ionic_qos_class_type {
 	IONIC_QOS_CLASS_TYPE_NONE	= 0,
@@ -1632,7 +1632,7 @@ enum ionic_qos_class_type {
 };
 
 /**
- * enum qos_sched_type - Qos class scheduling type
+ * enum ionic_qos_sched_type - Qos class scheduling type
  */
 enum ionic_qos_sched_type {
 	IONIC_QOS_SCHED_TYPE_STRICT	= 0,	/* Strict priority */
@@ -1640,15 +1640,15 @@ enum ionic_qos_sched_type {
 };
 
 /**
- * union qos_config - Qos configuration structure
+ * union ionic_qos_config - Qos configuration structure
  * @flags:		Configuration flags
  *	IONIC_QOS_CONFIG_F_ENABLE		enable
  *	IONIC_QOS_CONFIG_F_DROP			drop/nodrop
  *	IONIC_QOS_CONFIG_F_RW_DOT1Q_PCP		enable dot1q pcp rewrite
  *	IONIC_QOS_CONFIG_F_RW_IP_DSCP		enable ip dscp rewrite
- * @sched_type:		Qos class scheduling type (enum qos_sched_type)
- * @class_type:		Qos class type (enum qos_class_type)
- * @pause_type:		Qos pause type (enum qos_pause_type)
+ * @sched_type:		Qos class scheduling type (enum ionic_qos_sched_type)
+ * @class_type:		Qos class type (enum ionic_qos_class_type)
+ * @pause_type:		Qos pause type (enum ionic_qos_pause_type)
  * @name:		Qos class name
  * @mtu:		MTU of the class
  * @pfc_dot1q_pcp:	Pcp value for pause frames (valid iff F_NODROP)
@@ -1697,7 +1697,7 @@ union ionic_qos_config {
 };
 
 /**
- * union qos_identity - QoS identity structure
+ * union ionic_qos_identity - QoS identity structure
  * @version:	Version of the identify structure
  * @type:	QoS system type
  * @nclasses:	Number of usable QoS classes
@@ -1730,7 +1730,7 @@ struct ionic_qos_init_cmd {
 typedef struct ionic_admin_comp ionic_qos_init_comp;
 
 /**
- * struct qos_reset_cmd - Qos config reset command
+ * struct ionic_qos_reset_cmd - Qos config reset command
  * @opcode:	Opcode
  */
 struct ionic_qos_reset_cmd {
@@ -1742,7 +1742,7 @@ struct ionic_qos_reset_cmd {
 typedef struct ionic_admin_comp ionic_qos_reset_comp;
 
 /**
- * struct fw_download_cmd - Firmware download command
+ * struct ionic_fw_download_cmd - Firmware download command
  * @opcode:	opcode
  * @addr:	dma address of the firmware buffer
  * @offset:	offset of the firmware buffer within the full image
@@ -1765,9 +1765,9 @@ enum ionic_fw_control_oper {
 };
 
 /**
- * struct fw_control_cmd - Firmware control command
+ * struct ionic_fw_control_cmd - Firmware control command
  * @opcode:    opcode
- * @oper:      firmware control operation (enum fw_control_oper)
+ * @oper:      firmware control operation (enum ionic_fw_control_oper)
  * @slot:      slot to activate
  */
 struct ionic_fw_control_cmd {
@@ -1779,7 +1779,7 @@ struct ionic_fw_control_cmd {
 };
 
 /**
- * struct fw_control_comp - Firmware control copletion
+ * struct ionic_fw_control_comp - Firmware control copletion
  * @opcode:    opcode
  * @slot:      slot where the firmware was installed
  */
@@ -1797,13 +1797,13 @@ struct ionic_fw_control_comp {
  ******************************************************************/
 
 /**
- * struct rdma_reset_cmd - Reset RDMA LIF cmd
+ * struct ionic_rdma_reset_cmd - Reset RDMA LIF cmd
  * @opcode:        opcode
  * @lif_index:     lif index
  *
  * There is no rdma specific dev command completion struct.  Completion uses
- * the common struct admin_comp.  Only the status is indicated.  Nonzero status
- * means the LIF does not support rdma.
+ * the common struct ionic_admin_comp.  Only the status is indicated.
+ * Nonzero status means the LIF does not support rdma.
  **/
 struct ionic_rdma_reset_cmd {
 	u8     opcode;
@@ -1813,7 +1813,7 @@ struct ionic_rdma_reset_cmd {
 };
 
 /**
- * struct rdma_queue_cmd - Create RDMA Queue command
+ * struct ionic_rdma_queue_cmd - Create RDMA Queue command
  * @opcode:        opcode, 52, 53
  * @lif_index      lif index
  * @qid_ver:       (qid | (rdma version << 24))
@@ -1839,7 +1839,7 @@ struct ionic_rdma_reset_cmd {
  * memory registration.
  *
  * There is no rdma specific dev command completion struct.  Completion uses
- * the common struct admin_comp.  Only the status is indicated.
+ * the common struct ionic_admin_comp.  Only the status is indicated.
  **/
 struct ionic_rdma_queue_cmd {
 	u8     opcode;
@@ -1860,7 +1860,7 @@ struct ionic_rdma_queue_cmd {
  ******************************************************************/
 
 /**
- * struct notifyq_event
+ * struct ionic_notifyq_event
  * @eid:   event number
  * @ecode: event code
  * @data:  unspecified data about the event
@@ -1875,7 +1875,7 @@ struct ionic_notifyq_event {
 };
 
 /**
- * struct link_change_event
+ * struct ionic_link_change_event
  * @eid:		event number
  * @ecode:		event code = EVENT_OPCODE_LINK_CHANGE
  * @link_status:	link up or down, with error bits (enum port_status)
@@ -1892,7 +1892,7 @@ struct ionic_link_change_event {
 };
 
 /**
- * struct reset_event
+ * struct ionic_reset_event
  * @eid:		event number
  * @ecode:		event code = EVENT_OPCODE_RESET
  * @reset_code:		reset type
@@ -1910,7 +1910,7 @@ struct ionic_reset_event {
 };
 
 /**
- * struct heartbeat_event
+ * struct ionic_heartbeat_event
  * @eid:	event number
  * @ecode:	event code = EVENT_OPCODE_HEARTBEAT
  *
@@ -1923,7 +1923,7 @@ struct ionic_heartbeat_event {
 };
 
 /**
- * struct log_event
+ * struct ionic_log_event
  * @eid:	event number
  * @ecode:	event code = EVENT_OPCODE_LOG
  * @data:	log data
@@ -1937,7 +1937,7 @@ struct ionic_log_event {
 };
 
 /**
- * struct port_stats
+ * struct ionic_port_stats
  */
 struct ionic_port_stats {
 	__le64 frames_rx_ok;
@@ -2067,7 +2067,7 @@ struct ionic_mgmt_port_stats {
 };
 
 /**
- * struct port_identity - port identity structure
+ * struct ionic_port_identity - port identity structure
  * @version:        identity structure version
  * @type:           type of port (enum port_type)
  * @num_lanes:      number of lanes for the port
@@ -2099,7 +2099,7 @@ union ionic_port_identity {
 };
 
 /**
- * struct port_info - port info structure
+ * struct ionic_port_info - port info structure
  * @port_status:     port status
  * @port_stats:      port stats
  */
@@ -2110,7 +2110,7 @@ struct ionic_port_info {
 };
 
 /**
- * struct lif_stats
+ * struct ionic_lif_stats
  */
 struct ionic_lif_stats {
 	/* RX */
@@ -2264,7 +2264,7 @@ struct ionic_lif_stats {
 };
 
 /**
- * struct lif_info - lif info structure
+ * struct ionic_lif_info - lif info structure
  */
 struct ionic_lif_info {
 	union ionic_lif_config config;
@@ -2357,7 +2357,7 @@ union ionic_dev_info_regs {
 };
 
 /**
- * union dev_cmd_regs - Device command register format (read-write)
+ * union ionic_dev_cmd_regs - Device command register format (read-write)
  * @doorbell:        Device Cmd Doorbell, write-only.
  *                   Write a 1 to signal device to process cmd,
  *                   poll done for completion.
@@ -2379,7 +2379,7 @@ union ionic_dev_cmd_regs {
 };
 
 /**
- * union dev_regs - Device register format in for bar 0 page 0
+ * union ionic_dev_regs - Device register format in for bar 0 page 0
  * @info:            Device info registers
  * @devcmd:          Device command registers
  */
@@ -2433,7 +2433,7 @@ union ionic_adminq_comp {
 #define IONIC_ASIC_TYPE_CAPRI			0
 
 /**
- * struct doorbell - Doorbell register layout
+ * struct ionic_doorbell - Doorbell register layout
  * @p_index: Producer index
  * @ring:    Selects the specific ring of the queue to update.
  *           Type-specific meaning:
-- 
2.17.1

