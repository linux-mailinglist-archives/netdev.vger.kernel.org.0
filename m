Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99B11BA678
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgD0Ocp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Apr 2020 10:32:45 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54326 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727947AbgD0Ocp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:32:45 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-0ajjXbxaNbi5EXusJ4jNWw-1; Mon, 27 Apr 2020 10:32:38 -0400
X-MC-Unique: 0ajjXbxaNbi5EXusJ4jNWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27FA4EC1A0;
        Mon, 27 Apr 2020 14:32:37 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-35.ams2.redhat.com [10.36.112.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C891C5C1D6;
        Mon, 27 Apr 2020 14:32:35 +0000 (UTC)
Date:   Mon, 27 Apr 2020 16:32:34 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [ipsec-next:testing 1/2] net/ipv6/esp6.c:144:15: error: implicit
 declaration of function 'csum_ipv6_magic'; did you mean 'csum_tcpudp_magic'?
Message-ID: <20200427143234.GA113923@bistromath.localdomain>
References: <202004232028.daosFvMI%lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202004232028.daosFvMI%lkp@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-23, 20:02:30 +0800, kbuild test robot wrote:
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

This doesn't work for me :(

$HOME/0day/gcc-9.3.0-nolibc/c6x-elf/bin/../libexec/gcc/c6x-elf/9.3.0/cc1: error while loading shared libraries: libisl.so.19: cannot open shared object file: No such file or directory


-- 
Sabrina

