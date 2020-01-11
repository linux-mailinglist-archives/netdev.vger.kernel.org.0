Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F032137C19
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 08:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgAKHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 02:30:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgAKHaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 02:30:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64269159A883F;
        Fri, 10 Jan 2020 23:30:20 -0800 (PST)
Date:   Fri, 10 Jan 2020 23:30:19 -0800 (PST)
Message-Id: <20200110.233019.380242373018361619.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, arnd@arndb.de, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 0/9 v4] IXP4xx networking cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 23:30:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 10 Jan 2020 09:28:28 +0100

> This is a patch series which jams together Arnds and mine
> cleanups for the IXP4xx networking.
 ...

Hey, could you please respin this against current net-next for
me?  Some conflicts came up which I think came from the recent
net --> net-next merge.

Thank you.
