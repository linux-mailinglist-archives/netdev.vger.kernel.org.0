Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0EF1A329F
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 12:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgDIKld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 06:41:33 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:34085 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDIKlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 06:41:32 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M3UIe-1jLwOP22ni-000bUu; Thu, 09 Apr 2020 12:41:31 +0200
Received: by mail-qk1-f180.google.com with SMTP id z15so3395725qki.7;
        Thu, 09 Apr 2020 03:41:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuYB6P8o0aFEzfWoQU5AHd+quTzHr9uwJhbuRns7IN2hGas/tBj9
        CPbMV3pCx+IvNRBQcqtrfu/63O9yGEyDmHLSGRg=
X-Google-Smtp-Source: APiQypJ+MZNDx1nAeHQJUrsxI3ccDEBo8kCLAwyqI5SJ9WAba6/XBRqyHYyNfPORCxMsxCe8/yMMMt7xih71qKreb4o=
X-Received: by 2002:a37:a52:: with SMTP id 79mr11506167qkk.3.1586428890169;
 Thu, 09 Apr 2020 03:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200326140125.19794-1-jasowang@redhat.com> <20200326140125.19794-10-jasowang@redhat.com>
In-Reply-To: <20200326140125.19794-10-jasowang@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 9 Apr 2020 12:41:13 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
Message-ID: <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
Subject: Re: [PATCH V9 9/9] virtio: Intel IFC VF driver for VDPA
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        Parav Pandit <parav@mellanox.com>, kevin.tian@intel.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Bie Tiwei <tiwei.bie@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:HWzbXodPWtj3796KNdOWac9tTnFw3sd83DCpZ4tYyN9oV/qgGKH
 fh9QCRbNS0utuTU9EQtqCO6ZMTIIvNcRuhL2cqr0k4HKzZhz+uiywiNmgaemhac/AwdFKEV
 9zFmQgVG0n0f9ah0sZX3TABPeCExNtqJrKy6wBA2cT8/U8m02VlfUZ1IzMekJGmjApBy+WU
 WL7xd2t0u6StYdxj92ELg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FZrkDyo0urk=:LiTF4Hf9cz8JtqwzdwOHlC
 7V9TCsJOYLCqqVJJo13Ie7d9LKCh8bV8SMM0SbMkYXJXKODaxUystJK7yjQuM5uEUTTDQLbt0
 9A/e85+4X+QBIjN5zUkuVYPWJ2nZnFxYSDF+q/NpjUy515HKltJpmp5MF/che+ULTrLkLPrcq
 BxhrLOWxOlAb3R9PnzS8L/Nluk14VLNct3esVTMrAQfNS8Ri2DQNxcPhRMuBv737PXft0lsyQ
 D8RM1RHeGD4mTulcdYlppnNSLdcP3QkV6OakdtmVuvQdjuRHhITfoRTOna1S6DpttfhCLB3cM
 CCpf3k4qCPV7FJKVBkufBknimkXZIuiK72E2UQI8d5d9HJL7xH/7ASbhFD1f06oWednWvpmho
 FBma/1vv093R3IkpLh2May4rzttJnU5+XAYw2gigCHM26BgVJvnVU2xAggtliBp7v3YbEcK7I
 Xf/XHW+46yEV+yOJPUQGhKo+j5YJicEJk/DkBOfelTJFiaeF58EjmlAF9GCM6xbVv6kJPCm5p
 oB373GuFH9jSVGSTt6eSaUZ9dHvmDpnvwCitcdVPyFTUrLxq1dboPbDhnhUGJmZalPJarfTqH
 EGmnoInmTHXWexZY0PWxsvd9HXDgvkAAD8YxPl7/oQOLePUhEwqiAK9aGdkMnIa7oVIjF6Xls
 iVErHfLgKp8u2ZiWES7n61SzCHeb9JHudAhT9muDYsUSUzGnvVf1DI1wR3MLskPvF/M45CD8r
 cWQv9vKhv13MmdFpynWXOXFmL9mczotZpUKCUT7PxwBdnjh74LFYFIvG/LH9V3/Xq/Dyd+a4o
 x0fI0zggrorIi9rD7hqdDXISbeyaZ52nUZt+IRgXsFanzIjhu0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 3:08 PM Jason Wang <jasowang@redhat.com> wrote:
>
> From: Zhu Lingshan <lingshan.zhu@intel.com>
>
> This commit introduced two layers to drive IFC VF:
>
> (1) ifcvf_base layer, which handles IFC VF NIC hardware operations and
>     configurations.
>
> (2) ifcvf_main layer, which complies to VDPA bus framework,
>     implemented device operations for VDPA bus, handles device probe,
>     bus attaching, vring operations, etc.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Signed-off-by: Bie Tiwei <tiwei.bie@intel.com>
> Signed-off-by: Wang Xiao <xiao.w.wang@intel.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

> +
> +#define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
> +#define IFCVF_QUEUE_MAX                32768
> +static u16 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
> +{
> +       return IFCVF_QUEUE_ALIGNMENT;
> +}

This fails to build on arm64 with 64kb page size (found in linux-next):

/drivers/vdpa/ifcvf/ifcvf_main.c: In function 'ifcvf_vdpa_get_vq_align':
arch/arm64/include/asm/page-def.h:17:20: error: conversion from 'long
unsigned int' to 'u16' {aka 'short unsigned int'} changes value from
'65536' to '0' [-Werror=overflow]
   17 | #define PAGE_SIZE  (_AC(1, UL) << PAGE_SHIFT)
      |                    ^
drivers/vdpa/ifcvf/ifcvf_base.h:37:31: note: in expansion of macro 'PAGE_SIZE'
   37 | #define IFCVF_QUEUE_ALIGNMENT PAGE_SIZE
      |                               ^~~~~~~~~
drivers/vdpa/ifcvf/ifcvf_main.c:231:9: note: in expansion of macro
'IFCVF_QUEUE_ALIGNMENT'
  231 |  return IFCVF_QUEUE_ALIGNMENT;
      |         ^~~~~~~~~~~~~~~~~~~~~

It's probably good enough to just not allow the driver to be built in that
configuration as it's fairly rare but unfortunately there is no simple Kconfig
symbol for it.

In a similar driver, we did

config VMXNET3
        tristate "VMware VMXNET3 ethernet driver"
        depends on PCI && INET
        depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
                     IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
                     PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)

I think we should probably make PAGE_SIZE_64KB a global symbol
in arch/Kconfig and have it selected by the other symbols so drivers
like yours can add a dependency for it.

         Arnd
