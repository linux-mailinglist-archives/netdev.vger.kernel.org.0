Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7CA5F9FBA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJJN7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJJN7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:59:10 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC5272B54
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:59:06 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id DAD5118836EA;
        Mon, 10 Oct 2022 13:59:02 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id C65872505C4F;
        Mon, 10 Oct 2022 13:59:02 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id B5FA79EC0002; Mon, 10 Oct 2022 13:59:02 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 10 Oct 2022 15:59:02 +0200
From:   netdev@kapio-technology.com
To:     kernel test robot <lkp@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH v7 net-next 8/9] net: dsa: mv88e6xxx: add blackhole ATU
 entries
In-Reply-To: <202210102053.DqKoIJ78-lkp@intel.com>
References: <20221009174052.1927483-9-netdev@kapio-technology.com>
 <202210102053.DqKoIJ78-lkp@intel.com>
User-Agent: Gigahost Webmail
Message-ID: <c5c8a321cf1b951d4a5fa3298104e5b9@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-10 14:54, kernel test robot wrote:
> Hi Hans,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:
> https://github.com/intel-lab-lkp/linux/commits/Hans-J-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20221010-125833
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> 0326074ff4652329f2a1a9c8685104576bd8d131
> config: x86_64-randconfig-s032-20221010
> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         #
> https://github.com/intel-lab-lkp/linux/commit/bceb3d02ac2eb92d0fd72b1ce4ed17dbe407c086
>         git remote add linux-review 
> https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review
> Hans-J-Schultz/Extend-locked-port-feature-with-FDB-locked-flag-MAC-Auth-MAB/20221010-125833
>         git checkout bceb3d02ac2eb92d0fd72b1ce4ed17dbe407c086
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/mv88e6xxx/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> 
> sparse warnings: (new ones prefixed by >>)
>>> drivers/net/dsa/mv88e6xxx/chip.c:2776:5: sparse: sparse: symbol 
>>> 'mv88e6xxx_blackhole_fdb_add' was not declared. Should it be static?
>>> drivers/net/dsa/mv88e6xxx/chip.c:2782:5: sparse: sparse: symbol 
>>> 'mv88e6xxx_blackhole_fdb_del' was not declared. Should it be static?

Hi, yes they should both be static.
