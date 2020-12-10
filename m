Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16582D69A4
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404805AbgLJVVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:21:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45692 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393867AbgLJVUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:20:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 44EB74D2ED6E8;
        Thu, 10 Dec 2020 13:19:24 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:19:23 -0800 (PST)
Message-Id: <20201210.131923.261956317613003321.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ms@dev.tdt.de
Subject: Re: [PATCH net-next] net: lapbether: Consider it successful if
 (dis)connecting when already (dis)connected
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208225044.5522-1-xie.he.0141@gmail.com>
References: <20201208225044.5522-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:19:24 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Tue,  8 Dec 2020 14:50:44 -0800

> When the upper layer instruct us to connect (or disconnect), but we have
> already connected (or disconnected), consider this operation successful
> rather than failed.
> 
> This can help the upper layer to correct its record about whether we are
> connected or not here in layer 2.
> 
> The upper layer may not have the correct information about whether we are
> connected or not. This can happen if this driver has already been running
> for some time when the "x25" module gets loaded.
> 
> Another X.25 driver (hdlc_x25) is already doing this, so we make this
> driver do this, too.
> 
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thank you.
