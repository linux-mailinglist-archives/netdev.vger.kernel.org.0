Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC014A056
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgA0I6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:58:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:54348 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgA0I6I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:58:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jan 2020 00:57:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,369,1574150400"; 
   d="scan'208";a="228903952"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 27 Jan 2020 00:57:39 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iw0DD-0008L8-3F; Mon, 27 Jan 2020 16:57:39 +0800
Date:   Mon, 27 Jan 2020 16:57:00 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     kbuild-all@lists.01.org, michal.kalderon@marvell.com,
        ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 net-next 13/13] qed: FW 8.42.2.0 debug features
Message-ID: <202001271621.ERydEuXR%lkp@intel.com>
References: <20200123105836.15090-14-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123105836.15090-14-michal.kalderon@marvell.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on linus/master v5.5 next-20200121]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Michal-Kalderon/qed-Utilize-FW-8-42-2-0/20200125-055253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9bbc8be29d66cc34b650510f2c67b5c55235fe5d
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-153-g47b6dfef-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/net/ethernet/qlogic/qed/qed_debug.c:993:29: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:993:58: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:995:22: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:995:22: sparse:    expected unsigned int [assigned] [usertype] addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:995:22: sparse:    got restricted __le32 [addressable] [usertype] grc_addr
   drivers/net/ethernet/qlogic/qed/qed_debug.c:997:33: sparse: sparse: restricted __le32 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1126:65: sparse: sparse: incorrect type in argument 4 (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1126:65: sparse:    expected unsigned int [usertype] param_val
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1126:65: sparse:    got restricted __le32 [addressable] [usertype] timestamp
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse: sparse: invalid assignment: &=
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse: sparse: invalid assignment: |=
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse:    left side has type restricted __le32
>> drivers/net/ethernet/qlogic/qed/qed_debug.c:1824:17: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1827:25: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1832:25: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1837:25: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse: sparse: invalid assignment: &=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse:    right side has type int
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse: sparse: invalid assignment: |=
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse:    left side has type restricted __le32
   drivers/net/ethernet/qlogic/qed/qed_debug.c:1839:25: sparse:    right side has type unsigned long long
   drivers/net/ethernet/qlogic/qed/qed_debug.c:4445:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/qlogic/qed/qed_debug.c:5277:17: sparse: sparse: symbol 'qed_dbg_ilt_get_dump_buf_size' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_debug.c:5293:17: sparse: sparse: symbol 'qed_dbg_ilt_dump' was not declared. Should it be static?
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7674:46: sparse: sparse: incorrect type in assignment (different base types)
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7674:46: sparse:    expected unsigned int [usertype]
   drivers/net/ethernet/qlogic/qed/qed_debug.c:7674:46: sparse:    got restricted __be32 [assigned] [usertype] val

vim +1824 drivers/net/ethernet/qlogic/qed/qed_debug.c

  1777	
  1778	/* Dumps the GRC registers in the specified address range.
  1779	 * Returns the dumped size in dwords.
  1780	 * The addr and len arguments are specified in dwords.
  1781	 */
  1782	static u32 qed_grc_dump_addr_range(struct qed_hwfn *p_hwfn,
  1783					   struct qed_ptt *p_ptt,
  1784					   u32 *dump_buf,
  1785					   bool dump, u32 addr, u32 len, bool wide_bus,
  1786					   enum init_split_types split_type,
  1787					   u8 split_id)
  1788	{
  1789		struct dbg_tools_data *dev_data = &p_hwfn->dbg_info;
  1790		u8 port_id = 0, pf_id = 0, vf_id = 0, fid = 0;
  1791		bool read_using_dmae = false;
  1792		u32 thresh;
  1793	
  1794		if (!dump)
  1795			return len;
  1796	
  1797		switch (split_type) {
  1798		case SPLIT_TYPE_PORT:
  1799			port_id = split_id;
  1800			break;
  1801		case SPLIT_TYPE_PF:
  1802			pf_id = split_id;
  1803			break;
  1804		case SPLIT_TYPE_PORT_PF:
  1805			port_id = split_id / dev_data->num_pfs_per_port;
  1806			pf_id = port_id + dev_data->num_ports *
  1807			    (split_id % dev_data->num_pfs_per_port);
  1808			break;
  1809		case SPLIT_TYPE_VF:
  1810			vf_id = split_id;
  1811			break;
  1812		default:
  1813			break;
  1814		}
  1815	
  1816		/* Try reading using DMAE */
  1817		if (dev_data->use_dmae && split_type != SPLIT_TYPE_VF &&
  1818		    (len >= s_hw_type_defs[dev_data->hw_type].dmae_thresh ||
  1819		     (PROTECT_WIDE_BUS && wide_bus))) {
  1820			struct qed_dmae_params dmae_params;
  1821	
  1822			/* Set DMAE params */
  1823			memset(&dmae_params, 0, sizeof(dmae_params));
> 1824			SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_COMPLETION_DST, 1);
  1825			switch (split_type) {
  1826			case SPLIT_TYPE_PORT:
  1827				SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_PORT_VALID,
  1828					  1);
  1829				dmae_params.port_id = port_id;
  1830				break;
  1831			case SPLIT_TYPE_PF:
  1832				SET_FIELD(dmae_params.flags,
  1833					  QED_DMAE_PARAMS_SRC_PF_VALID, 1);
  1834				dmae_params.src_pfid = pf_id;
  1835				break;
  1836			case SPLIT_TYPE_PORT_PF:
  1837				SET_FIELD(dmae_params.flags, QED_DMAE_PARAMS_PORT_VALID,
  1838					  1);
  1839				SET_FIELD(dmae_params.flags,
  1840					  QED_DMAE_PARAMS_SRC_PF_VALID, 1);
  1841				dmae_params.port_id = port_id;
  1842				dmae_params.src_pfid = pf_id;
  1843				break;
  1844			default:
  1845				break;
  1846			}
  1847	
  1848			/* Execute DMAE command */
  1849			read_using_dmae = !qed_dmae_grc2host(p_hwfn,
  1850							     p_ptt,
  1851							     DWORDS_TO_BYTES(addr),
  1852							     (u64)(uintptr_t)(dump_buf),
  1853							     len, &dmae_params);
  1854			if (!read_using_dmae) {
  1855				dev_data->use_dmae = 0;
  1856				DP_VERBOSE(p_hwfn,
  1857					   QED_MSG_DEBUG,
  1858					   "Failed reading from chip using DMAE, using GRC instead\n");
  1859			}
  1860		}
  1861	
  1862		if (read_using_dmae)
  1863			goto print_log;
  1864	
  1865		/* If not read using DMAE, read using GRC */
  1866	
  1867		/* Set pretend */
  1868		if (split_type != dev_data->pretend.split_type ||
  1869		    split_id != dev_data->pretend.split_id) {
  1870			switch (split_type) {
  1871			case SPLIT_TYPE_PORT:
  1872				qed_port_pretend(p_hwfn, p_ptt, port_id);
  1873				break;
  1874			case SPLIT_TYPE_PF:
  1875				fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_PFID,
  1876						  pf_id);
  1877				qed_fid_pretend(p_hwfn, p_ptt, fid);
  1878				break;
  1879			case SPLIT_TYPE_PORT_PF:
  1880				fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_PFID,
  1881						  pf_id);
  1882				qed_port_fid_pretend(p_hwfn, p_ptt, port_id, fid);
  1883				break;
  1884			case SPLIT_TYPE_VF:
  1885				fid = FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_VFVALID, 1)
  1886				      | FIELD_VALUE(PXP_PRETEND_CONCRETE_FID_VFID,
  1887						  vf_id);
  1888				qed_fid_pretend(p_hwfn, p_ptt, fid);
  1889				break;
  1890			default:
  1891				break;
  1892			}
  1893	
  1894			dev_data->pretend.split_type = (u8)split_type;
  1895			dev_data->pretend.split_id = split_id;
  1896		}
  1897	
  1898		/* Read registers using GRC */
  1899		qed_read_regs(p_hwfn, p_ptt, dump_buf, addr, len);
  1900	
  1901	print_log:
  1902		/* Print log */
  1903		dev_data->num_regs_read += len;
  1904		thresh = s_hw_type_defs[dev_data->hw_type].log_thresh;
  1905		if ((dev_data->num_regs_read / thresh) >
  1906		    ((dev_data->num_regs_read - len) / thresh))
  1907			DP_VERBOSE(p_hwfn,
  1908				   QED_MSG_DEBUG,
  1909				   "Dumped %d registers...\n", dev_data->num_regs_read);
  1910	
  1911		return len;
  1912	}
  1913	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
