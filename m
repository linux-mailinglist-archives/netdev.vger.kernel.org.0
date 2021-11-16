Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040C1453C79
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhKPXBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 18:01:22 -0500
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:40256 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229775AbhKPXBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 18:01:22 -0500
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id AB5BB86E90;
        Tue, 16 Nov 2021 22:58:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 2FC745092ECC;
        Tue, 16 Nov 2021 22:58:15 +0000 (UTC)
Message-ID: <f03d59adc565c1cf2e97c97c5ea6083e614549dd.camel@perches.com>
Subject: Re: [PATCH v4 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
From:   Joe Perches <joe@perches.com>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com
Cc:     Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, sdeep@vmware.com,
        amakhalov@vmware.com, keerthanak@vmware.com, srivatsab@vmware.com,
        anishs@vmware.com, linux-kernel@vger.kernel.org, kuba@kernel.org,
        rostedt@goodmis.org
Date:   Tue, 16 Nov 2021 14:58:17 -0800
In-Reply-To: <163710245724.123451.10205809430483374831.stgit@csail.mit.edu>
References: <163710239472.123451.5004514369130059881.stgit@csail.mit.edu>
         <163710245724.123451.10205809430483374831.stgit@csail.mit.edu>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2FC745092ECC
X-Spam-Status: No, score=0.10
X-Stat-Signature: bag15ygnb7zycjmij7n8krsg37adfghn
X-Rspamd-Server: rspamout03
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+Z1DWOQKC1GCVRxp1buSNRLZLwazhnR2M=
X-HE-Tag: 1637103495-673145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-16 at 14:41 -0800, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> 
> VMware mailing lists in the MAINTAINERS file are private lists meant
> for VMware-internal review/notification for patches to the respective
> subsystems. Anyone can post to these addresses, but there is no public
> read access like open mailing lists, which makes them more like email
> aliases instead (to reach out to reviewers).
> 
> So update all the VMware mailing list references in the MAINTAINERS
> file to mark them as such, using "R: email-alias@vmware.com".
> 
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Acked-by: Joe Perches <joe@perches.com>

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -6223,8 +6223,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
>  F:	drivers/gpu/drm/vboxvideo/
>  
>  DRM DRIVER FOR VMWARE VIRTUAL GPU
> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
>  M:	Zack Rusin <zackr@vmware.com>
> +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>

etc...


