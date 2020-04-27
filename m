Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A2B1B97B5
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 08:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgD0GrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 02:47:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:58978 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgD0GrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 02:47:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CCC7B20322;
        Mon, 27 Apr 2020 08:47:11 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WRNQwlKoHDAD; Mon, 27 Apr 2020 08:47:11 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1662520299;
        Mon, 27 Apr 2020 08:47:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Apr 2020 08:47:10 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 27 Apr
 2020 08:47:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 39BA631800D5; Mon, 27 Apr 2020 08:47:10 +0200 (CEST)
Date:   Mon, 27 Apr 2020 08:47:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     kbuild test robot <lkp@intel.com>
CC:     Sabrina Dubroca <sd@queasysnail.net>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
Subject: Re: [ipsec-next:testing 1/2] net/ipv6/esp6.c:144:15: error: implicit
 declaration of function 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'?
Message-ID: <20200427064710.GH13121@gauss3.secunet.de>
References: <202004232028.daosFvMI%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202004232028.daosFvMI%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 08:02:30PM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> head:   ce37981d9045220810dabcb9cf20a1d86202c76a
> commit: 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3 [1/2] xfrm: add support for UDPv6 encapsulation of ESP
> config: c6x-allyesconfig (attached as .config)
> compiler: c6x-elf-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 3fd2d6fdcbb7bcd1fd7110d997fb6ed6eb71dca3
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=c6x 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    net/ipv6/esp6.c: In function 'esp_output_encap_csum':
> >> net/ipv6/esp6.c:144:15: error: implicit declaration of function 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'? [-Werror=implicit-function-declaration]
>      144 |   uh->check = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
>          |               ^~~~~~~~~~~~~~~
>          |               csum_tcpudp_magic
>    cc1: some warnings being treated as errors

Sabrina, can you please fix this and resend the pachset?
