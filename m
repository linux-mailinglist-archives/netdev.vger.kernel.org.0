Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB149CCDF4
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 04:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfJFCrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 22:47:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:6051 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfJFCrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 22:47:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 19:46:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="199208654"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Oct 2019 19:46:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGwZV-00030v-SO; Sun, 06 Oct 2019 10:46:57 +0800
Date:   Sun, 6 Oct 2019 10:46:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [ipsec-next:testing 7/8] include/net/espintcp.h:36:20: sparse:
 sparse: incorrect type in return expression (different address spaces)
Message-ID: <201910061039.jnJWPq01%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
head:   5374d99ba41893b4bb1ddbe35a88b1f08e860903
commit: 735de2631f8680ac714df1ecc8e052785e9f9f8e [7/8] xfrm: add espintcp (RFC 8229)
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout 735de2631f8680ac714df1ecc8e052785e9f9f8e
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> net/xfrm/espintcp.c:421:29: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:4> *icsk_ulp_data @@    got struct evoid [noderef] <asn:4> *icsk_ulp_data @@
>> net/xfrm/espintcp.c:421:29: sparse:    expected void [noderef] <asn:4> *icsk_ulp_data
>> net/xfrm/espintcp.c:421:29: sparse:    got struct espintcp_ctx *[assigned] ctx
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
>> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
>> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
>> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data

vim +36 include/net/espintcp.h

    31	
    32	static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
    33	{
    34		struct inet_connection_sock *icsk = inet_csk(sk);
    35	
  > 36		return icsk->icsk_ulp_data;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
