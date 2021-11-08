Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC8449F0F
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 00:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhKHXkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 18:40:46 -0500
Received: from smtprelay0080.hostedemail.com ([216.40.44.80]:47598 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231268AbhKHXkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 18:40:45 -0500
Received: from omf01.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 5411F837F24F;
        Mon,  8 Nov 2021 23:37:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 7C9C917274;
        Mon,  8 Nov 2021 23:37:54 +0000 (UTC)
Message-ID: <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
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
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Nov 2021 15:37:53 -0800
In-Reply-To: <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
         <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.22
X-Stat-Signature: dabja5iyhi1f3u7sn4gaygkth6wafpyr
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 7C9C917274
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19XvMXBRYU1i3HvRZAoQGyZbMrqYURbOg0=
X-HE-Tag: 1636414674-345765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-08 at 12:30 -0800, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> 
> VMware mailing lists in the MAINTAINERS file are private lists meant
> for VMware-internal review/notification for patches to the respective
> subsystems. So, in an earlier discussion [1][2], it was recommended to
> mark them as such. Update all the remaining VMware mailing list
> references to use that format -- "L: list@address (private)".
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
>  F:	drivers/gpu/drm/vboxvideo/
>  
>  DRM DRIVER FOR VMWARE VIRTUAL GPU
> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
>  M:	Zack Rusin <zackr@vmware.com>
> +L:	linux-graphics-maintainer@vmware.com (private)

This MAINTAINERS file is for _public_ use, marking something
non-public isn't useful.

private makes no sense and likely these L: entries shouldn't exist.


