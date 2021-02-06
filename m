Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039BA311F6E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhBFSul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:50:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhBFSuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 13:50:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AF8264E64;
        Sat,  6 Feb 2021 18:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612637399;
        bh=4LOMhWar+ntiOQeVNui71b97Dzd4LXDUNUm07e5WzPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kCD8FkEMkxEEQKJzmrZVzxhbCqjg/70AXwl6hMYB7EiudT9j123ZnsbZ/U43NmISo
         k3LkxdFhLhgcRL4Me8VBBcmrakE+EeOsNYrMTf24xq/dQsRRzMiBYOZkXYOaocvLBM
         a4QedP7Ti9aoNtw8k0JitXwak7nr/8Yee+sevhDh1queVLzZkuThIMnRrYyHzYCvIe
         VhnuemUZ65CtHxhgJvpNDnfsyyjBM8LhmM1prQJCseS8vlsUhH/UuicE2vRXMzfBHt
         ujNSTCiwOcTx7vZ5aPfi1eLwFevR8VvqlSUY2ekM3q+7GNGNOuIXKnnVl+qP0WHnEQ
         oLrKvJEsnxe0Q==
Date:   Sat, 6 Feb 2021 10:49:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, grygorii.strashko@ti.com
Subject: Re: [PATCH net-next] net: ethernet: ti: fix netdevice stats for XDP
Message-ID: <20210206104958.51a7cf3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a457cb17dd9c58c116d64ee34c354b2e89c0ff8f.1612375372.git.lorenzo@kernel.org>
References: <a457cb17dd9c58c116d64ee34c354b2e89c0ff8f.1612375372.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 19:06:17 +0100 Lorenzo Bianconi wrote:
> Align netdevice statistics when the device is running in XDP mode
> to other upstream drivers. In particular reports to user-space rx

report

> packets even if they are not forwarded to the networking stack
> (XDP_PASS) but if they are redirected (XDP_REDIRECT), dropped (XDP_DROP)
> or sent back using the same interface (XDP_TX). This patch allows the
> system administrator to very the device is receiving data correctly.

verify

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks.
