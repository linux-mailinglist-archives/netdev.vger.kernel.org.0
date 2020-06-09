Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DE21F47FD
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbgFIUUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 16:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFIUUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 16:20:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9339C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 13:20:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 809171277B97B;
        Tue,  9 Jun 2020 13:20:09 -0700 (PDT)
Date:   Tue, 09 Jun 2020 13:20:08 -0700 (PDT)
Message-Id: <20200609.132008.749856202059462247.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] ionic: wait on queue start until after IFF_UP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9594f97d-bfc8-6322-ba6e-5a838d1dbde0@pensando.io>
References: <99c98b8c-f8c3-b1be-9878-1ad0caf85656@pensando.io>
        <20200609.130637.1015423291014478400.davem@davemloft.net>
        <9594f97d-bfc8-6322-ba6e-5a838d1dbde0@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 13:20:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue, 9 Jun 2020 13:11:28 -0700

> Yes, the link check is triggered by the periodic watchdog
> ionic_watchdog_cb(), every 5 seconds.

Thanks for explaining.

Applied and queued up for v5.7 -stable, thank you.
