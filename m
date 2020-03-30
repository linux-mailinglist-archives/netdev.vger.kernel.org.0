Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA711972A1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 04:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgC3CrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 22:47:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42489 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728965AbgC3CrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 22:47:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585536423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JhRKQgYj4kt2ErgAvEa/JDhR6aA1zygUgBsUozFxa0s=;
        b=hStN2K64k2EeR65TiXrzdCBpaciwrVu4KcCJ/vPuDSvWZoH/V/6gB12U/RXgc7sMQeZYDY
        mmWYpVcM+0uvkXAJVX4HYuozj3XZLI99Vv4gC97H/p3sdvrNmr0MPVAQw0w53oZU0Eph17
        c7iDVSDDb50oClyUzPXzFlB8J2SoFGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-MDKfgYK0N4qCpGOTf-DT-A-1; Sun, 29 Mar 2020 22:46:43 -0400
X-MC-Unique: MDKfgYK0N4qCpGOTf-DT-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D40D81902EA8;
        Mon, 30 Mar 2020 02:46:41 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 836828F342;
        Mon, 30 Mar 2020 02:46:36 +0000 (UTC)
Subject: Re: [vhost:linux-next 8/13] include/linux/vringh.h:18:10: fatal
 error: linux/vhost_iotlb.h: No such file or directory
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <202003292026.dP7OOeCi%lkp@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f1270de5-7a2c-76d2-431c-34364def851a@redhat.com>
Date:   Mon, 30 Mar 2020 10:46:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <202003292026.dP7OOeCi%lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/29 =E4=B8=8B=E5=8D=888:08, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git l=
inux-next
> head:   f44a63f9ebf66a450c101084a35a3ef158ead209
> commit: c43908b0b9a900bd51f861f4c57b83cfd932f4d2 [8/13] vringh: IOTLB s=
upport
> config: arm-em_x270_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/=
sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout c43908b0b9a900bd51f861f4c57b83cfd932f4d2


I could not find this commit in the above branch.


>          # save the attached .config to linux build tree
>          GCC_VERSION=3D9.3.0 make.cross ARCH=3Darm


Try to use commit dc3b0673ae5efb73edab66ec5c2f074272e9a4df.

But this command does not work (I remember it used to work):

# GCC_VERSION=3D9.3.0 make.cross ARCH=3Darm
cd: received redirection to=20
`https://download.01.org/0day-ci/cross-package/'
lftpget -c=20
https://download.01.org/0day-ci/cross-package/./gcc-9.3.0-nolibc/x86_64-g=
cc-9.3.0-nolibc_arm-linux-gnueabihf.tar.xz
tar Jxf=20
gcc-9.3.0-nolibc/x86_64-gcc-9.3.0-nolibc_arm-linux-gnueabihf.tar.xz -C=20
/root/0day
No cross compiler for arm
setup_crosstool failed


>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     In file included from include/linux/virtio.h:12,
>                      from include/linux/virtio_config.h:7,
>                      from include/uapi/linux/virtio_net.h:30,
>                      from include/linux/virtio_net.h:6,
>                      from net//packet/af_packet.c:82:
>>> include/linux/vringh.h:18:10: fatal error: linux/vhost_iotlb.h: No su=
ch file or directory
>        18 | #include <linux/vhost_iotlb.h>
>           |          ^~~~~~~~~~~~~~~~~~~~~
>     compilation terminated.
>
> vim +18 include/linux/vringh.h
>
>    > 18	#include <linux/vhost_iotlb.h>
>      19	#include <asm/barrier.h>
>      20=09


I can hardly believe it can't work.

I get

# file include/linux/vringh.h
include/linux/vringh.h: C source, ASCII text

So this looks like a false positive to me?

Thanks


>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

