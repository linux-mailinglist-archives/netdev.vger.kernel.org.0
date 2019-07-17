Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66456C30C
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfGQWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:17:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfGQWRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 18:17:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 093EA14EB93EF;
        Wed, 17 Jul 2019 15:17:30 -0700 (PDT)
Date:   Wed, 17 Jul 2019 15:17:29 -0700 (PDT)
Message-Id: <20190717.151729.482507625320598662.davem@davemloft.net>
To:     rosenp@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv2] net: ag71xx: Add missing header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190717194645.24239-1-rosenp@gmail.com>
References: <20190717194645.24239-1-rosenp@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 15:17:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>
Date: Wed, 17 Jul 2019 12:46:45 -0700

> ag71xx uses devm_ioremap_nocache. This fixes usage of an implicit function
> 
> Fixes: d51b6ce441d356369387d20bc1de5f2edb0ab71e
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

Applied.
