Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C4F427B72
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhJIPpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:45:23 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:44118 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234290AbhJIPpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 11:45:22 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id D7874182CED28;
        Sat,  9 Oct 2021 15:43:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 1A5EB255100;
        Sat,  9 Oct 2021 15:43:23 +0000 (UTC)
Message-ID: <5aa73c7730e8dc219b0e8bb7ec3e618f4a7ef764.camel@perches.com>
Subject: Re: [PATCH net-next 0/5] net: remove direct netdev->dev_addr writes
From:   Joe Perches <joe@perches.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Date:   Sat, 09 Oct 2021 08:43:22 -0700
In-Reply-To: <163377720849.21740.224949011888662927.git-patchwork-notify@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
         <163377720849.21740.224949011888662927.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 1A5EB255100
X-Spam-Status: No, score=-1.23
X-Stat-Signature: q9s9rptyqngzxoppop5inn1tiy5mm5f7
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19W0sOuybRbr+0Fpx7yGTOcG/6rbGvafhA=
X-HE-Tag: 1633794203-331008
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-10-09 at 11:00 +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Fri,  8 Oct 2021 10:59:08 -0700 you wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> > 
> > This series contains top 5 conversions in terms of LoC required
> > to bring the driver into compliance.
[]
>   - [net-next,3/5] ethernet: tulip: remove direct netdev->dev_addr writes
>     https://git.kernel.org/netdev/net-next/c/ca8793175564

This one appears defective.



