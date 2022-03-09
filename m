Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7664D346B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiCIQZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiCIQVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:31 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF761092
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646842817; x=1678378817;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=FqnTi3KjDSx6QBLtOUGTWob6LUz8Rp6UWNEEH6D6DnA=;
  b=lfDfZNgLVlHWRigRnLakajChxVnnUdr1R85KP0CkbaivNN1zKlJXAENa
   rTo2DVbpo5sR/iFgPmPLuIA8ZPZ0cJ9FhIhr/IxdKRF/hy4PsQS7viDwA
   rIUca2SRP5BOg+b/ZZVwYgJf5dDNBtTox6YI4C1COCZ1xMzNkx7O2fJk9
   m8jNEhDK3MI9Ksn4n4VnVS0macZkR25q83Od1ojWIbJoT4RXdaLktreMs
   PBMIGHIED0vWRyrrIxhqCYABmpu6cLjs90hBE/gZj0VXzdfFX+cwwMUaP
   omjhs68hoscrPmX1glfKEe2RXjzGx4WVLYeTtSbyPmx5SKxifPcYJxu8i
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="234963077"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="234963077"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 08:20:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="632655513"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Mar 2022 08:20:16 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRz2t-0003Wq-HV; Wed, 09 Mar 2022 16:20:15 +0000
Date:   Thu, 10 Mar 2022 00:19:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [net-next:master 192/194] include/net/tcp.h:1694:1: warning:
 'tcp_inbound_md5_hash' used but never defined
Message-ID: <202203100028.PDew5dU4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   40bb09c87f0b00c991f6c2fb367f0a2711760332
commit: 1330b6ef3313fcec577d2b020c290dc8b9f11f1a [192/194] skb: make drop reason booleanable
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220310/202203100028.PDew5dU4-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=1330b6ef3313fcec577d2b020c290dc8b9f11f1a
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 1330b6ef3313fcec577d2b020c290dc8b9f11f1a
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash net/core/ net/ipv4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from net/ipv4/tcp_ipv4.c:64:
   include/net/tcp.h:1697:1: error: expected identifier or '(' before '{' token
    1697 | {
         | ^
>> include/net/tcp.h:1694:1: warning: 'tcp_inbound_md5_hash' used but never defined
    1694 | tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
         | ^~~~~~~~~~~~~~~~~~~~


vim +/tcp_inbound_md5_hash +1694 include/net/tcp.h

  1692	
  1693	static inline enum skb_drop_reason
> 1694	tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
  1695			     const void *saddr, const void *daddr,
  1696			     int family, int dif, int sdif);
> 1697	{
  1698		return SKB_NOT_DROPPED_YET;
  1699	}
  1700	#define tcp_twsk_md5_key(twsk)	NULL
  1701	#endif
  1702	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
