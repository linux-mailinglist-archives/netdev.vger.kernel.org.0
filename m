Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670744A7F25
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiBCFow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:44:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:23929 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbiBCFov (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 00:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643867092; x=1675403092;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6QTjfaThtdO9q0TWo75wLiuJznde8xAFYjIDlvH/Ewg=;
  b=ENjrFNDPyq7a266tnH7sk2MsnTA40pSUS5W7rurJbcGF7vpe7NjUXp/A
   aBqNC8NqfCg6sdWJottvhAciUX0/7pswhmkRAG5SupQ1y5PLHrbJ815SP
   I0cy6+j39d6YS7EBZAqgyAB+no7t9/itHKqJwE+rQRKazrxtO92kebqBK
   E8AIVVqIbQ/HThW/PqH224SVmr0Ogmd4xXj4/7BoH/7VyvXXqP+cUjIBh
   Sqay0UcarDMYsgtahzYGyoLNJB60hWHKXcjmVaSAy+83wXs/mz1NdGMly
   TGjOZeCXUq25e6nIMIDKjZU1t8O5gYfWxbFbC8v4/QF1Xcnqn1m3rVhVX
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="228048132"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="228048132"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 21:44:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="631230094"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 02 Feb 2022 21:44:49 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nFUvJ-000VgM-2K; Thu, 03 Feb 2022 05:44:49 +0000
Date:   Thu, 3 Feb 2022 13:43:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Message-ID: <202202031344.0FFfnywX-lkp@intel.com>
References: <20220203015140.3022854-10-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203015140.3022854-10-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 52dae93f3bad842c6d585700460a0dea4d70e096
config: arc-allyesconfig (https://download.01.org/0day-ci/archive/20220203/202202031344.0FFfnywX-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/tcp-BIG-TCP-implementation/20220203-095336
        git checkout 64ec6b0260be94b2ed90ee6d139591bdbd49c82d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arc SHELL=/bin/bash drivers/net/ethernet/3com/ drivers/net/ethernet/agere/ drivers/net/ethernet/mellanox/mlx5/core/ drivers/net/wireguard/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/wireguard/send.c: In function 'encrypt_packet':
>> drivers/net/wireguard/send.c:219:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     219 | }
         | ^
--
   drivers/net/wireguard/receive.c: In function 'decrypt_packet':
>> drivers/net/wireguard/receive.c:299:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
     299 | }
         | ^
--
>> drivers/net/ethernet/3com/typhoon.c:142:2: warning: #warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO [-Wcpp]
     142 | #warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
         |  ^~~~~~~


vim +219 drivers/net/wireguard/send.c

e7096c131e5161 Jason A. Donenfeld 2019-12-09  161  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  162  static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
e7096c131e5161 Jason A. Donenfeld 2019-12-09  163  {
e7096c131e5161 Jason A. Donenfeld 2019-12-09  164  	unsigned int padding_len, plaintext_len, trailer_len;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  165  	struct scatterlist sg[MAX_SKB_FRAGS + 8];
e7096c131e5161 Jason A. Donenfeld 2019-12-09  166  	struct message_data *header;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  167  	struct sk_buff *trailer;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  168  	int num_frags;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  169  
c78a0b4a78839d Jason A. Donenfeld 2020-05-19  170  	/* Force hash calculation before encryption so that flow analysis is
c78a0b4a78839d Jason A. Donenfeld 2020-05-19  171  	 * consistent over the inner packet.
c78a0b4a78839d Jason A. Donenfeld 2020-05-19  172  	 */
c78a0b4a78839d Jason A. Donenfeld 2020-05-19  173  	skb_get_hash(skb);
c78a0b4a78839d Jason A. Donenfeld 2020-05-19  174  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  175  	/* Calculate lengths. */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  176  	padding_len = calculate_skb_padding(skb);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  177  	trailer_len = padding_len + noise_encrypted_len(0);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  178  	plaintext_len = skb->len + padding_len;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  179  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  180  	/* Expand data section to have room for padding and auth tag. */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  181  	num_frags = skb_cow_data(skb, trailer_len, &trailer);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  182  	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
e7096c131e5161 Jason A. Donenfeld 2019-12-09  183  		return false;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  184  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  185  	/* Set the padding to zeros, and make sure it and the auth tag are part
e7096c131e5161 Jason A. Donenfeld 2019-12-09  186  	 * of the skb.
e7096c131e5161 Jason A. Donenfeld 2019-12-09  187  	 */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  188  	memset(skb_tail_pointer(trailer), 0, padding_len);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  189  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  190  	/* Expand head section to have room for our header and the network
e7096c131e5161 Jason A. Donenfeld 2019-12-09  191  	 * stack's headers.
e7096c131e5161 Jason A. Donenfeld 2019-12-09  192  	 */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  193  	if (unlikely(skb_cow_head(skb, DATA_PACKET_HEAD_ROOM) < 0))
e7096c131e5161 Jason A. Donenfeld 2019-12-09  194  		return false;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  195  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  196  	/* Finalize checksum calculation for the inner packet, if required. */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  197  	if (unlikely(skb->ip_summed == CHECKSUM_PARTIAL &&
e7096c131e5161 Jason A. Donenfeld 2019-12-09  198  		     skb_checksum_help(skb)))
e7096c131e5161 Jason A. Donenfeld 2019-12-09  199  		return false;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  200  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  201  	/* Only after checksumming can we safely add on the padding at the end
e7096c131e5161 Jason A. Donenfeld 2019-12-09  202  	 * and the header.
e7096c131e5161 Jason A. Donenfeld 2019-12-09  203  	 */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  204  	skb_set_inner_network_header(skb, 0);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  205  	header = (struct message_data *)skb_push(skb, sizeof(*header));
e7096c131e5161 Jason A. Donenfeld 2019-12-09  206  	header->header.type = cpu_to_le32(MESSAGE_DATA);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  207  	header->key_idx = keypair->remote_index;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  208  	header->counter = cpu_to_le64(PACKET_CB(skb)->nonce);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  209  	pskb_put(skb, trailer, trailer_len);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  210  
e7096c131e5161 Jason A. Donenfeld 2019-12-09  211  	/* Now we can encrypt the scattergather segments */
e7096c131e5161 Jason A. Donenfeld 2019-12-09  212  	sg_init_table(sg, num_frags);
e7096c131e5161 Jason A. Donenfeld 2019-12-09  213  	if (skb_to_sgvec(skb, sg, sizeof(struct message_data),
e7096c131e5161 Jason A. Donenfeld 2019-12-09  214  			 noise_encrypted_len(plaintext_len)) <= 0)
e7096c131e5161 Jason A. Donenfeld 2019-12-09  215  		return false;
e7096c131e5161 Jason A. Donenfeld 2019-12-09  216  	return chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  217  						   PACKET_CB(skb)->nonce,
e7096c131e5161 Jason A. Donenfeld 2019-12-09  218  						   keypair->sending.key);
e7096c131e5161 Jason A. Donenfeld 2019-12-09 @219  }
e7096c131e5161 Jason A. Donenfeld 2019-12-09  220  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
