Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07A4D764C
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 16:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiCMPSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 11:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiCMPSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 11:18:09 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B6D95493
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 08:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647184621; x=1678720621;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=usJ+MTImhmt6Bp+jzQfYh9cK4L+hspgYtVh4nIpJigk=;
  b=dR24hGs6xc99N5W/E135KUfKrXtpOAoVFjZ/gQ+befL+rTuO3wrl7FUa
   Pqmmk08hVVqAFCS4tSilVDBYxafGnczIsc5+DGt0ev42xD1y/DJ9jwR/G
   R1PKzdFd4GeGi/mZs9McXv43YwyTBSm/uE1jcgUPEZhx7LJaDzVF8alSj
   9q9dv6pnTKKA/IMRa8blu/1j91Xo0NlXm9QfXopuhO5BWYO8ql5t+zYqi
   yoDReGER+cPxL7RYc373gvSoNsTZydNmZ+G2VH9HdbtD11MSYh6Tk4EMt
   EhXK4I2X4CUMuj2XskjA7x2+fmgPBkuxyG2oT5gYkyjtD3MOnujMmB8Pc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="256064092"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="256064092"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 08:17:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="515124304"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 13 Mar 2022 08:16:59 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nTPxq-000945-Tl; Sun, 13 Mar 2022 15:16:58 +0000
Date:   Sun, 13 Mar 2022 23:16:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [net-next:master 61/103] drivers/net/gtp.c:1796
 gtp_genl_send_echo_req() warn: inconsistent indenting
Message-ID: <202203132318.O9ONpE9d-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   de29aff976d3216e7f3ab41fcd7af46fa8f7eab7
commit: d33bd757d362699cfce3c68b53cd12b947d196f4 [61/103] gtp: Implement GTP echo request
config: riscv-randconfig-m031-20220313 (https://download.01.org/0day-ci/archive/20220313/202203132318.O9ONpE9d-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

New smatch warnings:
drivers/net/gtp.c:1796 gtp_genl_send_echo_req() warn: inconsistent indenting

Old smatch warnings:
include/linux/skbuff.h:3122 __netdev_alloc_skb_ip_align() warn: should this be a bitwise op?

vim +1796 drivers/net/gtp.c

  1722	
  1723	static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
  1724	{
  1725		struct sk_buff *skb_to_send;
  1726		__be32 src_ip, dst_ip;
  1727		unsigned int version;
  1728		struct gtp_dev *gtp;
  1729		struct flowi4 fl4;
  1730		struct rtable *rt;
  1731		struct sock *sk;
  1732		__be16 port;
  1733		int len;
  1734	
  1735		if (!info->attrs[GTPA_VERSION] ||
  1736		    !info->attrs[GTPA_LINK] ||
  1737		    !info->attrs[GTPA_PEER_ADDRESS] ||
  1738		    !info->attrs[GTPA_MS_ADDRESS])
  1739			return -EINVAL;
  1740	
  1741		version = nla_get_u32(info->attrs[GTPA_VERSION]);
  1742		dst_ip = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
  1743		src_ip = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
  1744	
  1745		gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
  1746		if (!gtp)
  1747			return -ENODEV;
  1748	
  1749		if (!gtp->sk_created)
  1750			return -EOPNOTSUPP;
  1751		if (!(gtp->dev->flags & IFF_UP))
  1752			return -ENETDOWN;
  1753	
  1754		if (version == GTP_V0) {
  1755			struct gtp0_header *gtp0_h;
  1756	
  1757			len = LL_RESERVED_SPACE(gtp->dev) + sizeof(struct gtp0_header) +
  1758				sizeof(struct iphdr) + sizeof(struct udphdr);
  1759	
  1760			skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
  1761			if (!skb_to_send)
  1762				return -ENOMEM;
  1763	
  1764			sk = gtp->sk0;
  1765			port = htons(GTP0_PORT);
  1766	
  1767			gtp0_h = skb_push(skb_to_send, sizeof(struct gtp0_header));
  1768			memset(gtp0_h, 0, sizeof(struct gtp0_header));
  1769			gtp0_build_echo_msg(gtp0_h, GTP_ECHO_REQ);
  1770		} else if (version == GTP_V1) {
  1771			struct gtp1_header_long *gtp1u_h;
  1772	
  1773			len = LL_RESERVED_SPACE(gtp->dev) +
  1774				sizeof(struct gtp1_header_long) +
  1775				sizeof(struct iphdr) + sizeof(struct udphdr);
  1776	
  1777			skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
  1778			if (!skb_to_send)
  1779				return -ENOMEM;
  1780	
  1781			sk = gtp->sk1u;
  1782			port = htons(GTP1U_PORT);
  1783	
  1784			gtp1u_h = skb_push(skb_to_send,
  1785					   sizeof(struct gtp1_header_long));
  1786			memset(gtp1u_h, 0, sizeof(struct gtp1_header_long));
  1787			gtp1u_build_echo_msg(gtp1u_h, GTP_ECHO_REQ);
  1788		} else {
  1789			return -ENODEV;
  1790		}
  1791	
  1792		rt = ip4_route_output_gtp(&fl4, sk, dst_ip, src_ip);
  1793		if (IS_ERR(rt)) {
  1794			netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
  1795				   &dst_ip);
> 1796				   kfree_skb(skb_to_send);
  1797			return -ENODEV;
  1798		}
  1799	
  1800		udp_tunnel_xmit_skb(rt, sk, skb_to_send,
  1801				    fl4.saddr, fl4.daddr,
  1802				    fl4.flowi4_tos,
  1803				    ip4_dst_hoplimit(&rt->dst),
  1804				    0,
  1805				    port, port,
  1806				    !net_eq(sock_net(sk),
  1807					    dev_net(gtp->dev)),
  1808				    false);
  1809		return 0;
  1810	}
  1811	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
