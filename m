Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F391767A70E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 00:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjAXXoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 18:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAXXoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 18:44:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0430E1F4A0;
        Tue, 24 Jan 2023 15:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674603818; x=1706139818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2d4DLn4Wkq1yGxf176F911BtmoZDFFVhJcdoBSnLFkk=;
  b=h9t0hpFm8iUE6KVqgLIJBB5rjI2GSwbPOQ3btbm0x8WiLlz9ERLkIM1E
   7A/XMgRbvvFYTDrjVo0gl+FT7HELcrdJ/h2EvQnjDzoUNB42P85pbeUdo
   TgO+lK+iCCMFqKTAgUZ9o0ZIRg3eM28A9Z5ot0ShRtAJ/7WBFgoW9yLFM
   N0lCRcTHMYynm+7vz07N2Ms2AYv5gylLjcc3SWWNECYRuOT0Vu2/LAAl1
   1r+cZKI1ug4bTbUuiOPzIh8wskunyCcoA+YerfefDNWSltUMVLW2/CLUI
   wyCY6UK5CjPZ8w0YoLVyHNuyZLPxMIC2hUfRPPw0lkQC3ZjXP+cMZyBkp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="327695410"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="327695410"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 15:43:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="612219969"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="612219969"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 24 Jan 2023 15:43:27 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pKSwo-0006sW-0K;
        Tue, 24 Jan 2023 23:43:26 +0000
Date:   Wed, 25 Jan 2023 07:42:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com,
        neeraj.sanjaykale@nxp.com
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Message-ID: <202301250708.mfePhaPV-lkp@intel.com>
References: <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neeraj,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bluetooth-next/master]
[also build test WARNING on bluetooth/master tty/tty-testing tty/tty-next tty/tty-linus linus/master v6.2-rc5 next-20230124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Sanjay-Kale/serdev-Add-method-to-assert-break/20230125-015108
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
patch link:    https://lore.kernel.org/r/20230124174714.2775680-4-neeraj.sanjaykale%40nxp.com
patch subject: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230125/202301250708.mfePhaPV-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e5f775c45ec84de38a4cadfb115c488cb44e5943
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Neeraj-Sanjay-Kale/serdev-Add-method-to-assert-break/20230125-015108
        git checkout e5f775c45ec84de38a4cadfb115c488cb44e5943
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/bluetooth/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/bluetooth/btnxp.c:31:
   drivers/bluetooth/btnxp.c: In function 'nxp_recv_fw_req_v1':
>> drivers/bluetooth/btnxp.c:707:33: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
     707 |                         BT_INFO("FW_Downloaded Successfully: %ld bytes", nxpdev->fw->size);
         |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~
         |                                                                                    |
         |                                                                                    size_t {aka unsigned int}
   include/net/bluetooth/bluetooth.h:242:41: note: in definition of macro 'BT_INFO'
     242 | #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
         |                                         ^~~
   drivers/bluetooth/btnxp.c:707:64: note: format string is defined here
     707 |                         BT_INFO("FW_Downloaded Successfully: %ld bytes", nxpdev->fw->size);
         |                                                              ~~^
         |                                                                |
         |                                                                long int
         |                                                              %d
   drivers/bluetooth/btnxp.c: In function 'nxp_recv_fw_req_v3':
   drivers/bluetooth/btnxp.c:826:25: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
     826 |                 BT_INFO("FW_Downloaded Successfully: %ld bytes", nxpdev->fw->size);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~
         |                                                                            |
         |                                                                            size_t {aka unsigned int}
   include/net/bluetooth/bluetooth.h:242:41: note: in definition of macro 'BT_INFO'
     242 | #define BT_INFO(fmt, ...)       bt_info(fmt "\n", ##__VA_ARGS__)
         |                                         ^~~
   drivers/bluetooth/btnxp.c:826:56: note: format string is defined here
     826 |                 BT_INFO("FW_Downloaded Successfully: %ld bytes", nxpdev->fw->size);
         |                                                      ~~^
         |                                                        |
         |                                                        long int
         |                                                      %d


vim +707 drivers/bluetooth/btnxp.c

   647	
   648	/* for legacy chipsets with V1 bootloader */
   649	static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
   650	{
   651		struct V1_DATA_REQ *req = skb_pull_data(skb, sizeof(struct V1_DATA_REQ));
   652		struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
   653		const struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
   654		static bool timeout_changed;
   655		static bool baudrate_changed;
   656		u32 requested_len;
   657		static u32 expected_len = HDR_LEN;
   658		int err;
   659	
   660		if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
   661			return 0;
   662	
   663		if (strlen(nxpdev->fw_name) == 0) {
   664			err = nxp_load_fw_params_for_chip_id(0xffff, hdev);
   665			if (err < 0)
   666				return err;
   667			timeout_changed = false;
   668			baudrate_changed = false;
   669			/* If secondary baudrate is not read from
   670			 * the conf file set default value from nxp_data
   671			 */
   672			if (nxpdev->fw_dnld_sec_baudrate == 0)
   673				nxpdev->fw_dnld_sec_baudrate = nxp_data->fw_dnld_sec_baudrate;
   674		}
   675	
   676		if (nxpdev->fw_dnld_sec_baudrate != nxpdev->current_baudrate) {
   677			if (!timeout_changed) {
   678				nxp_send_ack(NXP_ACK_V1, hdev);
   679				timeout_changed = nxp_fw_change_timeout(hdev, req->len);
   680				return 0;
   681			}
   682			if (!baudrate_changed) {
   683				nxp_send_ack(NXP_ACK_V1, hdev);
   684				baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
   685				if (baudrate_changed) {
   686					serdev_device_set_baudrate(nxpdev->serdev,
   687									nxpdev->fw_dnld_sec_baudrate);
   688					nxpdev->current_baudrate = nxpdev->fw_dnld_sec_baudrate;
   689				}
   690				return 0;
   691			}
   692		}
   693	
   694		if (!nxpdev->fw) {
   695			BT_INFO("Request Firmware: %s", nxpdev->fw_name);
   696			err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
   697			if (err < 0) {
   698				BT_ERR("Firmware file %s not found", nxpdev->fw_name);
   699				clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
   700				return err;
   701			}
   702		}
   703	
   704		if (req && (req->len ^ req->len_comp) == 0xffff) {
   705			nxp_send_ack(NXP_ACK_V1, hdev);
   706			if (req->len == 0) {
 > 707				BT_INFO("FW_Downloaded Successfully: %ld bytes", nxpdev->fw->size);
   708				clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
   709				wake_up_interruptible(&nxpdev->suspend_wait_q);
   710				return 0;
   711			}
   712			if (req->len & 0x01) {
   713				/* The CRC did not match at the other end.
   714				 * That's why the request to re-send.
   715				 * Simply send the same bytes again.
   716				 */
   717				requested_len = nxpdev->fw_sent_bytes;
   718				BT_ERR("CRC error. Resend %d bytes of FW.", requested_len);
   719			} else {
   720				/* Increment offset by number of previous successfully sent bytes */
   721				nxpdev->fw_dnld_offset += nxpdev->fw_sent_bytes;
   722				requested_len = req->len;
   723			}
   724	
   725			/* The FW bin file is made up of many blocks of
   726			 * 16 byte header and payload data chunks. If the
   727			 * FW has requested a header, read the payload length
   728			 * info from the header, and then send the header.
   729			 * In the next iteration, the FW should request the
   730			 * payload data chunk, which should be equal to the
   731			 * payload length read from header. If there is a
   732			 * mismatch, clearly the driver and FW are out of sync,
   733			 * and we need to re-send the previous header again.
   734			 */
   735			if (requested_len == expected_len) {
   736				if (requested_len == HDR_LEN)
   737					expected_len = nxp_get_data_len(nxpdev->fw->data +
   738										nxpdev->fw_dnld_offset);
   739				else
   740					expected_len = HDR_LEN;
   741			} else {
   742				if (requested_len == HDR_LEN) {
   743					/* FW download out of sync. Send previous chunk again */
   744					nxpdev->fw_dnld_offset -= nxpdev->fw_sent_bytes;
   745					expected_len = HDR_LEN;
   746				}
   747			}
   748	
   749			if (nxpdev->fw_dnld_offset + requested_len <= nxpdev->fw->size)
   750				serdev_device_write_buf(nxpdev->serdev,
   751						nxpdev->fw->data + nxpdev->fw_dnld_offset,
   752						requested_len);
   753			nxpdev->fw_sent_bytes = requested_len;
   754		} else {
   755			BT_INFO("ERR: Send NAK");
   756			nxp_send_ack(NXP_NAK_V1, hdev);
   757		}
   758		return 0;
   759	}
   760	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
