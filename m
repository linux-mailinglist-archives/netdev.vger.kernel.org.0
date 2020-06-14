Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33941F876B
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgFNHOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbgFNHOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:14:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B93120714;
        Sun, 14 Jun 2020 07:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118873;
        bh=EmGc+rtmuJJq01SEvpEGL09joderOZsOwxiLfqVAvJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yslwl2HRsS++8VKJxvMGzMrIcTvD2EtWjx/LQ7lbn23rw2K1zMtabuh5CrEMkmEKh
         ojJBtX3VMa8LYXSahyUBurpbx4s2/WXrEQMJ4Pfo9MTQi6jDOt/IzqnDB3YpmWsM+r
         IuTn8Hmfdx6vvRYwUfw6lI9icZOFVpJ2wkVTfYkk=
Date:   Sun, 14 Jun 2020 09:14:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] NFC: Fix error handling in rawsock_connect()
Message-ID: <20200614071430.GC2629255@kroah.com>
References: <77ad4473-2c8a-f25a-51a8-be905d1414cd@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77ad4473-2c8a-f25a-51a8-be905d1414cd@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 07:56:36AM +0200, Markus Elfring wrote:
> > … The patch fixes this issue.
> 
> I suggest to replace this information by the tag “Fixes”.
> Please choose another imperative wording for your change description.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=df2fbf5bfa0e7fff8b4784507e4d68f200454318#n151
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
