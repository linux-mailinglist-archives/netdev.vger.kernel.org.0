Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A802AA7DC
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgKGUQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgKGUQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:16:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F54920885;
        Sat,  7 Nov 2020 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604780214;
        bh=SclaVh50kOJ0lCamcHNcGBRAlnU+aXdrtrNxzPD0prQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fu0qEFgL5xRvB7iGmmq/8VqMl3Gx8PQTuOt+P9aAnjl9qCakqPq9DXDtFN/GK8DMp
         4GECJO7YW6+Q07PbaXSs5h4GXaYIFbhnIaqJ9MLKS5siYYWrJv/Rtq4yWOsXcbKLmX
         LazVY1pjlO+738MzEMvYvXGErmSwgHJNcLsNlLWE=
Date:   Sat, 7 Nov 2020 12:16:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net] r8169: disable hw csum for short packets on all
 chip versions
Message-ID: <20201107121653.650f333e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com>
References: <7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 18:14:47 +0100 Heiner Kallweit wrote:
> RTL8125B has same or similar short packet hw padding bug as RTL8168evl.
> The main workaround has been extended accordingly, however we have to
> disable also hw checksumming for short packets on affected new chip
> versions. Instead of checking for an affected chip version let's
> simply disable hw checksumming for short packets in general.
> 
> v2:
> - remove the version checks and disable short packet hw csum in general
> - reflect this in commit title and message
> 
> Fixes: 0439297be951 ("r8169: add support for RTL8125B")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
