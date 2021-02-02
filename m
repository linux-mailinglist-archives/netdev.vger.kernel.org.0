Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B8E30B3E0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBBAIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhBBAIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 19:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A0960238;
        Tue,  2 Feb 2021 00:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612224491;
        bh=B6ktC2EpfC8DsDU+3U0w4wjPr5UjBgv2/i6cLe27up4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lAi6cpa5ztYvSMz3OoFqxAnj7fe/+K6x5wPTGB8nESOXijyz+RaltO+3b7K+YOdu+
         BWV+wCXW6VemalVU09iXawcSJb05F0rH3N5BUiVIdz7JCcSKbFHXHAR7dGPOi1w0Al
         3/eBIF+15eLRhIuVWhgFyIvhtPq/AhKP9kRfuCv57+nSV5Gi0TdaGOJ23Ga8uYh4gR
         fEaflGFQL2/hYREN4DeKKJKAmNMKBoW+wFzQCBsVmF0RbCVC7gij3Qv3pBw+s2ltiS
         yWCxplA1XdKOUJeYWVmNqRyhjXrDM94rOkGcIHBm4CS69cNvjVZGbsBVgYvLSZQp0H
         K1rVGy57lxtbw==
Date:   Mon, 1 Feb 2021 16:08:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Chris Mi <cmi@nvidia.com>, netdev@vger.kernel.org, jiri@nvidia.com,
        saeedm@nvidia.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210201160809.071bdfcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201180606.GA3456040@shredder.lan>
References: <20210130023319.32560-1-cmi@nvidia.com>
        <20210130145227.GB3329243@shredder.lan>
        <c62ee575-49e0-c5d6-f855-ead5775af141@nvidia.com>
        <20210201180606.GA3456040@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 20:06:06 +0200 Ido Schimmel wrote:
> On Mon, Feb 01, 2021 at 10:00:48AM +0800, Chris Mi wrote:
> > On 1/30/2021 10:52 PM, Ido Schimmel wrote:  
> > > This belongs in the changelog (that should be part of the commit
> > > message). Something like "Fix xxx reported by kernel test robot".  
> > But I see existing commits have it.  
> 
> It is used by commits whose sole purpose is to fix an issue that was
> reported by the kernel test robot. In this case the robot merely
> reported an issue with your v1. If you want to give credit, use the form
> I suggested above. It is misleading otherwise.

Personally I fully agree. But some people pushed back on this in 
the past saying buildbot should be credited for early detection, 
too - otherwise the funding may dry up. So I don't care either 
way now :)
