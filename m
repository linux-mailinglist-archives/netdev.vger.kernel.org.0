Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887284A4D7A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381092AbiAaRrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379995AbiAaRrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:47:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA5EC061714;
        Mon, 31 Jan 2022 09:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D4A6102C;
        Mon, 31 Jan 2022 17:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D284C340ED;
        Mon, 31 Jan 2022 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643651226;
        bh=2X2BmVHS2Tyjnx4FsGnmfBWniGfTti/23qtfZG8b/w0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PawOG8f8o4aF/bLUiHEASQ7YacziQOSLTt198ijQrbmmLbGCicg8MhuHzFos8GDeY
         kPU3C4pcxtQOgVrElDGIBGv4D7iDWFMlFWAM92idBXorZ0PIJ6G6dvBNZbTOYz9g7o
         ipdrAdtLzvAWm0ki7Wnypj2FbjqkWIEJC4vWjuSt/6G4LO+hGVpKSUOTS1H5iA514n
         EqJNMjWKIoWn1Cic2UCOtBDOj3XSE1O4HEEpdZp//K78TaQYGA2ncGPSKQTNXMLjBr
         Kj9DFGgrH2enEGZcu2HbJYkQXY31JW2ecC7ZXPOavbajQWj+14VPGcvQCpyxh76bTk
         OScGnZcTWkIFA==
Date:   Mon, 31 Jan 2022 09:47:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Georgi Valkov <gvalkov@abv.bg>,
        Greg KH <gregkh@linuxfoundation.org>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <luc.vanoostenryck@gmail.com>,
        <snelson@pensando.io>, <mst@redhat.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <corsac@corsac.net>,
        <matti.vuorela@bitfactor.fi>, <stable@vger.kernel.org>
Subject: Re: ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
Message-ID: <20220131094704.0e255169@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
        <20210720122215.54abaf53@cakuba>
        <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg>
        <YPa4ZelG2k8Z826E@kroah.com>
        <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg>
        <YPbHoScEo8ZJyox6@kroah.com>
        <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
        <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
        <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6108f260-36bf-0059-ccb9-8189f4a2d0c1@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 18:35:44 +0100 Jan Kiszka wrote:
> On 31.01.22 18:27, Jakub Kicinski wrote:
> > On Mon, 31 Jan 2022 10:45:23 +0100 Jan Kiszka wrote:  
> >> What happened here afterwards?
> >>
> >> I just found out the hard way that this patch is still not in mainline
> >> but really needed.  
> > 
> > I have not seen the repost :(  
> 
> Would it help if I do that on behalf of Georgi? Meanwhile, I can add a 
> tested-by to it, after almost a full working day with it applied.

That's probably the most expedient way to close the issue, yup.
Real Fixes: tag would be useful as well.
