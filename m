Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3AF1BEDE3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgD3ByG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:54:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:46312 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3ByF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 21:54:05 -0400
IronPort-SDR: 0MK2kr1nrAQJY3Izuit+fha58oC6tRm8u8+4zk9qV5z7IPe5WkkHXbhUp1Illj4PFnZuE3n3Iv
 THtbrYfljxgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 18:54:05 -0700
IronPort-SDR: JRfWvi/0Lcjk+7j12JjYQo0hWQ5eYjyLSlU4cFSiJd/P/ifnC+GnHASJKmi6QfUIwfb5/lw5Is
 uUZvwQBM3SGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="432783861"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2020 18:54:01 -0700
Date:   Thu, 30 Apr 2020 10:04:16 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Mao Wenan <maowenan@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf: Change error code when ops is NULL
Message-ID: <20200430020416.GE15540@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083010.28000-2-maowenan@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[also build test WARNING on bpf/master net/master net-next/master ipvs/master v5.7-rc2 next-20200423]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Mao-Wenan/Change-return-code-if-failed-to-load-object/20200424-025339
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
:::::: branch date: 19 hours ago
:::::: commit date: 19 hours ago

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> kernel/bpf/syscall.c:117:0: sparse: sparse: missing terminating " character
   kernel/bpf/syscall.c:118:0: sparse: sparse: missing terminating " character
>> kernel/bpf/syscall.c:686:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:772:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:979:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1046:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1111:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1164:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1341:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1442:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1504:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1548:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1550:1: sparse: sparse: directive in macro's argument list
   kernel/bpf/syscall.c:1551:1: sparse: sparse: directive in macro's argument list
>> kernel/bpf/syscall.c:116:17: sparse: sparse: macro "pr_warn" passed 2 arguments, but takes just 2
>> include/linux/bpf_types.h:7:1: sparse: sparse: No right hand side of ','-expression
   include/linux/bpf_types.h:7:1: sparse: sparse: Expected ; at end of statement
   include/linux/bpf_types.h:7:1: sparse: sparse: got [
   include/linux/bpf_types.h:121:0: sparse: sparse: Expected } at end of compound statement
   include/linux/bpf_types.h:121:0: sparse: sparse: got end-of-input
   include/linux/bpf_types.h:121:0: sparse: sparse: Expected } at end of function
   include/linux/bpf_types.h:121:0: sparse: sparse: got end-of-input
   kernel/bpf/syscall.c:116:17: sparse: sparse: undefined identifier 'pr_warn'
   kernel/bpf/syscall.c:1560:21: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1560:21: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1562:16: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1562:16: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1562:16: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1562:16: sparse: sparse: undefined identifier 'bpf_prog_types'
>> kernel/bpf/syscall.c:1562:16: sparse: sparse: cannot size expression
   kernel/bpf/syscall.c:1563:15: sparse: sparse: undefined identifier 'bpf_prog_types'
   kernel/bpf/syscall.c:1797:27: sparse: sparse: undefined identifier 'bpf_dummy_read'
   kernel/bpf/syscall.c:1798:27: sparse: sparse: undefined identifier 'bpf_dummy_write'
   kernel/bpf/syscall.c:2293:27: sparse: sparse: undefined identifier 'bpf_dummy_read'
   kernel/bpf/syscall.c:2294:27: sparse: sparse: undefined identifier 'bpf_dummy_write'
   kernel/bpf/syscall.c:2870:23: sparse: sparse: undefined identifier '__bpf_map_inc_not_zero'
   kernel/bpf/syscall.c:3538:15: sparse: sparse: undefined identifier 'map_get_sys_perms'
   kernel/bpf/syscall.c:3544:15: sparse: sparse: undefined identifier 'map_get_sys_perms'
   kernel/bpf/syscall.c:3685:23: sparse: sparse: undefined identifier 'map_create'
   kernel/bpf/syscall.c:3688:23: sparse: sparse: undefined identifier 'map_lookup_elem'
   kernel/bpf/syscall.c:3691:23: sparse: sparse: undefined identifier 'map_update_elem'
   kernel/bpf/syscall.c:3694:23: sparse: sparse: undefined identifier 'map_delete_elem'
   kernel/bpf/syscall.c:3697:23: sparse: sparse: undefined identifier 'map_get_next_key'
   kernel/bpf/syscall.c:3700:23: sparse: sparse: undefined identifier 'map_freeze'
   kernel/bpf/syscall.c:3757:23: sparse: sparse: undefined identifier 'map_lookup_and_delete_elem'

# https://github.com/0day-ci/linux/commit/45c88e856945c443c39e3f519ad9740b8e487d8d
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 45c88e856945c443c39e3f519ad9740b8e487d8d
vim +117 kernel/bpf/syscall.c

a38845729ea398 Jakub Kicinski     2018-01-11  103  
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  104  static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  105  {
1110f3a9bcf394 Jakub Kicinski     2018-01-11  106  	const struct bpf_map_ops *ops;
9ef09e35e521bf Mark Rutland       2018-05-03  107  	u32 type = attr->map_type;
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  108  	struct bpf_map *map;
1110f3a9bcf394 Jakub Kicinski     2018-01-11  109  	int err;
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  110  
9ef09e35e521bf Mark Rutland       2018-05-03  111  	if (type >= ARRAY_SIZE(bpf_map_types))
1110f3a9bcf394 Jakub Kicinski     2018-01-11  112  		return ERR_PTR(-EINVAL);
9ef09e35e521bf Mark Rutland       2018-05-03  113  	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
9ef09e35e521bf Mark Rutland       2018-05-03  114  	ops = bpf_map_types[type];
45c88e856945c4 Mao Wenan          2020-04-22  115  	if (!ops) {
45c88e856945c4 Mao Wenan          2020-04-22 @116  		pr_warn("map type %d not supported or
45c88e856945c4 Mao Wenan          2020-04-22 @117  			 kernel config not opened\n", type);
45c88e856945c4 Mao Wenan          2020-04-22  118  		return ERR_PTR(-EOPNOTSUPP);
45c88e856945c4 Mao Wenan          2020-04-22  119  	}
1110f3a9bcf394 Jakub Kicinski     2018-01-11  120  	if (ops->map_alloc_check) {
1110f3a9bcf394 Jakub Kicinski     2018-01-11  121  		err = ops->map_alloc_check(attr);
1110f3a9bcf394 Jakub Kicinski     2018-01-11  122  		if (err)
1110f3a9bcf394 Jakub Kicinski     2018-01-11  123  			return ERR_PTR(err);
1110f3a9bcf394 Jakub Kicinski     2018-01-11  124  	}
a38845729ea398 Jakub Kicinski     2018-01-11  125  	if (attr->map_ifindex)
a38845729ea398 Jakub Kicinski     2018-01-11  126  		ops = &bpf_map_offload_ops;
1110f3a9bcf394 Jakub Kicinski     2018-01-11  127  	map = ops->map_alloc(attr);
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  128  	if (IS_ERR(map))
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  129  		return map;
1110f3a9bcf394 Jakub Kicinski     2018-01-11  130  	map->ops = ops;
9ef09e35e521bf Mark Rutland       2018-05-03  131  	map->map_type = type;
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  132  	return map;
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  133  }
99c55f7d47c0dc Alexei Starovoitov 2014-09-26  134  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

