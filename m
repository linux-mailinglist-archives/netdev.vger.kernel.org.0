Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29891E3A10
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503818AbfJXRbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:31:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:33122 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbfJXRbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 13:31:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 10:31:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,225,1569308400"; 
   d="scan'208";a="282008162"
Received: from nesterov-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.8.153])
  by orsmga001.jf.intel.com with ESMTP; 24 Oct 2019 10:30:52 -0700
Date:   Thu, 24 Oct 2019 20:30:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Feng Tang <feng.tang@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH] Cleanup: replace prefered with preferred
Message-ID: <20191024173051.GB7948@linux.intel.com>
References: <20191022214208.211448-1-salyzyn@android.com>
 <20191023115637.GA23733@linux.intel.com>
 <fa12cb96-7a93-bf85-214d-a7bfaf8b8b0a@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa12cb96-7a93-bf85-214d-a7bfaf8b8b0a@android.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> 
> I will split this between pure and inert documentation/comments for now,
> with a followup later for the code portion which understandably is more
> controversial.
> 
> Cleanup is the least appreciated part of kernel maintenance ;-}.
> 
> Sincerely -- Mark Salyzyn

I'm a strong believer of "evolutionary" approach. Patch sets for the
most part (everything in the end has to be considered case by case, not
a strict rule) should have some functional changes involved.

What I do require for the parts that I maintain is that any new change
will result cleaner code base than the one that existed before that
change was applied. Again, there are some exceptions to this e.g.
circulating a firmware bug but this is my driving guideline as a
maintainer.

Doing cleanups just for cleanups can sometimes add unnecessary merge
conflicts when backporting patches to stable kernels. Thus, if you are
doing just a cleanup you should have extremely good reasons to do so.

/Jarkko
