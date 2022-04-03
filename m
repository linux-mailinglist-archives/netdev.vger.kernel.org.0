Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C61D4F0C4C
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 21:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376323AbiDCTgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 15:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbiDCTgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 15:36:39 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC2913D70;
        Sun,  3 Apr 2022 12:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649014483; x=1680550483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3fpNeibRgHoTtUImlPP9C8yV/BuGARvlKzID5Z6b34k=;
  b=E9cJPqCrbuR4fuRi4KhcUidpYt9t8pAG50YZlzfNGUCVpOBcCuZgxImM
   kDJZhcHgqTb4PPl47MsJaLAfNFkojX/G6NhwQcUxQ5YcJlUNazhR0W9nS
   xsZAJ+YQwfTVEGhlwUrnCC/K6Mp7qlmyZEbkimqgmmG6D4s65SdLZvPsX
   ib/rhNQfSQKWp9PJeLgtiCdaW+/tCnNyM8rNUxFAzq4UUiagM4in0qzKt
   bt4te92hqwTprRwZwW7g+v+z6yuHJd+aReZ+2VIS7se9qkgtfVeT1kSiS
   4w4OFxSAFls4slfSMwv+kNThnM+XC+mEt4hHSZwFAnnsRBI8z/8HbwI8D
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="321101389"
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="321101389"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 12:34:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,231,1643702400"; 
   d="scan'208";a="504694899"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 03 Apr 2022 12:34:39 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nb5zj-0001BR-0i;
        Sun, 03 Apr 2022 19:34:39 +0000
Date:   Mon, 4 Apr 2022 03:34:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stijn Tintel <stijn@linux-ipv6.be>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, pali@kernel.org, kabel@kernel.org,
        pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH] net: phy: marvell: add 88E1543 support
Message-ID: <202204040323.maY1Ox99-lkp@intel.com>
References: <20220403172936.3213998-1-stijn@linux-ipv6.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403172936.3213998-1-stijn@linux-ipv6.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stijn,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on net-next/master horms-ipvs/master linus/master v5.17 next-20220401]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Stijn-Tintel/net-phy-marvell-add-88E1543-support/20220404-013014
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 692930cc435099580a4b9e32fa781b0688c18439
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220404/202204040323.maY1Ox99-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c4a1b07d0979e7ff20d7d541af666d822d66b566)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/347a5d3810df9aea60a8ab28f6ca2060fce76830
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stijn-Tintel/net-phy-marvell-add-88E1543-support/20220404-013014
        git checkout 347a5d3810df9aea60a8ab28f6ca2060fce76830
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/phy/marvell.c:3181:20: error: use of undeclared identifier 'm88e1121_did_interrupt'
                   .did_interrupt = m88e1121_did_interrupt,
                                    ^
>> drivers/net/phy/marvell.c:3364:1: error: invalid application of 'sizeof' to an incomplete type 'struct phy_driver[]'
   module_phy_driver(marvell_drivers);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/phy.h:1827:35: note: expanded from macro 'module_phy_driver'
           phy_module_driver(__phy_drivers, ARRAY_SIZE(__phy_drivers))
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:55:32: note: expanded from macro 'ARRAY_SIZE'
   #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
                                  ^
   include/linux/phy.h:1817:45: note: expanded from macro 'phy_module_driver'
           return phy_drivers_register(__phy_drivers, __count, THIS_MODULE); \
                                                      ^~~~~~~
>> drivers/net/phy/marvell.c:3364:1: error: invalid application of 'sizeof' to an incomplete type 'struct phy_driver[]'
   module_phy_driver(marvell_drivers);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/phy.h:1827:35: note: expanded from macro 'module_phy_driver'
           phy_module_driver(__phy_drivers, ARRAY_SIZE(__phy_drivers))
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:55:32: note: expanded from macro 'ARRAY_SIZE'
   #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
                                  ^
   include/linux/phy.h:1822:40: note: expanded from macro 'phy_module_driver'
           phy_drivers_unregister(__phy_drivers, __count);                 \
                                                 ^~~~~~~
   3 errors generated.


vim +/m88e1121_did_interrupt +3181 drivers/net/phy/marvell.c

  2894	
  2895	static struct phy_driver marvell_drivers[] = {
  2896		{
  2897			.phy_id = MARVELL_PHY_ID_88E1101,
  2898			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2899			.name = "Marvell 88E1101",
  2900			/* PHY_GBIT_FEATURES */
  2901			.probe = marvell_probe,
  2902			.config_init = marvell_config_init,
  2903			.config_aneg = m88e1101_config_aneg,
  2904			.config_intr = marvell_config_intr,
  2905			.handle_interrupt = marvell_handle_interrupt,
  2906			.resume = genphy_resume,
  2907			.suspend = genphy_suspend,
  2908			.read_page = marvell_read_page,
  2909			.write_page = marvell_write_page,
  2910			.get_sset_count = marvell_get_sset_count,
  2911			.get_strings = marvell_get_strings,
  2912			.get_stats = marvell_get_stats,
  2913		},
  2914		{
  2915			.phy_id = MARVELL_PHY_ID_88E1112,
  2916			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2917			.name = "Marvell 88E1112",
  2918			/* PHY_GBIT_FEATURES */
  2919			.probe = marvell_probe,
  2920			.config_init = m88e1112_config_init,
  2921			.config_aneg = marvell_config_aneg,
  2922			.config_intr = marvell_config_intr,
  2923			.handle_interrupt = marvell_handle_interrupt,
  2924			.resume = genphy_resume,
  2925			.suspend = genphy_suspend,
  2926			.read_page = marvell_read_page,
  2927			.write_page = marvell_write_page,
  2928			.get_sset_count = marvell_get_sset_count,
  2929			.get_strings = marvell_get_strings,
  2930			.get_stats = marvell_get_stats,
  2931			.get_tunable = m88e1011_get_tunable,
  2932			.set_tunable = m88e1011_set_tunable,
  2933		},
  2934		{
  2935			.phy_id = MARVELL_PHY_ID_88E1111,
  2936			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2937			.name = "Marvell 88E1111",
  2938			/* PHY_GBIT_FEATURES */
  2939			.probe = marvell_probe,
  2940			.config_init = m88e1111gbe_config_init,
  2941			.config_aneg = m88e1111_config_aneg,
  2942			.read_status = marvell_read_status,
  2943			.config_intr = marvell_config_intr,
  2944			.handle_interrupt = marvell_handle_interrupt,
  2945			.resume = genphy_resume,
  2946			.suspend = genphy_suspend,
  2947			.read_page = marvell_read_page,
  2948			.write_page = marvell_write_page,
  2949			.get_sset_count = marvell_get_sset_count,
  2950			.get_strings = marvell_get_strings,
  2951			.get_stats = marvell_get_stats,
  2952			.get_tunable = m88e1111_get_tunable,
  2953			.set_tunable = m88e1111_set_tunable,
  2954		},
  2955		{
  2956			.phy_id = MARVELL_PHY_ID_88E1111_FINISAR,
  2957			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2958			.name = "Marvell 88E1111 (Finisar)",
  2959			/* PHY_GBIT_FEATURES */
  2960			.probe = marvell_probe,
  2961			.config_init = m88e1111gbe_config_init,
  2962			.config_aneg = m88e1111_config_aneg,
  2963			.read_status = marvell_read_status,
  2964			.config_intr = marvell_config_intr,
  2965			.handle_interrupt = marvell_handle_interrupt,
  2966			.resume = genphy_resume,
  2967			.suspend = genphy_suspend,
  2968			.read_page = marvell_read_page,
  2969			.write_page = marvell_write_page,
  2970			.get_sset_count = marvell_get_sset_count,
  2971			.get_strings = marvell_get_strings,
  2972			.get_stats = marvell_get_stats,
  2973			.get_tunable = m88e1111_get_tunable,
  2974			.set_tunable = m88e1111_set_tunable,
  2975		},
  2976		{
  2977			.phy_id = MARVELL_PHY_ID_88E1118,
  2978			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2979			.name = "Marvell 88E1118",
  2980			/* PHY_GBIT_FEATURES */
  2981			.probe = marvell_probe,
  2982			.config_init = m88e1118_config_init,
  2983			.config_aneg = m88e1118_config_aneg,
  2984			.config_intr = marvell_config_intr,
  2985			.handle_interrupt = marvell_handle_interrupt,
  2986			.resume = genphy_resume,
  2987			.suspend = genphy_suspend,
  2988			.read_page = marvell_read_page,
  2989			.write_page = marvell_write_page,
  2990			.get_sset_count = marvell_get_sset_count,
  2991			.get_strings = marvell_get_strings,
  2992			.get_stats = marvell_get_stats,
  2993		},
  2994		{
  2995			.phy_id = MARVELL_PHY_ID_88E1121R,
  2996			.phy_id_mask = MARVELL_PHY_ID_MASK,
  2997			.name = "Marvell 88E1121R",
  2998			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1121_hwmon_ops),
  2999			/* PHY_GBIT_FEATURES */
  3000			.probe = marvell_probe,
  3001			.config_init = marvell_1011gbe_config_init,
  3002			.config_aneg = m88e1121_config_aneg,
  3003			.read_status = marvell_read_status,
  3004			.config_intr = marvell_config_intr,
  3005			.handle_interrupt = marvell_handle_interrupt,
  3006			.resume = genphy_resume,
  3007			.suspend = genphy_suspend,
  3008			.read_page = marvell_read_page,
  3009			.write_page = marvell_write_page,
  3010			.get_sset_count = marvell_get_sset_count,
  3011			.get_strings = marvell_get_strings,
  3012			.get_stats = marvell_get_stats,
  3013			.get_tunable = m88e1011_get_tunable,
  3014			.set_tunable = m88e1011_set_tunable,
  3015		},
  3016		{
  3017			.phy_id = MARVELL_PHY_ID_88E1318S,
  3018			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3019			.name = "Marvell 88E1318S",
  3020			/* PHY_GBIT_FEATURES */
  3021			.probe = marvell_probe,
  3022			.config_init = m88e1318_config_init,
  3023			.config_aneg = m88e1318_config_aneg,
  3024			.read_status = marvell_read_status,
  3025			.config_intr = marvell_config_intr,
  3026			.handle_interrupt = marvell_handle_interrupt,
  3027			.get_wol = m88e1318_get_wol,
  3028			.set_wol = m88e1318_set_wol,
  3029			.resume = genphy_resume,
  3030			.suspend = genphy_suspend,
  3031			.read_page = marvell_read_page,
  3032			.write_page = marvell_write_page,
  3033			.get_sset_count = marvell_get_sset_count,
  3034			.get_strings = marvell_get_strings,
  3035			.get_stats = marvell_get_stats,
  3036		},
  3037		{
  3038			.phy_id = MARVELL_PHY_ID_88E1145,
  3039			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3040			.name = "Marvell 88E1145",
  3041			/* PHY_GBIT_FEATURES */
  3042			.probe = marvell_probe,
  3043			.config_init = m88e1145_config_init,
  3044			.config_aneg = m88e1101_config_aneg,
  3045			.config_intr = marvell_config_intr,
  3046			.handle_interrupt = marvell_handle_interrupt,
  3047			.resume = genphy_resume,
  3048			.suspend = genphy_suspend,
  3049			.read_page = marvell_read_page,
  3050			.write_page = marvell_write_page,
  3051			.get_sset_count = marvell_get_sset_count,
  3052			.get_strings = marvell_get_strings,
  3053			.get_stats = marvell_get_stats,
  3054			.get_tunable = m88e1111_get_tunable,
  3055			.set_tunable = m88e1111_set_tunable,
  3056		},
  3057		{
  3058			.phy_id = MARVELL_PHY_ID_88E1149R,
  3059			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3060			.name = "Marvell 88E1149R",
  3061			/* PHY_GBIT_FEATURES */
  3062			.probe = marvell_probe,
  3063			.config_init = m88e1149_config_init,
  3064			.config_aneg = m88e1118_config_aneg,
  3065			.config_intr = marvell_config_intr,
  3066			.handle_interrupt = marvell_handle_interrupt,
  3067			.resume = genphy_resume,
  3068			.suspend = genphy_suspend,
  3069			.read_page = marvell_read_page,
  3070			.write_page = marvell_write_page,
  3071			.get_sset_count = marvell_get_sset_count,
  3072			.get_strings = marvell_get_strings,
  3073			.get_stats = marvell_get_stats,
  3074		},
  3075		{
  3076			.phy_id = MARVELL_PHY_ID_88E1240,
  3077			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3078			.name = "Marvell 88E1240",
  3079			/* PHY_GBIT_FEATURES */
  3080			.probe = marvell_probe,
  3081			.config_init = m88e1112_config_init,
  3082			.config_aneg = marvell_config_aneg,
  3083			.config_intr = marvell_config_intr,
  3084			.handle_interrupt = marvell_handle_interrupt,
  3085			.resume = genphy_resume,
  3086			.suspend = genphy_suspend,
  3087			.read_page = marvell_read_page,
  3088			.write_page = marvell_write_page,
  3089			.get_sset_count = marvell_get_sset_count,
  3090			.get_strings = marvell_get_strings,
  3091			.get_stats = marvell_get_stats,
  3092			.get_tunable = m88e1011_get_tunable,
  3093			.set_tunable = m88e1011_set_tunable,
  3094		},
  3095		{
  3096			.phy_id = MARVELL_PHY_ID_88E1116R,
  3097			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3098			.name = "Marvell 88E1116R",
  3099			/* PHY_GBIT_FEATURES */
  3100			.probe = marvell_probe,
  3101			.config_init = m88e1116r_config_init,
  3102			.config_intr = marvell_config_intr,
  3103			.handle_interrupt = marvell_handle_interrupt,
  3104			.resume = genphy_resume,
  3105			.suspend = genphy_suspend,
  3106			.read_page = marvell_read_page,
  3107			.write_page = marvell_write_page,
  3108			.get_sset_count = marvell_get_sset_count,
  3109			.get_strings = marvell_get_strings,
  3110			.get_stats = marvell_get_stats,
  3111			.get_tunable = m88e1011_get_tunable,
  3112			.set_tunable = m88e1011_set_tunable,
  3113		},
  3114		{
  3115			.phy_id = MARVELL_PHY_ID_88E1510,
  3116			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3117			.name = "Marvell 88E1510",
  3118			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3119			.features = PHY_GBIT_FIBRE_FEATURES,
  3120			.flags = PHY_POLL_CABLE_TEST,
  3121			.probe = m88e1510_probe,
  3122			.config_init = m88e1510_config_init,
  3123			.config_aneg = m88e1510_config_aneg,
  3124			.read_status = marvell_read_status,
  3125			.config_intr = marvell_config_intr,
  3126			.handle_interrupt = marvell_handle_interrupt,
  3127			.get_wol = m88e1318_get_wol,
  3128			.set_wol = m88e1318_set_wol,
  3129			.resume = marvell_resume,
  3130			.suspend = marvell_suspend,
  3131			.read_page = marvell_read_page,
  3132			.write_page = marvell_write_page,
  3133			.get_sset_count = marvell_get_sset_count,
  3134			.get_strings = marvell_get_strings,
  3135			.get_stats = marvell_get_stats,
  3136			.set_loopback = m88e1510_loopback,
  3137			.get_tunable = m88e1011_get_tunable,
  3138			.set_tunable = m88e1011_set_tunable,
  3139			.cable_test_start = marvell_vct7_cable_test_start,
  3140			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3141			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3142		},
  3143		{
  3144			.phy_id = MARVELL_PHY_ID_88E1540,
  3145			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3146			.name = "Marvell 88E1540",
  3147			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3148			/* PHY_GBIT_FEATURES */
  3149			.flags = PHY_POLL_CABLE_TEST,
  3150			.probe = marvell_probe,
  3151			.config_init = marvell_1011gbe_config_init,
  3152			.config_aneg = m88e1510_config_aneg,
  3153			.read_status = marvell_read_status,
  3154			.config_intr = marvell_config_intr,
  3155			.handle_interrupt = marvell_handle_interrupt,
  3156			.resume = genphy_resume,
  3157			.suspend = genphy_suspend,
  3158			.read_page = marvell_read_page,
  3159			.write_page = marvell_write_page,
  3160			.get_sset_count = marvell_get_sset_count,
  3161			.get_strings = marvell_get_strings,
  3162			.get_stats = marvell_get_stats,
  3163			.get_tunable = m88e1540_get_tunable,
  3164			.set_tunable = m88e1540_set_tunable,
  3165			.cable_test_start = marvell_vct7_cable_test_start,
  3166			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3167			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3168		},
  3169		{
  3170			.phy_id = MARVELL_PHY_ID_88E1543,
  3171			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3172			.name = "Marvell 88E1543",
  3173			.probe = m88e1510_probe,
  3174			/* PHY_GBIT_FEATURES */
  3175			.flags = PHY_POLL_CABLE_TEST,
  3176			.config_init = marvell_config_init,
  3177			.config_aneg = m88e1510_config_aneg,
  3178			.read_status = marvell_read_status,
  3179			.ack_interrupt = marvell_ack_interrupt,
  3180			.config_intr = marvell_config_intr,
> 3181			.did_interrupt = m88e1121_did_interrupt,
  3182			.resume = genphy_resume,
  3183			.suspend = genphy_suspend,
  3184			.read_page = marvell_read_page,
  3185			.write_page = marvell_write_page,
  3186			.get_sset_count = marvell_get_sset_count,
  3187			.get_strings = marvell_get_strings,
  3188			.get_stats = marvell_get_stats,
  3189			.get_tunable = m88e1540_get_tunable,
  3190			.set_tunable = m88e1540_set_tunable,
  3191			.cable_test_start = marvell_vct7_cable_test_start,
  3192			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3193			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3194		},
  3195		{
  3196			.phy_id = MARVELL_PHY_ID_88E1545,
  3197			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3198			.name = "Marvell 88E1545",
  3199			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3200			.probe = marvell_probe,
  3201			/* PHY_GBIT_FEATURES */
  3202			.flags = PHY_POLL_CABLE_TEST,
  3203			.config_init = marvell_1011gbe_config_init,
  3204			.config_aneg = m88e1510_config_aneg,
  3205			.read_status = marvell_read_status,
  3206			.config_intr = marvell_config_intr,
  3207			.handle_interrupt = marvell_handle_interrupt,
  3208			.resume = genphy_resume,
  3209			.suspend = genphy_suspend,
  3210			.read_page = marvell_read_page,
  3211			.write_page = marvell_write_page,
  3212			.get_sset_count = marvell_get_sset_count,
  3213			.get_strings = marvell_get_strings,
  3214			.get_stats = marvell_get_stats,
  3215			.get_tunable = m88e1540_get_tunable,
  3216			.set_tunable = m88e1540_set_tunable,
  3217			.cable_test_start = marvell_vct7_cable_test_start,
  3218			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3219			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3220		},
  3221		{
  3222			.phy_id = MARVELL_PHY_ID_88E3016,
  3223			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3224			.name = "Marvell 88E3016",
  3225			/* PHY_BASIC_FEATURES */
  3226			.probe = marvell_probe,
  3227			.config_init = m88e3016_config_init,
  3228			.aneg_done = marvell_aneg_done,
  3229			.read_status = marvell_read_status,
  3230			.config_intr = marvell_config_intr,
  3231			.handle_interrupt = marvell_handle_interrupt,
  3232			.resume = genphy_resume,
  3233			.suspend = genphy_suspend,
  3234			.read_page = marvell_read_page,
  3235			.write_page = marvell_write_page,
  3236			.get_sset_count = marvell_get_sset_count,
  3237			.get_strings = marvell_get_strings,
  3238			.get_stats = marvell_get_stats,
  3239		},
  3240		{
  3241			.phy_id = MARVELL_PHY_ID_88E6341_FAMILY,
  3242			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3243			.name = "Marvell 88E6341 Family",
  3244			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3245			/* PHY_GBIT_FEATURES */
  3246			.flags = PHY_POLL_CABLE_TEST,
  3247			.probe = marvell_probe,
  3248			.config_init = marvell_1011gbe_config_init,
  3249			.config_aneg = m88e6390_config_aneg,
  3250			.read_status = marvell_read_status,
  3251			.config_intr = marvell_config_intr,
  3252			.handle_interrupt = marvell_handle_interrupt,
  3253			.resume = genphy_resume,
  3254			.suspend = genphy_suspend,
  3255			.read_page = marvell_read_page,
  3256			.write_page = marvell_write_page,
  3257			.get_sset_count = marvell_get_sset_count,
  3258			.get_strings = marvell_get_strings,
  3259			.get_stats = marvell_get_stats,
  3260			.get_tunable = m88e1540_get_tunable,
  3261			.set_tunable = m88e1540_set_tunable,
  3262			.cable_test_start = marvell_vct7_cable_test_start,
  3263			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3264			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3265		},
  3266		{
  3267			.phy_id = MARVELL_PHY_ID_88E6390_FAMILY,
  3268			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3269			.name = "Marvell 88E6390 Family",
  3270			.driver_data = DEF_MARVELL_HWMON_OPS(m88e6390_hwmon_ops),
  3271			/* PHY_GBIT_FEATURES */
  3272			.flags = PHY_POLL_CABLE_TEST,
  3273			.probe = marvell_probe,
  3274			.config_init = marvell_1011gbe_config_init,
  3275			.config_aneg = m88e6390_config_aneg,
  3276			.read_status = marvell_read_status,
  3277			.config_intr = marvell_config_intr,
  3278			.handle_interrupt = marvell_handle_interrupt,
  3279			.resume = genphy_resume,
  3280			.suspend = genphy_suspend,
  3281			.read_page = marvell_read_page,
  3282			.write_page = marvell_write_page,
  3283			.get_sset_count = marvell_get_sset_count,
  3284			.get_strings = marvell_get_strings,
  3285			.get_stats = marvell_get_stats,
  3286			.get_tunable = m88e1540_get_tunable,
  3287			.set_tunable = m88e1540_set_tunable,
  3288			.cable_test_start = marvell_vct7_cable_test_start,
  3289			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3290			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3291		},
  3292		{
  3293			.phy_id = MARVELL_PHY_ID_88E6393_FAMILY,
  3294			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3295			.name = "Marvell 88E6393 Family",
  3296			.driver_data = DEF_MARVELL_HWMON_OPS(m88e6393_hwmon_ops),
  3297			/* PHY_GBIT_FEATURES */
  3298			.flags = PHY_POLL_CABLE_TEST,
  3299			.probe = marvell_probe,
  3300			.config_init = marvell_1011gbe_config_init,
  3301			.config_aneg = m88e1510_config_aneg,
  3302			.read_status = marvell_read_status,
  3303			.config_intr = marvell_config_intr,
  3304			.handle_interrupt = marvell_handle_interrupt,
  3305			.resume = genphy_resume,
  3306			.suspend = genphy_suspend,
  3307			.read_page = marvell_read_page,
  3308			.write_page = marvell_write_page,
  3309			.get_sset_count = marvell_get_sset_count,
  3310			.get_strings = marvell_get_strings,
  3311			.get_stats = marvell_get_stats,
  3312			.get_tunable = m88e1540_get_tunable,
  3313			.set_tunable = m88e1540_set_tunable,
  3314			.cable_test_start = marvell_vct7_cable_test_start,
  3315			.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
  3316			.cable_test_get_status = marvell_vct7_cable_test_get_status,
  3317		},
  3318		{
  3319			.phy_id = MARVELL_PHY_ID_88E1340S,
  3320			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3321			.name = "Marvell 88E1340S",
  3322			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3323			.probe = marvell_probe,
  3324			/* PHY_GBIT_FEATURES */
  3325			.config_init = marvell_1011gbe_config_init,
  3326			.config_aneg = m88e1510_config_aneg,
  3327			.read_status = marvell_read_status,
  3328			.config_intr = marvell_config_intr,
  3329			.handle_interrupt = marvell_handle_interrupt,
  3330			.resume = genphy_resume,
  3331			.suspend = genphy_suspend,
  3332			.read_page = marvell_read_page,
  3333			.write_page = marvell_write_page,
  3334			.get_sset_count = marvell_get_sset_count,
  3335			.get_strings = marvell_get_strings,
  3336			.get_stats = marvell_get_stats,
  3337			.get_tunable = m88e1540_get_tunable,
  3338			.set_tunable = m88e1540_set_tunable,
  3339		},
  3340		{
  3341			.phy_id = MARVELL_PHY_ID_88E1548P,
  3342			.phy_id_mask = MARVELL_PHY_ID_MASK,
  3343			.name = "Marvell 88E1548P",
  3344			.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
  3345			.probe = marvell_probe,
  3346			.features = PHY_GBIT_FIBRE_FEATURES,
  3347			.config_init = marvell_1011gbe_config_init,
  3348			.config_aneg = m88e1510_config_aneg,
  3349			.read_status = marvell_read_status,
  3350			.config_intr = marvell_config_intr,
  3351			.handle_interrupt = marvell_handle_interrupt,
  3352			.resume = genphy_resume,
  3353			.suspend = genphy_suspend,
  3354			.read_page = marvell_read_page,
  3355			.write_page = marvell_write_page,
  3356			.get_sset_count = marvell_get_sset_count,
  3357			.get_strings = marvell_get_strings,
  3358			.get_stats = marvell_get_stats,
  3359			.get_tunable = m88e1540_get_tunable,
  3360			.set_tunable = m88e1540_set_tunable,
  3361		},
  3362	};
  3363	
> 3364	module_phy_driver(marvell_drivers);
  3365	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
