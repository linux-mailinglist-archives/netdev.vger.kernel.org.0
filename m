Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7930FE98
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhBDUiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:38:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240106AbhBDU2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:28:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6779064DAF;
        Thu,  4 Feb 2021 20:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612470450;
        bh=qMu01akOZYpXmGHYUuu1m138FJMW47Beim3uHBhAVhE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KL/28hn+rxPMsO9DRoH3BcTDKtxHZbI/TiRoZ4t+uUQ6UAoT0Ou+Fob+2yCe0443Z
         vUW4I5B+50F1gTmfdAS2M+S2YFMjLHgOZm23GJQ+9Pa6HhryB1KRUQJJUKu0SuOcLA
         xvbNjMsDSIawle01MgSJ1zZYRXS1NtZvtcIZwlqiY/aMB8Fx9bxX8er1tG8Q4SzHfL
         49O8DU2JJoQHim79GQIJvvEH/OPs4wMPWiZO1Wy0T9otOFQ5HFyPSZFq5BnTJmbyV5
         mo65aTILAPmwiaYLZ1c6p47Vgw24cgsZx/Dccin0A4xm/BxiBU9wbcNQydw2QXqaAX
         oNuHKURfy2r/Q==
Date:   Thu, 4 Feb 2021 12:27:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Geetha sowjanya <gakula@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <davem@davemloft.net>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <jerinj@marvell.com>, <lcherian@marvell.com>
Subject: Re: [net-next v3 00/14] Add Marvell CN10K support
Message-ID: <20210204122729.5b1b592a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204120454.000054d6@intel.com>
References: <1612437872-51671-1-git-send-email-gakula@marvell.com>
        <20210204120454.000054d6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 12:04:54 -0800 Jesse Brandeburg wrote:
> Geetha sowjanya wrote:
> 
> > v2-v3
> > Reposting as a single thread.  
> 
> FYI, it didn't work, suggest you try adding the git-send-email option
> (via git-config)
> 
> sendemail.thread=true
> sendemail.chainreplyto=false
> 
> And you can test locally by using first using git send-email to export
> to mbox and checking for References and In-Reply-to headers. Then
> sending for real.

And looks like there are build issues so you'll get a chance to try
again :/

Please make sure you don't add any new warnings to the build, with W=1
C=1 flags. Each patch must build cleanly.

Shooting from the hip something along the lines of:

 make allmodconfig
 current=$(make W=1 C=1 | wc -l)

 git rebase --exec '[ $current -eq $(make W=1 C=1 | wc -l) ]'

Please do not repost until the tree can build cleanly at every commit
of the series.
