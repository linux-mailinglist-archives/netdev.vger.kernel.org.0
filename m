Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4414A4D2E
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380915AbiAaR1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380085AbiAaR13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:27:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5191EC061714;
        Mon, 31 Jan 2022 09:27:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1FA760F54;
        Mon, 31 Jan 2022 17:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87E2C340EE;
        Mon, 31 Jan 2022 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643650048;
        bh=70SOn0z0ogL8vCvmugDM/5HPUyynbxERc7b9LIltGbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KwClkgagBONQH+84EQ5eYxtHVL5SMg2dD/CkCSS7NrDEPZTrFzeLN/QWUNm3HK52q
         fHzCTGqHqRTWlC85x4KBK1CrD5YbC3+S4bcJDTdpeMz1YosJiU/kxZL2mW1O5bJGML
         /XyUUNZL/9S0iUlzHzK/6q6S4O9WWh2pqZUdnFB13MTRIuXzmKWosHMZBZat4ljhO2
         j8R5/BpKpe7ntq4c01G0f0ThKIRw2iQwlkdE4M082GGLXT/fOcT/LWbh18LbQoM4sf
         a348Hc8NXHBrlRqFdL4alqNT7MHtfGFSu3/DrdPTE51yeJ9K4hPDl+8lzA1PqHG1JX
         ca/hELTVD2Fww==
Date:   Mon, 31 Jan 2022 09:27:26 -0800
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
Message-ID: <20220131092726.3864b19f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
References: <B60B8A4B-92A0-49B3-805D-809A2433B46C@abv.bg>
        <20210720122215.54abaf53@cakuba>
        <5D0CFF83-439B-4A10-A276-D2D17B037704@abv.bg>
        <YPa4ZelG2k8Z826E@kroah.com>
        <C6AA954F-8382-461D-835F-E5CA03363D84@abv.bg>
        <YPbHoScEo8ZJyox6@kroah.com>
        <AEC79E3B-FA7F-4A36-95CE-B6D0F3063DF8@abv.bg>
        <80a13e9b-e026-1238-39ed-32deb5ff17b0@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 10:45:23 +0100 Jan Kiszka wrote:
> On 20.07.21 15:12, Georgi Valkov wrote:
> > Thank you, Greg!
> > 
> > git send-email drivers/net/0001-ipheth-fix-EOVERFLOW-in-ipheth_rcvbulk_callback.patch
> > ...
> > Result: OK
> > 
> > I hope I got right. I added most of the e-mail addresses, and also tried adding Message-Id.
> > I have not received the e-mail yet, so I cannot confirm if it worked or not.
> >   
> 
> What happened here afterwards?
> 
> I just found out the hard way that this patch is still not in mainline 
> but really needed.

I have not seen the repost :(
