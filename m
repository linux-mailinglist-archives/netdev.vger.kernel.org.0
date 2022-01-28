Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38DC4A0331
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 22:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351658AbiA1Vtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 16:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiA1Vtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 16:49:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BBCC061714;
        Fri, 28 Jan 2022 13:49:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8409B82710;
        Fri, 28 Jan 2022 21:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A584C340E7;
        Fri, 28 Jan 2022 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643406592;
        bh=ECkQp0g/1yBmh9EK3DfBbjibFlqLD4cPkIdxyz4wbQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tbkJ1po8046IuZZqUCN30IKI12+WsXen7r+khHUvln52HjcLxmnfb4QIKixfbLbWE
         0GNg9aKqKmKGGtZ9bO4hq9tNNDQX3RPE9iFQSwM8I2OQ7vd/vnMmiF78i/TrL9X2tv
         fIq6kC0noMY/24JlGSjZVK8K2Yc1CfG6xGib6qT/1OKwjgoAg7IIkSfsqY48W8qZEn
         65rJHHfHN4uP09csjeiUTt9JMoLOQYDeRMfsuFAfqvEjdbVpZTmfBxQW0lVK6atZVK
         /KIxoy7iXKsqCyAP4V5oyVhEvOa62S6fiUOzSogkDYdEMugwcFuFVLth2eIOB78WRc
         3W98Tsh7MKyDQ==
Date:   Fri, 28 Jan 2022 13:49:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2022-01-28
Message-ID: <20220128134951.3452f557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128205915.3995760-1-luiz.dentz@gmail.com>
References: <20220128205915.3995760-1-luiz.dentz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 12:59:15 -0800 Luiz Augusto von Dentz wrote:
> The following changes since commit 8aaaf2f3af2ae212428f4db1af34214225f5cec3:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-01-28
> 
> for you to fetch changes up to 91cb4c19118a19470a9d7d6dbdf64763bbbadcde:
> 
>   Bluetooth: Increment management interface revision (2022-01-27 12:35:13 -0800)
> 
> ----------------------------------------------------------------
> bluetooth-next pull request for net-next:
> 
>  - Add support for RTL8822C hci_ver 0x08
>  - Add support for RTL8852AE part 0bda:2852
>  - Fix WBS setting for Intel legacy ROM products
>  - Enable SCO over I2S ib mt7921s
>  - Increment management interface revision

Thanks for fixing the warnings! :)

I presume this is for the net-next given the name of your tree, but 
a lot of patches here have fixes tags. What's your methodology on
separating fixes from new features?

I think it may be worth adjusting the filter there and send more 
stuff earlier to Linus's tree. Especially fixes with the right mix 
of confidence and impact or pure device ID additions.

To be clear - happy to pull this PR as is, I was meaning to ask about
this for a while.
