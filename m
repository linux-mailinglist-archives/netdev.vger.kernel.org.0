Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB69108F17
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfKYNlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727682AbfKYNlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 08:41:23 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16EB3207FD;
        Mon, 25 Nov 2019 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574689283;
        bh=LJO+du1/gX51L4cb1toQCsBF0nGKVtkR7X0buq5Gwz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RXQuaQiiXLe+9ekbqFwTXguwKU9GIc72nJgt2a98Isf+5V9uxvO+pj9D/ndC8HcWP
         hFMVmshA3KU1IkE1oRgJek1kOKVuMKozYFvcdtR3FL8a/JZRT8xHviGpL896c39GD2
         1bcj1pu8jqM4nWeLeBfsmHHW8NJTC3+BOR8B7N50=
Date:   Mon, 25 Nov 2019 08:41:21 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Adrian Bunk <bunk@kernel.org>
Cc:     netdev@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Please backport "mwifiex: Fix NL80211_TX_POWER_LIMITED" to
 stable branches
Message-ID: <20191125134121.GD12367@sasha-vm>
References: <20191122172431.GA24156@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191122172431.GA24156@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 07:24:31PM +0200, Adrian Bunk wrote:
>Please backport commit 65a576e27309120e0621f54d5c81eb9128bd56be
>"mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable branches.
>
>It is a non-CVE kind of security issue when a wifi adapter
>exceeds the configured TX power limit.
>
>The commit applies and builds against all branches from 3.16 to 4.19,
>confirmed working with 4.14. It is already included in kernel 5.3.

Queued up for all branches, thanks!

-- 
Thanks,
Sasha
