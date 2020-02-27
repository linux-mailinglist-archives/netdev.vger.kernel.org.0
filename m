Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7179172938
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgB0UF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:05:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbgB0UF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 15:05:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E903121793F8;
        Thu, 27 Feb 2020 12:05:28 -0800 (PST)
Date:   Thu, 27 Feb 2020 12:05:27 -0800 (PST)
Message-Id: <20200227.120527.959405071878620785.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH net] sfc: fix timestamp reconstruction at 16-bit
 rollover points
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ec166593-f68f-7834-e260-cd8ec6533054@solarflare.com>
References: <ec166593-f68f-7834-e260-cd8ec6533054@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 12:05:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Wed, 26 Feb 2020 17:33:19 +0000

> We can't just use the top bits of the last sync event as they could be
> off-by-one every 65,536 seconds, giving an error in reconstruction of
> 65,536 seconds.
> 
> This patch uses the difference in the bottom 16 bits (mod 2^16) to
> calculate an offset that needs to be applied to the last sync event to
> get to the current time.
> 
> Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>

Applied and queued up for -stable, thank you.
