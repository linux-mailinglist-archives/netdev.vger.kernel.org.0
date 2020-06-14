Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E52A1F876F
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFNHO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgFNHO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F352220714;
        Sun, 14 Jun 2020 07:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118898;
        bh=3JlDssrSZoB0F+GktGKDrpB2an7++l0WZtEXqaB0Yt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BW2qTMSu/HZtEoXpoAozDahjkSD/nRtSc3Q5Q4miFARJiOT2zHl2LXPrDo0wjqU0E
         QowjzYJ35nkiBRMYOtxADknB0v0A9OKGbsr048kZlqGdWVzr8Smi65FDk+38BfVqrB
         lBaILnYglEo3gS1n6R4pTbGSopJum2eAHI+4vMBA=
Date:   Sun, 14 Jun 2020 09:14:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Qiushi Wu <wu000273@umn.edu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ethernet: Fix memory leak in ethoc_probe()
Message-ID: <20200614071456.GE2629255@kroah.com>
References: <2a13092a-53ed-bfab-0a99-08196ad22f59@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a13092a-53ed-bfab-0a99-08196ad22f59@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 08:26:12AM +0200, Markus Elfring wrote:
> > … The patch fixes this issue.
> 
> I propose to replace this information by the tag “Fixes”.
> Please choose another imperative wording for your change description.
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
