Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751F758FC76
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiHKMht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235283AbiHKMhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:37:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336D620BF8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660221465; x=1691757465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nShIviX/VOK+O+zxy31C+5G7PUIBV3Eib4wPV4CZu1c=;
  b=YxFTVyzjy52/DlRq3fOzk4KH/LHGyEGyuNvBs7TKGTFEVfkY/H+vtkSm
   Y5qGfMIiGBoe0unBfPj8VwIRx2dTx0bLFim8jlUKP2kPmWD7ZseMwbBt3
   0qeBHvZ1UBnw4yKtBoH0mhZ9m4m/7L11/BV7V09VRY6oIqZcJHRQEbREd
   G9e8EhSK9pD+XonxWboCChcZM+WPwJa0cBflwGBrW489fVKhQvxMYVX9z
   JDdnZKRB6SWmJGE8T6R3auW4WvUSHMz3n+E5Nnqmi09wbeE18i6Mf1aTB
   ct/Ml3EtPfQ0ox2p4GRhEqEIG6lvN8hwrqgrRCkPNOLPcLIwMotW38tpP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="288901620"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="288901620"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 05:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581653221"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 11 Aug 2022 05:37:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27BCbe0A001545;
        Thu, 11 Aug 2022 13:37:40 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "shenjian (K)" <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 16/36] treewide: use replace features '0' by netdev_empty_features
Date:   Thu, 11 Aug 2022 14:35:47 +0200
Message-Id: <20220811123547.8367-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <7b6eb064-a649-8a26-8eff-2ad2b2457c22@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-17-shenjian15@huawei.com> <20220810104841.1306583-1-alexandr.lobakin@intel.com> <7b6eb064-a649-8a26-8eff-2ad2b2457c22@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "shenjian (K)" <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 20:25:38 +0800

> 在 2022/8/10 18:48, Alexander Lobakin 写道:
> > From: Jian Shen <shenjian15@huawei.com>
> > Date: Wed, 10 Aug 2022 11:06:04 +0800
> >
> >> For the prototype of netdev_features_t will be changed from
> >> u64 to bitmap, so it's unable to assignment with 0 directly.
> >> Replace it with netdev_empty_features.
> > Hmm, why not just netdev_features_zero() instead?
> > There's a couple places where empty netdev_features are needed, but
> > they're not probably worth a separate and rather pointless empty
> > variable, you could create one on the stack there.
> As replied before, the new netdev_features_t supports being
> assigned directly, so use netdev_emtpy_features looks
> more simple.

Dunno, looks reduntant. For declaring onstack variables, one can
simply:

	netdev_features_t feat = { };

For zeroing in the code it's a bit more complex:

	feat = (typeof(feat)){ };

But I can't remember empty complex variables in the kernel code
declared just to ease type initialization.

Hmm, how about

#define netdev_empty_features	((netdev_features_t){ })

?

It would work just as your variable, but without creating any
globals.
Before converting netdev_features to a structure, you can define
it just as `0`.

> 
> >> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> >> ---
> >>   drivers/hsi/clients/ssi_protocol.c             | 2 +-
> >>   drivers/net/caif/caif_serial.c                 | 2 +-
> >>   drivers/net/ethernet/amazon/ena/ena_netdev.c   | 2 +-
> >>   drivers/net/ethernet/broadcom/b44.c            | 2 +-
> >>   drivers/net/ethernet/broadcom/tg3.c            | 2 +-
> >>   drivers/net/ethernet/dnet.c                    | 2 +-
> >>   drivers/net/ethernet/ec_bhf.c                  | 2 +-
> >>   drivers/net/ethernet/emulex/benet/be_main.c    | 2 +-
> >>   drivers/net/ethernet/ethoc.c                   | 2 +-
> >>   drivers/net/ethernet/huawei/hinic/hinic_main.c | 5 +++--
> >>   drivers/net/ethernet/ibm/ibmvnic.c             | 6 +++---
> >>   drivers/net/ethernet/intel/iavf/iavf_main.c    | 9 +++++----
> >>   drivers/net/ethernet/microsoft/mana/mana_en.c  | 2 +-
> >>   drivers/net/ethernet/sfc/ef10.c                | 2 +-
> >>   drivers/net/tap.c                              | 2 +-
> >>   drivers/net/tun.c                              | 2 +-
> >>   drivers/net/usb/cdc-phonet.c                   | 3 ++-
> >>   drivers/net/usb/lan78xx.c                      | 2 +-
> >>   drivers/s390/net/qeth_core_main.c              | 2 +-
> >>   drivers/usb/gadget/function/f_phonet.c         | 3 ++-
> >>   net/dccp/ipv4.c                                | 2 +-
> >>   net/dccp/ipv6.c                                | 2 +-
> >>   net/ethtool/features.c                         | 2 +-
> >>   net/ethtool/ioctl.c                            | 6 ++++--
> >>   net/ipv4/af_inet.c                             | 2 +-
> >>   net/ipv4/tcp.c                                 | 2 +-
> >>   net/ipv4/tcp_ipv4.c                            | 2 +-
> >>   net/ipv6/af_inet6.c                            | 2 +-
> >>   net/ipv6/inet6_connection_sock.c               | 2 +-
> >>   net/ipv6/tcp_ipv6.c                            | 2 +-
> >>   net/openvswitch/datapath.c                     | 2 +-
> >>   31 files changed, 44 insertions(+), 38 deletions(-)
> > [...]
> >
> >> -- 
> >> 2.33.0
> > Thanks,
> > Olek
> > .
> >
> Thanks,
> Jian

Thanks,
Olek
