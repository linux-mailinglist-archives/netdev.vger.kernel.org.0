Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5189E36DCDE
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbhD1QV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:21:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:47219 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239890AbhD1QV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 12:21:58 -0400
IronPort-SDR: 4LgyVboeZW1qdli/qsn6TDnCGnoL7IhJWC9h84lGo210Zr7F784z5Uk7/3LYH29VyiT3PVmWUd
 qLUoWyqfcHHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9968"; a="258081129"
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="gz'50?scan'50,208,50";a="258081129"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 09:20:47 -0700
IronPort-SDR: DeNsagM9v45CaPQ9uTRr1v55xwf+KtAzn2IZvWJUpw7i8S2cE35+Zob6K7uBt/kQxIwqcGV/xv
 lkBNu8EE+I2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,258,1613462400"; 
   d="gz'50?scan'50,208,50";a="455127263"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2021 09:20:43 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lbmvb-0007Bz-8w; Wed, 28 Apr 2021 16:20:43 +0000
Date:   Thu, 29 Apr 2021 00:19:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        nicolas.ferre@microchip.com
Cc:     kbuild-all@lists.01.org, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH] net: macb: Remove redundant assignment to w0 and queue
Message-ID: <202104290048.3qUnQQzV-lkp@intel.com>
References: <1619604188-120341-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1619604188-120341-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jiapeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.12 next-20210428]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jiapeng-Chong/net-macb-Remove-redundant-assignment-to-w0-and-queue/20210428-180547
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git acd3d28594536e9096c1ea76c5867d8a68babef6
config: i386-randconfig-s001-20210428 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.3-341-g8af24329-dirty
        # https://github.com/0day-ci/linux/commit/baa719bc71d10dc85036336b0c1b1556da2339a6
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jiapeng-Chong/net-macb-Remove-redundant-assignment-to-w0-and-queue/20210428-180547
        git checkout baa719bc71d10dc85036336b0c1b1556da2339a6
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' W=1 ARCH=i386 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   drivers/net/ethernet/cadence/macb_main.c:282:16: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] bottom @@     got restricted __le32 [usertype] @@
   drivers/net/ethernet/cadence/macb_main.c:282:16: sparse:     expected unsigned int [usertype] bottom
   drivers/net/ethernet/cadence/macb_main.c:282:16: sparse:     got restricted __le32 [usertype]
   drivers/net/ethernet/cadence/macb_main.c:284:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] top @@     got restricted __le16 [usertype] @@
   drivers/net/ethernet/cadence/macb_main.c:284:13: sparse:     expected unsigned short [usertype] top
   drivers/net/ethernet/cadence/macb_main.c:284:13: sparse:     got restricted __le16 [usertype]
   drivers/net/ethernet/cadence/macb_main.c:3214:39: sparse: sparse: restricted __be32 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3219:39: sparse: sparse: restricted __be32 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3224:40: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3224:69: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3249:20: sparse: sparse: restricted __be32 degrades to integer
>> drivers/net/ethernet/cadence/macb_main.c:3252:20: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] w0 @@     got restricted __be32 [usertype] ip4src @@
   drivers/net/ethernet/cadence/macb_main.c:3252:20: sparse:     expected unsigned int [usertype] w0
   drivers/net/ethernet/cadence/macb_main.c:3252:20: sparse:     got restricted __be32 [usertype] ip4src
   drivers/net/ethernet/cadence/macb_main.c:3262:20: sparse: sparse: restricted __be32 degrades to integer
>> drivers/net/ethernet/cadence/macb_main.c:3265:20: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned int [usertype] w0 @@     got restricted __be32 [usertype] ip4dst @@
   drivers/net/ethernet/cadence/macb_main.c:3265:20: sparse:     expected unsigned int [usertype] w0
   drivers/net/ethernet/cadence/macb_main.c:3265:20: sparse:     got restricted __be32 [usertype] ip4dst
   drivers/net/ethernet/cadence/macb_main.c:3275:21: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3275:50: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3281:30: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3282:30: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3289:36: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3290:38: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3293:38: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __be32 [usertype] ip4src @@
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     expected unsigned int [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     got restricted __be32 [usertype] ip4src
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __be32 [usertype] ip4dst @@
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     expected unsigned int [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     got restricted __be32 [usertype] ip4dst
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] psrc @@
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     got restricted __be16 [usertype] psrc
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] pdst @@
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse:     got restricted __be16 [usertype] pdst
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3329:9: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __be32 [usertype] ip4src @@
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     expected unsigned int [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     got restricted __be32 [usertype] ip4src
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned int [usertype] val @@     got restricted __be32 [usertype] ip4dst @@
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     expected unsigned int [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     got restricted __be32 [usertype] ip4dst
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be32
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] psrc @@
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     got restricted __be16 [usertype] psrc
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned short [usertype] val @@     got restricted __be16 [usertype] pdst @@
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     expected unsigned short [usertype] val
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse:     got restricted __be16 [usertype] pdst
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16
   drivers/net/ethernet/cadence/macb_main.c:3382:25: sparse: sparse: cast from restricted __be16

vim +3252 drivers/net/ethernet/cadence/macb_main.c

ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3232  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3233  static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3234  {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3235  	struct ethtool_tcpip4_spec *tp4sp_v, *tp4sp_m;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3236  	uint16_t index = fs->location;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3237  	u32 w0, w1, t2_scr;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3238  	bool cmp_a = false;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3239  	bool cmp_b = false;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3240  	bool cmp_c = false;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3241  
a14d273ba15968 Claudiu Beznea 2021-04-02  3242  	if (!macb_is_gem(bp))
a14d273ba15968 Claudiu Beznea 2021-04-02  3243  		return;
a14d273ba15968 Claudiu Beznea 2021-04-02  3244  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3245  	tp4sp_v = &(fs->h_u.tcp_ip4_spec);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3246  	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3247  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3248  	/* ignore field if any masking set */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3249  	if (tp4sp_m->ip4src == 0xFFFFFFFF) {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3250  		/* 1st compare reg - IP source address */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3251  		w1 = 0;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30 @3252  		w0 = tp4sp_v->ip4src;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3253  		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3254  		w1 = GEM_BFINS(T2CMPOFST, GEM_T2COMPOFST_ETYPE, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3255  		w1 = GEM_BFINS(T2OFST, ETYPE_SRCIP_OFFSET, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3256  		gem_writel_n(bp, T2CMPW0, T2CMP_OFST(GEM_IP4SRC_CMP(index)), w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3257  		gem_writel_n(bp, T2CMPW1, T2CMP_OFST(GEM_IP4SRC_CMP(index)), w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3258  		cmp_a = true;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3259  	}
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3260  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3261  	/* ignore field if any masking set */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3262  	if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3263  		/* 2nd compare reg - IP destination address */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3264  		w1 = 0;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30 @3265  		w0 = tp4sp_v->ip4dst;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3266  		w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3267  		w1 = GEM_BFINS(T2CMPOFST, GEM_T2COMPOFST_ETYPE, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3268  		w1 = GEM_BFINS(T2OFST, ETYPE_DSTIP_OFFSET, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3269  		gem_writel_n(bp, T2CMPW0, T2CMP_OFST(GEM_IP4DST_CMP(index)), w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3270  		gem_writel_n(bp, T2CMPW1, T2CMP_OFST(GEM_IP4DST_CMP(index)), w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3271  		cmp_b = true;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3272  	}
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3273  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3274  	/* ignore both port fields if masking set in both */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3275  	if ((tp4sp_m->psrc == 0xFFFF) || (tp4sp_m->pdst == 0xFFFF)) {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3276  		/* 3rd compare reg - source port, destination port */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3277  		w0 = 0;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3278  		w1 = 0;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3279  		w1 = GEM_BFINS(T2CMPOFST, GEM_T2COMPOFST_IPHDR, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3280  		if (tp4sp_m->psrc == tp4sp_m->pdst) {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3281  			w0 = GEM_BFINS(T2MASK, tp4sp_v->psrc, w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3282  			w0 = GEM_BFINS(T2CMP, tp4sp_v->pdst, w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3283  			w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3284  			w1 = GEM_BFINS(T2OFST, IPHDR_SRCPORT_OFFSET, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3285  		} else {
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3286  			/* only one port definition */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3287  			w1 = GEM_BFINS(T2DISMSK, 0, w1); /* 16-bit compare */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3288  			w0 = GEM_BFINS(T2MASK, 0xFFFF, w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3289  			if (tp4sp_m->psrc == 0xFFFF) { /* src port */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3290  				w0 = GEM_BFINS(T2CMP, tp4sp_v->psrc, w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3291  				w1 = GEM_BFINS(T2OFST, IPHDR_SRCPORT_OFFSET, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3292  			} else { /* dst port */
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3293  				w0 = GEM_BFINS(T2CMP, tp4sp_v->pdst, w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3294  				w1 = GEM_BFINS(T2OFST, IPHDR_DSTPORT_OFFSET, w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3295  			}
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3296  		}
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3297  		gem_writel_n(bp, T2CMPW0, T2CMP_OFST(GEM_PORT_CMP(index)), w0);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3298  		gem_writel_n(bp, T2CMPW1, T2CMP_OFST(GEM_PORT_CMP(index)), w1);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3299  		cmp_c = true;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3300  	}
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3301  
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3302  	t2_scr = 0;
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3303  	t2_scr = GEM_BFINS(QUEUE, (fs->ring_cookie) & 0xFF, t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3304  	t2_scr = GEM_BFINS(ETHT2IDX, SCRT2_ETHT, t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3305  	if (cmp_a)
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3306  		t2_scr = GEM_BFINS(CMPA, GEM_IP4SRC_CMP(index), t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3307  	if (cmp_b)
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3308  		t2_scr = GEM_BFINS(CMPB, GEM_IP4DST_CMP(index), t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3309  	if (cmp_c)
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3310  		t2_scr = GEM_BFINS(CMPC, GEM_PORT_CMP(index), t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3311  	gem_writel_n(bp, SCRT2, index, t2_scr);
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3312  }
ae8223de3df5a0 Rafal Ozieblo  2017-11-30  3313  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--RnlQjJ0d97Da+TV1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
sKagzeHoB/fCUpX7w/8DsLR13QZUAgA=

--RnlQjJ0d97Da+TV1--
