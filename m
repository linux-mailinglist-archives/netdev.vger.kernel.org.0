Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330092B8464
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgKRTJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgKRTJT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:09:19 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D08221EB;
        Wed, 18 Nov 2020 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605726559;
        bh=j/ghzdEdIvdz6pQ8qWX9PNWPnfD47clX9DfWiJ6PsuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wOoW+AYa86UYV+rTwBMd6b6gWH3qT65qc0+mdlYZa5bepYjUe+/E7sMNr/cl6pavp
         BzfwL1JFLDgKkIha0jxOy241/W0761l/4TSxjwBlADc13Jg0Q2nRMrZl6BkdtxaEwN
         mfl3s6XzZHDI0Q40chmVsRo1i6jlZUIuuiPonLfQ=
Date:   Wed, 18 Nov 2020 11:09:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net 0/2] mlxsw: Couple of fixes
Message-ID: <20201118110918.46d2c115@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117173352.288491-1-idosch@idosch.org>
References: <20201117173352.288491-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 19:33:50 +0200 Ido Schimmel wrote:
> This patch set contains two fixes for mlxsw.
> 
> Patch #1 fixes firmware flashing when CONFIG_MLXSW_CORE=y and
> CONFIG_MLXFW=m.
> 
> Patch #2 prevents EMAD transactions from needlessly failing when the
> system is under heavy load by using exponential backoff.
> 
> Please consider patch #2 for stable.

Applied, and queued, thanks!
