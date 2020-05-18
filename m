Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98E1D745A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgERJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:50:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:57590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgERJub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 05:50:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88A57B155;
        Mon, 18 May 2020 09:50:31 +0000 (UTC)
Date:   Mon, 18 May 2020 11:50:26 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: Re: [PATCH V2] dynamic_debug: Add an option to enable dynamic debug
 for modules only
Message-ID: <20200518095026.GL7340@linux-b0ei>
References: <1587408228-10861-1-git-send-email-orson.unisoc@gmail.com>
 <20200420191014.GE121146@unreal>
 <CA+H2tpGgGtW_8Z8fV9to39JwA_KrcfAeBC+KN87v0xKnZHt2_w@mail.gmail.com>
 <20200422142552.GA492196@unreal>
 <CA+H2tpGR7tywhkexa31AD_FkhyxQgVq_L+b0DbvXzwr6yT8j9Q@mail.gmail.com>
 <20200515095501.GU17734@linux-b0ei>
 <CA+H2tpFyAx9d-mvp=ZoS0NXm6YYC6DDV1Fu-RHLY=v82MP52Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+H2tpFyAx9d-mvp=ZoS0NXm6YYC6DDV1Fu-RHLY=v82MP52Bg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 2020-05-16 11:55:04, Orson Zhai wrote:
> On Fri, May 15, 2020 at 5:55 PM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Thu 2020-04-23 00:02:48, Orson Zhai wrote:
> > > On Wed, Apr 22, 2020 at 10:25 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Wed, Apr 22, 2020 at 09:06:08PM +0800, Orson Zhai wrote:
> > > > > On Tue, Apr 21, 2020 at 3:10 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > My motivation came from the concept of GKI (Generic Kernel Image) in Android.
> > > > > Google will release a common kernel image (binary) to all of the Android system
> > > > > vendors in the world instead of letting them to build their owns as before.
> > > > > Every SoC vendor's device drivers will be provided in kernel modules only.
> > > > > By my patch, the driver owners could debug their modules in field (say
> > > > > production releases)
> > > > > without having to enable dynamic debug for the whole GKI.
> > > >
> > > > Will Google release that binary with CONFIG_DYNAMIC_DEBUG_CORE disabled?
> > > >
> > > In Google's plan, there will be only one GKI (no debug version) for
> > > one Android version per kernel version per year.
> >
> > Are there plans to use modules with debug messages enabled on production
> > systems?
> 
> Yes, but in a managed way. They are not being enabled directly to log buffer.
> Users / FAEs (Field Application Engineer) might control to open or
> close every single one on-the-fly.

I see.

> > IMHO, the debug messages are primary needed during development and
> > when fixing bugs. I am sure that developers will want to enable many
> > more features that will help with debugging and which will be disabled
> > on production systems.
> 
> I agree with you in general speaking.
> For real production build we usually keep a few critical debugging
> methods in case of some
> potential bugs which are extremely hard to be found in production test.
> Dynamic debug is one of these methods.
> I assume it is widely used for maintenance to PC or server because I
> can find it is enabled in some
> popular Linux distribution configs.

Fair enough.

Feel free to add:

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
