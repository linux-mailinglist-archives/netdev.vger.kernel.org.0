Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF2D44D16C
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 06:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhKKFWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 00:22:52 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:34552 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229814AbhKKFWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 00:22:52 -0500
Received: from omf18.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 8B8FC101EABB1;
        Thu, 11 Nov 2021 05:20:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf18.hostedemail.com (Postfix) with ESMTPA id 1C9ADC0002F4;
        Thu, 11 Nov 2021 05:19:53 +0000 (UTC)
Message-ID: <d7f3fec79287a149d6edc828583a771c84646b42.camel@perches.com>
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     jgross@suse.com, x86@kernel.org, pv-drivers@vmware.com,
        Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, amakhalov@vmware.com,
        sdeep@vmware.com, virtualization@lists.linux-foundation.org,
        keerthanak@vmware.com, srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Date:   Wed, 10 Nov 2021 21:19:53 -0800
In-Reply-To: <20211110173935.45a9f495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
         <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
         <20211110173935.45a9f495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ztcifz3jtb55m8w5484sjq3xynbqoduh
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 1C9ADC0002F4
X-Spam-Status: No, score=-1.31
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+SDIVTNx+3zME4BO7OMP/EAp4Y+zdx/2M=
X-HE-Tag: 1636607993-497590
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-10 at 17:39 -0800, Jakub Kicinski wrote:
> On Wed, 10 Nov 2021 12:09:06 -0800 Srivatsa S. Bhat wrote:
> >  DRM DRIVER FOR VMWARE VIRTUAL GPU
> > -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> >  M:	Zack Rusin <zackr@vmware.com>
> > +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
> >  L:	dri-devel@lists.freedesktop.org
> >  S:	Supported
> >  T:	git git://anongit.freedesktop.org/drm/drm-misc
> 
> It'd be preferable for these corporate entries to be marked or
> otherwise distinguishable so that we can ignore them when we try 
> to purge MAINTAINERS from developers who stopped participating.
> 
> These addresses will never show up in a commit tag which is normally
> sign of inactivity.

Funny.

The link below is from over 5 years ago.

https://lore.kernel.org/lkml/1472081625.3746.217.camel@perches.com/

Almost all of those entries are still in MAINTAINERS.

I think the concept of purging is a non-issue.

