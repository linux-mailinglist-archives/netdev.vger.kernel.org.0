Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38E82F41A9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbhAMCS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbhAMCS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:18:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78514230FC;
        Wed, 13 Jan 2021 02:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610504265;
        bh=sFr8FvwKd4eZzn6isvgmzoDL3bFS6hCllpVhEWOPE6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D0atCIGqV3jSNztCMFT8dawqx2mCwZ6LEkVWJCkrTADWxFJ3sq5IqbmQJkYqIcdgc
         DiDZRrCtNpCJ/glFXUnXDkz9a4n3DcDTxl9e6KmaQF74vgQT8ER2OH59FysbqXgHcX
         2gwXnlkmtClnHfTupd4vS/cleytlx3HiBDM30NA2FCLeYTUnEYYVNP+kcdeIUTQLVy
         ZxYUyhv4U7jpLFJC1aR3usI0AABX645KH1Edg0oxaUOq9epY8k2hkMDe6+7/GKypbr
         99luJPJtwdvUFHsswEzo6Dinhaa6/CoNH8uksJMsg2dF8nH01tYbpRUfDvf7ncROI3
         JhdhfDVflXdIQ==
Date:   Tue, 12 Jan 2021 18:17:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyingjie55@126.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/ipv4: add IPv4_is_multicast() check in
 ip_mc_leave_group().
Message-ID: <20210112181744.028dc6bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1610441229-13195-1-git-send-email-wangyingjie55@126.com>
References: <1610441229-13195-1-git-send-email-wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 00:47:09 -0800 wangyingjie55@126.com wrote:
> From: Yingjie Wang <wangyingjie55@126.com>
> 
> There is no IPv4_is_multicast() check added to ip_mc_leave_group()
> to determine whether imr->imr_multiaddr.s_addr is a multicast address.
> If not a multicast address, it may result in an error.
> In some cases, the callers of ip_mc_leave_group don't check
> whether it is multicast address or not such as do_ip_setsockopt().
> So I suggest added the ipv4_is_multicast() check to the
> ip_mc_leave_group function to prevent this from happening.
> 
> Fixes: d519aa299494 ("net/ipv4: add IPv4_is_multicast() check in ip_mc_leave_group().")
> Signed-off-by: Yingjie Wang <wangyingjie55@126.com>

Same story with the fixes tag as on your other submission.

The fixes tag is supposed to refer to the commit which introduced 
the bug. It helps the backporters determine whether they need to
backport given fix to their trees. In case the commit which added 
the bug predates git history you can refer to the first commit in
the history.

HTH
