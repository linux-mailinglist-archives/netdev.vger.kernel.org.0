Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F35248F1C
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHRTzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRTzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:55:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E2AC061389;
        Tue, 18 Aug 2020 12:55:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 017CD127A25DA;
        Tue, 18 Aug 2020 12:38:13 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:54:59 -0700 (PDT)
Message-Id: <20200818.125459.575328486010129838.davem@davemloft.net>
To:     alex.dewar90@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: cirrus: Remove unused macros
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818140605.442958-1-alex.dewar90@gmail.com>
References: <20200818140605.442958-1-alex.dewar90@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 12:38:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>
Date: Tue, 18 Aug 2020 15:06:01 +0100

> Remove a couple of unused #defines in cs89x0.h.
> 
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>

Applied to net-next.
