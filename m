Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830A344447
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhCVM7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:59:20 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:42303 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhCVM4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 08:56:38 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 4D319200EEC2;
        Mon, 22 Mar 2021 13:56:26 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4D319200EEC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1616417786;
        bh=bDx+N1UAJtqB40z3Y7emWWSuO0MgRMw4hpB72rrJAgA=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=GPSOCP4a97lcGyvDo0uojF0A1hnmJGV3GOamj/fPLDf2HhKW9/oIYESlpb38Sv6EH
         1DdzD7V5zYWqxGCqa/sfSVOS5RwqugSqrGpVOxsGiicDTOE+Mw3HLqg5krK3VM5Y3p
         YMHLOg6VARs6Njh+3gR48tu7oPLIR2YAcWqAxsIJyO26YfYSjXCMWpDabOgUvZuTap
         Cb/Y2DFdpupjnNFG9lOIOrjWRgxZnezMLzpDmDqQlmVYrbdv4nLR7i6/VbE3mJ1sB/
         FT2kzyyggOR9BriZi872vBNANrANG6TEqSma/bX02rw/hp3kXV17QcRT2rWF/8T0ky
         1S7HWh73OGXlg==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 410C2129EF37;
        Mon, 22 Mar 2021 13:56:26 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kFrSgTh6XtUu; Mon, 22 Mar 2021 13:56:26 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 24874129EF29;
        Mon, 22 Mar 2021 13:56:26 +0100 (CET)
Date:   Mon, 22 Mar 2021 13:56:26 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     kernel test robot <rong.a.chen@intel.com>
Cc:     netdev@vger.kernel.org, kbuild-all@lists.01.org,
        davem@davemloft.net, kuba@kernel.org, tom@herbertland.com
Message-ID: <1448994361.68241255.1616417786080.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210311005631.GJ219708@shao2-debian>
References: <20210311005631.GJ219708@shao2-debian>
Subject: Re: [PATCH net-next 4/5] ipv6: ioam: Support for IOAM injection
 with lwtunnels
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.244.6.142]
X-Mailer: Zimbra 8.8.15_GA_3980 (ZimbraWebClient - FF86 (Linux)/8.8.15_GA_3980)
Thread-Topic: ipv6: ioam: Support for IOAM injection with lwtunnels
Thread-Index: V2q+x0vKeKs52P45AhGrxCxLcOIkqQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Hi Justin,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:
> https://github.com/0day-ci/linux/commits/Justin-Iurman/Support-for-the-IOAM-Pre-allocated-Trace-with-IPv6/20210311-005727
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> d310ec03a34e92a77302edb804f7d68ee4f01ba0
> :::::: branch date: 2 hours ago
> :::::: commit date: 2 hours ago
> config: sparc64-randconfig-s032-20210310 (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 9.3.0
> reproduce:
>        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O
>        ~/bin/make.cross
>        chmod +x ~/bin/make.cross
>        # apt-get install sparse
>        # sparse version: v0.6.3-262-g5e674421-dirty
>        #
>        https://github.com/0day-ci/linux/commit/f20771586508a195a44298f251d68446c10830ce
>        git remote add linux-review https://github.com/0day-ci/linux
>        git fetch --no-tags linux-review
>        Justin-Iurman/Support-for-the-IOAM-Pre-allocated-Trace-with-IPv6/20210311-005727
>        git checkout f20771586508a195a44298f251d68446c10830ce
>        # save the attached .config to linux build tree
>        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1
>        CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=sparc64
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> "sparse warnings: (new ones prefixed by >>)"
>>> net/ipv6/ioam6.c:856:1: sparse: sparse: unused label 'out_unregister_genl'

Apologies for this small oversight, will update it and post a v3 (forgot the "v2" tag for this patchset by the way).

> vim +/out_unregister_genl +856 net/ipv6/ioam6.c
> 
> f20771586508a1 Justin Iurman 2021-03-10  851
> e1a4cb7c14f537 Justin Iurman 2021-03-10  852  	pr_info("In-situ OAM (IOAM) with
> IPv6\n");
> ffece959dfe59a Justin Iurman 2021-03-10  853
> ffece959dfe59a Justin Iurman 2021-03-10  854  out:
> ffece959dfe59a Justin Iurman 2021-03-10  855  	return err;
> f20771586508a1 Justin Iurman 2021-03-10 @856  out_unregister_genl:
> f20771586508a1 Justin Iurman 2021-03-10  857
> 	genl_unregister_family(&ioam6_genl_family);
> ffece959dfe59a Justin Iurman 2021-03-10  858  out_unregister_pernet_subsys:
> ffece959dfe59a Justin Iurman 2021-03-10  859
> 	unregister_pernet_subsys(&ioam6_net_ops);
> ffece959dfe59a Justin Iurman 2021-03-10  860  	goto out;
> e1a4cb7c14f537 Justin Iurman 2021-03-10  861  }
> e1a4cb7c14f537 Justin Iurman 2021-03-10  862
