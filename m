Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24F845B2F5
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhKXEG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240896AbhKXEG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:06:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5600E60551;
        Wed, 24 Nov 2021 04:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637726628;
        bh=SMO+DJRmOxkS3j8P437pwB2kbDjs8mxcnAz6vHY49xY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INhmPlwoiHWX+GncK/tf5wgiqgdd2n0jxeYcfogSI6lXaSsqyZ2TdQBXLy2Dz2tG3
         lbp/WnN2xRZhlcdP/CJYEOsHxe1lCIWFsfypLd/Lt9VFkPxIOxCBYpZpq6EEdA6XGZ
         g0ImMPuHvjUE2cQdsKkk/SBYiTCOKz775yZ2w++4zYYL2eX78rVOsP7zIU+sAco+qx
         FIXs733/VI1F7JzApmlTEWtDXD5rt13cWZvkMfqwATj1cWr9Zwfyrkkkj9UGi5YolB
         SkNkpXy50MFoci21dx4KTVIqfbQutdHIjdjWa4fNa0wbOuOAyXkTXjpyY6IGsivGwv
         pYuV0t0RzMlDA==
Date:   Tue, 23 Nov 2021 20:03:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        msizanoen1 <msizanoen@qtmlabs.xyz>, stable@vger.kernel.org
Subject: Re: [PATCH net] ipv6: fix memory leak in fib6_rule_suppress
Message-ID: <20211123200347.597e2daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123124832.15419-1-Jason@zx2c4.com>
References: <20211123124832.15419-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 13:48:32 +0100 Jason A. Donenfeld wrote:
> The original author of this commit and commit message is anonymous and
> is therefore unable to sign off on it. Greg suggested that I do the sign
> off, extracting it from the bugzilla entry above, and post it properly.
> The patch "seems to work" on first glance, but I haven't looked deeply
> at it yet and therefore it doesn't have my Reviewed-by, even though I'm
> submitting this patch on the author's behalf. And it should probably get
> a good look from the v6 fib folks. The original author should be on this
> thread to address issues that come off, and I'll shephard additional
> versions that he has.

Does the fact that the author responded to the patch undermine the need
for this special handling?
