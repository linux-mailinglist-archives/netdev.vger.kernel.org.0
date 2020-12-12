Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE292D8A7E
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408141AbgLLXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLXE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:04:58 -0500
Date:   Sat, 12 Dec 2020 15:04:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607814258;
        bh=SHo6xO91hFnAQ5Tuj2E+SDGAAtWlEeahr8cuGg0jWzM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=WTc98VGn233s2YQPIazu+A08l1LdZkIcSwZhKaG2/IBxWJV33lqT5NTVVd96ew3Ms
         zdYgFDk8hY2A9KjHUBu1YUq/UMsmSUidskLDKzqClAUYXz0iVJlVGX0QGHJZCzTbGN
         Dih7tb4IXXE4N7wSVvO67REOogfqtTXuJexMEcyaUJTgKBXEjxXL3GuBI642BTaHZs
         jmdk6eV3K1O9aeYlZIiei3lWHtfuEcykAcmMtRORc6rjtOj7xjSuOBeHWvQgvrp910
         1RVzI5i2WoPYnn5lHPremU7g6JSng8bldQiZW/Yw1cVUczpuBM5s5BgWVboDp/V6zh
         WLLWmTAwT0aKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] nfc: s3fwrn5: let core configure the interrupt trigger
Message-ID: <20201212150417.468d2e8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201210211824.214949-1-krzk@kernel.org>
References: <20201210211824.214949-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 22:18:24 +0100 Krzysztof Kozlowski wrote:
> If interrupt trigger is not set when requesting the interrupt, the core
> will take care of reading trigger type from Devicetree.  There is no
> point to do it in the driver.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Applied, thank you!
