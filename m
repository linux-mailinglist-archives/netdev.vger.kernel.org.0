Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647842FCCE9
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 09:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbhATImZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 03:42:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:19146 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbhATImO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 03:42:14 -0500
IronPort-SDR: c2qzxPag2ExPPQQMl3APmJY793FDowQPEI0yQFeZZ8SqyX+/gAo4gtnIxDuSYNWwTjurPHsWWQ
 KSrkN5NBvexA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="158843378"
X-IronPort-AV: E=Sophos;i="5.79,360,1602572400"; 
   d="scan'208";a="158843378"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 00:41:31 -0800
IronPort-SDR: 2DBWsjVqjbfjhLhPHq8IgWkspWbQNluOJMlZB+ny64p1NlHCeD47zVeQdWqJejtCjhixVRp8+s
 D0C40LQCRhKw==
X-IronPort-AV: E=Sophos;i="5.79,360,1602572400"; 
   d="scan'208";a="384674871"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 00:41:27 -0800
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     kernel test robot <lkp@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, maximmi@nvidia.com
References: <20210119155013.154808-5-bjorn.topel@gmail.com>
 <202101201622.G3pwF7Zj-lkp@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <20e6b170-21f8-bae0-e775-73bd387b939a@intel.com>
Date:   Wed, 20 Jan 2021 09:41:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <202101201622.G3pwF7Zj-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 09:25, kernel test robot wrote:
> Hi "Björn,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on 95204c9bfa48d2f4d3bab7df55c1cc823957ff81]
> 
> url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-bpf_redirect_xsk-helper/20210120-150357
> base:    95204c9bfa48d2f4d3bab7df55c1cc823957ff81
> config: x86_64-randconfig-m031-20210120 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=1 build):
>          # https://github.com/0day-ci/linux/commit/419b1341d7980ee57fb10f4306719eef3c1a15f8
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Bj-rn-T-pel/Introduce-bpf_redirect_xsk-helper/20210120-150357
>          git checkout 419b1341d7980ee57fb10f4306719eef3c1a15f8
>          # save the attached .config to linux build tree
>          make W=1 ARCH=x86_64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     In file included from <command-line>:
>     net/core/filter.c: In function '____bpf_xdp_redirect_xsk':
>>> net/core/filter.c:4165:35: error: 'struct netdev_rx_queue' has no member named 'xsk'

This rev is missing proper CONFIG_XDP_SOCKET ifdefs. I'll fix this in
the next spin, but I'll wait a bit for more comments.


Björn

[...]
