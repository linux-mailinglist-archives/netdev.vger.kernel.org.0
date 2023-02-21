Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3DD69DBD5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjBUIWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjBUIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:22:51 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BBC10CB;
        Tue, 21 Feb 2023 00:22:49 -0800 (PST)
Received: from [192.168.178.43] (dynamic-adsl-94-34-19-170.clienti.tiscali.it [94.34.19.170])
        by linux.microsoft.com (Postfix) with ESMTPSA id A7416209A89A;
        Tue, 21 Feb 2023 00:22:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A7416209A89A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1676967768;
        bh=oB6XZJNuRNsKWddqARPVPvSPJ4dG7fYOorsslLvoIwk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OSpF73HaNhkK604LDLNwPikfdAo38G0qWmAg4MS+6/jkKwJb7ihtGvY4ZmuIyWOuT
         /RYnp24ac9YMLE+RH+ls7P5xr/2hkHJAYjF1efRpm2kP9IUaaJDlJJdoeX+QzVoSG3
         N5dqVhlvZaot+SywMXJxKLbDJMbBV49+yJhthiyA=
Message-ID: <1dcc9919-3d92-f9cc-7274-f12e5186a66e@linux.microsoft.com>
Date:   Tue, 21 Feb 2023 09:22:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on
 x86
To:     kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Christoph Hellwig <hch@lst.de>
References: <20230220130235.2603366-1-jpiotrowski@linux.microsoft.com>
 <202302210943.Xq84rrhU-lkp@intel.com>
Content-Language: en-US
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <202302210943.Xq84rrhU-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/02/2023 02:08, kernel test robot wrote:
> Hi Jeremi,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on horms-ipvs/master]
> [also build test WARNING on mst-vhost/linux-next net/master net-next/master linus/master v6.2]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Jeremi-Piotrowski/ptp-kvm-Use-decrypted-memory-in-confidential-guest-on-x86/20230220-210441
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
> patch link:    https://lore.kernel.org/r/20230220130235.2603366-1-jpiotrowski%40linux.microsoft.com
> patch subject: [PATCH] ptp: kvm: Use decrypted memory in confidential guest on x86
> config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230221/202302210943.Xq84rrhU-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/0dd1701fd254692af3d0ca051e092e8dcef190c4
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Jeremi-Piotrowski/ptp-kvm-Use-decrypted-memory-in-confidential-guest-on-x86/20230220-210441
>         git checkout 0dd1701fd254692af3d0ca051e092e8dcef190c4
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 olddefconfig
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202302210943.Xq84rrhU-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/ptp/ptp_kvm_x86.c: In function 'kvm_arch_ptp_init':
>    drivers/ptp/ptp_kvm_x86.c:63:9: error: implicit declaration of function 'kvm_arch_ptp_exit'; did you mean 'kvm_arch_ptp_init'? [-Werror=implicit-function-declaration]
>       63 |         kvm_arch_ptp_exit();
>          |         ^~~~~~~~~~~~~~~~~
>          |         kvm_arch_ptp_init
>    drivers/ptp/ptp_kvm_x86.c: At top level:
>>> drivers/ptp/ptp_kvm_x86.c:68:6: warning: no previous prototype for 'kvm_arch_ptp_exit' [-Wmissing-prototypes]
>       68 | void kvm_arch_ptp_exit(void)
>          |      ^~~~~~~~~~~~~~~~~
>>> drivers/ptp/ptp_kvm_x86.c:68:6: warning: conflicting types for 'kvm_arch_ptp_exit'; have 'void(void)'
>    drivers/ptp/ptp_kvm_x86.c:63:9: note: previous implicit declaration of 'kvm_arch_ptp_exit' with type 'void(void)'
>       63 |         kvm_arch_ptp_exit();
>          |         ^~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> 
> vim +/kvm_arch_ptp_exit +68 drivers/ptp/ptp_kvm_x86.c
> 
>     67	
>   > 68	void kvm_arch_ptp_exit(void)
>     69	{
>     70		if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
>     71			WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
>     72			free_page((unsigned long)clock_pair);
>     73			clock_pair = NULL;
>     74		}
>     75	}
>     76	
> 

My bad - forgot to include changes to include/linux/ptp_kvm.h in the commit.
Will fix in v2, but will hold off a day or two in case someone has a suggestion
on how to reduce the allocation.

Jeremi
