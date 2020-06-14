Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F101F876D
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgFNHOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725949AbgFNHOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:14:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B122F20714;
        Sun, 14 Jun 2020 07:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118885;
        bh=zbXjGnPMX45JTqiR/mVy9+/B30zxTdS7yJsyaBGVEpM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W3O5JXHe6DexW5W8Wge6ykuSUJFdZCx2nwpHNc6Wg/SnV8nFeIZss+ts3PyIrpjnK
         99MKA+lUhztVHk4QlgKLCbcsrPPoI3bzsU30JfpWe9pcCR4nPjFVDcg1c5eDAIt+W6
         S/NUlfPlgioxjUPpvamcw9wncg5IE9zPw9sICnuU=
Date:   Sun, 14 Jun 2020 09:14:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Kangjie Lu <kjlu@umn.edu>,
        Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] rocker: Fix error handling in dma_rings_init()
Message-ID: <20200614071442.GD2629255@kroah.com>
References: <c87858ed-a91f-22d3-09d7-17a00703d168@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c87858ed-a91f-22d3-09d7-17a00703d168@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 08:14:13AM +0200, Markus Elfring wrote:
> > … The patch fixes the
> > order consistent with cleanup in rocker_dma_rings_fini().
> 
> I suggest to choose another imperative wording for your change description.
> Will the tag “Fixes” become helpful for the commit message?
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
