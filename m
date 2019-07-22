Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E377080B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbfGVSAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:00:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:49784 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731121AbfGVSAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 14:00:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jul 2019 10:42:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,295,1559545200"; 
   d="gz'50?scan'50,208,50";a="163237786"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 22 Jul 2019 10:42:37 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hpcKa-000GhA-MH; Tue, 23 Jul 2019 01:42:36 +0800
Date:   Tue, 23 Jul 2019 01:41:38 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kbuild-all@01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [vhost:linux-next 4/5] kernel/rcu/tiny.c:138:22: error: 'rcu_data'
 undeclared
Message-ID: <201907230131.wUPWMhl5%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zqpyqpu5utkr5ev4"
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zqpyqpu5utkr5ev4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/mst/vhost.git linux-next
head:   25da3c2b439666602852820e3231349085682e1a
commit: 4cfd64ce2ad979cbd9a97e1500533d2f5f1355b8 [4/5] rcu: add count of outstanding callbacks
config: i386-allnoconfig (attached as .config)
compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
reproduce:
        git checkout 4cfd64ce2ad979cbd9a97e1500533d2f5f1355b8
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from include/asm-generic/percpu.h:7:0,
                    from arch/x86/include/asm/percpu.h:556,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:51,
                    from include/linux/wait.h:9,
                    from include/linux/completion.h:12,
                    from kernel/rcu/tiny.c:12:
   kernel/rcu/tiny.c: In function 'call_rcu_outstanding':
>> kernel/rcu/tiny.c:138:22: error: 'rcu_data' undeclared (first use in this function)
     rdp = this_cpu_ptr(&rcu_data);
                         ^
   include/linux/percpu-defs.h:220:47: note: in definition of macro '__verify_pcpu_ptr'
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                  ^~~
>> include/linux/percpu-defs.h:264:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
>> include/linux/percpu-defs.h:265:26: note: in expansion of macro 'per_cpu_ptr'
    #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
                             ^~~~~~~~~~~
>> include/linux/percpu-defs.h:266:27: note: in expansion of macro 'raw_cpu_ptr'
    #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
                              ^~~~~~~~~~~
>> kernel/rcu/tiny.c:138:8: note: in expansion of macro 'this_cpu_ptr'
     rdp = this_cpu_ptr(&rcu_data);
           ^~~~~~~~~~~~
   kernel/rcu/tiny.c:138:22: note: each undeclared identifier is reported only once for each function it appears in
     rdp = this_cpu_ptr(&rcu_data);
                         ^
   include/linux/percpu-defs.h:220:47: note: in definition of macro '__verify_pcpu_ptr'
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                  ^~~
>> include/linux/percpu-defs.h:264:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^~~~~~~~~~~~~~~~~
>> include/linux/percpu-defs.h:265:26: note: in expansion of macro 'per_cpu_ptr'
    #define raw_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
                             ^~~~~~~~~~~
>> include/linux/percpu-defs.h:266:27: note: in expansion of macro 'raw_cpu_ptr'
    #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
                              ^~~~~~~~~~~
>> kernel/rcu/tiny.c:138:8: note: in expansion of macro 'this_cpu_ptr'
     rdp = this_cpu_ptr(&rcu_data);
           ^~~~~~~~~~~~

vim +/rcu_data +138 kernel/rcu/tiny.c

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--zqpyqpu5utkr5ev4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--zqpyqpu5utkr5ev4--
