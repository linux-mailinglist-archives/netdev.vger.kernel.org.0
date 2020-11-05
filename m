Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D012A73D1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733094AbgKEAbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgKEAbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:31:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F56A206A4;
        Thu,  5 Nov 2020 00:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604536299;
        bh=vMJDNHl9MYa8hTLqpJrkwmsbIpSv8VMeRiHsCDggUlQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r7+aNWX5k2Qa2YQVn2Q2zTdqLuvhB4hQLVuAYiD4+XkQQos/A3VejEpPIqwl2AOTt
         6Fn+iLKLBGto/By8zDnOe2E+dVI6jz88dDLJfbpnFtzbF/olaF3T+PYZoJyvlF8SYt
         X9IjSRZILDUBmWghhP79esBb9AtkJQNsGjqHqrpY=
Date:   Wed, 4 Nov 2020 16:31:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: ipa: tell GSI the IPA version
Message-ID: <20201104163138.6c5d534d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 11:53:54 -0600 Alex Elder wrote:
> The GSI code that supports IPA avoids having knowledge about the
> IPA layer it serves.  One result of this is that Boolean flags are
> used during GSI initialization to convey that certain hardware
> version-dependent special behaviors should be used.
> 
> A given version of IPA hardware uses a fixed/well-defined version
> of GSI, so the IPA version really implies the GSI version.
> 
> If given only the IPA version, the GSI code supporting IPA can
> use it to implement certain special behaviors required for IPA
> *or* GSI.  This avoids the need to pass and maintain numerous
> Boolean flags.

Applied, thanks.

> Note:  the last patch in this series depends on this patch posted
> for review earlier today:
>   https://lore.kernel.org/netdev/20201102173435.5987-1-elder@linaro.org

But in the future please don't post dependent changes like this. The
build bots cannot figure this out and give up on checking your series.
