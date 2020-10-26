Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ABF299CAF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437274AbgJ0AAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436479AbgJZX4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:33 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1B1D21655;
        Mon, 26 Oct 2020 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756592;
        bh=Iw0X268hAE10aeLSNpUJ115dksciv1Y8+UeHUMuS4LI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F8yPyw4K35UD0WRUH+EHg4FT6xJPIByqgqaqqbJbXtQKelf87Y5ynL5gtbgB3H3lM
         K/N2cJfLkSmDpy/9cKBkihNmW+vVv/zV5XHzdeNAdAQpWAbfRdKjstNcMEVvaIywDE
         jDauVLxDR7TVaQMeqbZLtLIlRjQJJkOU/AhEUId8=
Date:   Mon, 26 Oct 2020 16:56:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 0/3] mlxsw: Various fixes
Message-ID: <20201026165620.6de65e9f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201024133733.2107509-1-idosch@idosch.org>
References: <20201024133733.2107509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Oct 2020 16:37:30 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set contains various fixes for mlxsw.
> 
> Patch #1 ensures that only link modes that are supported by both the
> device and the driver are advertised. When a link mode that is not
> supported by the driver is negotiated by the device, it will be
> presented as an unknown speed by ethtool, causing the bond driver to
> wrongly assume that the link is down.
> 
> Patch #2 fixes a trivial memory leak upon module removal.
> 
> Patch #3 fixes a use-after-free that syzkaller was able to trigger once
> on a slow emulator after a few months of fuzzing.

Applied, queued #1 and #2, thanks!
