Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BBD3052C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfE3XHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:07:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:5592 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfE3XHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 19:07:10 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 16:07:10 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2019 16:07:08 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWU8a-0008nQ-2F; Fri, 31 May 2019 07:07:08 +0800
Date:   Fri, 31 May 2019 07:06:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jason Baron <jbaron@akamai.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [net-next:master 251/280] net/ipv4/tcp_fastopen.c:75:29: sparse:
 sparse: symbol 'tcp_fastopen_alloc_ctx' was not declared. Should it be
 static?
Message-ID: <201905310755.SmE6F5XI%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   84a32edec48056131c91bebb706c2a0a5976a1a1
commit: 9092a76d3cf8638467b09bbb4f409094349b2b53 [251/280] tcp: add backup TFO key infrastructure
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout 9092a76d3cf8638467b09bbb4f409094349b2b53
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/ipv4/tcp_fastopen.c:75:29: sparse: sparse: symbol 'tcp_fastopen_alloc_ctx' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
