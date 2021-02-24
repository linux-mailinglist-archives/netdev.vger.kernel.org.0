Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DB53234E8
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhBXBHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhBXBCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:02:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E63B564DBD;
        Wed, 24 Feb 2021 01:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614128530;
        bh=Rgw1HgxfL4K+dderH06Tp30ZAuQ1B51iQSGf9uhsX44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D3T7qOSkAuKwjp6Y5CzE9UxxmXSv6FUdXqhUrveIC0viX2N1ZivR2dAG9AGQwpZGM
         PDiEBTiNLCkpf0obN+XE5Nx4P4q3bnyHAI2FbEDckL56aKDIyGbfzeVAXm0+1SNZxF
         +dJ+3RQm7z6BCzwedcL/767WL/Q+MijWO3q+UtBFv+nfteReC0WeFoZKsMxFeuy+Ow
         Isd/fzNXb9Qx4hC69Nr6gDNjPIoI23gQLw4QD2+GYtgduK2gUL8DLK2Fz3ZfZLAs9H
         L+BbZTvRSZA38DWCUwyDbnVidkK2TfA9k1j2g78SPdj2NMFS/1Ck4HAfHYvvvDIWfK
         ygCmnjGKK9+wQ==
Date:   Tue, 23 Feb 2021 17:02:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one
 channel for RX/TX
Message-ID: <20210223170206.77a7e306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224003251.6lwgj2k73jt3edk5@lion.mk-sys.cz>
References: <20210223132440.810-1-simon.horman@netronome.com>
        <20210224003251.6lwgj2k73jt3edk5@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 01:32:51 +0100 Michal Kubecek wrote:
> On Tue, Feb 23, 2021 at 02:24:40PM +0100, Simon Horman wrote:
> > From: Yinjun Zhang <yinjun.zhang@corigine.com>
> > 
> > The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> > count and skip the error path, since the attrs
> > tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> > are NULL in this case when recent ethtool is used.
> > 
> > Tested using ethtool v5.10.
> > 
> > Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for TX/RX in the core")
> > Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>  
> 
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

IOW you prefer this to what I proposed?
