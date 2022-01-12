Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F8048CF0B
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235380AbiALXSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:18:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbiALXR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:17:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB50B82138
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 23:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6DBC36AE9;
        Wed, 12 Jan 2022 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642029476;
        bh=25aw4vWKjfjiEoB2NK9qkTMdYSPDWiEWg9IvdUXGubY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HWHkbrkz+o5FbwNMlpww2H5QMEm3XkfjLf1Q9iIq3BdTnFDOgRTSaH6/f63hXSzcL
         DSh2kHkdMpMBrWxUw1E4qMGbPdM0/dAYnICjcwYaK837b53dKcmCTkaYHuH3ZUYMBz
         PY3vkPe1m684yc57CmN8OGtisXMr35D3SFlBxl4Dvt6GvARNJvWCVJorYddAZB+HCa
         3Wf1iGcpQIvfdP+osKSqPDfduF3TE0uQC9cueO4pGIS9GAVPJ1J4NL64GU9ZpRd2nb
         MuDZd3jAjW1aPAdPF3GhP796dKhTXkbFSx1EmxldsWSKdPBkMsYq6XSgE3Aia8UqqA
         mWRZsC9Gx7FVg==
Date:   Wed, 12 Jan 2022 15:17:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v6 0/8] new Fungible Ethernet driver
Message-ID: <20220112151754.00d6f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109185502.3b83d31f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220110015636.245666-1-dmichail@fungible.com>
        <20220109185502.3b83d31f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Jan 2022 18:55:02 -0800 Jakub Kicinski wrote:
> On Sun,  9 Jan 2022 17:56:28 -0800 Dimitris Michailidis wrote:
> > v6:
> > - When changing queue depth or numbers allocate the new queues
> >   before shutting down the existing ones (Jakub)  
> 
> Thanks!
> 
> We've already posted our changes for 5.17 but we can continue the review
> of this driver and get it ready for after the merge window. I'll review
> this version tomorrow.

Few comments here and there but with those fixed pretty much ready 
to be applied once merge window is over.
