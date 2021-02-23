Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA31B3231F2
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhBWURj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhBWUQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E73DF64E5C;
        Tue, 23 Feb 2021 20:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614111376;
        bh=Gi0T8RFRTzayLKerSooTo9WkX+L7aCMqft1EEJnDgFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gOiAoTAedATmc4Mo66Sa0i6xsWdQqanhVPxXvYO7DB3yCTcHfMiOYuF7OPH3j8tSJ
         V6qmwbV8VF2sgeo7vPnAU3NsDjo40HrJhA1yxSKYkoIySJ5kCyCQTnufPa2Wqn7DYq
         nCndE0iXgUzd+HwqaZ9O4gAoAJVPRmAf3VFPb3fFol4MvklM1T3kkCBT2vepIyTBdY
         ByKH8h2j7Aa7Fz/qxrrgVQk3vyZj5oijAxts6eWRqct6lfEHNs1RrwcqWGBdflYsTI
         5REgOM4XCWQRoviY7gpNhEwBp3WsxZVOrJORoal0dt5++YY+Fjs3eWBecv75VmQcko
         oxaLO13j24O2g==
Date:   Tue, 23 Feb 2021 12:16:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Sieng Piaw Liew <liew.s.piaw@gmail.com>, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] bcm63xx_enet: fix sporadic kernel panic
Message-ID: <20210223121612.0fda2333@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f382effd-a4f5-b860-c521-5728f1f6200d@gmail.com>
References: <20210222013530.1356-1-liew.s.piaw@gmail.com>
        <f382effd-a4f5-b860-c521-5728f1f6200d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Feb 2021 21:05:50 -0800 Florian Fainelli wrote:
> On 2/21/2021 17:35, Sieng Piaw Liew wrote:
> > In ndo_stop functions, netdev_completed_queue() is called during forced
> > tx reclaim, after netdev_reset_queue(). This may trigger kernel panic if
> > there is any tx skb left.
> > 
> > This patch moves netdev_reset_queue() to after tx reclaim, so BQL can
> > complete successfully then reset.
> > 
> > Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>  
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> Fixes: 4c59b0f5543d ("bcm63xx_enet: add BQL support")

Applied, thanks!
