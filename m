Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01003180C19
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgCJXLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:11:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgCJXLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:11:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA3A14CD0E7F;
        Tue, 10 Mar 2020 16:11:01 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:11:01 -0700 (PDT)
Message-Id: <20200310.161101.1147354292077059361.davem@davemloft.net>
To:     george.mccollister@gmail.com
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com, andrew@lunn.ch,
        f.fainelli@gmail.com, marex@denx.de, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: use delayed_work instead
 of timer + work
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310175859.118105-1-george.mccollister@gmail.com>
References: <20200310175859.118105-1-george.mccollister@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:11:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>
Date: Tue, 10 Mar 2020 12:58:59 -0500

> Simplify ksz_common.c by using delayed_work instead of a combination of
> timer and work.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Applied, thanks.
