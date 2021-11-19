Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECAB45731D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbhKSQiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:38:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:56497 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235789AbhKSQix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 11:38:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="297861513"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="297861513"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 08:35:44 -0800
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="737108569"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 08:35:35 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mo6rG-008arp-NU;
        Fri, 19 Nov 2021 18:35:26 +0200
Date:   Fri, 19 Nov 2021 18:35:26 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Message-ID: <YZfSTrbAr3d2xORr@smile.fi.intel.com>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
 <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
 <YZfMXlqvG52ls2TE@smile.fi.intel.com>
 <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
 <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 05:22:48PM +0100, Alejandro Colomar (man-pages) wrote:
> 
> 
> On 11/19/21 17:18, Arnd Bergmann wrote:
> > On Fri, Nov 19, 2021 at 5:10 PM Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> >> On Fri, Nov 19, 2021 at 04:57:46PM +0100, Arnd Bergmann wrote:
> > 
> >>> The main problem with this approach is that as soon as you start
> >>> actually reducing the unneeded indirect includes, you end up with
> >>> countless .c files that no longer build because they are missing a
> >>> direct include for something that was always included somewhere
> >>> deep underneath, so I needed a second set of scripts to add
> >>> direct includes to every .c file.
> >>
> >> Can't it be done with cocci support?
> > 
> > There are many ways of doing it, but they all tend to suffer from the
> > problem of identifying which headers are actually needed based on
> > the contents of a file, and also figuring out where to put the extra
> > #include if there are complex #ifdefs.
> > 
> > For reference, see below for the naive pattern matching I tried.
> > This is obviously incomplete and partially wrong.
> 
> FYI, if you may not know the tool,
> theres include-what-you-use(1) (a.k.a. iwyu(1))[1],
> although it is still not mature,
> and I'm helping improve it a bit.

Yes, I know the tool, but it produces insanity. Jonathan (maintainer
of IIO subsystem) actually found it useful after manual work applied.
Perhaps you can chat with him about usage of it in the Linux kernel.

> If I understood better the kernel Makefiles,
> I'd try it.
> 
> You can try it yourselves.
> I still can't use it for my own code,
> since it has a lot of false positives.

> [1]: <https://include-what-you-use.org/>

-- 
With Best Regards,
Andy Shevchenko


