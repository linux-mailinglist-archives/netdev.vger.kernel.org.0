Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854BB40DB5B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbhIPNgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:36:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52022 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240208AbhIPNgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:36:40 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A4DAB4F7E6BDA;
        Thu, 16 Sep 2021 06:35:17 -0700 (PDT)
Date:   Thu, 16 Sep 2021 14:35:12 +0100 (BST)
Message-Id: <20210916.143512.2183620325345107048.davem@davemloft.net>
To:     asmaa@nvidia.com
Cc:     andy.shevchenko@gmail.com, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        rjw@rjwysocki.net, davthompson@nvidia.com
Subject: Re: [PATCH v1 2/2] net: mellanox: mlxbf_gige: Replace non-standard
 interrupt handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210915222847.10239-3-asmaa@nvidia.com>
References: <20210915222847.10239-1-asmaa@nvidia.com>
        <20210915222847.10239-3-asmaa@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 16 Sep 2021 06:35:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>
Date: Wed, 15 Sep 2021 18:28:47 -0400

> Since the GPIO driver (gpio-mlxbf2.c) supports interrupt handling,
> replace the custom routine with simple IRQ request.
> 
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>

Acked-by: David S. Miller <davem@davemloft.net>
