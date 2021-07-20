Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FEF3CF92D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbhGTLKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237868AbhGTLJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 07:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D6EC610FB;
        Tue, 20 Jul 2021 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626781799;
        bh=+U/MIESQRO2gMig9c7DN9708dMtV66+bXh8Vfx/UCcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pqhtb/soU95i+VSG6yDruSM7s1IwbqbF0W2/ZgmS4SzfNqHxNCfweKqehlhSi3Nt+
         EYNLPIBaVPV41+1is8uMoKcNEvzTofTsETx9BhFqHSNYe6bGpgM8SqQnxmFEsLeTPE
         yG49N8TPHpQxdnBPDDIHCXz1yp0MrQYU0OtY+H8k=
Date:   Tue, 20 Jul 2021 13:49:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Georgi Valkov <gvalkov@abv.bg>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        mhabets@solarflare.com, luc.vanoostenryck@gmail.com,
        snelson@pensando.io, mst@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        corsac@corsac.net, matti.vuorela@bitfactor.fi,
        stable@vger.kernel.org
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-ID: <YPa4ZelG2k8Z826E@kroah.com>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
 <20210720122215.54abaf53@cakuba>
 <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 02:39:49PM +0300, Georgi Valkov wrote:
> I am doing this for the first time, so any help would be appreciated!

Have you read Documentation/process/submitting-patches.rst yet?  If not,
please do so.

And look at examples on this list, you have to send individual patches,
not everything all crammed into one email.

thanks,

greg k-h
