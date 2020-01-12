Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD2B1388CC
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 00:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgALXoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 18:44:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbgALXoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 18:44:16 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A32B721556;
        Sun, 12 Jan 2020 23:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578872655;
        bh=J5YMpnnafMfrdXjFSrQpMCpRt+ANz4w4QSr6eVN3x/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGY73zoiQYoSsAW8p8GTiCTOYgMqwBxAXYIxH9ffZi5m1a2qllImhqW9OlFBtJF/W
         ssEXka6nmYkLTyxo43Vc9dmNbLy+u7ELY+SkSG/1waP/fB0gJpuAbsF64/y6XKOHt4
         mGeBcsulC3BIj0BLTT+jXAbfZ5m+uardTCn+1Y1I=
Date:   Sun, 12 Jan 2020 15:44:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next 0/9 v5] IXP4xx networking cleanups
Message-ID: <20200112154414.3bfd97f7@cakuba>
In-Reply-To: <20200112120450.11874-1-linus.walleij@linaro.org>
References: <20200112120450.11874-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 13:04:41 +0100, Linus Walleij wrote:
> This v5 is a rebase of the v4 patch set on top of
> net-next.

Thanks for the respin, looks like Dave was happy with v4 already, so
applied to net-next.

Thank you!
