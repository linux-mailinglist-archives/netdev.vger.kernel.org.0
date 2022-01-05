Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0358A485516
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241134AbiAEOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:52:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237103AbiAEOwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:52:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4551CB81897;
        Wed,  5 Jan 2022 14:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412A4C36AE0;
        Wed,  5 Jan 2022 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641394349;
        bh=zdrGBZxQAxrOnrhcPxxmm//IhiQfUFcgEDkY1MAzjKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pbI+HM3ZV11R6U9tkw1Z9S1vE/WpswaQkNAC3LsGiyBQpui6LtlVy4ffZL3qgELS9
         fWuAttenZdYCVxTot7D6sciPEsNi9jKmA20QzpGP4fGntKDh/+hsSLlUVIDZZ74t6c
         hFvgEAcJVU8XQdKB/4Voq2zOEvaKJtWuc4UvP83g=
Date:   Wed, 5 Jan 2022 15:52:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 3/3] net: usb: r8152: remove unused definition
Message-ID: <YdWwqdmDWfVe/Dv7@kroah.com>
References: <20220105142351.8026-1-aaron.ma@canonical.com>
 <20220105142351.8026-3-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105142351.8026-3-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 10:23:51PM +0800, Aaron Ma wrote:
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 3 ---
>  1 file changed, 3 deletions(-)

I know I do not take patches without any changelog text in it, maybe
other maintainers are more lax :)

Please fix.

thanks,

greg k-h
