Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44443449F9E
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbhKIAkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 19:40:41 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:34678 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229974AbhKIAkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 19:40:40 -0500
Received: from omf14.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B17CE18499AA5;
        Tue,  9 Nov 2021 00:37:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id 280E4268E45;
        Tue,  9 Nov 2021 00:37:48 +0000 (UTC)
Message-ID: <dcbd19fcd1625146f4db267f84abd7412513d20e.camel@perches.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
From:   Joe Perches <joe@perches.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com
Cc:     Nadav Amit <namit@vmware.com>, Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        sdeep@vmware.com, amakhalov@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        gregkh@linuxfoundation.org
Date:   Mon, 08 Nov 2021 16:37:46 -0800
In-Reply-To: <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
         <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
         <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
         <cb03ca42-b777-3d1a-5aba-b01cd19efa9a@csail.mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 280E4268E45
X-Spam-Status: No, score=-4.72
X-Stat-Signature: nb9hoi3t69ayygs8x58pxmai5y393qhi
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+/yA5i3mf5Qcbygfb34RS/hVZ8PmXw7yU=
X-HE-Tag: 1636418268-383849
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-08 at 16:22 -0800, Srivatsa S. Bhat wrote:
> +Greg, Thomas
> 
> Hi Joe,
> 
> On 11/8/21 3:37 PM, Joe Perches wrote:
> > On Mon, 2021-11-08 at 12:30 -0800, Srivatsa S. Bhat wrote:
> > > From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > > 
> > > VMware mailing lists in the MAINTAINERS file are private lists meant
> > > for VMware-internal review/notification for patches to the respective
> > > subsystems. So, in an earlier discussion [1][2], it was recommended to
> > > mark them as such. Update all the remaining VMware mailing list
> > > references to use that format -- "L: list@address (private)".
> > []
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > []
> > > @@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
> > >  F:	drivers/gpu/drm/vboxvideo/
> > >  
> > >  DRM DRIVER FOR VMWARE VIRTUAL GPU
> > > -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> > >  M:	Zack Rusin <zackr@vmware.com>
> > > +L:	linux-graphics-maintainer@vmware.com (private)
> > 
> > This MAINTAINERS file is for _public_ use, marking something
> > non-public isn't useful.
> > 
> > private makes no sense and likely these L: entries shouldn't exist.
> 
> Well, the public can send messages to this list, but membership is
> restricted.

Ah, new information.
That's not quite what the commit message describes.
 
> In many ways, I believe this is similar to x86@kernel.org, which is an
> email alias that anyone can post to in order to reach the x86
> maintainer community for patch review. I see x86@kernel.org listed as
> both L: and M: in the MAINTAINERS file, among different entries.
> 
> Although the @vmware list ids refer to VMware-internal mailing lists
> as opposed to email aliases, they serve a very similar purpose -- to
> inform VMware folks about patches to the relevant subsystems.
> 
> Is there a consensus on how such lists should be specified?

Not so far as I know.

> One
> suggestion (from Greg in the email thread referenced above) was to
> mark it as private, which is what this patch does. Maybe we can find a
> better alternative?
> 
> How about specifying such lists using M: (indicating that this address
> can be used to reach maintainers), as long as that is not the only M:
> entry for a given subsystem (i.e., it includes real people's email id
> as well)? I think that would address Greg's primary objection too from
> that other thread (related to personal responsibility as maintainers).

So it's an exploder not an actual maintainer and it likely isn't
publically archived with any normal list mechanism.

So IMO "private" isn't appropriate.  Neither is "L:"
Perhaps just mark it as what it is as an "exploder".

Or maybe these blocks should be similar to:

M:	Name of Lead Developer <somebody@vmware.com>
M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com>

Maybe something like a comment mechanism should be added to the
MAINTAINERS file.

Maybe #

so this entry could be something like:

M:	VMware <foo> maintainers <linux-<foo>-maintainers@vmlinux.com> # VMware's ever changing internal maintainers list


