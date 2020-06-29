Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEF220DFB4
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgF2UjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731732AbgF2TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5795C08C5FA
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:45:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D676129CF871;
        Sun, 28 Jun 2020 21:45:01 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:45:00 -0700 (PDT)
Message-Id: <20200628.214500.264303705636831522.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] 8390: Fix coding-style issues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627220747.GA27510@mx-linux-amd>
References: <20200627220747.GA27510@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 28 Jun 2020 21:45:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Sun, 28 Jun 2020 00:07:47 +0200

> Fix some coding-style issues, including one which
> made the function pointers in the struct ei_device
> hard to understand.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Applied.
