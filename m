Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B3B1C7B3E
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgEFU24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:28:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726218AbgEFU24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588796934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cu+S4C27UOFa3OfMh+dHOhDVzuXz2x4jIHvsepSqLnk=;
        b=RzgjY1X2YUq6hq6LT+O2X3l0faNp8tObRVD2LNhIR854zoOO3LJ5YdV9qc6xBb44ao60q3
        OGEIsyL6e3f0xTAPtESOsU77cEkxI3WcQ1mO8qtTU2depTO7oukNZXG49boiDldYphe9pz
        eBWh7g75DdWVA+PwBXB8JWl6JMtpH8M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-9anmkgmrPr2ryYOIfimHQA-1; Wed, 06 May 2020 16:28:52 -0400
X-MC-Unique: 9anmkgmrPr2ryYOIfimHQA-1
Received: by mail-wr1-f71.google.com with SMTP id g10so1920349wrr.10
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cu+S4C27UOFa3OfMh+dHOhDVzuXz2x4jIHvsepSqLnk=;
        b=USSfSbPnBBAaMBlvCquNwm5V15lP6XoZTy5tb9Fnna2xdocD7qmVb+baqgo+GoRagk
         eIDUJHdAh48yZHxxfpwyLsDrLNEbr0P/j+v8h1wXWuiJrE3yODqcNLCKl/62eu1HO0VZ
         RH1oTf1GBAWcxPzJ/dcQe0yzK/zknC+xb7wF1r6BpmmB4jveXeZKdUI5uEAmoUZyHi7H
         WXTiva6TKOLE1a3FGIOowP6Q3jEuUKkBok/JLDBwcdnmJ4/i+BvX9D8nqFCofe9QWWJX
         Cazpg2NYUi26Fb3mOoSQVrIE2ioJ1ly+QNYhddleZvcSR96vPJYO/X59xU2q5esbcPKu
         IlnQ==
X-Gm-Message-State: AGi0Pua/oKkxJAQatk3A8otXWXE9prL8FJCEUuVKL8P3uKP9EEhkO8zZ
        +UrKHFv05tdVS/x7m9KWIr17tEz9NKhrRAQO8aK09j6a5001rHaVOe7SIMjY985YWHPftTJZv7B
        J6X3UwySoD1W+9flR
X-Received: by 2002:adf:e449:: with SMTP id t9mr11428840wrm.108.1588796931025;
        Wed, 06 May 2020 13:28:51 -0700 (PDT)
X-Google-Smtp-Source: APiQypJYl+rPKkzHvCZgpgimxYFgM4/uAdMXx173aAgzcr8cA+F2M7DbC5yVSSYFy58Q5bTl4e+qyg==
X-Received: by 2002:adf:e449:: with SMTP id t9mr11428829wrm.108.1588796930811;
        Wed, 06 May 2020 13:28:50 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id q4sm4632965wrx.9.2020.05.06.13.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:28:50 -0700 (PDT)
Date:   Wed, 6 May 2020 16:28:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: Re: [vhost:vhost 8/22] drivers/virtio/virtio_mem.c:1375:20: error:
 implicit declaration of function 'kzalloc'; did you mean 'vzalloc'?
Message-ID: <20200506162751-mutt-send-email-mst@kernel.org>
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

OK try to do it ASAP, we don't want to repeat the drama we had with vdpa.

> The other stuff I have are extensions, I will send as add-on.
> 
> Thanks!
> 
> 
> -- 
> Thanks,
> 
> David / dhildenb

