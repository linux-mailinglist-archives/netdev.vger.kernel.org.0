Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0E415F09
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhIWM7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241114AbhIWM7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:59:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48EEE60F39;
        Thu, 23 Sep 2021 12:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632401883;
        bh=FRFMyT3GqGLKaEON7YhfZg/wUyMH86+EnRTt7TCTGF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lutvfPGfjZlzsljF6hEUvUJExx2B402Pnf9Tk/o8fVesTNmiSrxRGKEHDihkMACRM
         mHSqY+b/KDBmz0fX2sL8Guztn+yA6r6tFtV7kBnk77onPb8FqA8xsJid38WKSdtIZY
         p4E4sKVV1x1Mb9M/gLetSaTth5uCTW6lS8suuYyQarZAQ+3iGVZUUScxlWOPxxtP1p
         t0ql246gs/aRlTFV+GmNE+63R+AhCLf+1sinsoVWOqRQTueAFA/3ui19J72p4JM1uE
         vhDExqgIkfoa6ZS75Rj5C3T6ndfb2XAqV1VfL2w19AA0Ii5NciBTnycZIFa4py9HOL
         MhXYaoJeRVA9g==
Date:   Thu, 23 Sep 2021 05:58:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     MichelleJin <shjy180909@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        johannes@sipsolutions.net, saeedm@nvidia.com, leon@kernel.org,
        roid@nvidia.com, paulb@nvidia.com, lariel@nvidia.com,
        ozsh@nvidia.com, cmi@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: check return value of rhashtable_init
Message-ID: <20210923055802.2dc3833a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210923125317.9430-1-shjy180909@gmail.com>
References: <20210923125317.9430-1-shjy180909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 12:53:17 +0000 MichelleJin wrote:
> When rhashtable_init() fails, it returns -EINVAL.
> However, since error return value of rhashtable_init is not checked,
> it can cause use of uninitialized pointers.
> So, fix unhandled errors of rhashtable_init and possible memory leaks.
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>

Please split this into 3 patches (ipv6, mlx, mac80211).
