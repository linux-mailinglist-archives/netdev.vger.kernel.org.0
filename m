Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF0F42CF25
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 01:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhJMXYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 19:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMXYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 19:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B46760E05;
        Wed, 13 Oct 2021 23:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634167332;
        bh=3coNBPGYON6/61PBewDmxBthlFwCOyqICDIw5Ze6JZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uKqzCjUp2f7zhet88IYtCTKnHFtcYdP5WE6jXOnCpqJ/nLvvnzC1gr3I2B1Wjx/eS
         XUb8EWORfSjmGbS6dLvqMe0uaeCqPfV8Z3Vpr5JTnLPCt+88vqaRi5NqRyvAoUQT+b
         S7TEaWl5yH328SuJfek4gi+f8QV5kElF6e8qbgRJyqpIIXE/OFAWIHLNFhFxLOqROK
         bNyqNCEpnw7On/8ke2cDzfRPZuda+akwBRvKUA/keaGfx93rg+q4NgYVasP4YFFWSq
         /+xdASXoEWFpFouEtRejuDHts32XN05/37o2x06/rfwszOb6TZFhSUZ1or2IG7omBI
         DL8bp1gRwcEqA==
Date:   Wed, 13 Oct 2021 16:22:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     <davem@davemloft.net>, <yashsri421@gmail.com>,
        <weiyongjun1@huawei.com>, <krzysztof.kozlowski@canonical.com>,
        <shenyang39@huawei.com>, <dingsenjie@yulong.com>,
        <rdunlap@infradead.org>, <jringle@gridpoint.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: encx24j600: check error in
 devm_regmap_init_encx24j600
Message-ID: <20211013162211.6cacd0e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012125901.3623144-1-sunnanyong@huawei.com>
References: <20211012125901.3623144-1-sunnanyong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 20:59:01 +0800 Nanyong Sun wrote:
> devm_regmap_init may return error which caused by like out of memory,
> this will results in null pointer dereference later when reading
> or writing register:

Applied, but...


> -void devm_regmap_init_encx24j600(struct device *dev,
> +int devm_regmap_init_encx24j600(struct device *dev,
>  				 struct encx24j600_context *ctx)

> -void devm_regmap_init_encx24j600(struct device *dev,
> +int devm_regmap_init_encx24j600(struct device *dev,
>  				 struct encx24j600_context *ctx);

.. please make sure you adjust the continuation lines.
checkpatch points this out.
