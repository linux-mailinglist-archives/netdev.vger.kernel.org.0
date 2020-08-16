Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD51245A01
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 01:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgHPXFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 19:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHPXFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 19:05:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30A2C061786;
        Sun, 16 Aug 2020 16:05:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CFC711E47940;
        Sun, 16 Aug 2020 15:48:20 -0700 (PDT)
Date:   Sun, 16 Aug 2020 16:05:05 -0700 (PDT)
Message-Id: <20200816.160505.374966632241402758.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2020-08-15
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815092116.424137-1-mkl@pengutronix.de>
References: <20200815092116.424137-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 15:48:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Sat, 15 Aug 2020 11:21:12 +0200

> this is a pull request of 4 patches for net/master.
> 
> All patches are by Zhang Changzhong and fix broadcast related problems in the
> j1939 CAN networking stack.

Pulled, thanks Marc.
