Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F3139703D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhFAJYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:24:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:18036 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhFAJYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:24:31 -0400
IronPort-SDR: etfe8Ueiz6v6ha9lLblMI9nRntD0QY14eSXLfKGmOM+r6QnXbzbN572X4uJwflJYBskC4OcakI
 m1NULB+/Vv4g==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="201641229"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="gz'50?scan'50,208,50";a="201641229"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 02:22:50 -0700
IronPort-SDR: Qd9Rh7CtUjVM9iEKl0SO33fJcy9epIyoe3KfML6XcLA4LbmX7xMz+Km64Hef5O1HACr8ftOuce
 KV045hwd842g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="gz'50?scan'50,208,50";a="399235822"
Received: from lkp-server02.sh.intel.com (HELO 1ec8406c5392) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 01 Jun 2021 02:22:47 -0700
Received: from kbuild by 1ec8406c5392 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lo0bm-0005B1-EE; Tue, 01 Jun 2021 09:22:46 +0000
Date:   Tue, 1 Jun 2021 17:22:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jdmason@kudzu.us,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: Re: [PATCH net-next] net: vxge: Remove unused variable
Message-ID: <202106011706.JoWDF6pK-lkp@intel.com>
References: <20210601074744.4079327-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210601074744.4079327-1-zhengyongjun3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Zheng,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Zheng-Yongjun/net-vxge-Remove-unused-variable/20210601-153524
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 44fdd2edb36f0da66758cd355840d357078110fe
config: x86_64-randconfig-a012-20210601 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/3d8621406ca0701d83af93a9b4deec4112ccb616
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Zheng-Yongjun/net-vxge-Remove-unused-variable/20210601-153524
        git checkout 3d8621406ca0701d83af93a9b4deec4112ccb616
        # save the attached .config to linux build tree
        make W=1 ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/neterion/vxge/vxge-main.c: In function 'do_vxge_reset':
>> drivers/net/ethernet/neterion/vxge/vxge-main.c:1711:3: error: 'status' undeclared (first use in this function); did you mean 'kstatfs'?
    1711 |   status = vxge_reset_all_vpaths(vdev);
         |   ^~~~~~
         |   kstatfs
   drivers/net/ethernet/neterion/vxge/vxge-main.c:1711:3: note: each undeclared identifier is reported only once for each function it appears in


vim +1711 drivers/net/ethernet/neterion/vxge/vxge-main.c

16fded7da2cefc drivers/net/vxge/vxge-main.c Jon Mason       2011-01-18  1606  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1607  static int do_vxge_reset(struct vxgedev *vdev, int event)
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1608  {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1609  	int ret = 0, vp_id, i;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1610  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1611  	vxge_debug_entryexit(VXGE_TRACE, "%s:%d", __func__, __LINE__);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1612  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1613  	if ((event == VXGE_LL_FULL_RESET) || (event == VXGE_LL_START_RESET)) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1614  		/* check if device is down already */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1615  		if (unlikely(!is_vxge_card_up(vdev)))
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1616  			return 0;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1617  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1618  		/* is reset already scheduled */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1619  		if (test_and_set_bit(__VXGE_STATE_RESET_CARD, &vdev->state))
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1620  			return 0;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1621  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1622  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1623  	if (event == VXGE_LL_FULL_RESET) {
2e41f6449c561e drivers/net/vxge/vxge-main.c Jon Mason       2010-12-10  1624  		netif_carrier_off(vdev->ndev);
2e41f6449c561e drivers/net/vxge/vxge-main.c Jon Mason       2010-12-10  1625  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1626  		/* wait for all the vpath reset to complete */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1627  		for (vp_id = 0; vp_id < vdev->no_of_vpath; vp_id++) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1628  			while (test_bit(vp_id, &vdev->vp_reset))
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1629  				msleep(50);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1630  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1631  
2e41f6449c561e drivers/net/vxge/vxge-main.c Jon Mason       2010-12-10  1632  		netif_carrier_on(vdev->ndev);
2e41f6449c561e drivers/net/vxge/vxge-main.c Jon Mason       2010-12-10  1633  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1634  		/* if execution mode is set to debug, don't reset the adapter */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1635  		if (unlikely(vdev->exec_mode)) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1636  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1637  				"%s: execution mode is debug, returning..",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1638  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1639  			clear_bit(__VXGE_STATE_CARD_UP, &vdev->state);
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1640  			netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1641  			return 0;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1642  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1643  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1644  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1645  	if (event == VXGE_LL_FULL_RESET) {
4d2a5b406c02b2 drivers/net/vxge/vxge-main.c Jon Mason       2010-11-11  1646  		vxge_hw_device_wait_receive_idle(vdev->devh);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1647  		vxge_hw_device_intr_disable(vdev->devh);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1648  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1649  		switch (vdev->cric_err_event) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1650  		case VXGE_HW_EVENT_UNKNOWN:
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1651  			netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1652  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1653  				"fatal: %s: Disabling device due to"
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1654  				"unknown error",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1655  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1656  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1657  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1658  		case VXGE_HW_EVENT_RESET_START:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1659  			break;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1660  		case VXGE_HW_EVENT_RESET_COMPLETE:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1661  		case VXGE_HW_EVENT_LINK_DOWN:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1662  		case VXGE_HW_EVENT_LINK_UP:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1663  		case VXGE_HW_EVENT_ALARM_CLEARED:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1664  		case VXGE_HW_EVENT_ECCERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1665  		case VXGE_HW_EVENT_MRPCIM_ECCERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1666  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1667  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1668  		case VXGE_HW_EVENT_FIFO_ERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1669  		case VXGE_HW_EVENT_VPATH_ERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1670  			break;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1671  		case VXGE_HW_EVENT_CRITICAL_ERR:
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1672  			netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1673  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1674  				"fatal: %s: Disabling device due to"
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1675  				"serious error",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1676  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1677  			/* SOP or device reset required */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1678  			/* This event is not currently used */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1679  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1680  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1681  		case VXGE_HW_EVENT_SERR:
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1682  			netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1683  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1684  				"fatal: %s: Disabling device due to"
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1685  				"serious error",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1686  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1687  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1688  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1689  		case VXGE_HW_EVENT_SRPCIM_SERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1690  		case VXGE_HW_EVENT_MRPCIM_SERR:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1691  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1692  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1693  		case VXGE_HW_EVENT_SLOT_FREEZE:
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1694  			netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1695  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1696  				"fatal: %s: Disabling device due to"
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1697  				"slot freeze",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1698  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1699  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1700  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1701  		default:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1702  			break;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1703  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1704  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1705  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1706  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1707  	if ((event == VXGE_LL_FULL_RESET) || (event == VXGE_LL_START_RESET))
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1708  		netif_tx_stop_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1709  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1710  	if (event == VXGE_LL_FULL_RESET) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01 @1711  		status = vxge_reset_all_vpaths(vdev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1712  		if (status != VXGE_HW_OK) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1713  			vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1714  				"fatal: %s: can not reset vpaths",
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1715  				vdev->ndev->name);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1716  			ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1717  			goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1718  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1719  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1720  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1721  	if (event == VXGE_LL_COMPL_RESET) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1722  		for (i = 0; i < vdev->no_of_vpath; i++)
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1723  			if (vdev->vpaths[i].handle) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1724  				if (vxge_hw_vpath_recover_from_reset(
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1725  					vdev->vpaths[i].handle)
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1726  						!= VXGE_HW_OK) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1727  					vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1728  						"vxge_hw_vpath_recover_"
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1729  						"from_reset failed for vpath: "
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1730  						"%d", i);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1731  					ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1732  					goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1733  				}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1734  				} else {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1735  					vxge_debug_init(VXGE_ERR,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1736  					"vxge_hw_vpath_reset failed for "
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1737  						"vpath:%d", i);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1738  					ret = -EPERM;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1739  					goto out;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1740  				}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1741  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1742  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1743  	if ((event == VXGE_LL_FULL_RESET) || (event == VXGE_LL_COMPL_RESET)) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1744  		/* Reprogram the DA table with populated mac addresses */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1745  		for (vp_id = 0; vp_id < vdev->no_of_vpath; vp_id++) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1746  			vxge_restore_vpath_mac_addr(&vdev->vpaths[vp_id]);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1747  			vxge_restore_vpath_vid_table(&vdev->vpaths[vp_id]);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1748  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1749  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1750  		/* enable vpath interrupts */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1751  		for (i = 0; i < vdev->no_of_vpath; i++)
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1752  			vxge_vpath_intr_enable(vdev, i);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1753  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1754  		vxge_hw_device_intr_enable(vdev->devh);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1755  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1756  		smp_wmb();
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1757  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1758  		/* Indicate card up */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1759  		set_bit(__VXGE_STATE_CARD_UP, &vdev->state);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1760  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1761  		/* Get the traffic to flow through the vpaths */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1762  		for (i = 0; i < vdev->no_of_vpath; i++) {
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1763  			vxge_hw_vpath_enable(vdev->vpaths[i].handle);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1764  			smp_wmb();
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1765  			vxge_hw_vpath_rx_doorbell_init(vdev->vpaths[i].handle);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1766  		}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1767  
d03848e057cb33 drivers/net/vxge/vxge-main.c Jon Mason       2010-07-15  1768  		netif_tx_wake_all_queues(vdev->ndev);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1769  	}
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1770  
16fded7da2cefc drivers/net/vxge/vxge-main.c Jon Mason       2011-01-18  1771  	/* configure CI */
16fded7da2cefc drivers/net/vxge/vxge-main.c Jon Mason       2011-01-18  1772  	vxge_config_ci_for_tti_rti(vdev);
16fded7da2cefc drivers/net/vxge/vxge-main.c Jon Mason       2011-01-18  1773  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1774  out:
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1775  	vxge_debug_entryexit(VXGE_TRACE,
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1776  		"%s:%d  Exiting...", __func__, __LINE__);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1777  
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1778  	/* Indicate reset done */
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1779  	if ((event == VXGE_LL_FULL_RESET) || (event == VXGE_LL_COMPL_RESET))
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1780  		clear_bit(__VXGE_STATE_RESET_CARD, &vdev->state);
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1781  	return ret;
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1782  }
703da5a1a231d8 drivers/net/vxge/vxge-main.c Ramkrishna Vepa 2009-04-01  1783  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
3P8DjlZ0NVuUAgA=

--ZGiS0Q5IWpPtfppv--
