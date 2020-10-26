Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43055299A53
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404500AbgJZXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404490AbgJZXUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:20:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CA72207F7;
        Mon, 26 Oct 2020 23:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603754439;
        bh=H5Y8aWovojUcbzXwK62+FH8doQtb8oaZrMHnXYL7t2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FcVO4iqr3L1MXAUkFWOE/l883r0jhHLt1zANZB/7g4JT6bBEUKaED/DtrDMxP5Wvn
         1K3nT1zf3UTmCu5f7VOctIwgOXKJPIc/6sr+5D/Sk98CnbxRGWaQIPaafpS20V3tgs
         EEI6CPR5PIhJVcS63dTY6rzkAdsJMEq+DPHhph24=
Date:   Mon, 26 Oct 2020 16:20:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net] cxgb4: set up filter action after rewrites
Message-ID: <20201026162038.5069670b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023115852.18262-1-rajur@chelsio.com>
References: <20201023115852.18262-1-rajur@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 17:28:52 +0530 Raju Rangoju wrote:
> The current code sets up the filter action field before
> rewrites are set up. When the action 'switch' is used
> with rewrites, this may result in initial few packets
> that get switched out don't have rewrites applied
> on them.
> 
> So, make sure filter action is set up along with rewrites
> or only after everything else is set up for rewrites.
> 
> Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>

Applied, thanks!
