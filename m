Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8905290ACA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391100AbgJPRdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731789AbgJPRdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:33:21 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0F0C061755;
        Fri, 16 Oct 2020 10:33:20 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t20so3251557edr.11;
        Fri, 16 Oct 2020 10:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kso/t/FQGplwmPwYWFbbSAuJZcROUihXnMeufE07GRk=;
        b=BLwLFhhpdgTVNdpmuEOeE5mzRROgd19f+HRIwQhPzzm/+1ZG9e3fmVdGONVNcVlGUH
         /WzNKO1ZE2xCrs36UvzAPFcOAOuYJzrxhNFy7KkkDH7ARWZWbNTtK9g1WewKBqMX4yAx
         AxdJxqEGoll3yqMUXDFPeHp/czQgtU9BFoI7yIdLw47oZyHO2N+u8cnNrzl5O+rIHaWq
         8yBRrEGCFV1F9yVJJfbBmL9Q+G/CByIbxFqsSRieLytyYrbF1dUpOVUtefa3wmvz93Dw
         CT66tQJMf5usq/mcU61DK/zCFCQ6KrenEgZezhyn0DKR1y1yU4xJL+928QZVyNEHKLK0
         XlxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kso/t/FQGplwmPwYWFbbSAuJZcROUihXnMeufE07GRk=;
        b=uJfelFAjz4s3d3LHYmpBMrnx5K0M4MYfSzYIAMWzqCn3R2Q3lby83ncuEfCNMgshag
         LGSPt1LQEZI3wSIjl9WbACxDXBAtATis1KKBthSzbGqeJpLloxBu7Sm4jiOy+WFPhCQv
         iXZ+dv0fr4bmdecQu8sYDyQzjX7VyzSXkXTypwkChIW8p8fMeNn0X33mgsmlLK2EYffP
         FKfPMnzIrDx+UvnvFH3qVIZxaRB7dR/XfMZqSOnDp/e0br9JfASMGSJXTkJEA+9BhDmo
         TWK2dC+dOq/VIxjvsubNzIgROsFRD4W6UzfUXfqBLiia45dMyWBgbRQlYo4D7SB4wFmu
         H10Q==
X-Gm-Message-State: AOAM531IJBb+WIVKixSN1+w9a+wyOVc3Dfr/2U5khoFV7XT/kpF5BSrs
        1gU/GPXXhoCfpQuD2Z3RIjg=
X-Google-Smtp-Source: ABdhPJzt6UvcFHwXt4Lc7paQqFGd0R2+4HVuCNqj2Ha1vecWaPyzXlLAEZJOyoKKpcRkYW3ZqTmgqA==
X-Received: by 2002:a05:6402:1684:: with SMTP id a4mr5134938edv.79.1602869599455;
        Fri, 16 Oct 2020 10:33:19 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id y25sm2220134edr.7.2020.10.16.10.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 10:33:19 -0700 (PDT)
Date:   Fri, 16 Oct 2020 20:33:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        kbuild-all@lists.01.org,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016173317.4ihhiamrv5w5am6y@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
 <202010170153.fwOuks52-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202010170153.fwOuks52-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 17, 2020 at 01:25:08AM +0800, kernel test robot wrote:
> Hi Christian,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net/master]
>
> url:    https://github.com/0day-ci/linux/commits/Christian-Eggers/net-dsa-point-out-the-tail-taggers/20201017-003007
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 2ecbc1f684482b4ed52447a39903bd9b0f222898
> config: xtensa-allyesconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/aaa07cad29bf365264beb2c2e2668db83ca31923
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Christian-Eggers/net-dsa-point-out-the-tail-taggers/20201017-003007
>         git checkout aaa07cad29bf365264beb2c2e2668db83ca31923
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=xtensa
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
> >> net/dsa/tag_ksz.c:126:3: error: 'const struct dsa_device_ops' has no member named 'tail_tag'
>      126 |  .tail_tag = true,
>          |   ^~~~~~~~
> >> net/dsa/tag_ksz.c:126:14: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>      126 |  .tail_tag = true,
>          |              ^~~~
>    net/dsa/tag_ksz.c:126:14: note: (near initialization for 'ksz8795_netdev_ops.name')
> >> net/dsa/tag_ksz.c:126:14: warning: initialized field overwritten [-Woverride-init]
>    net/dsa/tag_ksz.c:126:14: note: (near initialization for 'ksz8795_netdev_ops.name')
>    net/dsa/tag_ksz.c:203:3: error: 'const struct dsa_device_ops' has no member named 'tail_tag'
>      203 |  .tail_tag = true,
>          |   ^~~~~~~~
>    net/dsa/tag_ksz.c:203:14: warning: initialization of 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
>      203 |  .tail_tag = true,
>          |              ^~~~
>    net/dsa/tag_ksz.c:203:14: note: (near initialization for 'ksz9477_netdev_ops.name')
>    net/dsa/tag_ksz.c:203:14: warning: initialized field overwritten [-Woverride-init]
>    net/dsa/tag_ksz.c:203:14: note: (near initialization for 'ksz9477_netdev_ops.name')
>
> vim +126 net/dsa/tag_ksz.c
>
>    119
>    120	static const struct dsa_device_ops ksz8795_netdev_ops = {
>    121		.name	= "ksz8795",
>    122		.proto	= DSA_TAG_PROTO_KSZ8795,
>    123		.xmit	= ksz8795_xmit,
>    124		.rcv	= ksz8795_rcv,
>    125		.overhead = KSZ_INGRESS_TAG_LEN,
>  > 126		.tail_tag = true,
>    127	};
>    128
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Is the test bot being a bit "slow" today?
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/include/net/dsa.h#n93?id=2ecbc1f684482b4ed52447a39903bd9b0f222898
