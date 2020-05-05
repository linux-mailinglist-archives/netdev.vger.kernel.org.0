Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3573B1C5D97
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbgEEQan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:30:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46106 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728687AbgEEQam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588696241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yMBKhgqvtU6JZa2/gwth5BlYVmq3nyyl0uG0nZStcYk=;
        b=XPcrHn4sH5bLjMD4GF02VjEZ55S/mOERILOWDbeV66PnTGpUKjXNNhK/HYEL6G9fY5Lxm9
        CketGxzxsqR895TOZxwiYENZvEGxHXSdWvqPCa6LoWMbjvL/rztirfZhRSDxRQWFzuvkMN
        Vf7HxVW7X/PVNTTXfJ98h9qdxpEt+iA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-0OAjTSeVOUer2w_K234Flw-1; Tue, 05 May 2020 12:30:37 -0400
X-MC-Unique: 0OAjTSeVOUer2w_K234Flw-1
Received: by mail-wm1-f71.google.com with SMTP id f17so1108163wmm.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMBKhgqvtU6JZa2/gwth5BlYVmq3nyyl0uG0nZStcYk=;
        b=EJgaASdB0AHqJyBbkFCkmVzG/PGnI9w1A5badg8PavpV2fn9as4uLqXakM7BTGGMs1
         XVETLDfNzZinzw3S+VEWkVkZ7EvHLQpW4oc8YjXrc9xgSsdNsJqFcMT38uKSNA6pAA21
         wQC6XYRwWWGSHF5blSxUe0XZmuLXdsARkvaeHXytganOt2EOxDRahbt8hF5WZXYnuZmM
         L/6ERFyfdhXkxa/l6QBT0zrSe0n5LMm0VDv7r2ul7VxP8XZSV86OueXzC0zqI2TXnHEu
         P7adn1WDN5e6n7cmn1p1Nw3J+AuQ4HBVkZDjykowj8ghJmk/ZYucJPuF/D/2lbD0+WOZ
         Shww==
X-Gm-Message-State: AGi0PuYc90KS9cyw7LAZhZg/H6hzHrYdWmwh4fELXvb3bYfgoJZCdzOL
        axgBkuDz0WndXUghv5KAsxUnqNIj4MYuOZ1gAonz7L/SK82JYlusSvphPy9MmGwAa6ztPNZQ8Pl
        5eV9p15alfqCuSRqU
X-Received: by 2002:a5d:5261:: with SMTP id l1mr4495413wrc.24.1588696236458;
        Tue, 05 May 2020 09:30:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypL6c2ZhSqgyVCoh+9xYBBrRpeIbvWaVoWn35WDDllP8SgqQVe+xSldK3GCh2yVta3+pQW6bDg==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr4495399wrc.24.1588696236272;
        Tue, 05 May 2020 09:30:36 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id x5sm3669458wro.12.2020.05.05.09.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 09:30:35 -0700 (PDT)
Date:   Tue, 5 May 2020 12:30:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Message-ID: <20200505123009-mutt-send-email-mst@kernel.org>
References: <202005052221.83QerHmG%lkp@intel.com>
 <7dea2810-85cf-0892-20a8-bba3e3a2c133@redhat.com>
 <20200505114433-mutt-send-email-mst@kernel.org>
 <3eaebd8d-750a-d046-15f5-706fb00a196e@redhat.com>
 <20200505121732-mutt-send-email-mst@kernel.org>
 <e607a850-ba5c-6033-93fc-144639b125b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e607a850-ba5c-6033-93fc-144639b125b8@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 06:22:51PM +0200, David Hildenbrand wrote:
> On 05.05.20 18:20, Michael S. Tsirkin wrote:
> > On Tue, May 05, 2020 at 05:46:44PM +0200, David Hildenbrand wrote:
> >> On 05.05.20 17:44, Michael S. Tsirkin wrote:
> >>> On Tue, May 05, 2020 at 04:50:13PM +0200, David Hildenbrand wrote:
> >>>> On 05.05.20 16:15, kbuild test robot wrote:
> >>>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> >>>>> head:   da1742791d8c0c0a8e5471f181549c4726a5c5f9
> >>>>> commit: 7527631e900d464ed2d533f799cb0da2b29cc6f0 [8/22] virtio-mem: Paravirtualized memory hotplug
> >>>>> config: x86_64-randconfig-b002-20200505 (attached as .config)
> >>>>> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> >>>>> reproduce:
> >>>>>         git checkout 7527631e900d464ed2d533f799cb0da2b29cc6f0
> >>>>>         # save the attached .config to linux build tree
> >>>>>         make ARCH=x86_64 
> >>>>>
> >>>>> If you fix the issue, kindly add following tag as appropriate
> >>>>> Reported-by: kbuild test robot <lkp@intel.com>
> >>>>>
> >>>>> All error/warnings (new ones prefixed by >>):
> >>>>>
> >>>>>    drivers/virtio/virtio_mem.c: In function 'virtio_mem_probe':
> >>>>>>> drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]
> >>>>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>>>                        ^~~~~~~
> >>>>>                        vzalloc
> >>>>>>> drivers/virtio/virtio_mem.c:1375:18: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> >>>>>      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >>>>>                      ^
> >>>>>>> drivers/virtio/virtio_mem.c:1419:2: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
> >>>>>      kfree(vm);
> >>>>>      ^~~~~
> >>>>>      vfree
> >>>>>    cc1: some warnings being treated as errors
> >>>>>
> >>>>> vim +1375 drivers/virtio/virtio_mem.c
> >>>>
> >>>> Guess we simply need
> >>>>
> >>>>  #include <linux/slab.h>
> >>>>
> >>>> to make it work for that config.
> >>>
> >>>
> >>> OK I added that in the 1st commit that introduced virtio-mem.
> >>
> >> Thanks. I have some addon-patches ready, what's the best way to continue
> >> with these?
> > 
> > If these are bugfixes, just respin the series (including this fix).
> 
> There are two really minor bugfixes for corner-case error handling and
> one simplification. I can squash them and resend, makes things easier.
> 
> The other stuff I have are extensions, I will send as add-on.
> 
> Thanks!

So just send a giant patchbomb explaining what's what in the
cover letter. Thanks!


> 
> -- 
> Thanks,
> 
> David / dhildenb

