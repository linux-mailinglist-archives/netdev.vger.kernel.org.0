Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082771C5C27
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgEEPo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:44:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730417AbgEEPo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588693497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ATymMeG6RiOGBAAfWdg7fwilnSvvAev3slucMk0tl5E=;
        b=e3dVUVbYT23HNGLZNXk4DR1D80eNSsGzSeatVpX26UC7LfLvdJ5v/Difa8HBs19Vv3OaSv
        jWEgCLMrFLs8KqTurvbsE5xmKqU5RaawrONW651QR1FTxJS/2iu2cVb8gGl9rGL4bWnnKm
        sZtWZQaZz/Pnh6E7zxN71Wb+iLxNmNI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-6ngYP9ZDM_i6FpayITGhgg-1; Tue, 05 May 2020 11:44:53 -0400
X-MC-Unique: 6ngYP9ZDM_i6FpayITGhgg-1
Received: by mail-wm1-f70.google.com with SMTP id 14so998861wmo.9
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 08:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ATymMeG6RiOGBAAfWdg7fwilnSvvAev3slucMk0tl5E=;
        b=p5FQwrOGpemTVWkVYayrgO3HdTmymhINaQoy5uHxokkR3aj9Ik4OiDUKQMsQViiIk+
         EyvSTnY/NOXkaT+baXC/g2nh4ENCEg4F5ax30ig/HyFBmf3ydpDLtikfkE3xvNU7693V
         V/ByMIca01GhJN7XcwxeWIeKbUs59MLbaHzsYnaUGIT75AXYPCs2TC1Xp9FIQgJd/F/r
         6JWysVFInDuhyT0k7sR6EyY4xgDeWR1qiB5cZLQ5FXKrrNfYJyjFbo5Go9lSXNQxV0JS
         gk5g15ByDlQzoXZ7MWZKJeJrGifrgOmILeZUQnDnbFg4FpxDtttynQQbyjShtXv0Y6Rj
         aT+g==
X-Gm-Message-State: AGi0PuZSPu0pdBub4ulypbYSIVs+XWzz4gyRxwEY1lYMiKsnv8GUVW8v
        46poIMTlAHzeveZsSqPbYl8SCDfbE9uBoH4aOFYbPRPCKYLqhzyF9T+Pc/2GMjdgq3Y97BOqVzm
        E9QhcrkmiR02GLipP
X-Received: by 2002:a05:600c:220c:: with SMTP id z12mr3889166wml.84.1588693492413;
        Tue, 05 May 2020 08:44:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypLAtAtR29+1Xpb9v/bXxgErbXkwmiM0ZkUgsrIiaMjwwteCzask/x8xdzj9MT0cC1whI9Hdyw==
X-Received: by 2002:a05:600c:220c:: with SMTP id z12mr3889139wml.84.1588693492106;
        Tue, 05 May 2020 08:44:52 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id x13sm4635004wmc.5.2020.05.05.08.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 08:44:51 -0700 (PDT)
Date:   Tue, 5 May 2020 11:44:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Message-ID: <20200505114433-mutt-send-email-mst@kernel.org>
References: <202005052221.83QerHmG%lkp@intel.com>
 <7dea2810-85cf-0892-20a8-bba3e3a2c133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dea2810-85cf-0892-20a8-bba3e3a2c133@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:50:13PM +0200, David Hildenbrand wrote:
> On 05.05.20 16:15, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> > head:   da1742791d8c0c0a8e5471f181549c4726a5c5f9
> > commit: 7527631e900d464ed2d533f799cb0da2b29cc6f0 [8/22] virtio-mem: Paravirtualized memory hotplug
> > config: x86_64-randconfig-b002-20200505 (attached as .config)
> > compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> > reproduce:
> >         git checkout 7527631e900d464ed2d533f799cb0da2b29cc6f0
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    drivers/virtio/virtio_mem.c: In function 'virtio_mem_probe':
> >>> drivers/virtio/virtio_mem.c:1375:20: error: implicit declaration of function 'kzalloc'; did you mean 'vzalloc'? [-Werror=implicit-function-declaration]
> >      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >                        ^~~~~~~
> >                        vzalloc
> >>> drivers/virtio/virtio_mem.c:1375:18: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
> >      vdev->priv = vm = kzalloc(sizeof(*vm), GFP_KERNEL);
> >                      ^
> >>> drivers/virtio/virtio_mem.c:1419:2: error: implicit declaration of function 'kfree'; did you mean 'vfree'? [-Werror=implicit-function-declaration]
> >      kfree(vm);
> >      ^~~~~
> >      vfree
> >    cc1: some warnings being treated as errors
> > 
> > vim +1375 drivers/virtio/virtio_mem.c
> 
> Guess we simply need
> 
>  #include <linux/slab.h>
> 
> to make it work for that config.


OK I added that in the 1st commit that introduced virtio-mem.

> -- 
> Thanks,
> 
> David / dhildenb

