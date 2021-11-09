Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA5A449F5C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbhKIATd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 19:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhKIATW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 19:19:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F9261104;
        Tue,  9 Nov 2021 00:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636416997;
        bh=e6eETMfldk25YhhOCrkCCcAt2VNZWoeJqi7WGDCXDYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ovBqOJljx/XmzXcfiQ71NhXBMqv0jdOpQW/90L/ozBJV36lZvgnTusUibrM/UOQaE
         JouikJZURVmWWRE27Z1mTVfte3f5ZJmXzBiIK7l3FkWv77uZprpZwMBepL26Fhf1+s
         UFRlPRHuRD3riePXbgl/5WD5W7wA2PGqq0krDN8GBJwE9r9hQBxqoyovP0MKbov+2w
         XEX7Bb094YYrIilz4p+2zXHFnq00sOZ+J9/UyGQnNVZabYkWnGqlcG2nT1j9hrHmuU
         iKSlLXibZ2AZEk+eIGwM3nmCEFzFGCcTiHs6l+tnm6s5lL2wIq94QPsUYe40qJ007Y
         +XnrRmheNXVAQ==
Date:   Mon, 8 Nov 2021 16:16:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>, jgross@suse.com,
        x86@kernel.org, pv-drivers@vmware.com,
        Nadav Amit <namit@vmware.com>,
        Vivek Thampi <vithampi@vmware.com>,
        Vishal Bhakta <vbhakta@vmware.com>,
        Ronak Doshi <doshir@vmware.com>,
        linux-graphics-maintainer@vmware.com,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        sdeep@vmware.com, amakhalov@vmware.com,
        virtualization@lists.linux-foundation.org, keerthanak@vmware.com,
        srivatsab@vmware.com, anishs@vmware.com,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] MAINTAINERS: Mark VMware mailing list entries as
 private
Message-ID: <20211108161631.2941f3a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
References: <163640336232.62866.489924062999332446.stgit@srivatsa-dev>
        <163640339370.62866.3435211389009241865.stgit@srivatsa-dev>
        <5179a7c097e0bb88f95642a394f53c53e64b66b1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Nov 2021 15:37:53 -0800 Joe Perches wrote:
> > @@ -6134,8 +6134,8 @@ T:	git git://anongit.freedesktop.org/drm/drm-misc
> >  F:	drivers/gpu/drm/vboxvideo/
> >  
> >  DRM DRIVER FOR VMWARE VIRTUAL GPU
> > -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
> >  M:	Zack Rusin <zackr@vmware.com>
> > +L:	linux-graphics-maintainer@vmware.com (private)  
> 
> This MAINTAINERS file is for _public_ use, marking something
> non-public isn't useful.

But Greg has a point. Corporations like to send us code with a list 
as the maintainer and MODULE_AUTHOR set to corp's name. We deal with
humans, not legal entities.

I've been trying to get them to use "M: email" without the name,
but "L: list (private)" also works.

Either way I feel like we need _some_ way to tell humans from corporate
"please CC this address" entries.

> private makes no sense and likely these L: entries shouldn't exist.
