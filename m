Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836EB1FD862
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgFQWIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFQWIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:08:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A60C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 15:08:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D5EA1297DAC2;
        Wed, 17 Jun 2020 15:08:21 -0700 (PDT)
Date:   Wed, 17 Jun 2020 15:08:20 -0700 (PDT)
Message-Id: <20200617.150820.728508945654936455.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: no link check while resetting queues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616011459.30966-1-snelson@pensando.io>
References: <20200616011459.30966-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 15:08:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 15 Jun 2020 18:14:59 -0700

> If the driver is busy resetting queues after a change in
> MTU or queue parameters, don't bother checking the link,
> wait until the next watchdog cycle.
> 
> Fixes: 987c0871e8ae ("ionic: check for linkup in watchdog")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied and queued up for v5.7 -stable, thanks.
