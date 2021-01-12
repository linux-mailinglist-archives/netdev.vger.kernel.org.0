Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8232F2935
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392129AbhALHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392076AbhALHuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:50:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D4822D2C;
        Tue, 12 Jan 2021 07:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610437803;
        bh=kg2dqaMFQ8oukwEarLjgYCUa05H4ThHj9S7L1S+e8aI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HT3FEp67PMNc2d2EmV8QEffKY8rhHyLP7wXcv2Dzx7Fj3zyB2fDwnt40yTKpUsnNh
         GWVfhyKe9L1KBFOKaly7Ox8lPncqsOJfxfmFfrtYW4onw2CpMOakb0yQj558I/0gAo
         eQOf7cLpO9fYVVWk46fwjOU47L07h4bkMWWTCeAM=
Date:   Tue, 12 Jan 2021 08:49:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cindy Lu <lulu@redhat.com>
Cc:     jasowang@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] vhost_vdpa: fix the problem in
 vhost_vdpa_set_config_call
Message-ID: <X/1Up+fcTcYq2osi@kroah.com>
References: <20210112053629.9853-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112053629.9853-1-lulu@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 01:36:29PM +0800, Cindy Lu wrote:
> In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> this cb.private will finally use in vhost_vdpa_config_cb as
> vhost_vdpa. Fix this issue.
> 
> Fixes: 776f395004d82 ("vhost_vdpa: Support config interrupt in vdpa")
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
