Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1A0401AF5
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241847AbhIFMJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241829AbhIFMJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 08:09:35 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80216C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 05:08:29 -0700 (PDT)
Received: from localhost (unknown [149.11.102.75])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7A56E4DA4C8F4;
        Mon,  6 Sep 2021 05:08:25 -0700 (PDT)
Date:   Mon, 06 Sep 2021 13:08:17 +0100 (BST)
Message-Id: <20210906.130817.2086973831700819915.davem@davemloft.net>
To:     osmith@sysmocom.de
Cc:     netdev@vger.kernel.org, laforge@gnumonks.org
Subject: Re: Missing include include acpi.h causes build failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <aa6271d7-7574-041d-ab35-ea98a8a6df79@sysmocom.de>
References: <aa6271d7-7574-041d-ab35-ea98a8a6df79@sysmocom.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 06 Sep 2021 05:08:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Smith <osmith@sysmocom.de>
Date: Mon, 6 Sep 2021 11:04:40 +0200

> Hello linux-netdev ML,
> 
> can somebody please cherry pick the following patch from
> torvalds/linux.git to net-next.git (or rebase on that patch? not sure
> about the usual workflow for net-next):
> 
> 	ea7b4244 ("x86/setup: Explicitly include acpi.h")
> 
> Since the 1st of September, this missing include causes the Osmocom CI
> job to fail, which runs osmo-ggsn against the GTP tunnel driver in
> net-next.git (to catch regressions in both kernel and Osmocom code).

I ff'd net-next ad this should be fixed now.

