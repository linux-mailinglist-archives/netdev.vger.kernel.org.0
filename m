Return-Path: <netdev+bounces-5939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE0C57137C0
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 06:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57F7A280E95
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 04:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6186E366;
	Sun, 28 May 2023 04:52:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB764B
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 04:52:00 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407FAC3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 21:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685249518; x=1716785518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EnbXtQhNpzXuIjlq7kcao3OWpxiPFaXH7Guxvx3hVbY=;
  b=HdHQDj+c5lbDyScmdCGeH7ZoCQ1981ZHJUKadnaQOtzeemm3MN92RDVk
   +VTiUnD3lPWVVBa5EbFyBM4mMEl5bckMoSQ0SFpniiXKF6x6nEInrkQue
   4+X6EFExElUFyqQ0To71uvmARTGhnfDDJiKMvWoYTWo30xMhmmmHHhH07
   A5ATMSbnevLqdKx/LLlgkg899MoOy/IkypU6eLVA3386PK/6JS7G8fE2F
   UHFqFbaqnfvKV8GuDGd3YBhBqj7rxP9qJYlsKRZitT6DPbzDqzWQplJI1
   6LDX7qHVzhsuHa1tZcXAetnu0meXTRvXZU5oBp49EBi25CEpbv5Dcd3vh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="357731519"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="357731519"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 21:51:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="708841576"
X-IronPort-AV: E=Sophos;i="6.00,198,1681196400"; 
   d="scan'208";a="708841576"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 27 May 2023 21:51:55 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q38Nm-000KRO-1s;
	Sun, 28 May 2023 04:51:54 +0000
Date: Sun, 28 May 2023 12:50:55 +0800
From: kernel test robot <lkp@intel.com>
To: Tristram.Ha@microchip.com, "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <202305281254.hziqmfSD-lkp@intel.com>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tristram-Ha-microchip-com/net-phy-smsc-add-WoL-support-to-LAN8740-LAN8742-PHYs/20230527-094102
base:   net-next/main
patch link:    https://lore.kernel.org/r/1685151574-2752-1-git-send-email-Tristram.Ha%40microchip.com
patch subject: [PATCH net-next] net: phy: smsc: add WoL support to LAN8740/LAN8742 PHYs.
config: i386-randconfig-s002-20230528 (https://download.01.org/0day-ci/archive/20230528/202305281254.hziqmfSD-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/a1e40c5a7a32445d5ae4541d4e57bbc4b5065057
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tristram-Ha-microchip-com/net-phy-smsc-add-WoL-support-to-LAN8740-LAN8742-PHYs/20230527-094102
        git checkout a1e40c5a7a32445d5ae4541d4e57bbc4b5065057
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 olddefconfig
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305281254.hziqmfSD-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/net/phy/smsc.c:449:27: sparse: sparse: cast removes address space '__rcu' of expression
>> drivers/net/phy/smsc.c:485:38: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct list_head *addr_list @@     got struct list_head [noderef] __rcu * @@
   drivers/net/phy/smsc.c:485:38: sparse:     expected struct list_head *addr_list
   drivers/net/phy/smsc.c:485:38: sparse:     got struct list_head [noderef] __rcu *
>> drivers/net/phy/smsc.c:449:45: sparse: sparse: dereference of noderef expression

vim +/__rcu +449 drivers/net/phy/smsc.c

   398	
   399	static int lan874x_set_wol(struct phy_device *phydev,
   400				   struct ethtool_wolinfo *wol)
   401	{
   402		struct net_device *ndev = phydev->attached_dev;
   403		struct smsc_phy_priv *priv = phydev->priv;
   404		u16 val, val_wucsr;
   405		u8 data[128];
   406		u8 datalen;
   407		int rc;
   408	
   409		if (wol->wolopts & WAKE_PHY)
   410			return -EOPNOTSUPP;
   411	
   412		/* lan874x has only one WoL filter pattern */
   413		if ((wol->wolopts & (WAKE_ARP | WAKE_MCAST)) ==
   414		    (WAKE_ARP | WAKE_MCAST)) {
   415			phydev_info(phydev,
   416				    "lan874x WoL supports one of ARP|MCAST at a time\n");
   417			return -EOPNOTSUPP;
   418		}
   419	
   420		rc = phy_read_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR);
   421		if (rc < 0)
   422			return rc;
   423	
   424		val_wucsr = rc;
   425	
   426		if (wol->wolopts & WAKE_UCAST)
   427			val_wucsr |= MII_LAN874X_PHY_WOL_PFDAEN;
   428		else
   429			val_wucsr &= ~MII_LAN874X_PHY_WOL_PFDAEN;
   430	
   431		if (wol->wolopts & WAKE_BCAST)
   432			val_wucsr |= MII_LAN874X_PHY_WOL_BCSTEN;
   433		else
   434			val_wucsr &= ~MII_LAN874X_PHY_WOL_BCSTEN;
   435	
   436		if (wol->wolopts & WAKE_MAGIC)
   437			val_wucsr |= MII_LAN874X_PHY_WOL_MPEN;
   438		else
   439			val_wucsr &= ~MII_LAN874X_PHY_WOL_MPEN;
   440	
   441		/* Need to use pattern matching */
   442		if (wol->wolopts & (WAKE_ARP | WAKE_MCAST))
   443			val_wucsr |= MII_LAN874X_PHY_WOL_WUEN;
   444		else
   445			val_wucsr &= ~MII_LAN874X_PHY_WOL_WUEN;
   446	
   447		if (wol->wolopts & WAKE_ARP) {
   448			const u8 *ip_addr =
 > 449				((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);
   450			const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };
   451			u8 pattern[42] = {
   452				0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
   453				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   454				0x08, 0x06,
   455				0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
   456				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   457				0x00, 0x00, 0x00, 0x00,
   458				0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
   459				0x00, 0x00, 0x00, 0x00 };
   460			u8 len = 42;
   461	
   462			memcpy(&pattern[38], ip_addr, 4);
   463			rc = lan874x_chk_wol_pattern(pattern, mask, len,
   464						     data, &datalen);
   465			if (rc)
   466				phydev_dbg(phydev, "pattern not valid at %d\n", rc);
   467	
   468			/* Need to match broadcast destination address. */
   469			val = MII_LAN874X_PHY_WOL_FILTER_BCSTEN;
   470			rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
   471						     len);
   472			if (rc < 0)
   473				return rc;
   474			priv->wol_arp = true;
   475		}
   476	
   477		if (wol->wolopts & WAKE_MCAST) {
   478			u8 pattern[6] = { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };
   479			u16 mask[1] = { 0x0007 };
   480			u8 len = 3;
   481	
   482			/* Try to match IPv6 Neighbor Solicitation. */
   483			if (ndev->ip6_ptr) {
   484				struct list_head *addr_list =
 > 485					&ndev->ip6_ptr->addr_list;
   486				struct inet6_ifaddr *ifa;
   487	
   488				list_for_each_entry(ifa, addr_list, if_list) {
   489					if (ifa->scope == IFA_LINK) {
   490						memcpy(&pattern[3],
   491						       &ifa->addr.in6_u.u6_addr8[13],
   492						       3);
   493						mask[0] = 0x003F;
   494						len = 6;
   495						break;
   496					}
   497				}
   498			}
   499			rc = lan874x_chk_wol_pattern(pattern, mask, len,
   500						     data, &datalen);
   501			if (rc)
   502				phydev_dbg(phydev, "pattern not valid at %d\n", rc);
   503	
   504			/* Need to match multicast destination address. */
   505			val = MII_LAN874X_PHY_WOL_FILTER_MCASTTEN;
   506			rc = lan874x_set_wol_pattern(phydev, val, data, datalen, mask,
   507						     len);
   508			if (rc < 0)
   509				return rc;
   510			priv->wol_arp = false;
   511		}
   512	
   513		if (wol->wolopts & (WAKE_MAGIC | WAKE_UCAST)) {
   514			const u8 *mac = (const u8 *)ndev->dev_addr;
   515	
   516			if (!is_valid_ether_addr(mac))
   517				return -EINVAL;
   518	
   519			rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
   520					   MII_LAN874X_PHY_MMD_WOL_RX_ADDRC,
   521					   ((mac[1] << 8) | mac[0]));
   522			if (rc < 0)
   523				return rc;
   524	
   525			rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
   526					   MII_LAN874X_PHY_MMD_WOL_RX_ADDRB,
   527					   ((mac[3] << 8) | mac[2]));
   528			if (rc < 0)
   529				return rc;
   530	
   531			rc = phy_write_mmd(phydev, MDIO_MMD_PCS,
   532					   MII_LAN874X_PHY_MMD_WOL_RX_ADDRA,
   533					   ((mac[5] << 8) | mac[4]));
   534			if (rc < 0)
   535				return rc;
   536		}
   537	
   538		rc = phy_write_mmd(phydev, MDIO_MMD_PCS, MII_LAN874X_PHY_MMD_WOL_WUCSR,
   539				   val_wucsr);
   540		if (rc < 0)
   541			return rc;
   542	
   543		return 0;
   544	}
   545	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

