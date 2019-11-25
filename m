Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA91910896F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 08:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfKYHtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 02:49:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:6732 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfKYHtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 02:49:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 23:48:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,240,1571727600"; 
   d="gz'50?scan'50,208,50";a="409535234"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 24 Nov 2019 23:48:53 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iZ977-0003dW-3y; Mon, 25 Nov 2019 15:48:53 +0800
Date:   Mon, 25 Nov 2019 15:47:56 +0800
From:   kbuild test robot <lkp@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     kbuild-all@lists.01.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>,
        dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Paul Mackerras <paulus@samba.org>,
        linux-kselftest@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-rdma@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        linux-block@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jens Axboe <axboe@kernel.dk>, netdev@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        "David S . Miller" <davem@davemloft.net>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH 07/19] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Message-ID: <201911251525.Awsu7Kl2%lkp@intel.com>
References: <20191125042011.3002372-8-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xgai4iybgx2i3zyn"
Content-Disposition: inline
In-Reply-To: <20191125042011.3002372-8-jhubbard@nvidia.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xgai4iybgx2i3zyn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on rdma/for-next]
[also build test ERROR on v5.4 next-20191122]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/John-Hubbard/pin_user_pages-reduced-risk-series-for-Linux-5-5/20191125-125637
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next
config: sh-rsk7269_defconfig (attached as .config)
compiler: sh4-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=sh 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   mm/gup.o: In function `pin_user_pages_remote':
>> gup.c:(.text+0x4a4): undefined reference to `get_user_pages_remote'

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--xgai4iybgx2i3zyn
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
G9HQ+MVog/4PrXqS7NK5AAA=

--xgai4iybgx2i3zyn--
