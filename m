Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B02A1FF
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 02:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfEYAIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 20:08:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:57462 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfEYAIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 20:08:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 17:08:37 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 24 May 2019 17:08:36 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hUKEm-0004ms-4K; Sat, 25 May 2019 08:08:36 +0800
Date:   Sat, 25 May 2019 08:08:23 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org
Subject: [net-next:master 86/94]
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:127:26: sparse:
 sparse: incorrect type in assignment (different base types)
Message-ID: <201905250819.rXBikZsC%lkp@intel.com>
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
head:   22942498ccebf13b076859f8746be161dc0c6d89
commit: 091810dbded96c2af81f645e386e4262553e3493 [86/94] net: stmmac: Introduce selftests support
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        git checkout 091810dbded96c2af81f645e386e4262553e3493
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:127:26: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
>> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:127:26: sparse:    expected unsigned short [usertype]
>> drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:127:26: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:128:24: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:128:24: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:128:24: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:129:24: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:129:24: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:129:24: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:131:34: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:131:34: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:131:34: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:132:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:132:32: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:132:32: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:133:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:133:32: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:133:32: sparse:    got restricted __be16 [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:134:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:134:32: sparse:    expected unsigned short [usertype]
   drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:134:32: sparse:    got restricted __be16 [usertype]

vim +127 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c

    49	
    50	static struct sk_buff *stmmac_test_get_udp_skb(struct stmmac_priv *priv,
    51						       struct stmmac_packet_attrs *attr)
    52	{
    53		struct sk_buff *skb = NULL;
    54		struct udphdr *uhdr = NULL;
    55		struct tcphdr *thdr = NULL;
    56		struct stmmachdr *shdr;
    57		struct ethhdr *ehdr;
    58		struct iphdr *ihdr;
    59		int iplen, size;
    60	
    61		size = attr->size + STMMAC_TEST_PKT_SIZE;
    62		if (attr->vlan) {
    63			size += 4;
    64			if (attr->vlan > 1)
    65				size += 4;
    66		}
    67	
    68		if (attr->tcp)
    69			size += sizeof(struct tcphdr);
    70		else
    71			size += sizeof(struct udphdr);
    72	
    73		skb = netdev_alloc_skb(priv->dev, size);
    74		if (!skb)
    75			return NULL;
    76	
    77		prefetchw(skb->data);
    78		skb_reserve(skb, NET_IP_ALIGN);
    79	
    80		if (attr->vlan > 1)
    81			ehdr = skb_push(skb, ETH_HLEN + 8);
    82		else if (attr->vlan)
    83			ehdr = skb_push(skb, ETH_HLEN + 4);
    84		else if (attr->remove_sa)
    85			ehdr = skb_push(skb, ETH_HLEN - 6);
    86		else
    87			ehdr = skb_push(skb, ETH_HLEN);
    88		skb_reset_mac_header(skb);
    89	
    90		skb_set_network_header(skb, skb->len);
    91		ihdr = skb_put(skb, sizeof(*ihdr));
    92	
    93		skb_set_transport_header(skb, skb->len);
    94		if (attr->tcp)
    95			thdr = skb_put(skb, sizeof(*thdr));
    96		else
    97			uhdr = skb_put(skb, sizeof(*uhdr));
    98	
    99		if (!attr->remove_sa)
   100			eth_zero_addr(ehdr->h_source);
   101		eth_zero_addr(ehdr->h_dest);
   102		if (attr->src && !attr->remove_sa)
   103			ether_addr_copy(ehdr->h_source, attr->src);
   104		if (attr->dst)
   105			ether_addr_copy(ehdr->h_dest, attr->dst);
   106	
   107		if (!attr->remove_sa) {
   108			ehdr->h_proto = htons(ETH_P_IP);
   109		} else {
   110			__be16 *ptr = (__be16 *)ehdr;
   111	
   112			/* HACK */
   113			ptr[3] = htons(ETH_P_IP);
   114		}
   115	
   116		if (attr->vlan) {
   117			u16 *tag, *proto;
   118	
   119			if (!attr->remove_sa) {
   120				tag = (void *)ehdr + ETH_HLEN;
   121				proto = (void *)ehdr + (2 * ETH_ALEN);
   122			} else {
   123				tag = (void *)ehdr + ETH_HLEN - 6;
   124				proto = (void *)ehdr + ETH_ALEN;
   125			}
   126	
 > 127			proto[0] = htons(ETH_P_8021Q);
   128			tag[0] = htons(attr->vlan_id_out);
   129			tag[1] = htons(ETH_P_IP);
   130			if (attr->vlan > 1) {
   131				proto[0] = htons(ETH_P_8021AD);
   132				tag[1] = htons(ETH_P_8021Q);
   133				tag[2] = htons(attr->vlan_id_in);
   134				tag[3] = htons(ETH_P_IP);
   135			}
   136		}
   137	
   138		if (attr->tcp) {
   139			thdr->source = htons(attr->sport);
   140			thdr->dest = htons(attr->dport);
   141			thdr->doff = sizeof(struct tcphdr) / 4;
   142			thdr->check = 0;
   143		} else {
   144			uhdr->source = htons(attr->sport);
   145			uhdr->dest = htons(attr->dport);
   146			uhdr->len = htons(sizeof(*shdr) + sizeof(*uhdr) + attr->size);
   147			uhdr->check = 0;
   148		}
   149	
   150		ihdr->ihl = 5;
   151		ihdr->ttl = 32;
   152		ihdr->version = 4;
   153		if (attr->tcp)
   154			ihdr->protocol = IPPROTO_TCP;
   155		else
   156			ihdr->protocol = IPPROTO_UDP;
   157		iplen = sizeof(*ihdr) + sizeof(*shdr) + attr->size;
   158		if (attr->tcp)
   159			iplen += sizeof(*thdr);
   160		else
   161			iplen += sizeof(*uhdr);
   162		ihdr->tot_len = htons(iplen);
   163		ihdr->frag_off = 0;
   164		ihdr->saddr = 0;
   165		ihdr->daddr = htonl(attr->ip_dst);
   166		ihdr->tos = 0;
   167		ihdr->id = 0;
   168		ip_send_check(ihdr);
   169	
   170		shdr = skb_put(skb, sizeof(*shdr));
   171		shdr->version = 0;
   172		shdr->magic = cpu_to_be64(STMMAC_TEST_PKT_MAGIC);
   173		attr->id = stmmac_test_next_id;
   174		shdr->id = stmmac_test_next_id++;
   175	
   176		if (attr->size)
   177			skb_put(skb, attr->size);
   178	
   179		skb->csum = 0;
   180		skb->ip_summed = CHECKSUM_PARTIAL;
   181		if (attr->tcp) {
   182			thdr->check = ~tcp_v4_check(skb->len, ihdr->saddr, ihdr->daddr, 0);
   183			skb->csum_start = skb_transport_header(skb) - skb->head;
   184			skb->csum_offset = offsetof(struct tcphdr, check);
   185		} else {
   186			udp4_hwcsum(skb, ihdr->saddr, ihdr->daddr);
   187		}
   188	
   189		skb->protocol = htons(ETH_P_IP);
   190		skb->pkt_type = PACKET_HOST;
   191		skb->dev = priv->dev;
   192	
   193		return skb;
   194	}
   195	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
