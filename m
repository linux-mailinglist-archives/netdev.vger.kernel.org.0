Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6929E464560
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbhLAD0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:26:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:14529 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241422AbhLAD0X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 22:26:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236603690"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236603690"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 19:23:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="747234956"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 30 Nov 2021 19:23:00 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1msGCy-000E8b-CC; Wed, 01 Dec 2021 03:23:00 +0000
Date:   Wed, 1 Dec 2021 11:22:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 12/15] Bluetooth: hci_event: Use of a function table to
 handle HCI events
Message-ID: <202112011107.rTK0mEYG-lkp@intel.com>
References: <20211201000215.1134831-13-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201000215.1134831-13-luiz.dentz@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

I love your patch! Yet something to improve:

[auto build test ERROR on bluetooth-next/master]
[also build test ERROR on next-20211130]
[cannot apply to net-next/master net/master linus/master bluetooth/master v5.16-rc3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Luiz-Augusto-von-Dentz/Rework-parsing-of-HCI-events/20211201-080632
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: h8300-randconfig-r022-20211130 (https://download.01.org/0day-ci/archive/20211201/202112011107.rTK0mEYG-lkp@intel.com/config)
compiler: h8300-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/bd4b2eeacef50f9df8f08056e9f6523083ac96f3
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Luiz-Augusto-von-Dentz/Rework-parsing-of-HCI-events/20211201-080632
        git checkout bd4b2eeacef50f9df8f08056e9f6523083ac96f3
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=h8300 SHELL=/bin/bash net/bluetooth/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> net/bluetooth/hci_event.c:7129:31: error: initialization of 'void (*)(struct hci_dev *, void *, struct sk_buff *)' from incompatible pointer type 'void (*)(struct hci_dev *, struct sk_buff *)' [-Werror=incompatible-pointer-types]
    7129 |         HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
         |                               ^~~~~~~~~~~~~~~
   net/bluetooth/hci_event.c:6952:17: note: in definition of macro 'HCI_EV_VL'
    6952 |         .func = _func, \
         |                 ^~~~~
   net/bluetooth/hci_event.c:7129:9: note: in expansion of macro 'HCI_EV'
    7129 |         HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
         |         ^~~~~~
   net/bluetooth/hci_event.c:7129:31: note: (near initialization for 'hci_ev_table[255].<anonymous>.func')
    7129 |         HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
         |                               ^~~~~~~~~~~~~~~
   net/bluetooth/hci_event.c:6952:17: note: in definition of macro 'HCI_EV_VL'
    6952 |         .func = _func, \
         |                 ^~~~~
   net/bluetooth/hci_event.c:7129:9: note: in expansion of macro 'HCI_EV'
    7129 |         HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
         |         ^~~~~~
>> net/bluetooth/hci_event.c:7132:6: warning: no previous prototype for 'hci_event_func' [-Wmissing-prototypes]
    7132 | void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
         |      ^~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +7129 net/bluetooth/hci_event.c

  6970	
  6971	#define HCI_EV_REQ(_op, _func, _len) \
  6972		HCI_EV_REQ_VL(_op, _func, _len, _len)
  6973	
  6974	/* Entries in this table shall have their position according to the event opcode
  6975	 * they handle so the use of the macros above is recommend since it does attempt
  6976	 * to initialize at its proper index using Designated Initializers that way
  6977	 * events without a callback function don't have entered.
  6978	 */
  6979	static const struct hci_ev {
  6980		bool req;
  6981		union {
  6982			void (*func)(struct hci_dev *hdev, void *data,
  6983				     struct sk_buff *skb);
  6984			void (*func_req)(struct hci_dev *hdev, void *data,
  6985					 struct sk_buff *skb, u16 *opcode, u8 *status,
  6986					 hci_req_complete_t *req_complete,
  6987					 hci_req_complete_skb_t *req_complete_skb);
  6988		};
  6989		u16  min_len;
  6990		u16  max_len;
  6991	} hci_ev_table[U8_MAX + 1] = {
  6992		/* [0x01 = HCI_EV_INQUIRY_COMPLETE] */
  6993		HCI_EV_STATUS(HCI_EV_INQUIRY_COMPLETE, hci_inquiry_complete_evt),
  6994		/* [0x02 = HCI_EV_INQUIRY_RESULT] */
  6995		HCI_EV_VL(HCI_EV_INQUIRY_RESULT, hci_inquiry_result_evt,
  6996			  sizeof(struct hci_ev_inquiry_result), HCI_MAX_EVENT_SIZE),
  6997		/* [0x03 = HCI_EV_CONN_COMPLETE] */
  6998		HCI_EV(HCI_EV_CONN_COMPLETE, hci_conn_complete_evt,
  6999		       sizeof(struct hci_ev_conn_complete)),
  7000		/* [0x04 = HCI_EV_CONN_REQUEST] */
  7001		HCI_EV(HCI_EV_CONN_REQUEST, hci_conn_request_evt,
  7002		       sizeof(struct hci_ev_conn_request)),
  7003		/* [0x05 = HCI_EV_DISCONN_COMPLETE] */
  7004		HCI_EV(HCI_EV_DISCONN_COMPLETE, hci_disconn_complete_evt,
  7005		       sizeof(struct hci_ev_disconn_complete)),
  7006		/* [0x06 = HCI_EV_AUTH_COMPLETE] */
  7007		HCI_EV(HCI_EV_AUTH_COMPLETE, hci_auth_complete_evt,
  7008		       sizeof(struct hci_ev_auth_complete)),
  7009		/* [0x07 = HCI_EV_REMOTE_NAME] */
  7010		HCI_EV(HCI_EV_REMOTE_NAME, hci_remote_name_evt,
  7011		       sizeof(struct hci_ev_remote_name)),
  7012		/* [0x08 = HCI_EV_ENCRYPT_CHANGE] */
  7013		HCI_EV(HCI_EV_ENCRYPT_CHANGE, hci_encrypt_change_evt,
  7014		       sizeof(struct hci_ev_encrypt_change)),
  7015		/* [0x09 = HCI_EV_CHANGE_LINK_KEY_COMPLETE] */
  7016		HCI_EV(HCI_EV_CHANGE_LINK_KEY_COMPLETE,
  7017		       hci_change_link_key_complete_evt,
  7018		       sizeof(struct hci_ev_change_link_key_complete)),
  7019		/* [0x0b = HCI_EV_REMOTE_FEATURES] */
  7020		HCI_EV(HCI_EV_REMOTE_FEATURES, hci_remote_features_evt,
  7021		       sizeof(struct hci_ev_remote_features)),
  7022		/* [0x0e = HCI_EV_CMD_COMPLETE] */
  7023		HCI_EV_REQ_VL(HCI_EV_CMD_COMPLETE, hci_cmd_complete_evt,
  7024			      sizeof(struct hci_ev_cmd_complete), HCI_MAX_EVENT_SIZE),
  7025		/* [0x0f = HCI_EV_CMD_STATUS] */
  7026		HCI_EV_REQ(HCI_EV_CMD_STATUS, hci_cmd_status_evt,
  7027			   sizeof(struct hci_ev_cmd_status)),
  7028		/* [0x10 = HCI_EV_CMD_STATUS] */
  7029		HCI_EV(HCI_EV_HARDWARE_ERROR, hci_hardware_error_evt,
  7030		       sizeof(struct hci_ev_hardware_error)),
  7031		/* [0x12 = HCI_EV_ROLE_CHANGE] */
  7032		HCI_EV(HCI_EV_ROLE_CHANGE, hci_role_change_evt,
  7033		       sizeof(struct hci_ev_role_change)),
  7034		/* [0x13 = HCI_EV_NUM_COMP_PKTS] */
  7035		HCI_EV_VL(HCI_EV_NUM_COMP_PKTS, hci_num_comp_pkts_evt,
  7036			  sizeof(struct hci_ev_num_comp_pkts), HCI_MAX_EVENT_SIZE),
  7037		/* [0x14 = HCI_EV_MODE_CHANGE] */
  7038		HCI_EV(HCI_EV_MODE_CHANGE, hci_mode_change_evt,
  7039		       sizeof(struct hci_ev_mode_change)),
  7040		/* [0x16 = HCI_EV_PIN_CODE_REQ] */
  7041		HCI_EV(HCI_EV_PIN_CODE_REQ, hci_pin_code_request_evt,
  7042		       sizeof(struct hci_ev_pin_code_req)),
  7043		/* [0x17 = HCI_EV_LINK_KEY_REQ] */
  7044		HCI_EV(HCI_EV_LINK_KEY_REQ, hci_link_key_request_evt,
  7045		       sizeof(struct hci_ev_link_key_req)),
  7046		/* [0x18 = HCI_EV_LINK_KEY_NOTIFY] */
  7047		HCI_EV(HCI_EV_LINK_KEY_NOTIFY, hci_link_key_notify_evt,
  7048		       sizeof(struct hci_ev_link_key_notify)),
  7049		/* [0x1c = HCI_EV_CLOCK_OFFSET] */
  7050		HCI_EV(HCI_EV_CLOCK_OFFSET, hci_clock_offset_evt,
  7051		       sizeof(struct hci_ev_clock_offset)),
  7052		/* [0x1d = HCI_EV_PKT_TYPE_CHANGE] */
  7053		HCI_EV(HCI_EV_PKT_TYPE_CHANGE, hci_pkt_type_change_evt,
  7054		       sizeof(struct hci_ev_pkt_type_change)),
  7055		/* [0x20 = HCI_EV_PSCAN_REP_MODE] */
  7056		HCI_EV(HCI_EV_PSCAN_REP_MODE, hci_pscan_rep_mode_evt,
  7057		       sizeof(struct hci_ev_pscan_rep_mode)),
  7058		/* [0x22 = HCI_EV_INQUIRY_RESULT_WITH_RSSI] */
  7059		HCI_EV_VL(HCI_EV_INQUIRY_RESULT_WITH_RSSI,
  7060			  hci_inquiry_result_with_rssi_evt,
  7061			  sizeof(struct hci_ev_inquiry_result_rssi),
  7062			  HCI_MAX_EVENT_SIZE),
  7063		/* [0x23 = HCI_EV_REMOTE_EXT_FEATURES] */
  7064		HCI_EV(HCI_EV_REMOTE_EXT_FEATURES, hci_remote_ext_features_evt,
  7065		       sizeof(struct hci_ev_remote_ext_features)),
  7066		/* [0x2c = HCI_EV_SYNC_CONN_COMPLETE] */
  7067		HCI_EV(HCI_EV_SYNC_CONN_COMPLETE, hci_sync_conn_complete_evt,
  7068		       sizeof(struct hci_ev_sync_conn_complete)),
  7069		/* [0x2d = HCI_EV_EXTENDED_INQUIRY_RESULT] */
  7070		HCI_EV_VL(HCI_EV_EXTENDED_INQUIRY_RESULT,
  7071			  hci_extended_inquiry_result_evt,
  7072			  sizeof(struct hci_ev_ext_inquiry_result), HCI_MAX_EVENT_SIZE),
  7073		/* [0x30 = HCI_EV_KEY_REFRESH_COMPLETE] */
  7074		HCI_EV(HCI_EV_KEY_REFRESH_COMPLETE, hci_key_refresh_complete_evt,
  7075		       sizeof(struct hci_ev_key_refresh_complete)),
  7076		/* [0x31 = HCI_EV_IO_CAPA_REQUEST] */
  7077		HCI_EV(HCI_EV_IO_CAPA_REQUEST, hci_io_capa_request_evt,
  7078		       sizeof(struct hci_ev_io_capa_request)),
  7079		/* [0x32 = HCI_EV_IO_CAPA_REPLY] */
  7080		HCI_EV(HCI_EV_IO_CAPA_REPLY, hci_io_capa_reply_evt,
  7081		       sizeof(struct hci_ev_io_capa_reply)),
  7082		/* [0x33 = HCI_EV_USER_CONFIRM_REQUEST] */
  7083		HCI_EV(HCI_EV_USER_CONFIRM_REQUEST, hci_user_confirm_request_evt,
  7084		       sizeof(struct hci_ev_user_confirm_req)),
  7085		/* [0x34 = HCI_EV_USER_PASSKEY_REQUEST] */
  7086		HCI_EV(HCI_EV_USER_PASSKEY_REQUEST, hci_user_passkey_request_evt,
  7087		       sizeof(struct hci_ev_user_passkey_req)),
  7088		/* [0x35 = HCI_EV_REMOTE_OOB_DATA_REQUEST] */
  7089		HCI_EV(HCI_EV_REMOTE_OOB_DATA_REQUEST, hci_remote_oob_data_request_evt,
  7090		       sizeof(struct hci_ev_remote_oob_data_request)),
  7091		/* [0x36 = HCI_EV_SIMPLE_PAIR_COMPLETE] */
  7092		HCI_EV(HCI_EV_SIMPLE_PAIR_COMPLETE, hci_simple_pair_complete_evt,
  7093		       sizeof(struct hci_ev_simple_pair_complete)),
  7094		/* [0x3b = HCI_EV_USER_PASSKEY_NOTIFY] */
  7095		HCI_EV(HCI_EV_USER_PASSKEY_NOTIFY, hci_user_passkey_notify_evt,
  7096		       sizeof(struct hci_ev_user_passkey_notify)),
  7097		/* [0x3c = HCI_EV_KEYPRESS_NOTIFY] */
  7098		HCI_EV(HCI_EV_KEYPRESS_NOTIFY, hci_keypress_notify_evt,
  7099		       sizeof(struct hci_ev_keypress_notify)),
  7100		/* [0x3d = HCI_EV_REMOTE_HOST_FEATURES] */
  7101		HCI_EV(HCI_EV_REMOTE_HOST_FEATURES, hci_remote_host_features_evt,
  7102		       sizeof(struct hci_ev_remote_host_features)),
  7103		/* [0x3e = HCI_EV_LE_META] */
  7104		HCI_EV_VL(HCI_EV_LE_META, hci_le_meta_evt,
  7105			  sizeof(struct hci_ev_le_meta), HCI_MAX_EVENT_SIZE),
  7106	#if IS_ENABLED(CONFIG_BT_HS)
  7107		/* [0x40 = HCI_EV_PHY_LINK_COMPLETE] */
  7108		HCI_EV(HCI_EV_PHY_LINK_COMPLETE, hci_phy_link_complete_evt,
  7109		       sizeof(struct hci_ev_phy_link_complete)),
  7110		/* [0x41 = HCI_EV_CHANNEL_SELECTED] */
  7111		HCI_EV(HCI_EV_CHANNEL_SELECTED, hci_chan_selected_evt,
  7112		       sizeof(struct hci_ev_channel_selected)),
  7113		/* [0x42 = HCI_EV_DISCONN_PHY_LINK_COMPLETE] */
  7114		HCI_EV(HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE,
  7115		       hci_disconn_loglink_complete_evt,
  7116		       sizeof(struct hci_ev_disconn_logical_link_complete)),
  7117		/* [0x45 = HCI_EV_LOGICAL_LINK_COMPLETE] */
  7118		HCI_EV(HCI_EV_LOGICAL_LINK_COMPLETE, hci_loglink_complete_evt,
  7119		       sizeof(struct hci_ev_logical_link_complete)),
  7120		/* [0x46 = HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE] */
  7121		HCI_EV(HCI_EV_DISCONN_PHY_LINK_COMPLETE,
  7122		       hci_disconn_phylink_complete_evt,
  7123		       sizeof(struct hci_ev_disconn_phy_link_complete)),
  7124	#endif
  7125		/* [0x48 = HCI_EV_NUM_COMP_BLOCKS] */
  7126		HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
  7127		       sizeof(struct hci_ev_num_comp_blocks)),
  7128		/* [0xff = HCI_EV_VENDOR] */
> 7129		HCI_EV(HCI_EV_VENDOR, msft_vendor_evt, 0),
  7130	};
  7131	
> 7132	void hci_event_func(struct hci_dev *hdev, u8 event, struct sk_buff *skb,
  7133			    u16 *opcode, u8 *status, hci_req_complete_t *req_complete,
  7134			    hci_req_complete_skb_t *req_complete_skb)
  7135	{
  7136		const struct hci_ev *ev = &hci_ev_table[event];
  7137		void *data;
  7138	
  7139		if (!ev->func)
  7140			return;
  7141	
  7142		if (skb->len < ev->min_len) {
  7143			bt_dev_err(hdev, "unexpected event 0x%2.2x length: %u < %u",
  7144				   event, skb->len, ev->min_len);
  7145			return;
  7146		}
  7147	
  7148		/* Just warn if the length is over max_len size it still be
  7149		 * possible to partially parse the event so leave to callback to
  7150		 * decide if that is acceptable.
  7151		 */
  7152		if (skb->len > ev->max_len)
  7153			bt_dev_warn(hdev, "unexpected event 0x%2.2x length: %u > %u",
  7154				    event, skb->len, ev->max_len);
  7155	
  7156		data = hci_ev_skb_pull(hdev, skb, event, ev->min_len);
  7157		if (!data)
  7158			return;
  7159	
  7160		if (ev->req)
  7161			ev->func_req(hdev, data, skb, opcode, status, req_complete,
  7162				     req_complete_skb);
  7163		else
  7164			ev->func(hdev, data, skb);
  7165	}
  7166	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
