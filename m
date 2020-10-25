Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0C42980F9
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 10:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414782AbgJYJW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 05:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1414778AbgJYJW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 05:22:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F3622259;
        Sun, 25 Oct 2020 09:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603617778;
        bh=zyob1uJJFMg/3l5Ccy8tiIhLwAdla2K9dlocrrPKKiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mDePK54IjYOE333bt19fKiguWbcXk7ad6uQrdwVP8DFnR1P87lUWSZzYTuP+1lHAi
         srQVcIJiUxkBBSYl7Uf6MlvPFfxtsQG3BtIQNNNxMXE8L+PXl9jhNDA9zPtvS/Rv3S
         JBNo/Ep57BqFX9PJJ+a74pqG2cQFfwEdSdO+AXog=
Date:   Sun, 25 Oct 2020 10:22:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] staging: octeon: Drop on uncorrectable alignment
 or FCS error
Message-ID: <20201025092255.GA113243@kroah.com>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
 <20201016101858.11374-2-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016101858.11374-2-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:18:58PM +0200, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Currently in case of alignment or FCS error if the packet cannot be
> corrected it's still not dropped. Report the error properly and drop the
> packet while making the code around a little bit more readable.
> 
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
> 
> Change-Id: Ie1fadcc57cb5e221cf3e83c169b53a5533b8edff

Please stop using gerrit for patches destined for upstream development
:(
