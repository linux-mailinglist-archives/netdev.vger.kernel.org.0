Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049BE6D85E3
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjDESXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjDESXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:23:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFBA35A1;
        Wed,  5 Apr 2023 11:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680719003; x=1712255003;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HSYygrAqQxExjf3K2A9u5AAu8i1ksBGRjV4gbq51MQg=;
  b=CxeYBhxJZhsSZonudJDndeDxllq5xjfGhaVIknrAzLZPlpK/zu/6Gq0K
   O0YYT/0CdN937C2bFqdLL5SdKzvRlxZqR/RzYRMiYuDe/Qv6gd8ii2rY+
   c4Fs0yAHHC1ij+uMBW7lW8qbadJd2/70G6igq9UkGqsVwP0hIRaOnPRKf
   iwRpMnWL0N3yTeBItCLElxEPC437GjbBQDsqmp+AOa7yLo5G+A7J2XUgp
   p8QgwKIkWvNivYvDMLfoV3BthTDRlPniyr8T8RTT+RvvF9wedlYNQQoJR
   ModsgtZyfayY7hH8q14lYGW6Rtf4cmp8SDZym9uyNCjEI8YASU9asPvgl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322184632"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="322184632"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 11:23:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="751356623"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="751356623"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 05 Apr 2023 11:23:21 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pk7my-000QhW-1M;
        Wed, 05 Apr 2023 18:23:20 +0000
Date:   Thu, 6 Apr 2023 02:22:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter
 program type
Message-ID: <202304060207.JawhnyR9-lkp@intel.com>
References: <20230405161116.13565-7-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161116.13565-7-fw@strlen.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230406-001447
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
patch link:    https://lore.kernel.org/r/20230405161116.13565-7-fw%40strlen.de
patch subject: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter program type
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20230406/202304060207.JawhnyR9-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7fba218dfc4942aa6781f4d1b5c475a0569cfd2e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Florian-Westphal/bpf-add-bpf_link-support-for-BPF_NETFILTER-programs/20230406-001447
        git checkout 7fba218dfc4942aa6781f4d1b5c475a0569cfd2e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304060207.JawhnyR9-lkp@intel.com/

All warnings (new ones prefixed by >>):

   net/bpf/test_run.c: In function 'bpf_prog_test_run_nf':
>> net/bpf/test_run.c:1750:30: warning: variable 'eth' set but not used [-Wunused-but-set-variable]
    1750 |         const struct ethhdr *eth;
         |                              ^~~


vim +/eth +1750 net/bpf/test_run.c

  1737	
  1738	int bpf_prog_test_run_nf(struct bpf_prog *prog,
  1739				 const union bpf_attr *kattr,
  1740				 union bpf_attr __user *uattr)
  1741	{
  1742		struct net *net = current->nsproxy->net_ns;
  1743		struct net_device *dev = net->loopback_dev;
  1744		struct nf_hook_state *user_ctx, hook_state = {
  1745			.pf = NFPROTO_IPV4,
  1746			.hook = NF_INET_PRE_ROUTING,
  1747		};
  1748		u32 size = kattr->test.data_size_in;
  1749		u32 repeat = kattr->test.repeat;
> 1750		const struct ethhdr *eth;
  1751		struct bpf_nf_ctx ctx = {
  1752			.state = &hook_state,
  1753		};
  1754		struct sk_buff *skb = NULL;
  1755		u32 retval, duration;
  1756		void *data;
  1757		int ret;
  1758	
  1759		if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
  1760			return -EINVAL;
  1761	
  1762		if (size < ETH_HLEN + sizeof(struct iphdr))
  1763			return -EINVAL;
  1764	
  1765		data = bpf_test_init(kattr, kattr->test.data_size_in, size,
  1766				     NET_SKB_PAD + NET_IP_ALIGN,
  1767				     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
  1768		if (IS_ERR(data))
  1769			return PTR_ERR(data);
  1770	
  1771		eth = (struct ethhdr *)data;
  1772	
  1773		if (!repeat)
  1774			repeat = 1;
  1775	
  1776		user_ctx = bpf_ctx_init(kattr, sizeof(struct nf_hook_state));
  1777		if (IS_ERR(user_ctx)) {
  1778			kfree(data);
  1779			return PTR_ERR(user_ctx);
  1780		}
  1781	
  1782		if (user_ctx) {
  1783			ret = verify_and_copy_hook_state(&hook_state, user_ctx, dev);
  1784			if (ret)
  1785				goto out;
  1786		}
  1787	
  1788		skb = slab_build_skb(data);
  1789		if (!skb) {
  1790			ret = -ENOMEM;
  1791			goto out;
  1792		}
  1793	
  1794		data = NULL; /* data released via kfree_skb */
  1795	
  1796		skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
  1797		__skb_put(skb, size);
  1798	
  1799		skb->protocol = eth_type_trans(skb, dev);
  1800	
  1801		skb_reset_network_header(skb);
  1802	
  1803		ret = -EINVAL;
  1804	
  1805		switch (skb->protocol) {
  1806		case htons(ETH_P_IP):
  1807			if (hook_state.pf == NFPROTO_IPV4)
  1808				break;
  1809			goto out;
  1810		case htons(ETH_P_IPV6):
  1811			if (size < ETH_HLEN + sizeof(struct ipv6hdr))
  1812				goto out;
  1813			if (hook_state.pf == NFPROTO_IPV6)
  1814				break;
  1815			goto out;
  1816		default:
  1817			ret = -EPROTO;
  1818			goto out;
  1819		}
  1820	
  1821		ctx.skb = skb;
  1822	
  1823		ret = bpf_test_run(prog, &ctx, repeat, &retval, &duration, false);
  1824		if (ret)
  1825			goto out;
  1826	
  1827		ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
  1828	
  1829	out:
  1830		kfree(user_ctx);
  1831		kfree_skb(skb);
  1832		kfree(data);
  1833		return ret;
  1834	}
  1835	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
