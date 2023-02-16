Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC366988FF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBPACT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjBPACS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:02:18 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B0F37B4A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676505736; x=1708041736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uom7en3Pw5pTm81KirlMMQMYR+feeqTdGAVzV59Td8E=;
  b=Y1ucDlL54SNPK0cEbicHlx5r4hvGv5zT1o0NSAdXdVfPDZkB/dojB6w5
   P7xrvyZWnPiiUgwb18njcJE1jNvUfZHX+IeJhGzOgPM8PtrVLUaGqgCYJ
   mC3bSrTmdsc5ICybB8zz7nEcTWJrEPBYZu9fO69FAPl0p2igTlaSa2vSA
   QM9ht1yOr48WV046xt9KPMwXbqKKT1W2i07f4YBge8457Ff1l4JFijHBT
   BduNAdI5rO9kyNDK/tXgq1guUA8DApXw9chUowHKy57bgP5IiZ7xuGHo9
   sGbIlr2fnCuWSOWNSCS2mAVoKQYZS+6KScnG75FMbfohMv/AwxgnYvAR9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396213063"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="396213063"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 16:02:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="843924701"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="843924701"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2023 16:02:10 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSRiz-0009t9-2p;
        Thu, 16 Feb 2023 00:02:09 +0000
Date:   Thu, 16 Feb 2023 08:01:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     oe-kbuild-all@lists.linux.dev, Oz Shlomo <ozsh@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v12 1/8] net/sched: Rename user cookie and act
 cookie
Message-ID: <202302160703.Lk9KSGnE-lkp@intel.com>
References: <20230215211014.6485-2-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215211014.6485-2-paulb@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Blakey/net-sched-Rename-user-cookie-and-act-cookie/20230216-051354
patch link:    https://lore.kernel.org/r/20230215211014.6485-2-paulb%40nvidia.com
patch subject: [PATCH net-next v12 1/8] net/sched: Rename user cookie and act cookie
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20230216/202302160703.Lk9KSGnE-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/172c6e134bdb4051c442e2dfad973cf7b4b85ec7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paul-Blakey/net-sched-Rename-user-cookie-and-act-cookie/20230216-051354
        git checkout 172c6e134bdb4051c442e2dfad973cf7b4b85ec7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/mellanox/mlxsw/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302160703.Lk9KSGnE-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c: In function 'mlxsw_sp_flower_parse_actions':
>> drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c:106:62: warning: passing argument 3 of 'mlxsw_sp_acl_rulei_act_drop' makes pointer from integer without a cast [-Wint-conversion]
     106 |                                                           act->cookie, extack);
         |                                                           ~~~^~~~~~~~
         |                                                              |
         |                                                              long unsigned int
   In file included from drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c:15:
   drivers/net/ethernet/mellanox/mlxsw/spectrum.h:1020:66: note: expected 'const struct flow_action_cookie *' but argument is of type 'long unsigned int'
    1020 |                                 const struct flow_action_cookie *fa_cookie,
         |                                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~


vim +/mlxsw_sp_acl_rulei_act_drop +106 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c

d97b4b105ce71f Jianbo Liu         2022-02-24   57  
7aa0f5aa9030aa Jiri Pirko         2017-02-03   58  static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
3bc3ffb6e911f9 Jiri Pirko         2020-04-27   59  					 struct mlxsw_sp_flow_block *block,
7aa0f5aa9030aa Jiri Pirko         2017-02-03   60  					 struct mlxsw_sp_acl_rule_info *rulei,
738678817573ce Pablo Neira Ayuso  2019-02-02   61  					 struct flow_action *flow_action,
ad7769ca2d80c3 Nir Dotan          2018-07-24   62  					 struct netlink_ext_ack *extack)
7aa0f5aa9030aa Jiri Pirko         2017-02-03   63  {
738678817573ce Pablo Neira Ayuso  2019-02-02   64  	const struct flow_action_entry *act;
52feb8b588f6d2 Danielle Ratson    2019-09-26   65  	int mirror_act_count = 0;
af11e818a76914 Ido Schimmel       2020-07-15   66  	int police_act_count = 0;
45aad0b7043da8 Ido Schimmel       2021-03-16   67  	int sample_act_count = 0;
244cd96adb5f5a Cong Wang          2018-08-19   68  	int err, i;
7aa0f5aa9030aa Jiri Pirko         2017-02-03   69  
738678817573ce Pablo Neira Ayuso  2019-02-02   70  	if (!flow_action_has_entries(flow_action))
7aa0f5aa9030aa Jiri Pirko         2017-02-03   71  		return 0;
53eca1f3479f35 Jakub Kicinski     2020-03-16   72  	if (!flow_action_mixed_hw_stats_check(flow_action, extack))
3632f6d3907828 Jiri Pirko         2020-03-07   73  		return -EOPNOTSUPP;
7aa0f5aa9030aa Jiri Pirko         2017-02-03   74  
c4afd0c81635db Jiri Pirko         2020-03-07   75  	act = flow_action_first_entry_get(flow_action);
060b6381efe584 Edward Cree        2020-05-20   76  	if (act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED) {
060b6381efe584 Edward Cree        2020-05-20   77  		/* Nothing to do */
060b6381efe584 Edward Cree        2020-05-20   78  	} else if (act->hw_stats & FLOW_ACTION_HW_STATS_IMMEDIATE) {
7c1b8eb175b69a Arkadi Sharshevsky 2017-03-11   79  		/* Count action is inserted first */
ad7769ca2d80c3 Nir Dotan          2018-07-24   80  		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
7c1b8eb175b69a Arkadi Sharshevsky 2017-03-11   81  		if (err)
7c1b8eb175b69a Arkadi Sharshevsky 2017-03-11   82  			return err;
060b6381efe584 Edward Cree        2020-05-20   83  	} else {
c4afd0c81635db Jiri Pirko         2020-03-07   84  		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
c4afd0c81635db Jiri Pirko         2020-03-07   85  		return -EOPNOTSUPP;
c4afd0c81635db Jiri Pirko         2020-03-07   86  	}
7c1b8eb175b69a Arkadi Sharshevsky 2017-03-11   87  
738678817573ce Pablo Neira Ayuso  2019-02-02   88  	flow_action_for_each(i, act, flow_action) {
738678817573ce Pablo Neira Ayuso  2019-02-02   89  		switch (act->id) {
738678817573ce Pablo Neira Ayuso  2019-02-02   90  		case FLOW_ACTION_ACCEPT:
49bae2f3093b0a Jiri Pirko         2018-03-09   91  			err = mlxsw_sp_acl_rulei_act_terminate(rulei);
27c203cd148921 Nir Dotan          2018-07-24   92  			if (err) {
27c203cd148921 Nir Dotan          2018-07-24   93  				NL_SET_ERR_MSG_MOD(extack, "Cannot append terminate action");
b2925957ec1a93 Jiri Pirko         2017-09-25   94  				return err;
27c203cd148921 Nir Dotan          2018-07-24   95  			}
738678817573ce Pablo Neira Ayuso  2019-02-02   96  			break;
86272d33973c93 Jiri Pirko         2020-02-24   97  		case FLOW_ACTION_DROP: {
86272d33973c93 Jiri Pirko         2020-02-24   98  			bool ingress;
86272d33973c93 Jiri Pirko         2020-02-24   99  
3bc3ffb6e911f9 Jiri Pirko         2020-04-27  100  			if (mlxsw_sp_flow_block_is_mixed_bound(block)) {
86272d33973c93 Jiri Pirko         2020-02-24  101  				NL_SET_ERR_MSG_MOD(extack, "Drop action is not supported when block is bound to ingress and egress");
86272d33973c93 Jiri Pirko         2020-02-24  102  				return -EOPNOTSUPP;
86272d33973c93 Jiri Pirko         2020-02-24  103  			}
3bc3ffb6e911f9 Jiri Pirko         2020-04-27  104  			ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
6d19d2bdc8a15b Jiri Pirko         2020-02-25  105  			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress,
6d19d2bdc8a15b Jiri Pirko         2020-02-25 @106  							  act->cookie, extack);
27c203cd148921 Nir Dotan          2018-07-24  107  			if (err) {
27c203cd148921 Nir Dotan          2018-07-24  108  				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
7aa0f5aa9030aa Jiri Pirko         2017-02-03  109  				return err;
27c203cd148921 Nir Dotan          2018-07-24  110  			}
86272d33973c93 Jiri Pirko         2020-02-24  111  
86272d33973c93 Jiri Pirko         2020-02-24  112  			/* Forbid block with this rulei to be bound
86272d33973c93 Jiri Pirko         2020-02-24  113  			 * to ingress/egress in future. Ingress rule is
86272d33973c93 Jiri Pirko         2020-02-24  114  			 * a blocker for egress and vice versa.
86272d33973c93 Jiri Pirko         2020-02-24  115  			 */
86272d33973c93 Jiri Pirko         2020-02-24  116  			if (ingress)
86272d33973c93 Jiri Pirko         2020-02-24  117  				rulei->egress_bind_blocker = 1;
86272d33973c93 Jiri Pirko         2020-02-24  118  			else
86272d33973c93 Jiri Pirko         2020-02-24  119  				rulei->ingress_bind_blocker = 1;
86272d33973c93 Jiri Pirko         2020-02-24  120  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  121  			break;
738678817573ce Pablo Neira Ayuso  2019-02-02  122  		case FLOW_ACTION_TRAP:
bd5ddba52dc0e2 Jiri Pirko         2017-06-06  123  			err = mlxsw_sp_acl_rulei_act_trap(rulei);
27c203cd148921 Nir Dotan          2018-07-24  124  			if (err) {
27c203cd148921 Nir Dotan          2018-07-24  125  				NL_SET_ERR_MSG_MOD(extack, "Cannot append trap action");
bd5ddba52dc0e2 Jiri Pirko         2017-06-06  126  				return err;
27c203cd148921 Nir Dotan          2018-07-24  127  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  128  			break;
738678817573ce Pablo Neira Ayuso  2019-02-02  129  		case FLOW_ACTION_GOTO: {
738678817573ce Pablo Neira Ayuso  2019-02-02  130  			u32 chain_index = act->chain_index;
0ede6ba2a1de08 Jiri Pirko         2017-08-23  131  			struct mlxsw_sp_acl_ruleset *ruleset;
0ede6ba2a1de08 Jiri Pirko         2017-08-23  132  			u16 group_id;
0ede6ba2a1de08 Jiri Pirko         2017-08-23  133  
3aaff323044e22 Jiri Pirko         2018-01-17  134  			ruleset = mlxsw_sp_acl_ruleset_lookup(mlxsw_sp, block,
0ede6ba2a1de08 Jiri Pirko         2017-08-23  135  							      chain_index,
0ede6ba2a1de08 Jiri Pirko         2017-08-23  136  							      MLXSW_SP_ACL_PROFILE_FLOWER);
0ede6ba2a1de08 Jiri Pirko         2017-08-23  137  			if (IS_ERR(ruleset))
0ede6ba2a1de08 Jiri Pirko         2017-08-23  138  				return PTR_ERR(ruleset);
0ede6ba2a1de08 Jiri Pirko         2017-08-23  139  
0ede6ba2a1de08 Jiri Pirko         2017-08-23  140  			group_id = mlxsw_sp_acl_ruleset_group_id(ruleset);
2a52a8c6e594cd Jiri Pirko         2017-09-25  141  			err = mlxsw_sp_acl_rulei_act_jump(rulei, group_id);
27c203cd148921 Nir Dotan          2018-07-24  142  			if (err) {
27c203cd148921 Nir Dotan          2018-07-24  143  				NL_SET_ERR_MSG_MOD(extack, "Cannot append jump action");
2a52a8c6e594cd Jiri Pirko         2017-09-25  144  				return err;
27c203cd148921 Nir Dotan          2018-07-24  145  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  146  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  147  			break;
738678817573ce Pablo Neira Ayuso  2019-02-02  148  		case FLOW_ACTION_REDIRECT: {
7aa0f5aa9030aa Jiri Pirko         2017-02-03  149  			struct net_device *out_dev;
a110748725450a Ido Schimmel       2017-05-26  150  			struct mlxsw_sp_fid *fid;
a110748725450a Ido Schimmel       2017-05-26  151  			u16 fid_index;
7aa0f5aa9030aa Jiri Pirko         2017-02-03  152  
3bc3ffb6e911f9 Jiri Pirko         2020-04-27  153  			if (mlxsw_sp_flow_block_is_egress_bound(block)) {
185556f0924911 Jiri Pirko         2019-07-27  154  				NL_SET_ERR_MSG_MOD(extack, "Redirect action is not supported on egress");
185556f0924911 Jiri Pirko         2019-07-27  155  				return -EOPNOTSUPP;
185556f0924911 Jiri Pirko         2019-07-27  156  			}
185556f0924911 Jiri Pirko         2019-07-27  157  
c9588e28123c56 Jiri Pirko         2019-07-27  158  			/* Forbid block with this rulei to be bound
c9588e28123c56 Jiri Pirko         2019-07-27  159  			 * to egress in future.
c9588e28123c56 Jiri Pirko         2019-07-27  160  			 */
c9588e28123c56 Jiri Pirko         2019-07-27  161  			rulei->egress_bind_blocker = 1;
c9588e28123c56 Jiri Pirko         2019-07-27  162  
a110748725450a Ido Schimmel       2017-05-26  163  			fid = mlxsw_sp_acl_dummy_fid(mlxsw_sp);
a110748725450a Ido Schimmel       2017-05-26  164  			fid_index = mlxsw_sp_fid_index(fid);
cedbb8b2594876 Jiri Pirko         2017-04-18  165  			err = mlxsw_sp_acl_rulei_act_fid_set(mlxsw_sp, rulei,
ad7769ca2d80c3 Nir Dotan          2018-07-24  166  							     fid_index, extack);
cedbb8b2594876 Jiri Pirko         2017-04-18  167  			if (err)
cedbb8b2594876 Jiri Pirko         2017-04-18  168  				return err;
cedbb8b2594876 Jiri Pirko         2017-04-18  169  
738678817573ce Pablo Neira Ayuso  2019-02-02  170  			out_dev = act->dev;
7aa0f5aa9030aa Jiri Pirko         2017-02-03  171  			err = mlxsw_sp_acl_rulei_act_fwd(mlxsw_sp, rulei,
ad7769ca2d80c3 Nir Dotan          2018-07-24  172  							 out_dev, extack);
7aa0f5aa9030aa Jiri Pirko         2017-02-03  173  			if (err)
7aa0f5aa9030aa Jiri Pirko         2017-02-03  174  				return err;
738678817573ce Pablo Neira Ayuso  2019-02-02  175  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  176  			break;
738678817573ce Pablo Neira Ayuso  2019-02-02  177  		case FLOW_ACTION_MIRRED: {
738678817573ce Pablo Neira Ayuso  2019-02-02  178  			struct net_device *out_dev = act->dev;
d0d13c1858a11b Arkadi Sharshevsky 2018-01-19  179  
52feb8b588f6d2 Danielle Ratson    2019-09-26  180  			if (mirror_act_count++) {
52feb8b588f6d2 Danielle Ratson    2019-09-26  181  				NL_SET_ERR_MSG_MOD(extack, "Multiple mirror actions per rule are not supported");
52feb8b588f6d2 Danielle Ratson    2019-09-26  182  				return -EOPNOTSUPP;
52feb8b588f6d2 Danielle Ratson    2019-09-26  183  			}
52feb8b588f6d2 Danielle Ratson    2019-09-26  184  
d0d13c1858a11b Arkadi Sharshevsky 2018-01-19  185  			err = mlxsw_sp_acl_rulei_act_mirror(mlxsw_sp, rulei,
ad7769ca2d80c3 Nir Dotan          2018-07-24  186  							    block, out_dev,
ad7769ca2d80c3 Nir Dotan          2018-07-24  187  							    extack);
d0d13c1858a11b Arkadi Sharshevsky 2018-01-19  188  			if (err)
d0d13c1858a11b Arkadi Sharshevsky 2018-01-19  189  				return err;
738678817573ce Pablo Neira Ayuso  2019-02-02  190  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  191  			break;
384c2f7473bc4f Ido Schimmel       2019-02-12  192  		case FLOW_ACTION_VLAN_MANGLE: {
738678817573ce Pablo Neira Ayuso  2019-02-02  193  			u16 proto = be16_to_cpu(act->vlan.proto);
738678817573ce Pablo Neira Ayuso  2019-02-02  194  			u8 prio = act->vlan.prio;
738678817573ce Pablo Neira Ayuso  2019-02-02  195  			u16 vid = act->vlan.vid;
a150201a70da3b Petr Machata       2017-03-09  196  
ccfc569347f870 Petr Machata       2020-04-05  197  			err = mlxsw_sp_acl_rulei_act_vlan(mlxsw_sp, rulei,
738678817573ce Pablo Neira Ayuso  2019-02-02  198  							  act->id, vid,
ad7769ca2d80c3 Nir Dotan          2018-07-24  199  							  proto, prio, extack);
ccfc569347f870 Petr Machata       2020-04-05  200  			if (err)
ccfc569347f870 Petr Machata       2020-04-05  201  				return err;
ccfc569347f870 Petr Machata       2020-04-05  202  			break;
738678817573ce Pablo Neira Ayuso  2019-02-02  203  			}
463957e3fbab36 Petr Machata       2020-03-19  204  		case FLOW_ACTION_PRIORITY:
0be0ae144109a4 Petr Machata       2020-04-05  205  			err = mlxsw_sp_acl_rulei_act_priority(mlxsw_sp, rulei,
463957e3fbab36 Petr Machata       2020-03-19  206  							      act->priority,
463957e3fbab36 Petr Machata       2020-03-19  207  							      extack);
0be0ae144109a4 Petr Machata       2020-04-05  208  			if (err)
0be0ae144109a4 Petr Machata       2020-04-05  209  				return err;
0be0ae144109a4 Petr Machata       2020-04-05  210  			break;
9b4b16bba298ce Petr Machata       2020-03-26  211  		case FLOW_ACTION_MANGLE: {
9b4b16bba298ce Petr Machata       2020-03-26  212  			enum flow_action_mangle_base htype = act->mangle.htype;
9b4b16bba298ce Petr Machata       2020-03-26  213  			__be32 be_mask = (__force __be32) act->mangle.mask;
9b4b16bba298ce Petr Machata       2020-03-26  214  			__be32 be_val = (__force __be32) act->mangle.val;
9b4b16bba298ce Petr Machata       2020-03-26  215  			u32 offset = act->mangle.offset;
9b4b16bba298ce Petr Machata       2020-03-26  216  			u32 mask = be32_to_cpu(be_mask);
9b4b16bba298ce Petr Machata       2020-03-26  217  			u32 val = be32_to_cpu(be_val);
9b4b16bba298ce Petr Machata       2020-03-26  218  
9b4b16bba298ce Petr Machata       2020-03-26  219  			err = mlxsw_sp_acl_rulei_act_mangle(mlxsw_sp, rulei,
9b4b16bba298ce Petr Machata       2020-03-26  220  							    htype, offset,
9b4b16bba298ce Petr Machata       2020-03-26  221  							    mask, val, extack);
9b4b16bba298ce Petr Machata       2020-03-26  222  			if (err)
9b4b16bba298ce Petr Machata       2020-03-26  223  				return err;
9b4b16bba298ce Petr Machata       2020-03-26  224  			break;
9b4b16bba298ce Petr Machata       2020-03-26  225  			}
af11e818a76914 Ido Schimmel       2020-07-15  226  		case FLOW_ACTION_POLICE: {
af11e818a76914 Ido Schimmel       2020-07-15  227  			u32 burst;
af11e818a76914 Ido Schimmel       2020-07-15  228  
af11e818a76914 Ido Schimmel       2020-07-15  229  			if (police_act_count++) {
af11e818a76914 Ido Schimmel       2020-07-15  230  				NL_SET_ERR_MSG_MOD(extack, "Multiple police actions per rule are not supported");
af11e818a76914 Ido Schimmel       2020-07-15  231  				return -EOPNOTSUPP;
af11e818a76914 Ido Schimmel       2020-07-15  232  			}
af11e818a76914 Ido Schimmel       2020-07-15  233  
d97b4b105ce71f Jianbo Liu         2022-02-24  234  			err = mlxsw_sp_policer_validate(flow_action, act, extack);
d97b4b105ce71f Jianbo Liu         2022-02-24  235  			if (err)
d97b4b105ce71f Jianbo Liu         2022-02-24  236  				return err;
6a56e19902af01 Baowen Zheng       2021-03-12  237  
af11e818a76914 Ido Schimmel       2020-07-15  238  			/* The kernel might adjust the requested burst size so
af11e818a76914 Ido Schimmel       2020-07-15  239  			 * that it is not exactly a power of two. Re-adjust it
af11e818a76914 Ido Schimmel       2020-07-15  240  			 * here since the hardware only supports burst sizes
af11e818a76914 Ido Schimmel       2020-07-15  241  			 * that are a power of two.
af11e818a76914 Ido Schimmel       2020-07-15  242  			 */
af11e818a76914 Ido Schimmel       2020-07-15  243  			burst = roundup_pow_of_two(act->police.burst);
af11e818a76914 Ido Schimmel       2020-07-15  244  			err = mlxsw_sp_acl_rulei_act_police(mlxsw_sp, rulei,
5a9959008fb631 Baowen Zheng       2021-12-17  245  							    act->hw_index,
af11e818a76914 Ido Schimmel       2020-07-15  246  							    act->police.rate_bytes_ps,
af11e818a76914 Ido Schimmel       2020-07-15  247  							    burst, extack);
af11e818a76914 Ido Schimmel       2020-07-15  248  			if (err)
af11e818a76914 Ido Schimmel       2020-07-15  249  				return err;
af11e818a76914 Ido Schimmel       2020-07-15  250  			break;
af11e818a76914 Ido Schimmel       2020-07-15  251  			}
45aad0b7043da8 Ido Schimmel       2021-03-16  252  		case FLOW_ACTION_SAMPLE: {
45aad0b7043da8 Ido Schimmel       2021-03-16  253  			if (sample_act_count++) {
45aad0b7043da8 Ido Schimmel       2021-03-16  254  				NL_SET_ERR_MSG_MOD(extack, "Multiple sample actions per rule are not supported");
45aad0b7043da8 Ido Schimmel       2021-03-16  255  				return -EOPNOTSUPP;
45aad0b7043da8 Ido Schimmel       2021-03-16  256  			}
45aad0b7043da8 Ido Schimmel       2021-03-16  257  
45aad0b7043da8 Ido Schimmel       2021-03-16  258  			err = mlxsw_sp_acl_rulei_act_sample(mlxsw_sp, rulei,
45aad0b7043da8 Ido Schimmel       2021-03-16  259  							    block,
45aad0b7043da8 Ido Schimmel       2021-03-16  260  							    act->sample.psample_group,
45aad0b7043da8 Ido Schimmel       2021-03-16  261  							    act->sample.rate,
45aad0b7043da8 Ido Schimmel       2021-03-16  262  							    act->sample.trunc_size,
45aad0b7043da8 Ido Schimmel       2021-03-16  263  							    act->sample.truncate,
45aad0b7043da8 Ido Schimmel       2021-03-16  264  							    extack);
45aad0b7043da8 Ido Schimmel       2021-03-16  265  			if (err)
45aad0b7043da8 Ido Schimmel       2021-03-16  266  				return err;
45aad0b7043da8 Ido Schimmel       2021-03-16  267  			break;
45aad0b7043da8 Ido Schimmel       2021-03-16  268  			}
738678817573ce Pablo Neira Ayuso  2019-02-02  269  		default:
27c203cd148921 Nir Dotan          2018-07-24  270  			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
7aa0f5aa9030aa Jiri Pirko         2017-02-03  271  			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
7aa0f5aa9030aa Jiri Pirko         2017-02-03  272  			return -EOPNOTSUPP;
7aa0f5aa9030aa Jiri Pirko         2017-02-03  273  		}
7aa0f5aa9030aa Jiri Pirko         2017-02-03  274  	}
463e1ab82a41c8 Danielle Ratson    2022-02-06  275  
463e1ab82a41c8 Danielle Ratson    2022-02-06  276  	if (rulei->ipv6_valid) {
463e1ab82a41c8 Danielle Ratson    2022-02-06  277  		NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
463e1ab82a41c8 Danielle Ratson    2022-02-06  278  		return -EOPNOTSUPP;
463e1ab82a41c8 Danielle Ratson    2022-02-06  279  	}
463e1ab82a41c8 Danielle Ratson    2022-02-06  280  
7aa0f5aa9030aa Jiri Pirko         2017-02-03  281  	return 0;
7aa0f5aa9030aa Jiri Pirko         2017-02-03  282  }
7aa0f5aa9030aa Jiri Pirko         2017-02-03  283  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
