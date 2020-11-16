Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4457A2B3ACF
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 01:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKPAcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 19:32:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:57554 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgKPAcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 19:32:42 -0500
IronPort-SDR: DmFHmWGmQHE8rH+QdecR9MpQfV4/bPKfMCPNW8+Y3gZGy1hPP17wC9AGz9cjbEjulnmOrmimA4
 cJU4iZUtNglA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="234842336"
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="234842336"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 16:32:41 -0800
IronPort-SDR: Blo/4i4yhgpV+3/7MsPMF0q5CjhQjb/3WFoG9A8sL2eOdoEcUG2VzbZw2RtePzZCtfU2jghPUI
 f4WmyeLSQasw==
X-IronPort-AV: E=Sophos;i="5.77,481,1596524400"; 
   d="scan'208";a="543395623"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.117]) ([10.239.13.117])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2020 16:32:38 -0800
Subject: Re: [kbuild-all] Re: [PATCH v6] can: usb: etas_es58X: add support for
 ETAS ES58X CAN USB interfaces
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        kernel test robot <lkp@intel.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20201114152325.523630-1-mailhol.vincent@wanadoo.fr>
 <202011150212.yNjsvCzu-lkp@intel.com>
 <CAMZ6RqJFasm658=-6Q4-Dm+gDG-tqj39ujzXbMAdYwmaRE=1ew@mail.gmail.com>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <25305b69-72f8-d862-6e67-9af1b2de3403@intel.com>
Date:   Mon, 16 Nov 2020 08:31:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJFasm658=-6Q4-Dm+gDG-tqj39ujzXbMAdYwmaRE=1ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/20 7:41 PM, Vincent MAILHOL wrote:
> The report from Intel's test robot is a false positive.
>
> On Sun. 15 Nov. 2020 at 03:12, kernel test robot wrote:
>> Hi Vincent,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on bff6f1db91e330d7fba56f815cdbc412c75fe163 v5.10-rc3 next-20201113]
>> [If your patch is applied to the wrong git tree, kindly drop us a note.
> Patch is applied to the wrong git tree. It is based on the testing
> branch of linux-can-next:
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=testing
>
>> And when submitting patch, we suggest to use '--base' as documented in
>> https://git-scm.com/docs/git-format-patch]
> I did so (c.f. the base-commit and prerequisite-patch-id tags at the
> bottom of the patch). While the base-commit was taken into account,
> the prerequisite-patch-id tags seem to have been ignored.
>
> FYI, I used the below command to generate the patch.
> git format-patch --base=bff6f1db91e330d7fba56f815cdbc412c75fe163 -v6
> -o patch/v6 HEAD~1

Hi Vincent,

Thanks for the feedback, we'll fix the problem asap.

Best Regards,
Rong Chen


>
>
> Yours sincerely,
> Vincent Mailhol
>
>> url:    https://github.com/0day-ci/linux/commits/Vincent-Mailhol/can-usb-etas_es58X-add-support-for-ETAS-ES58X-CAN-USB-interfaces/20201114-232854
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git f01c30de86f1047e9bae1b1b1417b0ce8dcd15b1
>> config: x86_64-randconfig-a005-20201115 (attached as .config)
>> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 9a85643cd357e412cff69067bb5c4840e228c2ab)
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # install x86_64 cross compiling tool for clang build
>>          # apt-get install binutils-x86-64-linux-gnu
>>          # https://github.com/0day-ci/linux/commit/80a9b72580bad04e879752fa5c54d278b486e2bb
>>          git remote add linux-review https://github.com/0day-ci/linux
>>          git fetch --no-tags linux-review Vincent-Mailhol/can-usb-etas_es58X-add-support-for-ETAS-ES58X-CAN-USB-interfaces/20201114-232854
>>          git checkout 80a9b72580bad04e879752fa5c54d278b486e2bb
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>):
>>
>>>> drivers/net/can/usb/etas_es58x/es58x_core.c:745:12: error: use of undeclared identifier 'CAN_MAX_RAW_DLC'
>>             if (dlc > CAN_MAX_RAW_DLC) {
>>                       ^
>>     drivers/net/can/usb/etas_es58x/es58x_core.c:748:22: error: use of undeclared identifier 'CAN_MAX_RAW_DLC'
>>                                __func__, dlc, CAN_MAX_RAW_DLC);
>>                                               ^
>>>> drivers/net/can/usb/etas_es58x/es58x_core.c:753:9: error: implicit declaration of function 'can_fd_dlc2len' [-Werror,-Wimplicit-function-declaration]
>>                     len = can_fd_dlc2len(dlc);
>>                           ^
>>     drivers/net/can/usb/etas_es58x/es58x_core.c:753:9: note: did you mean 'can_dlc2len'?
>>     include/linux/can/dev.h:190:4: note: 'can_dlc2len' declared here
>>     u8 can_dlc2len(u8 can_dlc);
>>        ^
>>>> drivers/net/can/usb/etas_es58x/es58x_core.c:756:9: error: implicit declaration of function 'can_cc_dlc2len' [-Werror,-Wimplicit-function-declaration]
>>                     len = can_cc_dlc2len(dlc);
>>                           ^
>>     drivers/net/can/usb/etas_es58x/es58x_core.c:756:9: note: did you mean 'can_dlc2len'?
>>     include/linux/can/dev.h:190:4: note: 'can_dlc2len' declared here
>>     u8 can_dlc2len(u8 can_dlc);
>>        ^
>>>> drivers/net/can/usb/etas_es58x/es58x_core.c:775:3: error: implicit declaration of function 'can_frame_set_cc_len' [-Werror,-Wimplicit-function-declaration]
>>                     can_frame_set_cc_len(ccf, dlc, es58x_priv(netdev)->can.ctrlmode);
>>                     ^
>>     5 errors generated.
>> --
>>>> drivers/net/can/usb/etas_es58x/es581_4.c:385:20: error: implicit declaration of function 'can_get_cc_dlc' [-Werror,-Wimplicit-function-declaration]
>>             tx_can_msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
>>                               ^
>>>> drivers/net/can/usb/etas_es58x/es581_4.c:387:41: error: no member named 'len' in 'struct can_frame'
>>             memcpy(tx_can_msg->data, cf->data, cf->len);
>>                                                ~~  ^
>>>> drivers/net/can/usb/etas_es58x/es581_4.c:391:13: error: implicit declaration of function 'can_cc_dlc2len' [-Werror,-Wimplicit-function-declaration]
>>             msg_len += es581_4_sizeof_rx_tx_msg(*tx_can_msg);
>>                        ^
>>     drivers/net/can/usb/etas_es58x/es581_4.c:30:29: note: expanded from macro 'es581_4_sizeof_rx_tx_msg'
>>             offsetof(typeof(msg), data[can_cc_dlc2len((msg).dlc)])
>>                                        ^
>>     drivers/net/can/usb/etas_es58x/es581_4.c:391:13: note: did you mean 'can_dlc2len'?
>>     drivers/net/can/usb/etas_es58x/es581_4.c:30:29: note: expanded from macro 'es581_4_sizeof_rx_tx_msg'
>>             offsetof(typeof(msg), data[can_cc_dlc2len((msg).dlc)])
>>                                        ^
>>     include/linux/can/dev.h:190:4: note: 'can_dlc2len' declared here
>>     u8 can_dlc2len(u8 can_dlc);
>>        ^
>>>> drivers/net/can/usb/etas_es58x/es581_4.c:515:48: error: use of undeclared identifier 'CAN_CTRLMODE_CC_LEN8_DLC'
>>             .ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_CC_LEN8_DLC,
>>                                                           ^
>>     4 errors generated.
>> --
>>>> drivers/net/can/usb/etas_es58x/es58x_fd.c:119:24: error: implicit declaration of function 'can_cc_dlc2len' [-Werror,-Wimplicit-function-declaration]
>>                     u16 rx_can_msg_len = es58x_fd_sizeof_rx_tx_msg(*rx_can_msg);
>>                                          ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:36:3: note: expanded from macro 'es58x_fd_sizeof_rx_tx_msg'
>>                     can_cc_dlc2len(__msg.dlc);                              \
>>                     ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:119:24: note: did you mean 'can_dlc2len'?
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:36:3: note: expanded from macro 'es58x_fd_sizeof_rx_tx_msg'
>>                     can_cc_dlc2len(__msg.dlc);                              \
>>                     ^
>>     include/linux/can/dev.h:190:4: note: 'can_dlc2len' declared here
>>     u8 can_dlc2len(u8 can_dlc);
>>        ^
>>>> drivers/net/can/usb/etas_es58x/es58x_fd.c:141:11: error: implicit declaration of function 'can_fd_len2dlc' [-Werror,-Wimplicit-function-declaration]
>>                                     dlc = can_fd_len2dlc(rx_can_msg->len);
>>                                           ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:141:11: note: did you mean 'can_len2dlc'?
>>     include/linux/can/dev.h:193:4: note: 'can_len2dlc' declared here
>>     u8 can_len2dlc(u8 len);
>>        ^
>>>> drivers/net/can/usb/etas_es58x/es58x_fd.c:371:25: error: no member named 'len' in 'struct can_frame'
>>                     tx_can_msg->len = cf->len;
>>                                       ~~  ^
>>>> drivers/net/can/usb/etas_es58x/es58x_fd.c:373:21: error: implicit declaration of function 'can_get_cc_dlc' [-Werror,-Wimplicit-function-declaration]
>>                     tx_can_msg->dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
>>                                       ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:374:41: error: no member named 'len' in 'struct can_frame'
>>             memcpy(tx_can_msg->data, cf->data, cf->len);
>>                                                ~~  ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:377:13: error: implicit declaration of function 'can_cc_dlc2len' [-Werror,-Wimplicit-function-declaration]
>>             msg_len += es58x_fd_sizeof_rx_tx_msg(*tx_can_msg);
>>                        ^
>>     drivers/net/can/usb/etas_es58x/es58x_fd.c:36:3: note: expanded from macro 'es58x_fd_sizeof_rx_tx_msg'
>>                     can_cc_dlc2len(__msg.dlc);                              \
>>                     ^
>>>> drivers/net/can/usb/etas_es58x/es58x_fd.c:617:6: error: use of undeclared identifier 'CAN_CTRLMODE_CC_LEN8_DLC'
>>                 CAN_CTRLMODE_CC_LEN8_DLC,
>>                 ^
>>     7 errors generated.
>>
>> vim +/CAN_MAX_RAW_DLC +745 drivers/net/can/usb/etas_es58x/es58x_core.c
>>
>>     718
>>     719  /**
>>     720   * es58x_rx_can_msg() - Handle a received a CAN message.
>>     721   * @netdev: CAN network device.
>>     722   * @timestamp: Hardware time stamp (only relevant in rx branches).
>>     723   * @data: CAN payload.
>>     724   * @can_id: CAN ID.
>>     725   * @es58x_flags: Please refer to enum es58x_flag.
>>     726   * @dlc: Data Length Code (raw value).
>>     727   *
>>     728   * Fill up a CAN skb and post it.
>>     729   *
>>     730   * This function handles the case where the DLC of a classical CAN
>>     731   * frame is greater than CAN_MAX_DLEN (c.f. the len8_dlc field of
>>     732   * struct can_frame).
>>     733   *
>>     734   * Return: zero on success.
>>     735   */
>>     736  int es58x_rx_can_msg(struct net_device *netdev, u64 timestamp, const u8 *data,
>>     737                       canid_t can_id, enum es58x_flag es58x_flags, u8 dlc)
>>     738  {
>>     739          struct canfd_frame *cfd;
>>     740          struct can_frame *ccf;
>>     741          struct sk_buff *skb;
>>     742          u8 len;
>>     743          bool is_can_fd = !!(es58x_flags & ES58X_FLAG_FD_DATA);
>>     744
>>   > 745          if (dlc > CAN_MAX_RAW_DLC) {
>>     746                  netdev_err(netdev,
>>     747                             "%s: DLC is %d but maximum should be %d\n",
>>     748                             __func__, dlc, CAN_MAX_RAW_DLC);
>>     749                  return -EMSGSIZE;
>>     750          }
>>     751
>>     752          if (is_can_fd) {
>>   > 753                  len = can_fd_dlc2len(dlc);
>>     754                  skb = alloc_canfd_skb(netdev, &cfd);
>>     755          } else {
>>   > 756                  len = can_cc_dlc2len(dlc);
>>     757                  skb = alloc_can_skb(netdev, &ccf);
>>     758                  cfd = (struct canfd_frame *)ccf;
>>     759          }
>>     760
>>     761          if (!skb) {
>>     762                  netdev->stats.rx_dropped++;
>>     763                  return -ENOMEM;
>>     764          }
>>     765          cfd->can_id = can_id;
>>     766          if (es58x_flags & ES58X_FLAG_EFF)
>>     767                  cfd->can_id |= CAN_EFF_FLAG;
>>     768          if (is_can_fd) {
>>     769                  cfd->len = len;
>>     770                  if (es58x_flags & ES58X_FLAG_FD_BRS)
>>     771                          cfd->flags |= CANFD_BRS;
>>     772                  if (es58x_flags & ES58X_FLAG_FD_ESI)
>>     773                          cfd->flags |= CANFD_ESI;
>>     774          } else {
>>   > 775                  can_frame_set_cc_len(ccf, dlc, es58x_priv(netdev)->can.ctrlmode);
>>     776                  if (es58x_flags & ES58X_FLAG_RTR) {
>>     777                          ccf->can_id |= CAN_RTR_FLAG;
>>     778                          len = 0;
>>     779                  }
>>     780          }
>>     781          memcpy(cfd->data, data, len);
>>     782          netdev->stats.rx_packets++;
>>     783          netdev->stats.rx_bytes += len;
>>     784
>>     785          es58x_set_skb_timestamp(netdev, skb, timestamp);
>>     786          netif_rx(skb);
>>     787
>>     788          es58x_priv(netdev)->err_passive_before_rtx_success = 0;
>>     789
>>     790          return 0;
>>     791  }
>>     792
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> _______________________________________________
> kbuild-all mailing list -- kbuild-all@lists.01.org
> To unsubscribe send an email to kbuild-all-leave@lists.01.org

