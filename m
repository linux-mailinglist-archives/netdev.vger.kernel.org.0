Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0033A3F51
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFKJqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhFKJql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:46:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204B8C061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 02:44:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lrdiO-0007MX-G7; Fri, 11 Jun 2021 11:44:36 +0200
Date:   Fri, 11 Jun 2021 11:44:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     kernel test robot <lkp@intel.com>
Cc:     Florian Westphal <fw@strlen.de>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [ipsec-next:testing 10/10] net/xfrm/xfrm_output.c:100:33: error:
 'nh' undeclared
Message-ID: <20210611094436.GR20020@breakpoint.cc>
References: <202106111714.at0vSzPp-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202106111714.at0vSzPp-lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot <lkp@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> head:   65b3564d0c98ea3c0ca4f19d5edd9b77090d8998
> commit: 65b3564d0c98ea3c0ca4f19d5edd9b77090d8998 [10/10] xfrm: merge dstopt and routing hdroff functions
> config: sh-randconfig-s031-20210611 (attached as .config)
> compiler: sh4-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-341-g8af24329-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git/commit/?id=65b3564d0c98ea3c0ca4f19d5edd9b77090d8998
>         git remote add ipsec-next https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git
>         git fetch --no-tags ipsec-next testing
>         git checkout 65b3564d0c98ea3c0ca4f19d5edd9b77090d8998
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' W=1 ARCH=sh 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>

Ouch, my bad.  I'll send a fix.
