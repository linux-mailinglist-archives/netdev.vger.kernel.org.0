Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1331EC4E3
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgFBW13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730148AbgFBW11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:27:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7CFC08C5C0;
        Tue,  2 Jun 2020 15:27:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DD4D1277CC73;
        Tue,  2 Jun 2020 15:27:26 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:27:25 -0700 (PDT)
Message-Id: <20200602.152725.1354529297857870970.davem@davemloft.net>
To:     piotr.stankiewicz@intel.com
Cc:     irusskikh@marvell.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] aquantia: atlantic: use PCI_IRQ_ALL_TYPES where
 appropriate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602092111.32235-1-piotr.stankiewicz@intel.com>
References: <20200602092111.32235-1-piotr.stankiewicz@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:27:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Date: Tue,  2 Jun 2020 11:21:11 +0200

> Seeing as there is shorthand available to use when asking for any type
> of interrupt, or any type of message signalled interrupt, leverage it.
> 
> Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Applied.
