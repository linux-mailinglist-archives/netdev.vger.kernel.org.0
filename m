Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095671F8983
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 17:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgFNPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 11:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgFNPaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 11:30:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51FCD206D7;
        Sun, 14 Jun 2020 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592148620;
        bh=BhI3AzDTgZ6FuNM+0FU5AEqv+pod8JXJS5xxEKM5s0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ZLC6P+8vdV2mT8RnZ1waZEHQi7p3rZjFmTjjczHyidzQxwQhDSDvXUZIwEs8cies
         1nBh89VCer1IwuIEsF33W10t0cmpL51kDkLacrMTN8rwmis4TTys6eA0JxKBzlDBYg
         IuOFLujmbr0PfLATpdPPyVO1N7Gf4BF6rZ7LrrMY=
Date:   Sun, 14 Jun 2020 17:30:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        netdev@vger.kernel.org, Navid Emamdoost <emamd001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <mccamant@cs.umn.edu>,
        Qiushi Wu <wu000273@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: fix ref count leaking when pm_runtime_get_sync
 fails
Message-ID: <20200614153018.GA2663587@kroah.com>
References: <38dcaa5d-98ad-e1df-6e83-2e6dd677a483@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38dcaa5d-98ad-e1df-6e83-2e6dd677a483@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 10:25:38AM +0200, Markus Elfring wrote:
> > in fec_enet_mdio_read, …
> 
> I am curious under which circumstances you would like to improve
> such commit messages.
> 
> * Will the tag “Fixes” become helpful?
> 
> * Which source code analysis tools did trigger to send
>   update suggestions according to 16 similar issues for today?
> 

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
