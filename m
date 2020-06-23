Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C310020488E
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 06:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbgFWEN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 00:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgFWEN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 00:13:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB919C061573;
        Mon, 22 Jun 2020 21:13:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86DDD1210C093;
        Mon, 22 Jun 2020 21:13:26 -0700 (PDT)
Date:   Mon, 22 Jun 2020 21:13:25 -0700 (PDT)
Message-Id: <20200622.211325.220885937123149899.davem@davemloft.net>
To:     aiden.leong@aibsd.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH v2] GUE: Fix a typo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623030459.13508-1-aiden.leong@aibsd.com>
References: <20200623030459.13508-1-aiden.leong@aibsd.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 21:13:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aiden Leong <aiden.leong@aibsd.com>
Date: Mon, 22 Jun 2020 20:04:58 -0700

> Fix a typo in gue.h
> 
> Signed-off-by: Aiden Leong <aiden.leong@aibsd.com>

Applied, thank you.
