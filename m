Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2DC27F4E2
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbgI3WMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgI3WMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:12:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDC6C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:12:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0BF6313C75916;
        Wed, 30 Sep 2020 14:55:25 -0700 (PDT)
Date:   Wed, 30 Sep 2020 15:12:11 -0700 (PDT)
Message-Id: <20200930.151211.1697680843020543520.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] ionic watchdog training
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930174828.39657-1-snelson@pensando.io>
References: <20200930174828.39657-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:55:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 30 Sep 2020 10:48:26 -0700

> Our link watchdog displayed a couple of unfriendly behaviors in some recent
> stress testing.  These patches change the startup and stop timing in order
> to be sure that expected structures are ready to be used by the watchdog.

Series applied, thanks.
