Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C8F177FE9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgCCRxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:53:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbgCCRxf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:35 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D4AB206D5;
        Tue,  3 Mar 2020 17:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258014;
        bh=EpRhqg1t2E2K0Or7CHeACcbTjwjBa3cBLkyGEK5sBw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mPFoltkybB7GKFwqM7aa9nrG3QKhQCSTLz1AtKCRK3tvTsGitjsupuZowCR+UCHzu
         xr8SteCXaHMu1JgG3D2dW0DzkZdiUi4J0oL1LqJy76cXFmyiy/Ezr7V6WcFMIBHH84
         Is68busg2NQv+208JliSqp3StByr8QOR13CDKxdc=
Date:   Tue, 3 Mar 2020 09:53:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH wireless 0/3] nl80211: add missing attribute validation
Message-ID: <20200303095332.138ce9b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e5d88e0dbca9cc445caa95cfe32edda52f6b193d.camel@sipsolutions.net>
References: <20200303051058.4089398-1-kuba@kernel.org>
        <e5d88e0dbca9cc445caa95cfe32edda52f6b193d.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Mar 2020 08:29:46 +0100 Johannes Berg wrote:
> Hi Jakub,
> 
> > Wireless seems to be missing a handful of netlink policy entries.  
> 
> Yep, these look good to me.
> 
> Here's a
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> if you want to apply them directly? 

Up to Dave, I only put a maintainer hat to cover for Dave when he's
away :)

> I can take them, but you said later you might want to pick them into
> stable, so maybe you have some more direct plan there?

No real plan, but the autoselection bot will very likely pick those up
even if we don't do anything, so given the very limited testing I was
cautious with refactoring.
