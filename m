Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B395F15556F
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGKQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:16:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgBGKQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:16:52 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69A6F15A313A0;
        Fri,  7 Feb 2020 02:16:51 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:16:48 +0100 (CET)
Message-Id: <20200207.111648.1915539223489764931.davem@davemloft.net>
To:     hayashi.kunihiko@socionext.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        masami.hiramatsu@linaro.org, jaswinder.singh@linaro.org
Subject: Re: [PATCH net] net: ethernet: ave: Add capability of rgmii-id mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580954376-27283-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1580954376-27283-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:16:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Date: Thu,  6 Feb 2020 10:59:36 +0900

> This allows you to specify the type of rgmii-id that will enable phy
> internal delay in ethernet phy-mode.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

I do not understand this change at all.

At a minimum you must explain things more clearly and completely in your
commit message.

Are you just adding all of the RGMII cases to the code that only currently
mentions PHY_INTERFACE_MODE_RGMII?  If so, why did you only do this for
some but not all of the get_pinmode() methods in this driver?

Thank you.
