Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DF13CF9EA
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhGTMOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhGTMOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:14:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F7AC610D2;
        Tue, 20 Jul 2021 12:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626785700;
        bh=pI77XCIHidvCqn0bjmVbWNXeMP9eCvjJeUVEsiFJriE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BJAb+xUbmD9RZSSicF9kw+4lj71adK6LBPgjF6EIQV1oShZ5FJzjNB7g4wWqM6mXa
         Rwa1Ec3J88m0BVFK7loIXVZkRaieKcsYASEAj2FPwlZ2iAYq9ww8nq5qRKA35k/8Wu
         ja+DrNs3Cr6T03CoZ4LG07XlWbvjY5zlvLBFFb8M=
Date:   Tue, 20 Jul 2021 14:54:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Georgi Valkov <gvalkov@abv.bg>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        mhabets@solarflare.com, luc.vanoostenryck@gmail.com,
        snelson@pensando.io, mst@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-ID: <YPbHoScEo8ZJyox6@kroah.com>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg>
 <YPa4ZelG2k8Z826E@kroah.com>
 <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 03:46:11PM +0300, Georgi Valkov wrote:
> Yes, I read it, and before my previous e-mail that I also read the link from Jakub,
> which essentially provides the same information.
> 
> There is only one patch 0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch

Great, send that using 'git send-email' and all is good.

> The command I used from the example also generated a 0000-cover-letter, so
> I included it as well.

Why do you need a cover letter for 1 patch?

thanks,

greg k-h
