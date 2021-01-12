Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA1C2F2932
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392069AbhALHug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:50:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbhALHug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:50:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34CE20739;
        Tue, 12 Jan 2021 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610437789;
        bh=/6DFCCaRYUp6K/lYBRxihjG38D3Texx1g45T4/icnMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I78GCH1wwsEEUAsd+drOEFwauvHcPzLIh30yuD1zKCNXaQHhlWQLEUtX1XZFWx0aP
         eWhjO9ZXwKFMOZIjtl+mYHgYy+PKc752UM/35D71ulTMaIxv0TkmLO3xQoQa7e7ox5
         nTcUyQLtj8YhEFQJ3PsrbMLBTozTvhyL4FNdy7/g=
Date:   Tue, 12 Jan 2021 08:49:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Cindy Lu <lulu@redhat.com>
Cc:     jasowang@redhat.com, mst@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] vhost_vdpa: fix the problem in
 vhost_vdpa_set_config_call
Message-ID: <X/1UmaAb8j2eot5Q@kroah.com>
References: <20210112053227.8574-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112053227.8574-1-lulu@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 01:32:27PM +0800, Cindy Lu wrote:
> In vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
> this cb.private will finally use in vhost_vdpa_config_cb as
> vhost_vdpa. Fix this issue.
> 
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
