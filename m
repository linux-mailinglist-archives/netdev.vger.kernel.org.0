Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79A45E73BC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 08:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiIWGO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 02:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIWGOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 02:14:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E736DDE;
        Thu, 22 Sep 2022 23:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663913692; x=1695449692;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lXSwP6og/ifxpWP/EGCyBAwoeYKaiCrVRuMGlHz6n0A=;
  b=IvHnMYI9n4Al7rg8Nq02b+AHoOrI3n46aIb8CKEEaYlrufsfSSp4Fe6B
   rCkyMlVhQuiwloKVp/JyUTMu1CsJ3SPWsg4h1icf6W5YvAFwNIJlV/r2h
   Z9nCSgmGaoBwj2IVXa8v5A7zzjchU7RPmQjqt/AQ0j0rqzjiYwMmiMVzf
   z9BVQ+kjv2b82Qe7UaIaxeAtpPs4/rQXkV+DY2IA6AtIsGaInz7lDCNRB
   tswdTtSvzH7NKJnDBXriaZFKvKedlcqfOlJ4Ki31xVQf8t/EyaHyIV2DO
   UVFYGNdYS+Nf2oGYvpjsdpBx0cu5fGUAxfP1GThJ1/BzvXJvOYt6u473f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="362329709"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="362329709"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 23:14:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="688607032"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 22 Sep 2022 23:14:36 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1obbxL-0005Nk-1v;
        Fri, 23 Sep 2022 06:14:35 +0000
Date:   Fri, 23 Sep 2022 14:13:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>, jiri@mellanox.com,
        moshe@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com
Cc:     kbuild-all@lists.01.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        chenhao418@huawei.com
Subject: Re: [PATCH net-next 1/2] devlink: expand
 __DEVLINK_PARAM_MAX_STRING_VALUE to 256
Message-ID: <202209231438.WCQ3Wu5L-lkp@intel.com>
References: <20220923013818.51003-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923013818.51003-2-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guangbin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Guangbin-Huang/net-hns3-add-support-setting-parameters-of-congestion-control-algorithm-by-devlink-param/20220923-094236
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git bcff1a37bafc144d67192f2f5e1f4b9c49b37bd6
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20220923/202209231438.WCQ3Wu5L-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e503c1118546fbb4e0d1274058f5ca0851f4b9a0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Guangbin-Huang/net-hns3-add-support-setting-parameters-of-congestion-control-algorithm-by-devlink-param/20220923-094236
        git checkout e503c1118546fbb4e0d1274058f5ca0851f4b9a0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash net/core/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/core/devlink.c: In function 'devlink_nl_param_fill.constprop':
>> net/core/devlink.c:5382:1: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    5382 | }
         | ^


vim +5382 net/core/devlink.c

45f05def5c44c8 Moshe Shemesh    2018-07-04  5293  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5294  static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
f4601dee25d5fe Vasundhara Volam 2019-01-28  5295  				 unsigned int port_index,
45f05def5c44c8 Moshe Shemesh    2018-07-04  5296  				 struct devlink_param_item *param_item,
45f05def5c44c8 Moshe Shemesh    2018-07-04  5297  				 enum devlink_command cmd,
45f05def5c44c8 Moshe Shemesh    2018-07-04  5298  				 u32 portid, u32 seq, int flags)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5299  {
45f05def5c44c8 Moshe Shemesh    2018-07-04  5300  	union devlink_param_value param_value[DEVLINK_PARAM_CMODE_MAX + 1];
7c62cfb8c5744b Jiri Pirko       2019-02-07  5301  	bool param_value_set[DEVLINK_PARAM_CMODE_MAX + 1] = {};
45f05def5c44c8 Moshe Shemesh    2018-07-04  5302  	const struct devlink_param *param = param_item->param;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5303  	struct devlink_param_gset_ctx ctx;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5304  	struct nlattr *param_values_list;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5305  	struct nlattr *param_attr;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5306  	int nla_type;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5307  	void *hdr;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5308  	int err;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5309  	int i;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5310  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5311  	/* Get value from driver part to driverinit configuration mode */
45f05def5c44c8 Moshe Shemesh    2018-07-04  5312  	for (i = 0; i <= DEVLINK_PARAM_CMODE_MAX; i++) {
45f05def5c44c8 Moshe Shemesh    2018-07-04  5313  		if (!devlink_param_cmode_is_supported(param, i))
45f05def5c44c8 Moshe Shemesh    2018-07-04  5314  			continue;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5315  		if (i == DEVLINK_PARAM_CMODE_DRIVERINIT) {
45f05def5c44c8 Moshe Shemesh    2018-07-04  5316  			if (!param_item->driverinit_value_valid)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5317  				return -EOPNOTSUPP;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5318  			param_value[i] = param_item->driverinit_value;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5319  		} else {
45f05def5c44c8 Moshe Shemesh    2018-07-04  5320  			ctx.cmode = i;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5321  			err = devlink_param_get(devlink, param, &ctx);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5322  			if (err)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5323  				return err;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5324  			param_value[i] = ctx.val;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5325  		}
7c62cfb8c5744b Jiri Pirko       2019-02-07  5326  		param_value_set[i] = true;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5327  	}
45f05def5c44c8 Moshe Shemesh    2018-07-04  5328  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5329  	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5330  	if (!hdr)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5331  		return -EMSGSIZE;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5332  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5333  	if (devlink_nl_put_handle(msg, devlink))
45f05def5c44c8 Moshe Shemesh    2018-07-04  5334  		goto genlmsg_cancel;
f4601dee25d5fe Vasundhara Volam 2019-01-28  5335  
c1e5786d6771c6 Vasundhara Volam 2019-01-28  5336  	if (cmd == DEVLINK_CMD_PORT_PARAM_GET ||
c1e5786d6771c6 Vasundhara Volam 2019-01-28  5337  	    cmd == DEVLINK_CMD_PORT_PARAM_NEW ||
c1e5786d6771c6 Vasundhara Volam 2019-01-28  5338  	    cmd == DEVLINK_CMD_PORT_PARAM_DEL)
f4601dee25d5fe Vasundhara Volam 2019-01-28  5339  		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, port_index))
f4601dee25d5fe Vasundhara Volam 2019-01-28  5340  			goto genlmsg_cancel;
f4601dee25d5fe Vasundhara Volam 2019-01-28  5341  
ae0be8de9a53cd Michal Kubecek   2019-04-26  5342  	param_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_PARAM);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5343  	if (!param_attr)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5344  		goto genlmsg_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5345  	if (nla_put_string(msg, DEVLINK_ATTR_PARAM_NAME, param->name))
45f05def5c44c8 Moshe Shemesh    2018-07-04  5346  		goto param_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5347  	if (param->generic && nla_put_flag(msg, DEVLINK_ATTR_PARAM_GENERIC))
45f05def5c44c8 Moshe Shemesh    2018-07-04  5348  		goto param_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5349  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5350  	nla_type = devlink_param_type_to_nla_type(param->type);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5351  	if (nla_type < 0)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5352  		goto param_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5353  	if (nla_put_u8(msg, DEVLINK_ATTR_PARAM_TYPE, nla_type))
45f05def5c44c8 Moshe Shemesh    2018-07-04  5354  		goto param_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5355  
ae0be8de9a53cd Michal Kubecek   2019-04-26  5356  	param_values_list = nla_nest_start_noflag(msg,
ae0be8de9a53cd Michal Kubecek   2019-04-26  5357  						  DEVLINK_ATTR_PARAM_VALUES_LIST);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5358  	if (!param_values_list)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5359  		goto param_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5360  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5361  	for (i = 0; i <= DEVLINK_PARAM_CMODE_MAX; i++) {
7c62cfb8c5744b Jiri Pirko       2019-02-07  5362  		if (!param_value_set[i])
45f05def5c44c8 Moshe Shemesh    2018-07-04  5363  			continue;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5364  		err = devlink_nl_param_value_fill_one(msg, param->type,
45f05def5c44c8 Moshe Shemesh    2018-07-04  5365  						      i, param_value[i]);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5366  		if (err)
45f05def5c44c8 Moshe Shemesh    2018-07-04  5367  			goto values_list_nest_cancel;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5368  	}
45f05def5c44c8 Moshe Shemesh    2018-07-04  5369  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5370  	nla_nest_end(msg, param_values_list);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5371  	nla_nest_end(msg, param_attr);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5372  	genlmsg_end(msg, hdr);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5373  	return 0;
45f05def5c44c8 Moshe Shemesh    2018-07-04  5374  
45f05def5c44c8 Moshe Shemesh    2018-07-04  5375  values_list_nest_cancel:
45f05def5c44c8 Moshe Shemesh    2018-07-04  5376  	nla_nest_end(msg, param_values_list);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5377  param_nest_cancel:
45f05def5c44c8 Moshe Shemesh    2018-07-04  5378  	nla_nest_cancel(msg, param_attr);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5379  genlmsg_cancel:
45f05def5c44c8 Moshe Shemesh    2018-07-04  5380  	genlmsg_cancel(msg, hdr);
45f05def5c44c8 Moshe Shemesh    2018-07-04  5381  	return -EMSGSIZE;
45f05def5c44c8 Moshe Shemesh    2018-07-04 @5382  }
45f05def5c44c8 Moshe Shemesh    2018-07-04  5383  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
