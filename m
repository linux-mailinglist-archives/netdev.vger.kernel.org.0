Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53F6E2483
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjDNNog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDNNof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:44:35 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FF3E4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681479874; x=1713015874;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rY1i2jCNOFyhxxStFDTJ1f292hh8THV7Or9esFomxwE=;
  b=iAFTSOa66eiJp3kvxtQdKca+Shde9ZM2E5unWN0ULP6khNf55FcdVp3R
   oXlPH28GygFENpIS9il8fXMsK9qVepom5bidl0ap2RGyvSIF51KK9ttfA
   Nf76A9askhWvOmNxEnFWFOxXThUtqDndMDKWXhv6jkEWx30fL3ELjEH2R
   0xo2GiA+wWure86dH4rEb7jJqMLU1YNxSusFRGsG7RopFNIRX2rK39xT+
   lTQzbQRSTeeBQ5kXCITIq7mkvvm6lwYc1DiZAowkxlsTE4FlilG4Rh5r4
   gKHSj+/bQ/LKYaj4ICZ4/SFavIPVTjTQm5Zbrialq2vtjrRWRVVUe+BBP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="407339147"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="407339147"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 06:44:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="936014654"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="936014654"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2023 06:44:32 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pnJj5-000Za9-20;
        Fri, 14 Apr 2023 13:44:31 +0000
Date:   Fri, 14 Apr 2023 21:43:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, jiawenwu@trustnetic.com,
        mengyuanlou <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next 1/5] net: wangxun: libwx add tx offload functions
Message-ID: <202304142124.tgNMARJh-lkp@intel.com>
References: <20230414104833.42989-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414104833.42989-2-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mengyuan,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Mengyuan-Lou/net-wangxun-libwx-add-tx-offload-functions/20230414-185326
patch link:    https://lore.kernel.org/r/20230414104833.42989-2-mengyuanlou%40net-swift.com
patch subject: [PATCH net-next 1/5] net: wangxun: libwx add tx offload functions
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20230414/202304142124.tgNMARJh-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/ca12bb428f738ec21104d37ed1a3944dc33e1121
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mengyuan-Lou/net-wangxun-libwx-add-tx-offload-functions/20230414-185326
        git checkout ca12bb428f738ec21104d37ed1a3944dc33e1121
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/wangxun/libwx/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304142124.tgNMARJh-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/libwx/wx_lib.c: In function 'wx_tso':
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:1118:22: error: implicit declaration of function 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'? [-Werror=implicit-function-declaration]
    1118 |                     ~csum_ipv6_magic(&ipv6h->saddr,
         |                      ^~~~~~~~~~~~~~~
         |                      csum_tcpudp_magic
   cc1: some warnings being treated as errors


vim +1118 drivers/net/ethernet/wangxun/libwx/wx_lib.c

  1074	
  1075	static int wx_tso(struct wx_ring *tx_ring, struct wx_tx_buffer *first,
  1076			  u8 *hdr_len, wx_dptype dptype)
  1077	{
  1078		u32 vlan_macip_lens, type_tucmd, mss_l4len_idx;
  1079		struct net_device *netdev = tx_ring->netdev;
  1080		struct sk_buff *skb = first->skb;
  1081		u32 l4len, tunhdr_eiplen_tunlen;
  1082		bool enc = skb->encapsulation;
  1083		struct ipv6hdr *ipv6h;
  1084		struct tcphdr *tcph;
  1085		struct iphdr *iph;
  1086		u8 tun_prot = 0;
  1087		int err;
  1088	
  1089		if (skb->ip_summed != CHECKSUM_PARTIAL)
  1090			return 0;
  1091	
  1092		if (!skb_is_gso(skb))
  1093			return 0;
  1094	
  1095		err = skb_cow_head(skb, 0);
  1096		if (err < 0)
  1097			return err;
  1098	
  1099		/* indicates the inner headers in the skbuff are valid. */
  1100		iph = enc ? inner_ip_hdr(skb) : ip_hdr(skb);
  1101		if (iph->version == 4) {
  1102			tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
  1103			iph->tot_len = 0;
  1104			iph->check = 0;
  1105			tcph->check = ~csum_tcpudp_magic(iph->saddr,
  1106							iph->daddr, 0,
  1107							IPPROTO_TCP,
  1108							0);
  1109			first->tx_flags |= WX_TX_FLAGS_TSO |
  1110					   WX_TX_FLAGS_CSUM |
  1111					   WX_TX_FLAGS_IPV4 |
  1112					   WX_TX_FLAGS_CC;
  1113		} else if (iph->version == 6 && skb_is_gso_v6(skb)) {
  1114			ipv6h = enc ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
  1115			tcph = enc ? inner_tcp_hdr(skb) : tcp_hdr(skb);
  1116			ipv6h->payload_len = 0;
  1117			tcph->check =
> 1118			    ~csum_ipv6_magic(&ipv6h->saddr,
  1119					     &ipv6h->daddr,
  1120					     0, IPPROTO_TCP, 0);
  1121			first->tx_flags |= WX_TX_FLAGS_TSO |
  1122					   WX_TX_FLAGS_CSUM |
  1123					   WX_TX_FLAGS_CC;
  1124		}
  1125	
  1126		/* compute header lengths */
  1127		l4len = enc ? inner_tcp_hdrlen(skb) : tcp_hdrlen(skb);
  1128		*hdr_len = enc ? (skb_inner_transport_header(skb) - skb->data)
  1129			       : skb_transport_offset(skb);
  1130		*hdr_len += l4len;
  1131	
  1132		/* update gso size and bytecount with header size */
  1133		first->gso_segs = skb_shinfo(skb)->gso_segs;
  1134		first->bytecount += (first->gso_segs - 1) * *hdr_len;
  1135	
  1136		/* mss_l4len_id: use 0 as index for TSO */
  1137		mss_l4len_idx = l4len << WX_TXD_L4LEN_SHIFT;
  1138		mss_l4len_idx |= skb_shinfo(skb)->gso_size << WX_TXD_MSS_SHIFT;
  1139	
  1140		/* vlan_macip_lens: HEADLEN, MACLEN, VLAN tag */
  1141		if (enc) {
  1142			switch (first->protocol) {
  1143			case htons(ETH_P_IP):
  1144				tun_prot = ip_hdr(skb)->protocol;
  1145				first->tx_flags |= WX_TX_FLAGS_OUTER_IPV4;
  1146				break;
  1147			case htons(ETH_P_IPV6):
  1148				tun_prot = ipv6_hdr(skb)->nexthdr;
  1149				break;
  1150			default:
  1151				break;
  1152			}
  1153			switch (tun_prot) {
  1154			case IPPROTO_UDP:
  1155				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_UDP;
  1156				tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
  1157							 WX_TXD_OUTER_IPLEN_SHIFT) |
  1158							(((skb_inner_mac_header(skb) -
  1159							skb_transport_header(skb)) >> 1) <<
  1160							WX_TXD_TUNNEL_LEN_SHIFT);
  1161				break;
  1162			case IPPROTO_GRE:
  1163				tunhdr_eiplen_tunlen = WX_TXD_TUNNEL_GRE;
  1164				tunhdr_eiplen_tunlen |= ((skb_network_header_len(skb) >> 2) <<
  1165							 WX_TXD_OUTER_IPLEN_SHIFT) |
  1166							(((skb_inner_mac_header(skb) -
  1167							skb_transport_header(skb)) >> 1) <<
  1168							WX_TXD_TUNNEL_LEN_SHIFT);
  1169				break;
  1170			case IPPROTO_IPIP:
  1171				tunhdr_eiplen_tunlen = (((char *)inner_ip_hdr(skb) -
  1172							(char *)ip_hdr(skb)) >> 2) <<
  1173							WX_TXD_OUTER_IPLEN_SHIFT;
  1174				break;
  1175			default:
  1176				break;
  1177			}
  1178			vlan_macip_lens = skb_inner_network_header_len(skb) >> 1;
  1179		} else {
  1180			vlan_macip_lens = skb_network_header_len(skb) >> 1;
  1181		}
  1182	
  1183		vlan_macip_lens |= skb_network_offset(skb) << WX_TXD_MACLEN_SHIFT;
  1184		vlan_macip_lens |= first->tx_flags & WX_TX_FLAGS_VLAN_MASK;
  1185	
  1186		type_tucmd = dptype.ptype << 24;
  1187		if (skb->vlan_proto == htons(ETH_P_8021AD) &&
  1188		    netdev->features & NETIF_F_HW_VLAN_STAG_TX)
  1189			type_tucmd |= WX_SET_FLAG(first->tx_flags,
  1190						  WX_TX_FLAGS_HW_VLAN,
  1191						  0x1 << WX_TXD_TAG_TPID_SEL_SHIFT);
  1192		wx_tx_ctxtdesc(tx_ring, vlan_macip_lens, tunhdr_eiplen_tunlen,
  1193			       type_tucmd, mss_l4len_idx);
  1194	
  1195		return 1;
  1196	}
  1197	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
