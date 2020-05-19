Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45D51D9C5D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgESQUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:20:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:9797 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgESQUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:20:14 -0400
IronPort-SDR: o3RNfQZBKwvz4Azsv4w4nCsmLeeCOymg4C4ySIZDif8HUEJwXMtbyNHl0p5f1TAZLHGDpu6l8r
 /W7gN+x1SsoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 09:20:14 -0700
IronPort-SDR: eirhOS9d5jbEnEJW7qcNvSY8CvMw3KNxz3F3nzI3oNMNIvzXku6lZAwphlIZ54DxxvP2rce+z7
 4XKPKDRag0ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,410,1583222400"; 
   d="scan'208";a="439672455"
Received: from shochwel-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.38.72])
  by orsmga005.jf.intel.com with ESMTP; 19 May 2020 09:20:10 -0700
Subject: Re: [PATCH bpf-next v3 07/15] i40e: separate kernel allocated rx_bi
 rings from AF_XDP rings
To:     kbuild test robot <lkp@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     kbuild-all@lists.01.org, maximmi@mellanox.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org
References: <20200519085724.294949-8-bjorn.topel@gmail.com>
 <202005192351.j1H08VpV%lkp@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <c81b36a0-11dd-4b7f-fad8-85f31dced58c@intel.com>
Date:   Tue, 19 May 2020 18:20:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <202005192351.j1H08VpV%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-19 17:18, kbuild test robot wrote:
> Hi "Björn,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on bpf-next/master]
> [also build test WARNING on jkirsher-next-queue/dev-queue next-20200518]
> [cannot apply to bpf/master linus/master v5.7-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Bj-rn-T-pel/Introduce-AF_XDP-buffer-allocation-API/20200519-203122
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: riscv-allyesconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 9.3.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=riscv
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
>>> drivers/net/ethernet/intel/i40e/i40e_txrx.c:531:6: warning: no previous prototype for 'i40e_fd_handle_status' [-Wmissing-prototypes]
> 531 | void i40e_fd_handle_status(struct i40e_ring *rx_ring, u64 qword0_raw,
> |      ^~~~~~~~~~~~~~~~~~~~~
>

Yes, this could indeed be made static. Hmm, I wonder why I didn't get
that warning on my x86-64 build!? I'll spin a v4 (or do a follow-up?).


Björn
