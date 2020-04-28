Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381951BB2A3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 02:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgD1AV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 20:21:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:55328 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgD1AV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 20:21:26 -0400
IronPort-SDR: c0jRT4hJfN49aQpbHE5sbXT+HgSkBohg2/FSTGUDASF2ToOsRm5hk597Y0kNk/reSNL6UuSc68
 a1E6/njgjNBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:21:25 -0700
IronPort-SDR: WxT6wELVrEv1bLcnoai5Vj3NqJplvVi8/p0QRnBayX6BZErMeNrM0R/JP8wu8MtvEgDkzP05hF
 lkX1NASt+t/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="281960935"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.3]) ([10.239.13.3])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2020 17:21:24 -0700
Subject: Re: [kbuild-all] Re: [ipsec-next:testing 1/2] net/ipv6/esp6.c:144:15:
 error: implicit declaration of function 'csum_ipv6_magic'; did you mean
 'csum_tcpudp_magic'?
To:     Sabrina Dubroca <sd@queasysnail.net>,
        kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <202004232028.daosFvMI%lkp@intel.com>
 <20200427143234.GA113923@bistromath.localdomain>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <019f7073-d423-8b42-bd76-ca1dba0e65e5@intel.com>
Date:   Tue, 28 Apr 2020 08:21:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200427143234.GA113923@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/20 10:32 PM, Sabrina Dubroca wrote:
> 2020-04-23, 20:02:30 +0800, kbuild test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
>> head:   ce37981d9045220810dabcb9cf20a1d86202c76a
>> commit: 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3 [1/2] xfrm: add support for UDPv6 encapsulation of ESP
>> config: c6x-allyesconfig (attached as .config)
>> compiler: c6x-elf-gcc (GCC) 9.3.0
>> reproduce:
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          git checkout 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3
>>          # save the attached .config to linux build tree
>>          COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=c6x
> This doesn't work for me :(
>
> $HOME/0day/gcc-9.3.0-nolibc/c6x-elf/bin/../libexec/gcc/c6x-elf/9.3.0/cc1: error while loading shared libraries: libisl.so.19: cannot open shared object file: No such file or directory
>
>

Hi Sabrina,

You may need to install libisl19.

Best Regards,
Rong Chen
