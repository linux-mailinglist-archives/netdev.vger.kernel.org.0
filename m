Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51AD744C89F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhKJTMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:12:45 -0500
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:49739 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232512AbhKJTMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:12:44 -0500
Received: from [128.177.79.46] (helo=csail.mit.edu)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1mksyl-000UxK-A3; Wed, 10 Nov 2021 14:09:51 -0500
Date:   Wed, 10 Nov 2021 11:13:03 -0800
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     Nadav Amit <namit@vmware.com>
Cc:     Joe Perches <joe@perches.com>, Juergen Gross <jgross@suse.com>,
        X86 ML <x86@kernel.org>, Pv-drivers <Pv-drivers@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Zack Rusin <zackr@vmware.com>, Deep Shah <sdeep@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Keerthana Kalyanasundaram <keerthanak@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Message-ID: <20211110191303.GA122235@csail.mit.edu>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
 <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
 <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
 <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
 <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
 <5C24FB2A-D2C0-4D95-A0C0-B48C4B8D5AF4@vmware.com>
 <1875b0458294d23d8e3260d2824894b095d6a62d.camel@perches.com>
 <20211110172000.GA121926@csail.mit.edu>
 <F21C4118-BFDE-4DA7-B42F-90EC71CFED57@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F21C4118-BFDE-4DA7-B42F-90EC71CFED57@vmware.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 05:40:09PM +0000, Nadav Amit wrote:
> 
> 
> > On Nov 10, 2021, at 9:20 AM, Srivatsa S. Bhat <srivatsa@csail.mit.edu> wrote:
> > 
> > On Tue, Nov 09, 2021 at 01:57:31PM -0800, Joe Perches wrote:
> >> On Tue, 2021-11-09 at 00:58 +0000, Nadav Amit wrote:
> >>>> On Nov 8, 2021, at 4:37 PM, Joe Perches <joe@perches.com> wrote:
> >>>> On Mon, 2021-11-08 at 16:22 -0800, Srivatsa S. Bhat wrote:
> >>>> 
> >>>> So it's an exploder not an actual maintainer and it likely isn't
> >>>> publically archived with any normal list mechanism.
> >>>> 
> >>>> So IMO "private" isn't appropriate.  Neither is "L:"
> >>>> Perhaps just mark it as what it is as an "exploder".
> >>>> 
> >>>> Or maybe these blocks should be similar to:
> >>>> 
> >>>> M:	Name of Lead Developer <somebody@vmware.com>
> >>>> M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com>
> >> 
> >> Maybe adding entries like
> >> 
> >> M:	Named maintainer <whoever@vmware.com>
> >> R:	VMware <foo> reviewers <linux-<foo>-maintainers@vmware.com>
> >> 
> >> would be best/simplest.
> >> 
> > 
> > Sure, that sounds good to me. I also considered adding "(email alias)"
> > like Juergen suggested, but I think the R: entry is clear enough.
> > Please find the updated patch below.
> > 
> > ---
> > 
> > From f66faa238facf504cfc66325912ce7af8cbf79ec Mon Sep 17 00:00:00 2001
> > From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
> > Date: Mon, 8 Nov 2021 11:46:57 -0800
> > Subject: [PATCH v2 2/2] MAINTAINERS: Mark VMware mailing list entries as email
> > aliases
> > 
> > VMware mailing lists in the MAINTAINERS file are private lists meant
> > for VMware-internal review/notification for patches to the respective
> > subsystems. Anyone can post to these addresses, but there is no public
> > read access like open mailing lists, which makes them more like email
> > aliases instead (to reach out to reviewers).
> > 
> > So update all the VMware mailing list references in the MAINTAINERS
> > file to mark them as such, using "R: email-alias@vmware.com".
> > 
> > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > Cc: Zack Rusin <zackr@vmware.com>
> > Cc: Nadav Amit <namit@vmware.com>
> > Cc: Vivek Thampi <vithampi@vmware.com>
> > Cc: Vishal Bhakta <vbhakta@vmware.com>
> > Cc: Ronak Doshi <doshir@vmware.com>
> > Cc: pv-drivers@vmware.com
> > Cc: linux-graphics-maintainer@vmware.com
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-scsi@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-input@vger.kernel.org
> > ---
> > MAINTAINERS | 22 +++++++++++-----------
> > 1 file changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 118cf8170d02..4372d79027e9 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
> > F:	drivers/gpu/drm/vboxvideo/
> > 
> > DRM DRIVER FOR VMWARE VIRTUAL GPU
> > -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> > M:	Zack Rusin <zackr@vmware.com>
> > +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
> > L:	dri-devel@lists.freedesktop.org
> > S:	Supported
> > T:	git git://anongit.freedesktop.org/drm/drm-misc
> > @@ -14189,7 +14189,7 @@ F:	include/uapi/linux/ppdev.h
> > PARAVIRT_OPS INTERFACE
> > M:	Juergen Gross <jgross@suse.com>
> > M:	Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > -L:	pv-drivers@vmware.com (private)
> > +R:	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
> 
> This patch that you just sent seems to go on top of the previous patches
> (as it removes "L: pv-drivers@vmware.com (private)”).
> 

Actually, that's a bit misleading, since I had corrected that entry in
the first patch itself, while adding myself as the maintainer. So
there are still only 2 patches in this series right now.

Thanks for pointing this out! I'll move the VMware list modifications
out of the first patch, to avoid confusion.

> Since the patches were still not merged, I would presume you should squash
> the old 2/2 with this new patch and send v3 of these patches.
> 

I'll send out a v3, and also add Zack Rusin as the maintainer for the
vmmouse sub-driver, since it does not have a named maintainer at the
moment (Zack indicated that he will be taking up the maintainership).

Thank you!

Regards,
Srivatsa
