Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDEF1B2A15
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgDUOhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:37:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:43218 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgDUOhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 10:37:13 -0400
IronPort-SDR: CwLb502Qvx1ud/O4Yr9yA1F//EPpIZNYeb4DviSQGIjPR2Z9CiquTFGzTRx30anus3nDGz1stp
 NaxPdn13s7ZA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 07:37:10 -0700
IronPort-SDR: 0B2wrR/kbvJezAx9zo6vmrc3CHiK3qK+5W7o73c1cdOPDD0gOtrup0hywQpfLeedNGl5+5dCaH
 an1knMJROzKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,410,1580803200"; 
   d="scan'208";a="456126990"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 07:37:08 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jQu1L-0005qj-UF; Tue, 21 Apr 2020 22:37:07 +0800
Date:   Tue, 21 Apr 2020 22:36:41 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Jianwei Mao (Mao)" <mao-linux@maojianwei.com>,
        netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>, kuba <kuba@kernel.org>,
        maojianwei <maojianwei@huawei.com>
Cc:     kbuild-all@lists.01.org, davem <davem@davemloft.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>, kuba <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: ipv6: support Application-aware IPv6
 Network (APN6)
Message-ID: <202004212206.rWMiLj2e%lkp@intel.com>
References: <71eb2d7b-6afa-48fd-af96-140dd6ddd1e0.mao-linux@maojianwei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71eb2d7b-6afa-48fd-af96-140dd6ddd1e0.mao-linux@maojianwei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi "Jianwei,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master ipsec/master linus/master v5.7-rc2 next-20200421]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Jianwei-Mao-Mao/net-ipv6-support-Application-aware-IPv6-Network-APN6/20200421-072711
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 82ebc889091a488b4dd95e682b3c3b889a50713c
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/ipv6/ipv6_sockglue.c:171:13: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] sla @@    got restrunsigned int [assigned] sla @@
>> net/ipv6/ipv6_sockglue.c:171:13: sparse:    expected unsigned int [assigned] sla
>> net/ipv6/ipv6_sockglue.c:171:13: sparse:    got restricted __be32 [usertype]
>> net/ipv6/ipv6_sockglue.c:172:16: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] app_id @@    got restrunsigned int [assigned] app_id @@
>> net/ipv6/ipv6_sockglue.c:172:16: sparse:    expected unsigned int [assigned] app_id
   net/ipv6/ipv6_sockglue.c:172:16: sparse:    got restricted __be32 [usertype]
>> net/ipv6/ipv6_sockglue.c:173:17: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int [assigned] user_id @@    got restrunsigned int [assigned] user_id @@
>> net/ipv6/ipv6_sockglue.c:173:17: sparse:    expected unsigned int [assigned] user_id
   net/ipv6/ipv6_sockglue.c:173:17: sparse:    got restricted __be32 [usertype]
   net/ipv6/ipv6_sockglue.c:1143:33: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected void *msg_control @@    got char [noderef] <asvoid *msg_control @@
   net/ipv6/ipv6_sockglue.c:1143:33: sparse:    expected void *msg_control
   net/ipv6/ipv6_sockglue.c:1143:33: sparse:    got char [noderef] <asn:1> *optval

vim +171 net/ipv6/ipv6_sockglue.c

   138	
   139	#define APN6_HBH_LEN 16
   140	#define APN6_HBH_HDR_LEN 4
   141	#define APN6_OPTION_TYPE 0x03
   142	#define APN6_OPTION_LEN (APN6_HBH_LEN - APN6_HBH_HDR_LEN)
   143	#define APN6_SLA_SIZE 4
   144	#define APN6_APPID_SIZE 4
   145	#define APN6_USERID_SIZE 4
   146	/* Return APN6 Hop-by-Hop(HBH) extension header */
   147	static void *generate_apn6_hopopts(char __user *optval, unsigned int optlen)
   148	{
   149		unsigned char *hbh;
   150		unsigned int sla, app_id, user_id;
   151	
   152		if (optlen < (sizeof(unsigned int) * 3))
   153			return NULL;
   154		else if (!optval)
   155			return NULL;
   156	
   157		if (get_user(sla, ((unsigned int __user *)optval)) ||
   158		    get_user(app_id, ((unsigned int __user *)optval) + 1) ||
   159		    get_user(user_id, ((unsigned int __user *)optval) + 2))
   160			return ERR_PTR(-EFAULT);
   161	
   162		pr_info("APN6: Get info: SLA:%08X AppID:%08X UserID:%08X",
   163			    sla, app_id, user_id);
   164	
   165		hbh = kzalloc(APN6_HBH_LEN, GFP_KERNEL);
   166		// hbh[0] is 0x0 now, and will be set natively when sending packets.
   167		hbh[1] = (APN6_HBH_LEN >> 3) - 1;
   168		hbh[2] = APN6_OPTION_TYPE;
   169		hbh[3] = APN6_OPTION_LEN;
   170	
 > 171		sla = htonl(sla);
 > 172		app_id = htonl(app_id);
 > 173		user_id = htonl(user_id);
   174		memcpy(hbh + APN6_HBH_HDR_LEN, &sla, APN6_SLA_SIZE);
   175		memcpy(hbh + APN6_HBH_HDR_LEN + APN6_SLA_SIZE, &app_id, APN6_APPID_SIZE);
   176		memcpy(hbh + APN6_HBH_HDR_LEN + APN6_SLA_SIZE + APN6_APPID_SIZE,
   177		       &user_id, APN6_USERID_SIZE);
   178	
   179		pr_info("APN6: Generate APN6 Hop-by-Hop extension header:\n"
   180				"%02X %02X %02X %02X\n"
   181				"%02X %02X %02X %02X\n"
   182				"%02X %02X %02X %02X\n"
   183				"%02X %02X %02X %02X",
   184				hbh[0], hbh[1], hbh[2], hbh[3],
   185				hbh[4], hbh[5], hbh[6], hbh[7],
   186				hbh[8], hbh[9], hbh[10], hbh[11],
   187				hbh[12], hbh[13], hbh[14], hbh[15]);
   188	
   189		return hbh;
   190	}
   191	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
