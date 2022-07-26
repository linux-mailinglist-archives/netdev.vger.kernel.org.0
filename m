Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9EA580DC7
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiGZHdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbiGZHcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:32:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90C22A964;
        Tue, 26 Jul 2022 00:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658820487; x=1690356487;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yfeBMpJQONyIZu7Rakc0/IyGerTlcG//iuvPj/kUfms=;
  b=VRRp0b5Bq4Y30A2wqsT/vQqfEfy9aXzbvls8T4QwYCIp0doDu5IA+VAp
   jZKuKArgjg2IGJ4yU2riIPtq6f8lS6w3MHgcTVKBL93dU+j8MAqgFHsJI
   TeppIidCSOdVFZcevUcFI4+naMku+yzxrBGdroHe9Nk5FXM6dYGDvFO3d
   VxPDjXBvTgd6ySaOomeeYT00Mp1CLnHAcX0r74RXzl/Q3SMCbUJJWQmy+
   M4aVceuF2GIJEsbvOIN9wJ10PIInJMIJ2qbxKQ4S617qstKfpT1Un9gp6
   sgtgCQ2tDPXvNgy9e4oONP5zJ8DOyFU+QdOwzLhTmuSbfXNttTPeVFGBM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274751533"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274751533"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 00:27:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="776214725"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 Jul 2022 00:27:48 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oGEyp-0006BE-2z;
        Tue, 26 Jul 2022 07:27:47 +0000
Date:   Tue, 26 Jul 2022 15:27:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     alexandru.tachici@analog.com, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gerhard@engleder-embedded.com,
        geert+renesas@glider.be, joel@jms.id.au, stefan.wahren@i2se.com,
        wellslutw@gmail.com, geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next v2 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <202207261549.2tRjhI43-lkp@intel.com>
References: <20220725165312.59471-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725165312.59471-3-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/alexandru-tachici-analog-com/net-ethernet-adi-Add-ADIN1110-support/20220726-004159
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 086f8246ed621bcc91d07e867fdbfae9382c1fbd
config: x86_64-allmodconfig (https://download.01.org/0day-ci/archive/20220726/202207261549.2tRjhI43-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/98b8eeb76eafcfa5bf3706812764e769004d9e32
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alexandru-tachici-analog-com/net-ethernet-adi-Add-ADIN1110-support/20220726-004159
        git checkout 98b8eeb76eafcfa5bf3706812764e769004d9e32
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/ethernet/adi/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/adi/adin1110.c:194:39: sparse: sparse: cast to restricted __le16
>> drivers/net/ethernet/adi/adin1110.c:194:39: sparse: sparse: restricted __le16 degrades to integer
>> drivers/net/ethernet/adi/adin1110.c:194:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:195:25: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:195:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:195:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:242:56: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:242:56: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:242:56: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:243:25: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:243:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:243:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:326:39: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:326:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:326:39: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:327:25: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:327:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:327:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:395:56: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:395:56: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:395:56: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:396:25: sparse: sparse: cast to restricted __le16
   drivers/net/ethernet/adi/adin1110.c:396:25: sparse: sparse: restricted __le16 degrades to integer
   drivers/net/ethernet/adi/adin1110.c:396:25: sparse: sparse: restricted __le16 degrades to integer

vim +194 drivers/net/ethernet/adi/adin1110.c

   185	
   186	static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg, u32 *val)
   187	{
   188		struct spi_transfer t[2] = {0};
   189		__le16 __reg = cpu_to_le16(reg);
   190		u32 header_len = ADIN1110_RD_HEADER_LEN;
   191		u32 read_len = ADIN1110_REG_LEN;
   192		int ret;
   193	
 > 194		priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8), __reg);
   195		priv->data[1] = FIELD_GET(GENMASK(7, 0), __reg);
   196		priv->data[2] = 0x00;
   197	
   198		if (priv->append_crc) {
   199			priv->data[2] = adin1110_crc_data(&priv->data[0], 2);
   200			priv->data[3] = 0x00;
   201			header_len++;
   202		}
   203	
   204		t[0].tx_buf = &priv->data[0];
   205		t[0].len = header_len;
   206	
   207		if (priv->append_crc)
   208			read_len++;
   209	
   210		memset(&priv->data[header_len], 0, read_len);
   211		t[1].rx_buf = &priv->data[header_len];
   212		t[1].len = read_len;
   213	
   214		ret = spi_sync_transfer(priv->spidev, t, 2);
   215		if (ret)
   216			return ret;
   217	
   218		if (priv->append_crc) {
   219			u8 recv_crc;
   220			u8 crc;
   221	
   222			crc = adin1110_crc_data(&priv->data[header_len], ADIN1110_REG_LEN);
   223			recv_crc = priv->data[header_len + ADIN1110_REG_LEN];
   224	
   225			if (crc != recv_crc) {
   226				dev_err_ratelimited(&priv->spidev->dev, "CRC error.");
   227				return -EBADMSG;
   228			}
   229		}
   230	
   231		*val = get_unaligned_be32(&priv->data[header_len]);
   232	
   233		return ret;
   234	}
   235	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
