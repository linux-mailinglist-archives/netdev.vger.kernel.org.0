Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFF21EC4E1
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgFBW1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730121AbgFBW1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:27:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F51C08C5C0;
        Tue,  2 Jun 2020 15:27:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE4811277CC6E;
        Tue,  2 Jun 2020 15:27:21 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:27:20 -0700 (PDT)
Message-Id: <20200602.152720.2064219583725974441.davem@davemloft.net>
To:     piotr.stankiewicz@intel.com
Cc:     thomas.lendacky@amd.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] amd-xgbe: use PCI_IRQ_MSI_TYPES where appropriate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602092105.32190-1-piotr.stankiewicz@intel.com>
References: <20200602092105.32190-1-piotr.stankiewicz@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:27:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Date: Tue,  2 Jun 2020 11:21:05 +0200

> Seeing as there is shorthand available to use when asking for any type
> of interrupt, or any type of message signalled interrupt, leverage it.
> 
> Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Applied.
