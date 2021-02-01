Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A6230ACFD
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhBAQtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhBAQsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 11:48:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B8E64DA5;
        Mon,  1 Feb 2021 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612198069;
        bh=SVKQyodZbdFBbSqD3MZfgh+P6IpacQgIu1UoE/nVkww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ftvAyXzW6YmC3158pQgLRMNSs7Vgg45mxODcnjMtUD5tO2S94dPqZxdRSCQt7pQXl
         hSYLOk9xWiLm4d29Hg33We5pRAUR8THv6Lp7ZUtQx3qurAN4lWR6I01j2cNen2zKbQ
         zY1nLwWTGomG9MKu+tYdFmMpllZOToKKQGIMd8rRJC7MpVosGLBCPcCAbCXJTQyp/X
         olsR6J+CQP6NRPmFeZEwS9q0pXJTsk6WeUybQwRQOrkAOV9a/YzIMo9aV07TdmGfoH
         WGBMSfpp9rdD0ocCpEieBnUMUzKZvvcFQTnjnFKwc6JQk6KVzEBQat+TwHTGPu2EkT
         bzNceKU57Dlog==
Date:   Mon, 1 Feb 2021 08:47:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Corallo <linux-wired-list@bluematt.me>
Cc:     Nick Lowe <nick.lowe@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Message-ID: <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
References: <20201221222502.1706-1-nick.lowe@gmail.com>
        <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 18:17:11 -0500 Matt Corallo wrote:
> Given this fixes a major (albeit ancient) performance regression, is
> it not a candidate for backport? It landed on Tony's dev-queue branch
> with a Fixes tag but no stable CC.

Tony's tree needs to get fed into net, then net into Linus's tree and
then we can do the backport :(
