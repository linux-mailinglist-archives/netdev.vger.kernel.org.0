Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D195D3EF6F5
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 02:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhHRAjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 20:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhHRAjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 20:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D8760FD7;
        Wed, 18 Aug 2021 00:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629247145;
        bh=cq0E8ds3oJ+PnJZRtljrRViJEwWhfbSxbL8BOB58uNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d1Z1Ff/yJcRM8bflpiCg8xrHJqDgXHV6U3jjv9sI5OTuhB22br+0tCWdyKafuNPUK
         PadmSqWa4r0flPAU3Cv5vzoKro4CBWHEQQ/Mm+uO+MtXL+/sr1D7iUue6siH0lgrQl
         +z99/RekE5x1/eKOIN4H/tw3BIr1njLLWysWLaSF8K2wtoOjRheSrLdE02m/gDAGHb
         FI1MnIOjpxcf2PwPJ63ILmssUiPdponITPgWhH1G8rEdt0fsCC6GHmNpV3FWV52zE0
         K083ixbByFCPgRduXe/N4KJh2daJIYDgj0U8VybOpSWXpE6QB24yAMgOGHU/SICAlH
         mdx2Nk3t6qEGA==
Date:   Tue, 17 Aug 2021 17:39:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, andriy.shevchenko@linux.intel.com,
        christophe.jaillet@wanadoo.fr, jesse.brandeburg@intel.com,
        kaixuxia@tencent.com, lee.jones@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: mii: make mii_ethtool_gset() return void
Message-ID: <20210817173904.306fb7c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
References: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Aug 2021 21:34:42 +0300 Pavel Skripkin wrote:
> mii_ethtool_gset() does not return any errors. We can make it return
> void to simplify error checking in drivers, that rely on return value
> of this function.
> 
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

This breaks the build and therefore would be a nuisance in bisection.
Please squash the changes or invert the order.
