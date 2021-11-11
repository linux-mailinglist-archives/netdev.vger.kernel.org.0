Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7544CF19
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbhKKBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231312AbhKKBmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 20:42:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B8460EE4;
        Thu, 11 Nov 2021 01:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636594777;
        bh=cf5yOhrezRaS3az4I+5LjwvWmGyLUDhsfildHNI2s2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TERuJy+0mBTSaXjUPuv97W88N9bqw45z6KMJt40R91eXi2cwfbpZ7DLMiCURoVFrO
         HY9VrAJuvI9zgAUhl5FuPKJD2/ge4X7H873CCkdRjsl02PFlJqerhjL2WDBSYM5kG4
         cdb1WmUVdcOQ56pMUz1UT8zzIhHEsZGAtdIwx0V7uGt32eZaPpQ+ITPB0AnPbcIgj1
         oNUyFGVR0OLShASmRN1xqk0EfJ5LzhEgKOIwdUKjsGqQVzRq2pafRu4O9bpjEAO5SU
         q1PE6zavYqmU8KskvjXGGWbMBRSfoR6gHkykTHNPZwNiOxinnB1ZmXajrtCMf7zUmd
         uP+X+V8iXixqw==
Date:   Wed, 10 Nov 2021 17:39:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
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
        linux-kernel@vger.kernel.org, joe@perches.com, rostedt@goodmis.org
Subject: Re: [PATCH v3 3/3] MAINTAINERS: Mark VMware mailing list entries as
 email aliases
Message-ID: <20211110173935.45a9f495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
References: <163657479269.84207.13658789048079672839.stgit@srivatsa-dev>
        <163657493334.84207.11063282485812745766.stgit@srivatsa-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 12:09:06 -0800 Srivatsa S. Bhat wrote:
>  DRM DRIVER FOR VMWARE VIRTUAL GPU
> -M:	"VMware Graphics" <linux-graphics-maintainer@vmware.com>
>  M:	Zack Rusin <zackr@vmware.com>
> +R:	VMware Graphics Reviewers <linux-graphics-maintainer@vmware.com>
>  L:	dri-devel@lists.freedesktop.org
>  S:	Supported
>  T:	git git://anongit.freedesktop.org/drm/drm-misc

It'd be preferable for these corporate entries to be marked or
otherwise distinguishable so that we can ignore them when we try 
to purge MAINTAINERS from developers who stopped participating.

These addresses will never show up in a commit tag which is normally
sign of inactivity.
