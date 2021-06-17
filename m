Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FE03ABDC6
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhFQVJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhFQVJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 17:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DFE361351;
        Thu, 17 Jun 2021 21:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623964065;
        bh=mP8wppDi6zT/aU3asgWfZ56w1oNDPHNn5cdeR4REH18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LLByJ4EtAiYf0EwPgDQSs5fLPtYdMz8LXCkCbkwsylb4DMfFVP/TKnB/xv+W5Oury
         wYMgycxehhVfApqwZ8yxWLzsDGyr3xxHbFhGjLAcxnTDLivRiFD3wlRfHLhlhsmgLE
         jY+PhtyRra1SaFdXBNCu94sJLoim2sB4VGCU9ek4Tvm3Y6rv/nMJbEyaeP7u59X9Nm
         0bp3CD/5mPa4pIk8wsCNYdrHuIlV5idl7GOZTe9pdx3S+ifHOYs3VRcGWvgtmAzwJ+
         qhPcyJiSVJZTxu3az4W4/PKY4sK/V7ZGrjyr08vWPCvTE8J6E0H1fcshaGNzev3USd
         ianeaPTRh05oA==
Date:   Thu, 17 Jun 2021 14:07:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Amit Cohen <amcohen@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] ethtool: strset: Fix reply_size value
Message-ID: <20210617140744.0f0adb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YMt5Vx9/Yz+3hXB+@shredder>
References: <20210617154252.688724-1-amcohen@nvidia.com>
        <20210617162923.i7cvvxszntf7mvvl@lion.mk-sys.cz>
        <YMt5Vx9/Yz+3hXB+@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 19:33:27 +0300 Ido Schimmel wrote:
> On Thu, Jun 17, 2021 at 06:29:23PM +0200, Michal Kubecek wrote:
> > I believe this issue has been already fixed in net tree by commit
> > e175aef90269 ("ethtool: strset: fix message length calculation") but as
> > this commit has not been merged into net-next yet, you could hit it with
> > the stricter check.  
> 
> Yea. I reached the same conclusion :/

Ah damn, I should have waited for the merge, sorry about that :S
