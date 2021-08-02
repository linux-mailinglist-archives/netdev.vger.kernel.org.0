Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772273DDD09
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhHBQFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhHBQFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:05:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ECAC60EC0;
        Mon,  2 Aug 2021 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627920330;
        bh=yQ8HgbDmYcSD7+LPYDAOMtU2rPpURC+Yr9y0boV+cYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JMBgSynityPKWAvpsSIeJytcSEqqwdePxnQKxpWuYRc/W9Kcdw/B/eiARo6iQ50E8
         8uyrEFB7T6TuOsq874UdUMT/9aqlqC99erWy9xmcQY8bKzw6CWM6MmHpLSFdx0SpAl
         RZM/2JhJp/o1ki57fPCFl7AbUwtcUaBhHWgkcefXncdxtIAUpOf9aqqKVc2LT9Efrx
         S1j+ZGti+k5LQ28nkr1oCB3QR49NHNmFth+FjakV6di6wGwTe3JTAotMzZvjGMZRpF
         I923oHqoJxV7DyqTA+3Ok43QTuTh3iyinrAfZD6nQNyrmtlmhViqHzf3siV4VIOA8P
         ElXtwGyhV8E8g==
Date:   Mon, 2 Aug 2021 09:05:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH net-next 0/6] IXP46x PTP Timer clean-up and DT
Message-ID: <20210802090529.52bdbf4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Aug 2021 02:27:31 +0200 Linus Walleij wrote:
> This is a combination of a few cleanups from Arnd and some cleanup
> and device tree support work from me, together modernizing the
> PTP timer for the IXP46x platforms.

This set does not apply to net-next, please respin.
