Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25592316A9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgG2APD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2APD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:15:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4EFC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:15:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DFD4128D3067;
        Tue, 28 Jul 2020 16:58:17 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:15:02 -0700 (PDT)
Message-Id: <20200728.171502.244593483876309593.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com
Subject: Re: [PATCH net v2 0/3] Fix bugs in Octeontx2 netdev driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
References: <1595652234-29834-1-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 16:58:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep.lkml@gmail.com
Date: Sat, 25 Jul 2020 10:13:51 +0530

> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Hi,
> 
> There are problems in the existing Octeontx2
> netdev drivers like missing cancel_work for the
> reset task, missing lock in reset task and
> missing unergister_netdev in driver remove.
> This patch set fixes the above problems.

Series applied, thanks.
