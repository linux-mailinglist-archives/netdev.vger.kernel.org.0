Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9630829EC01
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgJ2Mk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:40:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgJ2MkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:40:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY7E1-0049dv-Sp; Thu, 29 Oct 2020 13:40:17 +0100
Date:   Thu, 29 Oct 2020 13:40:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: tipc: Add __printf() markup to fix
 -Wsuggest-attribute=format
Message-ID: <20201029124017.GI933237@lunn.ch>
References: <20201028003849.929490-3-andrew@lunn.ch>
 <202010291009.4MeXI3UF-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010291009.4MeXI3UF-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:49:34AM +0800, kernel test robot wrote:
> Hi Andrew,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Andrew-Lunn/net-dccp-Add-__printf-markup-to-fix-Wsuggest-attribute-format/20201029-081346
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git cd29296fdfca919590e4004a7e4905544f4c4a32
> config: arc-allyesconfig (attached as .config)
> compiler: arceb-elf-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/0be08855cea6e7b987406c1beee6ca1b508f5066
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Andrew-Lunn/net-dccp-Add-__printf-markup-to-fix-Wsuggest-attribute-format/20201029-081346
>         git checkout 0be08855cea6e7b987406c1beee6ca1b508f5066
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    net/tipc/netlink_compat.c: In function 'tipc_nl_compat_link_stat_dump':
> >> net/tipc/netlink_compat.c:591:39: warning: format '%s' expects argument of type 'char *', but argument 3 has type 'void *' [-Wformat=]
>      591 |  tipc_tlv_sprintf(msg->rep, "\nLink <%s>\n",
>          |                                      ~^
>          |                                       |
>          |                                       char *
>          |                                      %p
>      592 |     nla_data(link[TIPC_NLA_LINK_NAME]));
>          |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
>          |     |
>          |     void *

Yep, which is the point of adding this markup, and why there is a
follow up patch fixing this.

Please don't let this 0-day report stop the commit being merged.

       Andrew
