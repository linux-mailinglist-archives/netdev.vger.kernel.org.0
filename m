Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCAB207EE0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405132AbgFXVuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404965AbgFXVuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:50:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65D4C061573;
        Wed, 24 Jun 2020 14:50:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D45712737DDD;
        Wed, 24 Jun 2020 14:50:19 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:50:18 -0700 (PDT)
Message-Id: <20200624.145018.367399335825700289.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        tharvey@gateworks.com, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] lan743x: Remove duplicated include from
 lan743x_main.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624071821.175075-1-yuehaibing@huawei.com>
References: <20200624071821.175075-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:50:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 24 Jun 2020 07:18:21 +0000

> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
