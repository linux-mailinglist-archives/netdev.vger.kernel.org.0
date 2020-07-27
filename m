Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E648422EA2F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgG0KlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 06:41:18 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:59736 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726662AbgG0KlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 06:41:17 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 62B9D60073;
        Mon, 27 Jul 2020 10:41:17 +0000 (UTC)
Received: from us4-mdac16-27.ut7.mdlocal (unknown [10.7.66.59])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6147D8009B;
        Mon, 27 Jul 2020 10:41:17 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E7CC0280050;
        Mon, 27 Jul 2020 10:41:16 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79814480081;
        Mon, 27 Jul 2020 10:41:16 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 11:41:07 +0100
Subject: Re: [PATCH v4 net-next 04/16] sfc: skeleton EF100 PF driver
To:     kernel test robot <lkp@intel.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>
References: <b734869c-ee2f-a121-2470-a7d632e1dfbf@solarflare.com>
 <202007250411.qUhQvyZz%lkp@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0c9d51a0-4583-6f5a-46e3-c27dd4e0315c@solarflare.com>
Date:   Mon, 27 Jul 2020 11:41:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202007250411.qUhQvyZz%lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-9.293800-8.000000-10
X-TMASE-MatchedRID: vEvJ7Rh1lGiczwUwXNyhwjVUc/h8Ki+CABYRpyLYSPrk1kyQDpEj8MWl
        hj9iHeVp6p2MwhnGDkC/UScO8V00kpt8I5a2mQhNnVTWWiNp+v+NY/pqxovzxR1rVWTdGrE41w8
        DPX3mEjaMYg2Zw8Pzykib2JaUlOFowrMHbpAUmLlSFqtD2wqeMW4lczE4XkmwNEbJ0Gr9hUIxX1
        Naq4dzMiFEEdbgC8XE1sAsJSZL0aQ32uiNuPEGTJr5ykm9NtIcNV9S7O+u3Ka9riHHO5UXuBQAr
        vun+J7W2tmoqiGUvaIx9t8sM0+WvM11iH9zkl9E9Ib/6w+1lWTdXhRKGhNdp44iwAQuovtYSXAV
        7ymJFIPcJ/RhXvDY5zCBmWgH9MGx5UcZtwNsCrqDGx/OQ1GV8v1vTGBiuZrt1GcRAJRT6PP3FLe
        ZXNZS4H0jHMQPhEvZ/q0Vdvobx4yqJGvjZGdhh2r0XMTyJrsTlvodiv8TfRaZsftwwIX2T0GH4Z
        rdgeLgM8yeDlLSf5uwjRySHQdvV2wC+RrNSUxb8B1+fkPI48NcLq4mdz+nRKyCWSW0HzF0amjOS
        5qVJMM7pyVyc/F9UH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.293800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595846477-EOTWoK9Cp1eh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/07/2020 21:32, kernel test robot wrote:
> Hi Edward,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Edward-Cree/sfc-driver-for-EF100-family-NICs-part-1/20200725-000401
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1b6687e31a2df9fbdb12d25c1d1d372777bf96a8
> config: microblaze-randconfig-r021-20200725 (attached as .config)
> compiler: microblaze-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=microblaze 
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
>>> drivers/net/ethernet/sfc/siena.c:1021:16: error: '__efx_enqueue_skb' undeclared here (not in a function); did you mean 'efx_enqueue_skb'?
>     1021 |  .tx_enqueue = __efx_enqueue_skb,
>          |                ^~~~~~~~~~~~~~~~~
>          |                efx_enqueue_skb
Aaaaaargh.
Apparently INDIRECT_CALLABLE_DECLARE doesn't declare anything #ifndef
 CONFIG_RETPOLINE.  I presumably misunderstood what it was for, and I
 should just declare those prototypes normally, without it.

Time to spin a v5...

-ed
