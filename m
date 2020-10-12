Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F087F28B401
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388244AbgJLLmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:42:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:35076 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388231AbgJLLmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 07:42:36 -0400
IronPort-SDR: 9cYkBdCZGdVYjuugydH3nE15vPLMUG22y8KynPhtWvd2mnGZBbY7SViVuQJwlQPrb0nZZ5RrO7
 Pla2qZ48eXHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9771"; a="162259223"
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="gz'50?scan'50,208,50";a="162259223"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 04:42:33 -0700
IronPort-SDR: beXUN8YR9tyVKlrh2duSzWas84wMlNDIXU2MW43oZnnpvWZvmzhHCSNWilmSwTfyAJnMuj/Trm
 YKra67S+qxuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="gz'50?scan'50,208,50";a="355770407"
Received: from lkp-server02.sh.intel.com (HELO c41e9df04563) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Oct 2020 04:42:29 -0700
Received: from kbuild by c41e9df04563 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kRwDl-00006Y-1G; Mon, 12 Oct 2020 11:42:29 +0000
Date:   Mon, 12 Oct 2020 19:42:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, schandran@marvell.com, pathreya@marvell.com
Subject: Re: [PATCH v6,net-next,03/13] octeontx2-af: add debugfs entries for
 CPT block
Message-ID: <202010121923.LSSVXxqA-lkp@intel.com>
References: <20201012081152.1126-4-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20201012081152.1126-4-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Srujana,

I love your patch! Yet something to improve:

[auto build test ERROR on ipvs/master]
[also build test ERROR on linus/master v5.9 next-20201009]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Srujana-Challa/octeontx2-af-add-debugfs-entries-for-CPT-block/20201012-161457
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: arm64-randconfig-r001-20201012 (attached as .config)
compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project 9e72d3eaf38f217698f72cb8fdc969a6e72dad3a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/0day-ci/linux/commit/e56a51df7a3a1e85e34c91f054ed9e042df486c5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Srujana-Challa/octeontx2-af-add-debugfs-entries-for-CPT-block/20201012-161457
        git checkout e56a51df7a3a1e85e34c91f054ed9e042df486c5
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1764:33: error: use of undeclared identifier 'CPT_AF_CONSTANTS1'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
                                          ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1788:34: error: implicit declaration of function 'CPT_AF_EXEX_STS' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
                                                  ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1833:33: error: use of undeclared identifier 'CPT_AF_CONSTANTS1'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
                                          ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1858:34: error: implicit declaration of function 'CPT_AF_EXEX_CTL2' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1861:34: error: implicit declaration of function 'CPT_AF_EXEX_ACTIVE' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_ACTIVE(e));
                                                  ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1861:34: note: did you mean 'CPT_AF_EXEX_CTL2'?
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1858:34: note: 'CPT_AF_EXEX_CTL2' declared here
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1864:34: error: implicit declaration of function 'CPT_AF_EXEX_CTL' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(e));
                                                  ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1864:34: note: did you mean 'CPT_AF_EXEX_CTL2'?
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1858:34: note: 'CPT_AF_EXEX_CTL2' declared here
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1894:34: error: implicit declaration of function 'CPT_AF_LFX_CTL' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1896:34: error: implicit declaration of function 'CPT_AF_LFX_CTL2' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(lf));
                                                  ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1896:34: note: did you mean 'CPT_AF_LFX_CTL'?
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1894:34: note: 'CPT_AF_LFX_CTL' declared here
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1898:34: error: implicit declaration of function 'CPT_AF_LFX_PTR_CTL' [-Werror,-Wimplicit-function-declaration]
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_PTR_CTL(lf));
                                                  ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1898:34: note: did you mean 'CPT_AF_LFX_CTL'?
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1894:34: note: 'CPT_AF_LFX_CTL' declared here
                   reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
                                                  ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1920:34: error: implicit declaration of function 'CPT_AF_FLTX_INT' [-Werror,-Wimplicit-function-declaration]
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1923:34: error: implicit declaration of function 'CPT_AF_PSNX_EXE' [-Werror,-Wimplicit-function-declaration]
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1926:34: error: implicit declaration of function 'CPT_AF_PSNX_LF' [-Werror,-Wimplicit-function-declaration]
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_LF(0));
                                           ^
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1926:34: note: did you mean 'CPT_AF_PSNX_EXE'?
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1923:34: note: 'CPT_AF_PSNX_EXE' declared here
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1928:34: error: use of undeclared identifier 'CPT_AF_RVU_INT'; did you mean 'CPT_AF_FLTX_INT'?
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
                                           ^~~~~~~~~~~~~~
                                           CPT_AF_FLTX_INT
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1920:34: note: 'CPT_AF_FLTX_INT' declared here
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1930:34: error: use of undeclared identifier 'CPT_AF_RAS_INT'; did you mean 'CPT_AF_FLTX_INT'?
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
                                           ^~~~~~~~~~~~~~
                                           CPT_AF_FLTX_INT
   drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1920:34: note: 'CPT_AF_FLTX_INT' declared here
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1932:34: error: use of undeclared identifier 'CPT_AF_EXE_ERR_INFO'
           reg0 = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
                                           ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1951:33: error: use of undeclared identifier 'CPT_AF_INST_REQ_PC'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
                                          ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1953:33: error: use of undeclared identifier 'CPT_AF_INST_LATENCY_PC'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
                                          ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1955:33: error: use of undeclared identifier 'CPT_AF_RD_REQ_PC'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
                                          ^
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1957:33: error: use of undeclared identifier 'CPT_AF_RD_LATENCY_PC'
           reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
                                          ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.

vim +/CPT_AF_CONSTANTS1 +1764 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c

  1749	
  1750	static int rvu_dbg_cpt_engines_sts_display(struct seq_file *filp, void *unused)
  1751	{
  1752		u64  busy_sts[2] = {0}, free_sts[2] = {0};
  1753		struct rvu *rvu = filp->private;
  1754		u16  max_ses, max_ies, max_aes;
  1755		u32  e_min = 0, e_max = 0, e;
  1756		int  blkaddr;
  1757		char *e_type;
  1758		u64  reg;
  1759	
  1760		blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
  1761		if (blkaddr < 0)
  1762			return -ENODEV;
  1763	
> 1764		reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
  1765		max_ses = reg & 0xffff;
  1766		max_ies = (reg >> 16) & 0xffff;
  1767		max_aes = (reg >> 32) & 0xffff;
  1768	
  1769		e_type = rvu->rvu_dbg.cpt_ctx.e_type;
  1770	
  1771		if (strcmp(e_type, "SE") == 0) {
  1772			e_min = 0;
  1773			e_max = max_ses - 1;
  1774		} else if (strcmp(e_type, "IE") == 0) {
  1775			e_min = max_ses;
  1776			e_max = max_ses + max_ies - 1;
  1777		} else if (strcmp(e_type, "AE") == 0) {
  1778			e_min = max_ses + max_ies;
  1779			e_max = max_ses + max_ies + max_aes - 1;
  1780		} else if (strcmp(e_type, "all") == 0) {
  1781			e_min = 0;
  1782			e_max = max_ses + max_ies + max_aes - 1;
  1783		} else {
  1784			return -EINVAL;
  1785		}
  1786	
  1787		for (e = e_min; e <= e_max; e++) {
> 1788			reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_STS(e));
  1789			if (reg & 0x1) {
  1790				if (e < max_ses)
  1791					busy_sts[0] |= 1ULL << e;
  1792				else if (e >= max_ses)
  1793					busy_sts[1] |= 1ULL << (e - max_ses);
  1794			}
  1795			if (reg & 0x2) {
  1796				if (e < max_ses)
  1797					free_sts[0] |= 1ULL << e;
  1798				else if (e >= max_ses)
  1799					free_sts[1] |= 1ULL << (e - max_ses);
  1800			}
  1801		}
  1802		seq_printf(filp, "FREE STS : 0x%016llx  0x%016llx\n", free_sts[1],
  1803			   free_sts[0]);
  1804		seq_printf(filp, "BUSY STS : 0x%016llx  0x%016llx\n", busy_sts[1],
  1805			   busy_sts[0]);
  1806	
  1807		return 0;
  1808	}
  1809	
  1810	RVU_DEBUG_SEQ_FOPS(cpt_engines_sts, cpt_engines_sts_display,
  1811			   cpt_engines_sts_write);
  1812	
  1813	static ssize_t rvu_dbg_cpt_engines_info_write(struct file *filp,
  1814						      const char __user *buffer,
  1815						      size_t count, loff_t *ppos)
  1816	{
  1817		return rvu_dbg_cpt_cmd_parser(filp, buffer, count, ppos);
  1818	}
  1819	
  1820	static int rvu_dbg_cpt_engines_info_display(struct seq_file *filp, void *unused)
  1821	{
  1822		struct rvu *rvu = filp->private;
  1823		u16  max_ses, max_ies, max_aes;
  1824		u32  e_min, e_max, e;
  1825		int  blkaddr;
  1826		char *e_type;
  1827		u64  reg;
  1828	
  1829		blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
  1830		if (blkaddr < 0)
  1831			return -ENODEV;
  1832	
  1833		reg = rvu_read64(rvu, blkaddr, CPT_AF_CONSTANTS1);
  1834		max_ses = reg & 0xffff;
  1835		max_ies = (reg >> 16) & 0xffff;
  1836		max_aes = (reg >> 32) & 0xffff;
  1837	
  1838		e_type = rvu->rvu_dbg.cpt_ctx.e_type;
  1839	
  1840		if (strcmp(e_type, "SE") == 0) {
  1841			e_min = 0;
  1842			e_max = max_ses - 1;
  1843		} else if (strcmp(e_type, "IE") == 0) {
  1844			e_min = max_ses;
  1845			e_max = max_ses + max_ies - 1;
  1846		} else if (strcmp(e_type, "AE") == 0) {
  1847			e_min = max_ses + max_ies;
  1848			e_max = max_ses + max_ies + max_aes - 1;
  1849		} else if (strcmp(e_type, "all") == 0) {
  1850			e_min = 0;
  1851			e_max = max_ses + max_ies + max_aes - 1;
  1852		} else {
  1853			return -EINVAL;
  1854		}
  1855	
  1856		seq_puts(filp, "===========================================\n");
  1857		for (e = e_min; e <= e_max; e++) {
> 1858			reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL2(e));
  1859			seq_printf(filp, "CPT Engine[%u] Group Enable   0x%02llx\n", e,
  1860				   reg & 0xff);
> 1861			reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_ACTIVE(e));
  1862			seq_printf(filp, "CPT Engine[%u] Active Info    0x%llx\n", e,
  1863				   reg);
> 1864			reg = rvu_read64(rvu, blkaddr, CPT_AF_EXEX_CTL(e));
  1865			seq_printf(filp, "CPT Engine[%u] Control        0x%llx\n", e,
  1866				   reg);
  1867			seq_puts(filp, "===========================================\n");
  1868		}
  1869		return 0;
  1870	}
  1871	
  1872	RVU_DEBUG_SEQ_FOPS(cpt_engines_info, cpt_engines_info_display,
  1873			   cpt_engines_info_write);
  1874	
  1875	static int rvu_dbg_cpt_lfs_info_display(struct seq_file *filp, void *unused)
  1876	{
  1877		struct rvu *rvu = filp->private;
  1878		struct rvu_hwinfo *hw = rvu->hw;
  1879		struct rvu_block *block;
  1880		int blkaddr;
  1881		u64 reg;
  1882		u32 lf;
  1883	
  1884		blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
  1885		if (blkaddr < 0)
  1886			return -ENODEV;
  1887	
  1888		block = &hw->block[blkaddr];
  1889		if (!block->lf.bmap)
  1890			return -ENODEV;
  1891	
  1892		seq_puts(filp, "===========================================\n");
  1893		for (lf = 0; lf < block->lf.max; lf++) {
> 1894			reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(lf));
  1895			seq_printf(filp, "CPT Lf[%u] CTL          0x%llx\n", lf, reg);
> 1896			reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL2(lf));
  1897			seq_printf(filp, "CPT Lf[%u] CTL2         0x%llx\n", lf, reg);
> 1898			reg = rvu_read64(rvu, blkaddr, CPT_AF_LFX_PTR_CTL(lf));
  1899			seq_printf(filp, "CPT Lf[%u] PTR_CTL      0x%llx\n", lf, reg);
  1900			reg = rvu_read64(rvu, blkaddr, block->lfcfg_reg |
  1901					(lf << block->lfshift));
  1902			seq_printf(filp, "CPT Lf[%u] CFG          0x%llx\n", lf, reg);
  1903			seq_puts(filp, "===========================================\n");
  1904		}
  1905		return 0;
  1906	}
  1907	
  1908	RVU_DEBUG_SEQ_FOPS(cpt_lfs_info, cpt_lfs_info_display, NULL);
  1909	
  1910	static int rvu_dbg_cpt_err_info_display(struct seq_file *filp, void *unused)
  1911	{
  1912		struct rvu *rvu = filp->private;
  1913		u64 reg0, reg1;
  1914		int blkaddr;
  1915	
  1916		blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
  1917		if (blkaddr < 0)
  1918			return -ENODEV;
  1919	
> 1920		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(0));
  1921		reg1 = rvu_read64(rvu, blkaddr, CPT_AF_FLTX_INT(1));
  1922		seq_printf(filp, "CPT_AF_FLTX_INT:       0x%llx 0x%llx\n", reg0, reg1);
> 1923		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(0));
  1924		reg1 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_EXE(1));
  1925		seq_printf(filp, "CPT_AF_PSNX_EXE:       0x%llx 0x%llx\n", reg0, reg1);
> 1926		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_PSNX_LF(0));
  1927		seq_printf(filp, "CPT_AF_PSNX_LF:        0x%llx\n", reg0);
> 1928		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RVU_INT);
  1929		seq_printf(filp, "CPT_AF_RVU_INT:        0x%llx\n", reg0);
> 1930		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_RAS_INT);
  1931		seq_printf(filp, "CPT_AF_RAS_INT:        0x%llx\n", reg0);
> 1932		reg0 = rvu_read64(rvu, blkaddr, CPT_AF_EXE_ERR_INFO);
  1933		seq_printf(filp, "CPT_AF_EXE_ERR_INFO:   0x%llx\n", reg0);
  1934	
  1935		return 0;
  1936	}
  1937	
  1938	RVU_DEBUG_SEQ_FOPS(cpt_err_info, cpt_err_info_display, NULL);
  1939	
  1940	static int rvu_dbg_cpt_pc_display(struct seq_file *filp, void *unused)
  1941	{
  1942		struct rvu *rvu;
  1943		int blkaddr;
  1944		u64 reg;
  1945	
  1946		rvu = filp->private;
  1947		blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_CPT, 0);
  1948		if (blkaddr < 0)
  1949			return -ENODEV;
  1950	
> 1951		reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_REQ_PC);
  1952		seq_printf(filp, "CPT instruction requests   %llu\n", reg);
> 1953		reg = rvu_read64(rvu, blkaddr, CPT_AF_INST_LATENCY_PC);
  1954		seq_printf(filp, "CPT instruction latency    %llu\n", reg);
> 1955		reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_REQ_PC);
  1956		seq_printf(filp, "CPT NCB read requests      %llu\n", reg);
> 1957		reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_LATENCY_PC);
  1958		seq_printf(filp, "CPT NCB read latency       %llu\n", reg);
  1959		reg = rvu_read64(rvu, blkaddr, CPT_AF_RD_UC_PC);
  1960		seq_printf(filp, "CPT read requests caused by UC fills   %llu\n", reg);
  1961		reg = rvu_read64(rvu, blkaddr, CPT_AF_ACTIVE_CYCLES_PC);
  1962		seq_printf(filp, "CPT active cycles pc       %llu\n", reg);
  1963		reg = rvu_read64(rvu, blkaddr, CPT_AF_CPTCLK_CNT);
  1964		seq_printf(filp, "CPT clock count pc         %llu\n", reg);
  1965	
  1966		return 0;
  1967	}
  1968	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--RnlQjJ0d97Da+TV1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--RnlQjJ0d97Da+TV1--
