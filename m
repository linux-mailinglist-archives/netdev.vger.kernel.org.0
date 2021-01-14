Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E82F6E4C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbhANWee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbhANWee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:34:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B0523107;
        Thu, 14 Jan 2021 22:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610663634;
        bh=TDsxr8TTkWkSQFGv6iTVrjmtNAhZptF8/N/0Q6MMqIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SPGMrDGNehe/WDAJz5u+dW3WSsT3EiTaze4Hrxnd4TPS9j/SH8RmOWrbT9W6VWDud
         M5B9u6LicBJXnsTA90y3yb8ekDC8Mh0b5OEmeZ37VkRM97rWMW6Qwr30Q5EBbUkh+3
         UdtQkwC2Lc7/vTKcGeYSad3KXP29a1/5ZXIKq9CA/LAtBba6quKNqDH2Dw4HvoNzVg
         MFKuNn0BXZk2pkTXB82vZOTUeThXsc+/UE6e+AnFk5vOqZduEXGE9eEfT4ocyuAhZL
         PZqX1c7qJvXlGH3aeMzE/K3vRTO1TcnbZf4LVRvGNO3ZRnwvLOmOMiXKX4jr9BewpZ
         TlqDVhSBZtZlQ==
Date:   Thu, 14 Jan 2021 14:33:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Networking for 5.11-rc4
Message-ID: <20210114143352.7bfe4b94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=wjWP_7VU8Pi6A-88-1X7F_fs+2qoGf6qjkVOUnFQd3CDw@mail.gmail.com>
References: <20210114200551.208209-1-kuba@kernel.org>
        <CAHk-=wjWP_7VU8Pi6A-88-1X7F_fs+2qoGf6qjkVOUnFQd3CDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 13:37:17 -0800 Linus Torvalds wrote:
> On Thu, Jan 14, 2021 at 12:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Current release - regressions:
> >  ...
> > Current release - always broken:  
> 
> So I understand what you mean, but it does sound odd with that
> "Current release - always broken" thing not being a regression. The
> "always broken" makes it sound like it's some old broken code that has
> never worked, which it clearly isn't.
> 
> Maybe rephrase it as "new code bugs" or something? You've done that
> before ("bugs in new features").
> 
> I left it alone in the merge message, since we've had that pattern of
> speech before, but for some reason I reacted to it this time.

Will do, I succumbed to the lure of matching "Previous releases -
always broken".
