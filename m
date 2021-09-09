Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB87B40484E
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbhIIKRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:17:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34740 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhIIKRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:17:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5DEF320536;
        Thu,  9 Sep 2021 12:16:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1xaOSM7Z8LQF; Thu,  9 Sep 2021 12:16:03 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6A488201E2;
        Thu,  9 Sep 2021 12:16:03 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 6473980004A;
        Thu,  9 Sep 2021 12:16:03 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Sep 2021 12:16:03 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 9 Sep
 2021 12:16:02 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A07433181BF3; Thu,  9 Sep 2021 12:16:02 +0200 (CEST)
Date:   Thu, 9 Sep 2021 12:16:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     kernel test robot <lkp@intel.com>
CC:     Eugene Syromiatnikov <esyr@redhat.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>, "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [ipsec:testing 1/2] include/linux/compiler_types.h:328:38:
 error: call to '__compiletime_assert_633' declared with attribute error:
 BUILD_BUG_ON failed: XFRM_MSG_MAX != XFRM_MSG_MAPPING
Message-ID: <20210909101602.GG9115@gauss3.secunet.de>
References: <202109082146.dl8o0gJv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <202109082146.dl8o0gJv-lkp@intel.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 09:15:53PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git testing
> head:   f693aa9c98e4e3347930f928c123bb2460317fe0
> commit: 56e47fcb5c6150e22c5a591833d67c3ae7a4e9be [1/2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage
> config: x86_64-randconfig-a005-20210908 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=56e47fcb5c6150e22c5a591833d67c3ae7a4e9be
>         git remote add ipsec https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git
>         git fetch --no-tags ipsec testing
>         git checkout 56e47fcb5c6150e22c5a591833d67c3ae7a4e9be
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from <command-line>:
>    security/selinux/nlmsgtab.c: In function 'selinux_nlmsg_lookup':
> >> include/linux/compiler_types.h:328:38: error: call to '__compiletime_assert_633' declared with attribute error: BUILD_BUG_ON failed: XFRM_MSG_MAX != XFRM_MSG_MAPPING

Eugene, I had to drop this patch for now.
Please fix and resend, thanks!
