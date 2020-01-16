Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A91813DA08
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 13:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgAPM37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 07:29:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgAPM36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 07:29:58 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E07CA15B52F1F;
        Thu, 16 Jan 2020 04:29:56 -0800 (PST)
Date:   Thu, 16 Jan 2020 04:29:55 -0800 (PST)
Message-Id: <20200116.042955.2186430020664708353.davem@davemloft.net>
To:     hayashi.kunihiko@socionext.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        masami.hiramatsu@linaro.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH net] net: ethernet: ave: Avoid lockdep warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579060962-12125-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1579060962-12125-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 04:29:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Wed, 15 Jan 2020 13:02:42 +0900

> When building with PROVE_LOCKING=y, lockdep shows the following
> dump message.
> 
>     INFO: trying to register non-static key.
>     the code is fine but needs lockdep annotation.
>     turning off the locking correctness validator.
>      ...
> 
> Calling device_set_wakeup_enable() directly occurs this issue,
> and it isn't necessary for initialization, so this patch creates
> internal function __ave_ethtool_set_wol() and replaces with this
> in ave_init() and ave_resume().
> 
> Fixes: 7200f2e3c9e2 ("net: ethernet: ave: Set initial wol state to disabled")
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

Applied and queued up for -stable, thank you.
