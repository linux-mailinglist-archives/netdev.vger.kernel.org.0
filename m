Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41830E3B49
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440184AbfJXSri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440168AbfJXSrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:47:37 -0400
Received: from localhost (unknown [75.104.69.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B01B20659;
        Thu, 24 Oct 2019 18:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571942856;
        bh=P2j4bA86XgvOqRFtfCl5MtPYc2xM05N5w3nh3XKCbOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JXFsM9yewwErnF5S3LK+7K6bicNse77w5ov+K8sMXE1WbXMnNUxJ53lRpClS1Y1CC
         11fXyyi93K6RL+XYzVbm018cMUVbdftXTSBMyZqzEhGJR0OX5ENyHkk/LV+cr97wvX
         JQuzhFZ9aaA31ctCt2wdqqskCAv9tdJU2DNgNRus=
Date:   Thu, 24 Oct 2019 14:47:28 -0400
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ingo Molnar <mingo@kernel.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        hersen wu <hersenxs.wu@amd.com>, Roman Li <Roman.Li@amd.com>,
        Maxim Martynov <maxim@arista.com>,
        David Ahern <dsahern@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Feng Tang <feng.tang@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH] Cleanup: replace prefered with preferred
Message-ID: <20191024184728.GC260560@kroah.com>
References: <20191022214208.211448-1-salyzyn@android.com>
 <20191023115637.GA23733@linux.intel.com>
 <fa12cb96-7a93-bf85-214d-a7bfaf8b8b0a@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa12cb96-7a93-bf85-214d-a7bfaf8b8b0a@android.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 08:40:59AM -0700, Mark Salyzyn wrote:
> On 10/23/19 4:56 AM, Jarkko Sakkinen wrote:
> > On Tue, Oct 22, 2019 at 02:41:45PM -0700, Mark Salyzyn wrote:
> > > Replace all occurrences of prefered with preferred to make future
> > > checkpatch.pl's happy.  A few places the incorrect spelling is
> > > matched with the correct spelling to preserve existing user space API.
> > > 
> > > Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> > I'd fix such things when the code is otherwise change and scope this
> > patch only to Documentation/. There is no pragmatic benefit of doing
> > this for the code.
> > 
> > /Jarkko
> 
> The pragmatic benefit comes with the use of an ABI/API checker (which is a
> 'distro' thing, not a top of tree kernel thing) produces its map which is
> typically required to be co-located in the same tree as the kernel
> repository. Quite a few ABI/API update checkins result in a checkpatch.pl
> complaint about the misspelled elements being (re-)recorded due to
> proximity. We have a separate task to improve how it is tracked in Android
> to reduce milepost marker changes that result in sweeping changes to the
> database which would reduce the occurrences.

Requiring checkpatch spelling warnings to be correct based on function
names is crazy, you should fix your tools if you are requiring something
as looney as that :)

> I will split this between pure and inert documentation/comments for now,
> with a followup later for the code portion which understandably is more
> controversial.

Please break up per subsystem, like all trivial patches, as this
isn't anything special.

thanks,

greg k-h
