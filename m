Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6D2D1C1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfE1W7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfE1W7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 18:59:20 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B74D621019;
        Tue, 28 May 2019 22:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559084359;
        bh=w02FbIeZKF2WVr9wtwvuMsuHWRbJxSGeB0X1TjOPLxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QIDZUcOSiWM8vWJXRLnIQgxtmdftcFkkB7Jz4acBfyOUcF4rcQJ+vz66x7frDqh19
         43wComa1MSLZ1jXkoZOHL9etNBR6t+5J1VJyG5Bh32A1aPirCmkrBniNsfSQ6WWhLQ
         CD+SKNEwbiBIPsjQbDpiQMO8/a06CU9b9+6jCC6g=
Date:   Tue, 28 May 2019 15:59:02 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stable <stable@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
Message-ID: <20190528225902.GA5989@kroah.com>
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
 <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
 <20190506131605.kapyns6gkyphbea2@salvia>
 <6dea0101-9267-ae20-d317-649f1f550089@6wind.com>
 <20190524092249.7gatc643noc27qzp@salvia>
 <6ad87483-711a-f205-8986-2217dab828d0@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ad87483-711a-f205-8986-2217dab828d0@6wind.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 03:57:37PM +0200, Nicolas Dichtel wrote:
> Le 24/05/2019 à 11:22, Pablo Neira Ayuso a écrit :
> > On Mon, May 20, 2019 at 10:35:07AM +0200, Nicolas Dichtel wrote:
> >> Le 06/05/2019 à 15:16, Pablo Neira Ayuso a écrit :
> >>> On Mon, May 06, 2019 at 10:49:52AM +0200, Nicolas Dichtel wrote:
> >> [snip]
> >>>> Is it possible to queue this for stable?
> >>>
> >>> Sure, as soon as this hits Linus' tree.
> >>>
> >> FYI, it's now in Linus tree:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8e608982022
> > 
> > Please, send an email requesting this to stable@vger.kernel.org and
> > keep me on CC.
> This is a request to backport the upstream commit f8e608982022 ("netfilter:
> ctnetlink: Resolve conntrack L3-protocol flush regression") in stable trees.

Now queued up, thanks.

greg k-h
