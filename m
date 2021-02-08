Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162EE312C4A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhBHIwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhBHItr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 03:49:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE9964E3F;
        Mon,  8 Feb 2021 08:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612774143;
        bh=jK8gkHstEVx/vPidU4geaVSKjlzS90MaLfQBHIeLEo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSsSNZmeb3cWitZZY0IHyUSPQmxsmr+C8zZdmWtNlSHZ5ZjiKVLahAVcBJnLC747H
         NRs0vboGQWrWe4bq+pDHSIWApxb5Unk/SEYjIyrRp99joRu+grE+Nh5xrB5eVJtBB8
         S6AfUCw2ACAf/fU5cg7GBs0fBXz5bGcARJXyb3dY=
Date:   Mon, 8 Feb 2021 09:49:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Where is this patch buried?
Message-ID: <YCD6/OByXFRyuR71@kroah.com>
References: <7953a4158fd14aabbcfbad8365231961@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7953a4158fd14aabbcfbad8365231961@SVR-IES-MBX-03.mgc.mentorg.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:12:29AM +0000, Schmid, Carsten wrote:
> Hi Greg,
> 
> in kernel 4.14 i have seen a NULL pointer deref in
> [65064.613465] RIP: 0010:ip_route_output_key_hash_rcu+0x755/0x850
> (i have a core dump and detailed analysis)
> 
> That looks like this patch could have prevented it:
> 
> https://www.spinics.net/lists/stable-commits/msg133055.html
> 
> this one was queued for 4.14, but i can't find it in git tree?
> Any idea who/what buried this one?
> 
> In 4.19 it is present.
> 
> Because our customer uses 4.14 (going to 4.14.212 in a few days) i kindly want to ask why this patch hasn't entered 4.14.

Because it breaks the build?  Try it yourself and see what happens :)

I will gladly take a working backport if you can submit it.

thanks,

greg k-h
